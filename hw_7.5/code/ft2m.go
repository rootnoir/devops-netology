package main

import "fmt"

func main() {
	const convert float32 = 0.3048
	var input float32
	fmt.Println("Enter meters: ")
	fmt.Scanf("%f", &input)
	fmt.Println(input, " meters is ", input*convert, "feets")
}