const Report = require("../models/Report")

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

module.exports = saveNewReport