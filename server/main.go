package main

import "net/http"
import "encoding/json"
import "os"
import "encoding/base64"
import "strings"
import "io"
import "fmt"
import "math/rand"

func file_gambar(res http.ResponseWriter, req *http.Request) {
	file := req.FormValue("gambar")
	nama := RandStringBytes(40)

	if file == "" {
		data := map[string]bool{
			"Stats": false,
		}
		json.NewEncoder(res).Encode(data)
		return
	}
	if nama == "" {
		data := map[string]bool{
			"Stats": false,
		}
		json.NewEncoder(res).Encode(data)
		return
	}

	mf, _ := os.Create("data/foto/" + nama + ".jpg")
	txt, _ := os.Create("data/foto/" + nama + ".txt")
	txt.WriteString(file)

	f := base64.NewDecoder(base64.StdEncoding, strings.NewReader(file))

	io.Copy(mf, f)

	mf.Close()
	txt.Close()

	data := map[string]bool{
		"Stats": true,
	}
	json.NewEncoder(res).Encode(data)
	fmt.Println("telah diakses")

}

const letterBytes = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

func RandStringBytes(n int) string {
	b := make([]byte, n)
	for i := range b {
		b[i] = letterBytes[rand.Intn(len(letterBytes))]
	}
	return string(b)
}

func main() {

	http.HandleFunc("/file", file_gambar)
	http.ListenAndServe(":8080", nil)
}
