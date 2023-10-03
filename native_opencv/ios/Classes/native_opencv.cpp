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

        // int cx = frame.size().width / 2;
        // int cy = frame.size().height / 2;

        Vec3b pixel = frame.at<Vec3b>(pointY, pointX);
        int hue_value = pixel[0];

        const char* color = "Undefined";

        if (hue_value <= 7.5) {
            color = "Red";
        }
        else if (hue_value <= 22.5) {
            color = "Orange";
        }
        else if (hue_value <= 37.5) {
            color = "Yellow";
        }
        else if (hue_value <= 52.5) {
            color = "Yellow Green";
        }
        else if (hue_value <= 67.5) {
            color = "Green";
        }
        else if (hue_value <= 82.5) {
            color = "Blue Green";
        }
        else if (hue_value <= 97.5) {
            color = "Cyan";
        }
        else if (hue_value <= 112.5) {
            color = "Green Blue";
        }
        else if (hue_value <= 127.5) {
            color = "Blue";
        }
        else if (hue_value <= 142.5) {
            color = "Purple Blue";
        }
        else if (hue_value <= 157.2) {
            color = "Magenta";
        }
        else if (hue_value <= 172.5) {
            color = "Purple Red";
        }
        else {
            color = "Red";
        }

        return color;
    }
}