// Package main provides command line interface for RPN calculator.
package main

import (
	"bufio"
	"fmt"
	"github.com/fatih/color"
	"io"
	"os"
	"os/signal"
	"strings"
	"syscall"

	"rpn_calc/internal/pkg/calclib"
)

var exitImpl = os.Exit

// PRIVATE FUNCTIONS

func main() {
	run(os.Stdin)
}

func run(in io.Reader) {
	// Create REPL
	yellow := color.New(color.FgYellow).SprintFunc()
	fmt.Println(fmt.Sprintf("Type %s to end the session.", yellow("`q`")))

	// Rescue interrupt
	c := make(chan os.Signal)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	go func() {
		<-c
		fmt.Println("")
		exit()
	}()

	reader := bufio.NewReader(in)
	for {
		// Print prompt
		fmt.Print("> ")
		bytes, _, err := reader.ReadLine()
		if err == io.EOF {
			exit()
		}

		arg := strings.TrimSpace(string(bytes))
		if arg == "q" {
			exit()
		}

		fmt.Println(execute(arg))
	}
}

func exit() {
	fmt.Println("Exiting.")
	exitImpl(0)
}

func execute(arg string) string {
	result, err := calclib.Process(arg)
	if err != nil {
		red := color.New(color.FgRed).SprintFunc()
		fmt.Print(fmt.Sprintf("%s %s", red("[error]"), err))
	}
	return result
}
