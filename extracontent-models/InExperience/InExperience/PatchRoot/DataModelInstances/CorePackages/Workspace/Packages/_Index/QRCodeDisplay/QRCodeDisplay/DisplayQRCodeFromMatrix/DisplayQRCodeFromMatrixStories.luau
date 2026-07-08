local Parent = script:FindFirstAncestor("QRCodeDisplay").Parent
local DisplayQRCodeFromMatrix = require(script.Parent.DisplayQRCodeFromMatrix)
local React = require(Parent.React)
local QRCode = require(Parent.QRCode)

return {
	SimpleMatrix = function() -- line: 9
		-- upvalues: React (copy), DisplayQRCodeFromMatrix (copy)
		return React.createElement(DisplayQRCodeFromMatrix, {
			sideLength = 100,
			qrCodeMatrix = {
				{
					1,
					0
				},
				{
					1,
					0
				}
			}
		})
	end,
	ComplexMatrix = function() -- line: 16
		-- upvalues: QRCode (copy), React (copy), DisplayQRCodeFromMatrix (copy)
		local _, v6 = QRCode.qrcode("https://www.bbc.com/news", 4)

		return React.createElement(DisplayQRCodeFromMatrix, {
			sideLength = 200,
			qrCodeMatrix = v6
		})
	end,
	SuperComplexMatrix = function() -- line: 24
		-- upvalues: QRCode (copy), React (copy), DisplayQRCodeFromMatrix (copy)
		local _, v8 = QRCode.qrcode("https://ro.blox.com/Ebh5?pid=share&is_retargeting=true&af_dp=roblox%3A%2F%2Fnavigation%2Fshare_links%3Fcode%3D6e5de960f12ec44797d1d974c76605ff%26type%3DFriendInvite&af_web_dp=https%3A%2F%2Fwww.roblox.com%2Fshare-links%3Fcode%3D6e5de960f12ec44797d1d974c76605ff%26type%3DFriendInvite", 2)

		return React.createElement(DisplayQRCodeFromMatrix, {
			sideLength = 400,
			qrCodeMatrix = v8
		})
	end,
	CustomisedMatrix = function() -- line: 35
		-- upvalues: QRCode (copy), React (copy), DisplayQRCodeFromMatrix (copy)
		local _, v10 = QRCode.qrcode("https://ro.blox.com/Ebh5?pid=share&is_retargeting=true&af_dp=roblox%3A%2F%2Fnavigation%2Fshare_links%3Fcode%3D6e5de960f12ec44797d1d974c76605ff%26type%3DFriendInvite&af_web_dp=https%3A%2F%2Fwww.roblox.com%2Fshare-links%3Fcode%3D6e5de960f12ec44797d1d974c76605ff%26type%3DFriendInvite", 4)

		return React.createElement(DisplayQRCodeFromMatrix, {
			sideLength = 200,
			qrCodeMatrix = v10,
			pixelColor3 = Color3.new(1, 0, 1),
			backgroundColor3 = Color3.new(0, 1, 0)
		})
	end,
	ReallySmallSideLength = function() -- line: 48
		-- upvalues: QRCode (copy), React (copy), DisplayQRCodeFromMatrix (copy)
		local _, v12 = QRCode.qrcode("https://ro.blox.com/Ebh5?pid=share&is_retargeting=true&af_dp=roblox%3A%2F%2Fnavigation%2Fshare_links%3Fcode%3D6e5de960f12ec44797d1d974c76605ff%26type%3DFriendInvite&af_web_dp=https%3A%2F%2Fwww.roblox.com%2Fshare-links%3Fcode%3D6e5de960f12ec44797d1d974c76605ff%26type%3DFriendInvite", 4)

		return React.createElement(DisplayQRCodeFromMatrix, {
			sideLength = 1,
			qrCodeMatrix = v12
		})
	end
}
