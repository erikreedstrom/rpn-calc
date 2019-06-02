// Package main provides command line interface for RPN calculator.
package main

import (
	"os"
	"strings"
)

// quits on `q`
func Example_run_0() {
	exitImpl = setupExit
	defer cleanupExit()

	input := "q"
	run(strings.NewReader(input))
	// Output: Type `q` to end the session.
	//> Exiting.
}

// quits on EOF
func Example_run_1() {
	exitImpl = setupExit
	defer cleanupExit()

	input := ""
	run(strings.NewReader(input))
	// Output: Type `q` to end the session.
	//> Exiting.
}

// prints validity warnings
func Example_run_2() {
	exitImpl = setupExit
	defer cleanupExit()

	input := "s\n-"
	run(strings.NewReader(input))
	// Output: Type `q` to end the session.
	//> [error] invalid input
	//> [error] at least 2 values are required
	//> Exiting.
}

// prints calculator returns
func Example_run_3() {
	exitImpl = setupExit
	defer cleanupExit()

	input := "2\n9\n3\n+\n*"
	run(strings.NewReader(input))
	// Output: Type `q` to end the session.
	//> 2
	//> 9
	//> 3
	//> 12
	//> 24
	//> Exiting.
}

// PRIVATE FUNCTIONS

func setupExit(int) {
	panic("os.Exit")
}

func cleanupExit() {
	if r := recover(); r == "os.Exit" {
		exitImpl = os.Exit
	} else {
		panic(r)
	}
}