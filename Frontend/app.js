const API_URL = "http://localhost:8080/products";

const form = document.getElementById("productForm");
const productList = document.getElementById("productList");

async function fetchProducts() {
  const res = await fetch(API_URL);
  const products = await res.json();
  renderProducts(products);
}

function renderProducts(products) {
  productList.innerHTML = "";
  products.forEach((p) => {
    const card = document.createElement("div");
    card.className = "product-card";
    card.innerHTML = `
      <strong>${p.productName}</strong><br>
      💰 $${p.productPrice} | 📦 ${p.productCategory} | 🧮 ${p.quantityProduct}<br>
      <small>${p.productDescription}</small>
      <div class="actions">
        <button onclick="editProduct(${p.productId})">✏️ Editar</button>
        <button onclick="deleteProduct(${p.productId})">🗑️ Eliminar</button>
      </div>
    `;
    productList.appendChild(card);
  });
}

form.addEventListener("submit", async (e) => {
  e.preventDefault();

  const data = {
    productImage: productImage.value,
    productName: productName.value,
    productPrice: parseInt(productPrice.value),
    productDescription: productDescription.value,
    productCategory: productCategory.value,
    quantityProduct: parseInt(quantityProduct.value),
  };

  const id = productId.value;
  const method = id ? "PUT" : "POST";
  const url = id ? `${API_URL}/${id}` : API_URL;

  await fetch(url, {
    method,
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });

  form.reset();
  fetchProducts();
});

async function editProduct(id) {
  const res = await fetch(`${API_URL}`);
  const products = await res.json();
  const product = products.find((p) => p.productId === id);

  productId.value = product.productId;
  productImage.value = product.productImage;
  productName.value = product.productName;
  productPrice.value = product.productPrice;
  productDescription.value = product.productDescription;
  productCategory.value = product.productCategory;
  quantityProduct.value = product.quantityProduct;
}

async function deleteProduct(id) {
  if (!confirm("¿Seguro que quieres eliminar este producto?")) return;
  await fetch(`${API_URL}/${id}`, { method: "DELETE" });
  fetchProducts();
}

fetchProducts();
