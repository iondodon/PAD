const http = require("http")
const express = require("express")

const app = express()

app.get("/", (_req, res) => {
	res.send("response")
})

app.listen(9090)