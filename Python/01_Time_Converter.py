import sys

def minutes_to_text(total_minutes: int) -> str:
    sign = "-" if total_minutes < 0 else ""
    m = abs(total_minutes)
    hours = m // 60
    minutes = m % 60
    h_unit = "hr" if hours == 1 else "hrs"
    m_unit = "minute" if minutes == 1 else "minutes"
    return f"{sign}{hours} {h_unit} {minutes} {m_unit}"

def main():
    if len(sys.argv) > 1:
        try:
            value = int(sys.argv[1])
        except ValueError:
            print("Please pass a valid integer, e.g., 130")
            return
    else:
        user_input = input("Enter total minutes (integer): ").strip()
        try:
            value = int(user_input)
        except ValueError:
            print("Please enter a valid integer.")
            return

    print(minutes_to_text(value))

if __name__ == "__main__":
    main()
