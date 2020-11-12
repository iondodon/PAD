const fetch = require("node-fetch")

const register = () => {
	const requestOptions = {
		headers: {
			"content-type": "application/json; charset=UTF-8"
		},
		body: JSON.stringify({
			"address": process.env.SERVICE_ADDRESS +":" + process.env.SERVER_PORT,
			"service": process.env.SERVICE_NAME
		}),
		method: "POST"
	}

	fetch(`http://${process.env.GATEWAY_ADDRESS}:${process.env.GATEWAY_PORT}/register`,
		requestOptions)
		.then(response => console.log(response))
		.then(data => console.log(data))
		.catch(err => console.log(err))
}

module.exports = register