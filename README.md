# Memorix

Memorix is a memory training app inspired by the chimp test, designed to improve your working memory. Your goal is to memorize and tap numbered tiles in the correct sequence. You start with three lives (hearts) in every difficulty.

Memorix challenges your short-term memory. Numbers are briefly displayed in random positions, and you must then tap them in ascending order. It's a simple concept, but it gets progressively harder as the number of tiles increases with difficulty.

## Features

* **Working Memory Training:** Improves your ability to retain and recall visual information.
* **Chimp Test Inspired:** Based on the concept of the Ayumu memory test, designed to push your memory limits.
* **Three Difficulty Modes:**
    * **Easy:** 5 tiles.
    * **Medium:** 8 tiles.
    * **Hard:** 12 tiles.
* **Randomized Tile Placement:** Numbers are shuffled and placed randomly for each round.
* **Number Replacement:** Correctly tapped tiles are replaced with "?".
* **Clear Visual Feedback:** Tiles provide visual cues during the reveal sequence and upon tapping.
* **Three Lives (Hearts):** Every difficulty starts with three lives. A wrong tap loses a life.
* **Game Over:** Game ends when all lives are lost or the sequence is completed incorrectly.

## Gameplay

1.  **Difficulty Selection:** Choose your desired difficulty level (Easy, Medium, or Hard) from the start screen.
2.  **Reveal Sequence:** Numbers are displayed briefly in random positions. Memorize their locations.
3.  **Tap Sequence:** Once you tap the "1" tile, all numbers are replaced with "?".
4.  **Recall and Tap:** Use your memory to tap the remaining tiles in ascending order (2, 3, 4, etc.).
5.  **Lives:** You start with three lives represented by hearts.
6.  **Losing a Life:** Tapping the wrong tile will result in losing one life (heart).
7.  **Game Over:** The game ends if you lose all three lives or if you fail to complete the sequence.
8.  **Progressive Difficulty:** Each successful round will increase the number of tiles depending on the chosen difficulty.

## Getting Started

1.  **Ensure Flutter is installed:**
    * Follow the official Flutter installation guide: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2.  **Clone the repository:**

    ```bash
    git clone https://github.com/Kartik-Xplorer/Memorix
    cd memorix
    ```

3.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

4.  **Run the application:**

    ```bash
    flutter run
    ```

    This will start the application on your connected device or emulator.

## Technologies Used

* **Flutter:** Cross-platform mobile app development framework.
* **Dart:** Programming language used by Flutter.
* **Material UI (Flutter):** Material Design widgets for Flutter.
