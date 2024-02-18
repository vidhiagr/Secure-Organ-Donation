import React, { useState } from "react";
import { Form, Input, Button } from "antd";
import "./App.css";
import organchain from './organchain';
import web3 from './web3';
import donate from "./donate.svg";

const FindMatch = () => {
	const [donorAddress, setDonorAddress] = useState("");

	const handleAddress = (e) => {
		setDonorAddress(e.target.value);
	};

	const submitForm = async e => {
		e.preventDefault();
		const accounts = await window.ethereum.enable();
		const account = accounts[0];
		const gas = await organchain.methods.transplantmatch(donorAddress).estimateGas();
		const result = organchain.methods.transplantmatch(donorAddress).send({ from: account, gas});
		console.log(result);
/*
		organchain.methods.
		getdonorandrecipientwithtransplant(donorAddress)
		.call()
		.then(console.log);*/
		
	};
	return (
		<div className="form-container">
			<img src={donate} width="500px" alt="donate" />
			<div className="form">
				
				<div
					style={{
						fontSize: "25px",
						margin: "0px 0px 20px 0px",
						borderBottom: "1px solid #b0bec5",
						paddingBottom: "10px",
						color: "grey",
					}}
				>
					Find Transplant Match
				</div>
				<hr />
				<Form
					style={{ width: "60%" }}
					name="basic"
					initialValues={{ remember: true }}
				>
					<Form.Item>
						<div
							style={{
								display: "flex",
								flexDirection: "column",
								width: "100%",
							}}
						>
							<span style={{ fontSize: "15px" }}>Donor's address</span>
							<Input
								value={donorAddress}
								onChange={handleAddress}
								className="input"
							/>
							<span>We'll never share your information with anyone</span>
						</div>
					</Form.Item>
					<Form.Item>
						<Button
							type="primary"
							style={{
								width: "100%",
								height: "40px",
								marginTop: "20px",
								borderRadius: "4px",
								fontSize: "17px",
								backgroundColor: "#6C63FF",
							}}
							htmlType="submit"
							onClick={submitForm}
						>
							Submit
						</Button>
					</Form.Item>
				</Form>
			</div>

		</div>
	);
};

export default FindMatch;
