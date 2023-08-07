#include <SoftTimers.h>

#define ANALOG_PIN A0

/****************************************************************
 * Compute the minimum, maximum and average time of a function or
 * a section of code to execute.
 ****************************************************************/

int loop_count = 0;

static const int unsorted_values[] = {
179, 211, 219, 307, 495, 462, 485, 396, 286, 189, 361, 122, 312, 398, 218, 487, 287, 452, 86, 297, 147, 196, 298, 158, 265, 136, 229, 301, 412, 160, 300,
168, 489, 407, 34, 303, 443, 2, 149, 391, 131, 228, 360, 128, 343, 271, 294, 186, 69, 267, 164, 10, 340, 223, 63, 140, 132, 508, 258, 496, 457, 266, 44,
43, 115, 313, 447, 57, 247, 123, 296, 7, 499, 399, 112, 198, 126, 374, 213, 163, 220, 335, 474, 473, 451, 161, 420, 475, 18, 37, 212, 104, 144, 245, 28,
410, 143, 60, 446, 356, 127, 162, 224, 365, 510, 170, 109, 54, 137, 392, 155, 16, 330, 389, 302, 225, 467, 89, 153, 317, 275, 436, 184, 107, 388, 56, 230,
319, 270, 174, 488, 156, 280, 347, 30, 497, 148, 409, 38, 8, 454, 382, 427, 358, 461, 441, 274, 251, 135, 181, 440, 387, 263, 23, 311, 422, 426, 509, 468,
345, 173, 460, 90, 76, 39, 332, 385, 1, 484, 432, 419, 310, 64, 53, 390, 242, 222, 491, 324, 221, 283, 444, 237, 350, 134, 70, 45, 470, 395, 171, 29, 48,
209, 116, 429, 207, 438, 273, 328, 289, 423, 479, 459, 210, 430, 252, 259, 11, 167, 406, 185, 244, 142, 425, 35, 25, 450, 206, 78, 367, 12, 238, 309, 77,
264, 133, 415, 85, 208, 66, 493, 9, 180, 404, 351, 187, 483, 49, 91, 32, 166, 339, 394, 130, 94, 333, 243, 169, 58, 241, 165, 232, 22, 299, 276, 393, 82,
354, 103, 192, 88, 418, 84, 5, 119, 500, 6, 42, 190, 59, 341, 414, 110, 379, 463, 282, 151, 195, 480, 503, 150, 348, 377, 239, 346, 75, 19, 372, 3, 125,
417, 413, 323, 336, 506, 73, 261, 424, 95, 256, 15, 408, 201, 98, 233, 384, 327, 355, 260, 124, 14, 284, 326, 46, 17, 191, 72, 79, 363, 397, 51, 511, 437,
453, 386, 472, 102, 501, 357, 93, 215, 369, 183, 117, 177, 269, 381, 492, 308, 154, 456, 486, 305, 466, 316, 105, 272, 13, 67, 254, 157, 315, 121, 108,
375, 442, 203, 97, 338, 400, 376, 52, 36, 33, 490, 290, 27, 20, 113, 494, 26, 81, 4, 321, 401, 325, 47, 65, 458, 295, 481, 74, 465, 250, 193, 50, 279, 24,
380, 433, 235, 383, 285, 364, 306, 145, 505, 362, 507, 448, 268, 434, 111, 202, 138, 370, 322, 455, 236, 101, 471, 139, 129, 405, 334, 234, 291, 141, 371,
342, 159, 477, 99, 329, 314, 359, 21, 100, 257, 172, 352, 318, 320, 199, 176, 61, 246, 204, 240, 504, 502, 214, 416, 41, 449, 227, 178, 293, 92, 366, 182,
435, 253, 469, 331, 118, 96, 152, 55, 402, 498, 194, 445, 248, 353, 205, 421, 231, 226, 431, 344, 114, 277, 31, 464, 278, 216, 262, 40, 80, 106, 120, 68,
439, 476, 304, 87, 71, 175, 403, 349, 146, 83, 249, 373, 197, 288, 411, 428, 200, 281, 378, 292, 62, 368, 188, 337, 255, 217, 482, 478,};
static const size_t unsorted_values_count = sizeof(unsorted_values) / sizeof(unsorted_values[0]);
static const size_t sorted_values_count = unsorted_values_count;
static int sorted_values[sorted_values_count];

void setup() {
  pinMode(ANALOG_PIN, INPUT);

  Serial.begin(115200);
  Serial.println("ready");
}

void profileAnalogRead() {
  SoftTimerProfiler profiler(&micros); // microseconds profiler
  profiler.reset();

  for(int i=0; i<1000; i++) {
    profiler.start();
    int value = analogRead(ANALOG_PIN);
    profiler.stop();
  }

  profiler.end();
  profiler.print("analogRead");
}

// perform the bubble sort
void bubbleSort(int array[], int size) {

  // loop to access each array element
  for (int step = 0; step < size - 1; ++step) {
      
    // loop to compare array elements
    for (int i = 0; i < size - step - 1; ++i) {
      
      // compare two adjacent elements
      // change > to < to sort in descending order
      if (array[i] > array[i + 1]) {
        
        // swapping occurs if elements
        // are not in the intended order
        int temp = array[i];
        array[i] = array[i + 1];
        array[i + 1] = temp;
      }
    }
  }
}

void profileBubbleSort() {
  SoftTimerProfilerMillis profiler; // milliseconds profiler
  profiler.reset();

  for(int i=0; i<50; i++) {
    // Copy unsorted values into the array that we will sort.
    // This operation is outside of the scope of the profiler.
    memcpy(&sorted_values, unsorted_values, sizeof(sorted_values));

    profiler.start();
    bubbleSort(sorted_values, sorted_values_count);
    profiler.stop();
  }

  profiler.end();
  profiler.print("bubbleSort");
}

void loop() {
  if (loop_count%2 == 0)
    profileAnalogRead();
  else
    profileBubbleSort();

  loop_count++;
}
