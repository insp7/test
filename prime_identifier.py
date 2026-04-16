"""Prime Number Identifier Program.

Identifies whether a given number is prime and provides related utilities.
"""

import math
import sys


def is_prime(n: int) -> bool:
    """Check if a number is prime.

    Args:
        n: The integer to check.

    Returns:
        True if n is prime, False otherwise.
    """
    if n < 2:
        return False
    if n < 4:
        return True
    if n % 2 == 0 or n % 3 == 0:
        return False
    for i in range(5, int(math.isqrt(n)) + 1, 6):
        if n % i == 0 or n % (i + 2) == 0:
            return False
    return True


def primes_up_to(limit: int) -> list[int]:
    """Return all prime numbers up to a given limit using the Sieve of Eratosthenes.

    Args:
        limit: Upper bound (inclusive).

    Returns:
        List of primes up to limit.
    """
    if limit < 2:
        return []
    sieve = [True] * (limit + 1)
    sieve[0] = sieve[1] = False
    for i in range(2, int(math.isqrt(limit)) + 1):
        if sieve[i]:
            for j in range(i * i, limit + 1, i):
                sieve[j] = False
    return [i for i, flag in enumerate(sieve) if flag]


def next_prime(n: int) -> int:
    """Find the smallest prime greater than n.

    Args:
        n: Starting integer.

    Returns:
        The next prime after n.
    """
    candidate = n + 1
    while not is_prime(candidate):
        candidate += 1
    return candidate


def main() -> None:
    """Interactive prime number identifier."""
    if len(sys.argv) > 1:
        # CLI mode: check numbers passed as arguments
        for arg in sys.argv[1:]:
            try:
                num = int(arg)
                if is_prime(num):
                    print(f"{num} is a prime number.")
                else:
                    print(f"{num} is NOT a prime number.")
            except ValueError:
                print(f"'{arg}' is not a valid integer.")
        return

    # Interactive mode
    print("=== Prime Number Identifier ===")
    print("Commands: <number> | list <n> | next <n> | quit")
    print()

    while True:
        try:
            user_input = input("Enter a number (or command): ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\nGoodbye!")
            break

        if not user_input:
            continue

        if user_input.lower() in ("quit", "exit", "q"):
            print("Goodbye!")
            break

        parts = user_input.split()

        if parts[0].lower() == "list" and len(parts) == 2:
            try:
                limit = int(parts[1])
                primes = primes_up_to(limit)
                print(f"Primes up to {limit}: {primes}")
            except ValueError:
                print("Usage: list <integer>")
        elif parts[0].lower() == "next" and len(parts) == 2:
            try:
                n = int(parts[1])
                p = next_prime(n)
                print(f"The next prime after {n} is {p}.")
            except ValueError:
                print("Usage: next <integer>")
        else:
            try:
                num = int(parts[0])
                if is_prime(num):
                    print(f"{num} is a prime number.")
                else:
                    print(f"{num} is NOT a prime number.")
            except ValueError:
                print(f"Unknown command or invalid number: '{user_input}'")


if __name__ == "__main__":
    main()
