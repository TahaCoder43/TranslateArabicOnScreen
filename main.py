from functools import reduce
import subprocess
import sys
from PIL import ImageGrab
import re
import easyocr
import webbrowser

SCREENSHOT_PATH = "/tmp/arabic_to_translate.png"
reader = easyocr.Reader(["ar"])


def screenshot():
    result = subprocess.run(["slurp"], capture_output=True, text=True)
    stdout_lines = result.stdout.splitlines()

    if len(stdout_lines) == 0:
        print("No dimensions captures", file=sys.stderr)
        exit(1)

    dimensions = stdout_lines[0]
    print(dimensions)
    bbox_match = re.match(r"(\d+),(\d+) (\d+)x(\d+)", dimensions)

    if bbox_match is None:
        print("slurp should output [x],[y] [width]x[height]", file=sys.stderr)
        exit(1)

    bbox = tuple(int(group) for group in bbox_match.groups())

    if len(bbox) != 4:
        print("Bbox should have 4 numbers", file=sys.stderr)
        exit(1)

    try: 
        image = ImageGrab.grab(bbox=bbox)
        with open(SCREENSHOT_PATH, "rw") as file:
            image.save(file)
    except ValueError:
        subprocess.run(["grim", "-g", dimensions, SCREENSHOT_PATH,])


def extract_arabic_text() -> str:
    extracted_arabic = reader.readtext(SCREENSHOT_PATH)
    filtered_arabic = filter(lambda text: text[-1] > 0.5, extracted_arabic)
    texts: list[str] = list(map(lambda text: text[-2], filtered_arabic))
    all_text = reduce(lambda text, part: f"{text} {part}", texts)

    with open("/tmp/arabic_output", "w") as file:
        file.write(all_text)

    return all_text



def main():
    screenshot()
    text = extract_arabic_text()
    webbrowser.open("https://en.wiktionary.org/wiki/" + text)

if __name__ == "__main__":
    main()
