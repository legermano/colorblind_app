#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/imgcodecs.hpp>
#include <iostream>

using namespace std;
using namespace cv;

void rotateMat(Mat &matImage, int rotation)
{
    if (rotation == 90) {
        rotate(matImage, matImage, ROTATE_90_CLOCKWISE);
    } else if (rotation == 270) {
        rotate(matImage, matImage, ROTATE_90_COUNTERCLOCKWISE);
        flip(matImage, matImage, 1);
    } else if (rotation == 180) {
        rotate(matImage, matImage, ROTATE_180);
    }
}

Mat correctionMatrix(double protanopiaDegree, double deutranopiaDegree) {
	Mat matrix(3, 3, CV_64F);

	matrix.at<double>(0, 0) = 1.0 - deutranopiaDegree / 2;
	matrix.at<double>(0, 1) = protanopiaDegree / 2;
	matrix.at<double>(0, 2) = protanopiaDegree / 4;

	matrix.at<double>(1, 0) = deutranopiaDegree / 2;
	matrix.at<double>(1, 1) = 1.0 - protanopiaDegree / 2;
	matrix.at<double>(1, 2) = deutranopiaDegree / 4;

	matrix.at<double>(2, 0) = 0;
	matrix.at<double>(2, 1) = 0;
	matrix.at<double>(2, 2) = 1.0 - (protanopiaDegree + deutranopiaDegree) / 4;

	matrix.convertTo(matrix, CV_32FC3);

	return matrix.t();
}

Mat rgbToLMS() {
	Mat matrix(3, 3, CV_64F);

	matrix.at<double>(0, 0) = 17.8824;
	matrix.at<double>(0, 1) = 3.45565;
	matrix.at<double>(0, 2) = 0.0299566;

	matrix.at<double>(1, 0) = 43.5161;
	matrix.at<double>(1, 1) = 27.1554;
	matrix.at<double>(1, 2) = 0.184309;

	matrix.at<double>(2, 0) = 4.11935;
	matrix.at<double>(2, 1) = 3.86714;
	matrix.at<double>(2, 2) = 1.46709;

	matrix.convertTo(matrix, CV_32FC3);

	return matrix.t();
}

Mat lmsToRGB() {
	Mat matrix(3, 3, CV_64F);

	matrix.at<double>(0, 0) = 0.0809;
	matrix.at<double>(0, 1) = -0.0102;
	matrix.at<double>(0, 2) = -0.0004;

	matrix.at<double>(1, 0) = -0.1305;
	matrix.at<double>(1, 1) = 0.0540;
	matrix.at<double>(1, 2) = -0.0041;

	matrix.at<double>(2, 0) = 0.1167;
	matrix.at<double>(2, 1) = -0.1136;
	matrix.at<double>(2, 2) = 0.6935;

	matrix.convertTo(matrix, CV_32FC3);

	return matrix.t();
}

Mat lmsProtanopiaSimulation(double degree) {
	Mat matrix(3, 3, CV_64F);

	matrix.at<double>(0, 0) = 1 - degree;
	matrix.at<double>(0, 1) = 0;
	matrix.at<double>(0, 2) = 0;

	matrix.at<double>(1, 0) = 2.02344 * degree;
	matrix.at<double>(1, 1) = 1;
	matrix.at<double>(1, 2) = 0;

	matrix.at<double>(2, 0) = -2.52581 * degree;
	matrix.at<double>(2, 1) = 0;
	matrix.at<double>(2, 2) = 1;

	matrix.convertTo(matrix, CV_32FC3);

	return matrix.t();
}

Mat lmsDeutranopiaSimulation(double degree) {
	Mat matrix(3, 3, CV_64F);

	matrix.at<double>(0, 0) = 1;
	matrix.at<double>(0, 1) = 0.494207 * degree;
	matrix.at<double>(0, 2) = 0;

	matrix.at<double>(1, 0) = 0;
	matrix.at<double>(1, 1) = 1 - degree;
	matrix.at<double>(1, 2) = 0;

	matrix.at<double>(2, 0) = 0;
	matrix.at<double>(2, 1) = 1.24827 * degree;
	matrix.at<double>(2, 2) = 1;

	matrix.convertTo(matrix, CV_32FC3);

	return matrix.t();
}

Mat lmsTritanopiaSimulation(double degree) {
	Mat matrix(3, 3, CV_64F);

	matrix.at<double>(0, 0) = 1;
	matrix.at<double>(0, 1) = 0;
	matrix.at<double>(0, 2) = -0.395913 * degree;

	matrix.at<double>(1, 0) = 0;
	matrix.at<double>(1, 1) = 1;
	matrix.at<double>(1, 2) = 0.801109 * degree;

	matrix.at<double>(2, 0) = 0;
	matrix.at<double>(2, 1) = 0;
	matrix.at<double>(2, 2) = 1 - degree;

	matrix.convertTo(matrix, CV_32FC3);

	return matrix.t();
}

extern "C" {
    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    const char* version() {
        return CV_VERSION;
    }

    __attribute__((visibility("default"))) __attribute__((used))
    const char* getColor(int width, int height, int rotation, int pointX, int pointY, uint8_t* bytes, bool isYUV) {
        Mat frame;

        if(isYUV) {
            Mat myyuv(height + height / 2, width, CV_8UC1, bytes);
            cvtColor(myyuv, frame, COLOR_YUV2BGRA_NV21);
        } else {
            frame = Mat(height, width, CV_8UC4, bytes);
        }

        rotateMat(frame, rotation);
        cvtColor(frame, frame, COLOR_BGR2HSV);

        Vec3b pixel = frame.at<Vec3b>(pointY, pointX);

        int hue = pixel[0];
        int saturation = pixel[1];
        int value = pixel[2];

        const char* color = "";

        if (value > 140 && saturation <= 40) {
            color = "Branco";
        }
        else if ((value <= 140 && value > 40) && (saturation <= 40 || (saturation <= 75 and hue >= 100 && hue <= 135 ))) {
            color = "Cinza";
        }
        else if (value <= 40) {
            color = "Preto";
        }
        else if (hue <= 7.5 ) {
            color = "Vermelho";
        }
        else if (hue <= 22.5) {
            color = "Laranja";
        }
        else if (hue <= 34.5) {
            color = "Amarelo";
        }
        else if (hue <= 102.5) {
            color = "Verde";
        }
        else if (hue <= 126.5) {
            color = "Azul";
        }
        else if (hue <= 142.5) {
            color = "Roxo";
        }
        else if (hue <= 172.2) {
            color = "Rosa";
        }
        else {
            color = "Vermelho";
        }

        return color;
    }

    __attribute__((visibility("default"))) __attribute__((used))
    const void correct(int width, int height, int rotation, float protanopiaDegree, float deutranopiaDegree, uint8_t* bytes, bool isYUV, uint8_t* encodedBytes, int32_t* outCount) {
        Mat frame;

        if(isYUV) {
            Mat myyuv(height + height / 2, width, CV_8UC1, bytes);
            cvtColor(myyuv, frame, COLOR_YUV2BGRA_NV21);
        } else {
            frame = Mat(height, width, CV_8UC4, bytes);
        }

        rotateMat(frame, rotation);
        cvtColor(frame, frame, COLOR_BGR2RGB);

        frame.convertTo(frame, CV_32FC3 , 1.f/255);

        transform(frame, frame, correctionMatrix(protanopiaDegree, deutranopiaDegree));

        frame.convertTo(frame, CV_8U, 255);

        vector<uint8_t> jpegData;

        vector<int> params;
        params.push_back(IMWRITE_JPEG_QUALITY);
        params.push_back(90);

        imencode(".jpg", frame, jpegData, params);

        memcpy(encodedBytes, jpegData.data(), jpegData.size());

        *outCount = jpegData.size();
    }

    __attribute__((visibility("default"))) __attribute__((used))
    const void simulate(int width, int height, int rotation, const char* type, float degree, uint8_t* bytes, bool isYUV, uint8_t* encodedBytes, int32_t* outCount) {
        const char* protanopia  = "protanopia";
        const char* deutranopia = "deutranopia";
        const char* tritanopia  = "tritanopia";

        Mat frame;

        if(isYUV) {
            Mat myyuv(height + height / 2, width, CV_8UC1, bytes);
            cvtColor(myyuv, frame, COLOR_YUV2BGRA_NV21);
        } else {
            frame = Mat(height, width, CV_8UC4, bytes);
        }

        rotateMat(frame, rotation);
        cvtColor(frame, frame, COLOR_BGR2RGB);

        frame.convertTo(frame, CV_32FC3 , 1.f/255);

        transform(frame, frame, rgbToLMS());

        if (strcmp(type, protanopia) == 0) {
            transform(frame, frame, lmsProtanopiaSimulation(degree));
        } else if (strcmp(type, deutranopia) == 0) {
            transform(frame, frame, lmsDeutranopiaSimulation(degree));
        } else if (strcmp(type, tritanopia) == 0) {
            transform(frame, frame, lmsTritanopiaSimulation(degree));
        }

        transform(frame, frame, lmsToRGB());

        frame.convertTo(frame, CV_8U, 255);

        vector<uint8_t> jpegData;

        vector<int> params;
        params.push_back(IMWRITE_JPEG_QUALITY);
        params.push_back(90);

        imencode(".jpg", frame, jpegData, params);

        memcpy(encodedBytes, jpegData.data(), jpegData.size());

        *outCount = jpegData.size();
    }
}