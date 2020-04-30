package lattice

import (
	"bufio"
	"fmt"
	"io"
	"math"
	"strconv"
	"strings"
	"time"

	"github.com/pkg/errors"
)

//Word is one line in lattice file
type Word struct {
	Main  string
	From  string
	To    string
	Word  string
	Punct string
}

//Part is some lattice data
type Part struct {
	Speaker string
	Num     int
	Words   []*Word
}

//SilWord indicate ssil word in lattice
var SilWord = "<eps>"

//MainInd ord line indicator
var MainInd = "1"

//Read reads lattice file
func Read(src io.Reader) ([]*Part, error) {
	res := make([]*Part, 0)
	scanner := bufio.NewScanner(src)
	line := ""
	var cPart *Part
	var err error
	ln := 0
	for scanner.Scan() {
		ln++
		line = strings.TrimSpace(scanner.Text())
		strs := strings.Split(line, " ")
		if strings.HasPrefix(line, "#") {
			cPart = &Part{}
			if len(strs) < 3 {
				return nil, errors.Errorf("Line %d. Wrong part start: %s", ln, line)
			}
			cPart.Speaker = strs[2]
			cPart.Num, err = strconv.Atoi(strs[1])
			if err != nil {
				return nil, errors.Wrapf(err, "Line %d. Wrong part start: %s", ln, line)
			}
			res = append(res, cPart)
		} else if line == "" {
			cPart = nil
		} else {
			if cPart == nil {
				return nil, errors.Errorf("Line %d. No init part", ln)
			}
			if len(strs) < 4 {
				return nil, errors.Errorf("Line %d. Wrong line start: %s", ln, line)
			}
			w := &Word{}
			w.Main = strs[0]
			w.From = strs[1]
			w.To = strs[2]
			w.Word = strs[3]
			if len(strs) > 4 {
				w.Punct = strs[4]
			}
			cPart.Words = append(cPart.Words, w)
		}
	}
	if err := scanner.Err(); err != nil {
		return nil, err
	}
	return res, nil
}

//Write writes lattice file
func Write(data []*Part, writer io.Writer) error {
	for _, p := range data {
		_, err := fmt.Fprintf(writer, "# %d %s\n", p.Num, p.Speaker)
		if err != nil {
			return err
		}
		for _, w := range p.Words {
			punct := ""
			if w.Punct != "" {
				punct = " " + w.Punct
			}
			_, err = fmt.Fprintf(writer, "%s %s %s %s%s\n", w.Main, w.From, w.To, w.Word, punct)
			if err != nil {
				return err
			}
		}
		_, err = fmt.Fprintf(writer, "\n")
		if err != nil {
			return err
		}
	}
	return nil
}

//WordDuration return duration from word line
func WordDuration(w *Word) time.Duration {
	return Duration(w.To) - Duration(w.From)
}

//Duration return duration from string as seconds (eg.: "2.50")
func Duration(str string) time.Duration {
	res, err := strconv.ParseFloat(str, 64)
	if err != nil {
		return 0
	}
	return time.Duration(math.Round(res*1000)) * time.Millisecond
}