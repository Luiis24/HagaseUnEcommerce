package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"

	_ "github.com/lib/pq"
)

var db *sql.DB

type Product struct {
	ProductID         int     `json:"productId"`
	ProductImage      string  `json:"productImage"`
	ProductName       string  `json:"productName"`
	ProductPrice      float64 `json:"productPrice"`
	ProductDescription string `json:"productDescription"`
	ProductCategory   string  `json:"productCategory"`
	QuantityProduct   int     `json:"quantityProduct"`
}

func main() {
	// Configuración de la base de datos
	const (
		host     = "localhost"
		port     = 5432
		user     = "postgres"
		password = "123"
		dbname   = "HagaseUnEcommercee"
	)

	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	var err error
	db, err = sql.Open("postgres", psqlInfo)
	if err != nil {
		log.Fatal("❌ Error al abrir la conexión:", err)
	}
	defer db.Close()

	err = db.Ping()
	if err != nil {
		log.Fatal("❌ Error al conectar con la base de datos:", err)
	}
	fmt.Println("✅ Conexión exitosa a PostgreSQL")

	http.HandleFunc("/products", productsHandler)
	http.HandleFunc("/products/", productByIDHandler)

	fmt.Println("🚀 Servidor corriendo en http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func productsHandler(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodGet:
		getAllProducts(w)
	case http.MethodPost:
		createProduct(w, r)
	default:
		http.Error(w, "Método no permitido", http.StatusMethodNotAllowed)
	}
}

func getAllProducts(w http.ResponseWriter) {
	rows, err := db.Query(`SELECT * FROM products`)
	if err != nil {
		log.Println("❌ Error en la consulta:", err)
		http.Error(w, "Error en la consulta", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var products []Product
	for rows.Next() {
		var p Product
		err := rows.Scan(
			&p.ProductID,
			&p.ProductImage,
			&p.ProductName,
			&p.ProductPrice,
			&p.ProductDescription,
			&p.ProductCategory,
			&p.QuantityProduct,
		)
		if err != nil {
			log.Println("❌ Error al escanear producto:", err)
			http.Error(w, "Error al leer los datos", http.StatusInternalServerError)
			return
		}
		products = append(products, p)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(products)
}

func createProduct(w http.ResponseWriter, r *http.Request) {
	var p Product
	err := json.NewDecoder(r.Body).Decode(&p)
	if err != nil {
		log.Println("❌ JSON inválido:", err)
		http.Error(w, "JSON inválido", http.StatusBadRequest)
		return
	}

	query := `
	INSERT INTO products (
		"productImage",
		"productName",
		"productPrice",
		"productDescription",
		"productCategory",
		"quantityProduct"
	)
	VALUES ($1, $2, $3, $4, $5, $6)
`

	_, err = db.Exec(query,
		p.ProductImage,
		p.ProductName,
		p.ProductPrice,
		p.ProductDescription,
		p.ProductCategory,
		p.QuantityProduct,
	)
	if err != nil {
		log.Println("🔥 Error real:", err) // 👉 esto imprime el error exacto en consola
		http.Error(w, "Error al insertar producto", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]string{"message": "✅ Producto creado"})
}

func productByIDHandler(w http.ResponseWriter, r *http.Request) {
	idStr := strings.TrimPrefix(r.URL.Path, "/products/")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "ID inválido", http.StatusBadRequest)
		return
	}

	switch r.Method {
	case http.MethodPut:
		updateProduct(w, r, id)
	case http.MethodDelete:
		deleteProduct(w, id)
	default:
		http.Error(w, "Método no permitido", http.StatusMethodNotAllowed)
	}
}

func updateProduct(w http.ResponseWriter, r *http.Request, id int) {
	var p Product
	err := json.NewDecoder(r.Body).Decode(&p)
	if err != nil {
		log.Println("❌ JSON inválido:", err)
		http.Error(w, "JSON inválido", http.StatusBadRequest)
		return
	}

	query := `
		UPDATE products
		SET "productImage" = $1,
		    "productName" = $2,
		    "productPrice" = $3,
		    "productDescription" = $4,
		    "productCategory" = $5,
		    "quantityProduct" = $6
		WHERE "productId" = $7
	`

	_, err = db.Exec(query,
		p.ProductImage,
		p.ProductName,
		p.ProductPrice,
		p.ProductDescription,
		p.ProductCategory,
		p.QuantityProduct,
		id,
	)
	if err != nil {
		log.Println("❌ Error al actualizar producto:", err)
		http.Error(w, "Error al actualizar producto", http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]string{"message": "🔄 Producto actualizado"})
}


func deleteProduct(w http.ResponseWriter, id int) {
	query := `DELETE FROM products WHERE "productId"=$1`
	result, err := db.Exec(query, id)
	if err != nil {
		log.Println("❌ Error al eliminar producto:", err)
		http.Error(w, "Error al eliminar producto", http.StatusInternalServerError)
		return
	}

	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		http.Error(w, "Producto no encontrado", http.StatusNotFound)
		return
	}

	json.NewEncoder(w).Encode(map[string]string{"message": "🗑️ Producto eliminado"})
}

