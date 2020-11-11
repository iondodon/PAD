const express = require("express")
const bodyParser = require("body-parser")
const mongoose = require("mongoose")
const app = express()
const reportsRoutes = require("./routes/reports")
const cors = require("cors")
const register = require("./startup/register")
require("dotenv/config")


app.use(cors())
app.use(bodyParser.json())


app.use("/report", reportsRoutes)
app.get("/", (_req, res) => {
	res.send("Welcome to reports service!")
})


mongoose.connect(
	process.env.DB_CONNECTION_URL,
	{ useNewUrlParser: true, useUnifiedTopology: true },
	(error) => console.log(error ? error : "Connected to Mongo DB")
)


register()

app.listen(9090)