import sys

def remove_duplicates(s: str) -> str:
    result = []
    seen = set()
    for ch in s:
        if ch not in seen:
            result.append(ch)
            seen.add(ch)
    return "".join(result)

def main():
    if len(sys.argv) < 2:
        s = input("Enter a string: ")
    else:
        s = sys.argv[1]
    print(remove_duplicates(s))

if __name__ == "__main__":
    main()
