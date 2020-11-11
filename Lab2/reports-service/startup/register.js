const fetch = require("node-fetch")

const register = () => {
	const requestOptions = {
		headers: {
			"content-type": "application/json; charset=UTF-8"
		},
		body: JSON.stringify({
			"address": "reports-service1:9090",
			"service": "reports-service"
		}),
		method: "POST"
	}

	fetch("http://gateway:7171/register", requestOptions)
		.then(response => console.log(response))
		.then(data => console.log(data))
		.catch(err => console.log(err))
}

module.exports = register