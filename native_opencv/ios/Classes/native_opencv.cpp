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
	matrix.at<double>(2, 1) = deutranopiaDegree / 4;

	matrix.at<double>(2, 0) = 0;
	matrix.at<double>(2, 1) = 0;
	matrix.at<double>(2, 2) = 1.0 - (protanopiaDegree + deutranopiaDegree) / 4;

	matrix.convertTo(matrix, CV_32FC3);

	return matrix.t(); // Transpose the matrix to match Python's behavior
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
}