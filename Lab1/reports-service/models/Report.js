const mongoose = require("mongoose")

const ReportSchema = mongoose.Schema({
	title: {
		type: String,
		required: true
	},
	description: {
		type: String,
		required: true
	},
	date: {
		type: Date,
		default: Date.now,
		required: true
	},
	preparedOrders: {
		type: [[Object]],
		required: true
	}
})

module.exports = mongoose.model("Report", ReportSchema)