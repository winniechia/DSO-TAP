def calculate_grade(score):
    if score >= 90:
        return "A"
    elif score >= 80:
        return "B"
    elif score >= 70:
        return "C"
    elif score >= 60:
        return "D"
    else:
        return "F"


student_name = "Alice"
score = 88

print(f"Student: {student_name}")
print(f"Score: {score}")
print(f"Grade: {calculate_grade(score)}")