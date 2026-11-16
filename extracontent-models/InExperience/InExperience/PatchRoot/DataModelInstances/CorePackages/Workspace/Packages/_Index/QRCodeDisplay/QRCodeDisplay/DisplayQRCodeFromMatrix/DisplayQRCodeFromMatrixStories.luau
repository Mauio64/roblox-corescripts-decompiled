local parent = script:FindFirstAncestor("QRCodeDisplay").Parent

local DisplayQRCodeFromMatrix = require(script.Parent.DisplayQRCodeFromMatrix)
local React = require(parent.React)
local QRCode = require(parent.QRCode)
local DisplayQRCodeFromMatrixStories = {}

function DisplayQRCodeFromMatrixStories.SimpleMatrix()
	return React.createElement(DisplayQRCodeFromMatrix, {
		qrCodeMatrix = {
			{ 1, 0 },
			{ 1, 0 }
		},
		sideLength = 100
	})
end

function DisplayQRCodeFromMatrixStories.ComplexMatrix()
	local _, qrCodeMatrix = QRCode.qrcode("https://www.bbc.com/news", 4)
	return React.createElement(DisplayQRCodeFromMatrix, {
		qrCodeMatrix = qrCodeMatrix,
		sideLength = 200
	})
end

function DisplayQRCodeFromMatrixStories.SuperComplexMatrix()
	local _, qrCodeMatrix = QRCode.qrcode(
		"https://ro.blox.com/Ebh5?pid=share&is_retargeting=true&af_dp=roblox%3A%2F%2Fnavigation%2Fshare_links%3Fcode%3D6e5de960f12ec44797d1d974c76605ff%26type%3DFriendInvite&af_web_dp=https%3A%2F%2Fwww.roblox.com%2Fshare-links%3Fcode%3D6e5de960f12ec44797d1d974c76605ff%26type%3DFriendInvite",
		2
	)

	return React.createElement(DisplayQRCodeFromMatrix, {
		qrCodeMatrix = qrCodeMatrix,
		sideLength = 400
	})
end

function DisplayQRCodeFromMatrixStories.CustomisedMatrix()
	local _, qrCodeMatrix = QRCode.qrcode(
		"https://ro.blox.com/Ebh5?pid=share&is_retargeting=true&af_dp=roblox%3A%2F%2Fnavigation%2Fshare_links%3Fcode%3D6e5de960f12ec44797d1d974c76605ff%26type%3DFriendInvite&af_web_dp=https%3A%2F%2Fwww.roblox.com%2Fshare-links%3Fcode%3D6e5de960f12ec44797d1d974c76605ff%26type%3DFriendInvite",
		4
	)

	return React.createElement(DisplayQRCodeFromMatrix, {
		qrCodeMatrix = qrCodeMatrix,
		sideLength = 200,
		pixelColor3 = Color3.new(1, 0, 1),
		backgroundColor3 = Color3.new(0, 1, 0)
	})
end

function DisplayQRCodeFromMatrixStories.ReallySmallSideLength()
	local _, qrCodeMatrix = QRCode.qrcode(
		"https://ro.blox.com/Ebh5?pid=share&is_retargeting=true&af_dp=roblox%3A%2F%2Fnavigation%2Fshare_links%3Fcode%3D6e5de960f12ec44797d1d974c76605ff%26type%3DFriendInvite&af_web_dp=https%3A%2F%2Fwww.roblox.com%2Fshare-links%3Fcode%3D6e5de960f12ec44797d1d974c76605ff%26type%3DFriendInvite",
		4
	)

	return React.createElement(DisplayQRCodeFromMatrix, {
		qrCodeMatrix = qrCodeMatrix,
		sideLength = 1
	})
end

return DisplayQRCodeFromMatrixStories
