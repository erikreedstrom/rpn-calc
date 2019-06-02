// Package calclib implements an RPN calculator.
package calclib

import (
	"errors"
	"regexp"
	"strings"

	"github.com/shopspring/decimal"
)

var stack []decimal.Decimal

// Process provides methods for calculating operations in RPN notation.
//
// Takes either a numeric input, or an operator.
//
// Supports:
// - addition `+`
// - subtraction `-`
// - multiplication `*`
// - division `/`
//
// Example: Add two numbers
//   calclib.Process('1')
//   calclib.Process('1')
//   calclib.Process('+')
//   // => '2'
func Process(input string) (result string, err error) {
	// Guard against invalid input.
	if !isValid(input) {
		return "", errors.New("invalid input")
	}

	// Place number on stack
	if isNumeric(input) {
		return place(input), nil
	}

	// Apply operation to last two input values
	return operate(input)
}

// PRIVATE FUNCTIONS

func place(numeric string) string {
	d, _ := decimal.NewFromString(numeric)
	stack = append(stack, d)
	return format(d.String())
}

func operate(input string) (result string, err error) {
	if len(stack) < 2 {
		return "", errors.New("at least 2 values are required")
	}

	var tail []decimal.Decimal
	tail, stack = stack[len(stack)-2:], stack[:len(stack)-2]
	a, b := tail[0], tail[1]

	defer func() {
		if r := recover(); r == "decimal division by 0" {
			stack = append(stack, a, b)
			result, err = "", errors.New("function returns infinity")
		}
	}()

	var d decimal.Decimal
	switch input {
	case "+": d = a.Add(b)
	case "-": d = a.Sub(b)
	case "*": d = a.Mul(b)
	case "/": d = a.Div(b)
	}

	stack = append(stack, d)
	return format(d.String()), err
}

func isValid(input string) bool {
	isMatch, _ := regexp.MatchString(`^(?:[-+*/]|-?\d+(?:.\d+)?)$`, input)
	return isMatch
}

func isNumeric(input string) bool {
	isMatch, _ := regexp.MatchString(`^-?\d+(?:.\d+)?$`, input)
	return isMatch
}

func format(numeric string) string {
	isDecimal, _ := regexp.MatchString(`^\d+\.\d+?$`, numeric)
	if !isDecimal {
		return numeric
	}

	return strings.TrimRight(strings.TrimRight(numeric, "0"), ".")
}
