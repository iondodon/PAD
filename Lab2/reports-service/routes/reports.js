const express = require("express")
const Report = require("../models/Report")

const router = express.Router()

router.get("/", async (_req, res) => {
	console.log("Get all reports")
	try {
		const reports = await Report.find()
		res.status(200).json(reports)
	} catch(err) {
		console.log(err)
		res.status(500).json({ message: err })
	}
})

router.get("/:reportID", async (req, res) => {
	console.log("Get report " + req.params.reportID)
	try {
		const report = await Report.findById(req.params.reportID)
		report ?
			res.status(200).json(report) :
			res.status(404).json({ message: "resource not found" })
	} catch(err) {
		console.log(err)
		res.status(500).json({ message: err })
	}
})

router.post("/", async (req, res) => {
	console.log("Post report")
	const report = new Report(req.body)

	try {
		const savedReport = await report.save()
		res.status(201).json(savedReport)
	} catch(err) {
		console.log(err)
		res.status(500).json({ message: err })
	}
})

router.put("/:reportID", async (req, res) => {
	console.log("Update report " + req.params.reportID)
	try {
		const response = await Report.updateOne(
			{ _id: req.params.reportID },
			{
				$set: {
					title: req.body.title
				}
			}
		)
		response["nModified"] == 0 ?
			res.status(404).json({ message: "resource not found" }) :
			res.status(200).json(response)
	} catch(err) {
		console.log(err)
		res.status(500).json({ message: err })
	}
})

router.delete("/:reportID", async (req, res) => {
	console.log("Delete report " + req.params.reportID)
	try {
		const response = await Report.deleteOne({ _id: req.params.reportID })
		response["deletedCount"] == 0 ?
			res.status(404).json({ message: "resource not found" }) :
			res.status(200).json(response)
	} catch(err) {
		console.log(err)
		res.status(500).json({ message: err })
	}
})

module.exports = router