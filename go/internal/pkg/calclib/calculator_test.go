// Package calclib implements an RPN calculator.
package calclib

import (
	"errors"
	"reflect"
	"testing"
)

func TestProcess(t *testing.T) {
	type args struct {
		input string
	}
	tests := []struct {
		name       string
		args       args
		wantResult string
		wantErr    error
	}{
		{
			"returns warning on invalid input",
			args{"%"},
			"",
			errors.New("invalid input"),
		},
		{
			"returns warning on operations with too few values",
			args{"+"},
			"",
			errors.New("at least 2 values are required"),
		},
		{
			"returns value on valid input",
			args{"1"},
			"1",
			nil,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			gotResult, err := Process(tt.args.input)
			if (err != nil) && !reflect.DeepEqual(err, tt.wantErr) {
				t.Errorf("Process() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if gotResult != tt.wantResult {
				t.Errorf("Process() = %v, want %v", gotResult, tt.wantResult)
			}
		})
	}

	t.Run("returns warning on division by 0", func(t *testing.T) {
		_, _ = Process("5")
		_, _ = Process("0")
		gotResult, err := Process("/")

		wantResult := ""
		wantErr := errors.New("function returns infinity")
		if (err != nil) && !reflect.DeepEqual(err, wantErr) {
			t.Errorf("Process() error = %v, wantErr %v", err, wantErr)
			return
		}
		if gotResult != wantResult {
			t.Errorf("Process() = %v, want %v", gotResult, wantResult)
		}
	})

	t.Run("supports addition", func(t *testing.T) {
		_, _ = Process("5")
		_, _ = Process("8")
		gotResult, err := Process("+")
		wantResult := "13"
		if err != nil {
			t.Errorf("Process() error = %v, wantErr %v", err, nil)
			return
		}
		if gotResult != wantResult {
			t.Errorf("Process() = %v, want %v", gotResult, wantResult)
		}
	})

	t.Run("supports subtraction", func(t *testing.T) {
		_, _ = Process("5")
		_, _ = Process("8")
		gotResult, err := Process("-")
		wantResult := "-3"
		if err != nil {
			t.Errorf("Process() error = %v, wantErr %v", err, nil)
			return
		}
		if gotResult != wantResult {
			t.Errorf("Process() = %v, want %v", gotResult, wantResult)
		}
	})

	t.Run("supports multiplication", func(t *testing.T) {
		_, _ = Process("5")
		_, _ = Process("8")
		gotResult, err := Process("*")
		wantResult := "40"
		if err != nil {
			t.Errorf("Process() error = %v, wantErr %v", err, nil)
			return
		}
		if gotResult != wantResult {
			t.Errorf("Process() = %v, want %v", gotResult, wantResult)
		}
	})

	t.Run("supports division", func(t *testing.T) {
		_, _ = Process("5")
		_, _ = Process("8")
		gotResult, err := Process("/")
		wantResult := "0.625"
		if err != nil {
			t.Errorf("Process() error = %v, wantErr %v", err, nil)
			return
		}
		if gotResult != wantResult {
			t.Errorf("Process() = %v, want %v", gotResult, wantResult)
		}
	})

	t.Run("supports negative numbers", func(t *testing.T) {
		_, _ = Process("-5")
		_, _ = Process("-8")
		gotResult, err := Process("+")
		wantResult := "-13"
		if err != nil {
			t.Errorf("Process() error = %v, wantErr %v", err, nil)
			return
		}
		if gotResult != wantResult {
			t.Errorf("Process() = %v, want %v", gotResult, wantResult)
		}
	})

	t.Run("supports decimal numbers", func(t *testing.T) {
		_, _ = Process("-0.5")
		_, _ = Process("-8")
		gotResult, err := Process("*")
		wantResult := "4"
		if err != nil {
			t.Errorf("Process() error = %v, wantErr %v", err, nil)
			return
		}
		if gotResult != wantResult {
			t.Errorf("Process() = %v, want %v", gotResult, wantResult)
		}
	})

	t.Run("supports stacked operators", func(t *testing.T) {
		_, _ = Process("2")
		_, _ = Process("9")
		_, _ = Process("3")
		_, _ = Process("+")
		gotResult, err := Process("*")
		wantResult := "24"
		if err != nil {
			t.Errorf("Process() error = %v, wantErr %v", err, nil)
			return
		}
		if gotResult != wantResult {
			t.Errorf("Process() = %v, want %v", gotResult, wantResult)
		}
	})

	t.Run("supports chained operations", func(t *testing.T) {
		_, _ = Process("20")
		_, _ = Process("13")
		_, _ = Process("-")
		_, _ = Process("2")
		gotResult, err := Process("/")
		wantResult := "3.5"
		if err != nil {
			t.Errorf("Process() error = %v, wantErr %v", err, nil)
			return
		}
		if gotResult != wantResult {
			t.Errorf("Process() = %v, want %v", gotResult, wantResult)
		}
	})
}