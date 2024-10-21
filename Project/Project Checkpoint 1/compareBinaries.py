def compare_binaries(file1, file2):
    with open(file1, "rb") as f1, open(file2, "rb") as f2:
        content1 = f1.read()
        content2 = f2.read()

        if content1 == content2:
            print("The binaries match!")
        else:
            print("The binaries do not match.")
            # Optionally, display the differences
            for i, (byte1, byte2) in enumerate(zip(content1, content2)):
                if byte1 != byte2:
                    print(f"Difference at byte {i}: {byte1} != {byte2}")

compare_binaries("output.bin", "expected_output.bin")
