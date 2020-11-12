const fetch = require("node-fetch")

const updatePreparedOrdersList = () => {
	const requestOptions = { method: "GET" }

	setInterval(() => {
		console.log("Updating prepared orders list")
		fetch(`http://${process.env.GATEWAY_ADDRESS}:${process.env.GATEWAY_PORT}/orders-service/order`,
			requestOptions)
			.then(response => console.log(response))
			.then(data => console.log(data))
			.catch(err => console.log(err))
	}, 1000)
}

module.exports = updatePreparedOrdersList