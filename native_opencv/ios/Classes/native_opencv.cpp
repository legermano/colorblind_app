#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/imgcodecs.hpp>
#include <iostream>

using namespace std;
using namespace cv;

void rotateMat(Mat &matImage, int rotation)
{
    if (rotation == 90) {
        transpose(matImage, matImage);
        flip(matImage, matImage, 1);
    } else if (rotation == 270) {
        transpose(matImage, matImage);
    } else if (rotation == 180) {
        flip(matImage, matImage, -1);
    }
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
}