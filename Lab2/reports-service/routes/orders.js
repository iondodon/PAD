const express = require("express")
const Report = require("../models/Report")
const axios = require("axios")
const { response } = require("express")

const router = express.Router()

const saveNewReport = async (req, res, orders) => {
	const newReport = new Report({
		title: req.body.title,
		description: req.body.description,
		preparedOrders: orders
	})

	try {
		const savedReport = await newReport.save()
		res.status(201).json(savedReport)
	} catch(err) {
		console.log(err)
		res.status(500).json({ message: err })
	}
}

router.post("/make", async (req, res) => {
	console.log("Get all prepared orders")

	try {
		const response = await axios.get(`http://${process.env.GATEWAY_ADDRESS}:${process.env.GATEWAY_PORT}/orders-service/order`)
		if(response.data) {
			const preparedOrders = response.data.filter(order => order["isPrepared"] == true)
			saveNewReport(req, res, preparedOrders)
		}
	}catch(err) {
		res.status(500).send(err)
		console.log(response)
	}
})

module.exports = router