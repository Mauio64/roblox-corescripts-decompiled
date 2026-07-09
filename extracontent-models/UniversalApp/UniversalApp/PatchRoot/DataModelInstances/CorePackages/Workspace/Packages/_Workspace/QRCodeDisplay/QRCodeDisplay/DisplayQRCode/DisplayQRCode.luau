local QRCodeDisplay = script:FindFirstAncestor("QRCodeDisplay")
local QRCodeDisplayParent = QRCodeDisplay.Parent
local React = require(QRCodeDisplayParent.React)
local Dash = require(QRCodeDisplayParent.Dash)
local DisplayQRCodeFromMatrix = require(script.Parent.Parent.DisplayQRCodeFromMatrix.DisplayQRCodeFromMatrix)

require(QRCodeDisplay.Common.ECLevels)

local useQRCode = require(script.Parent.useQRCode)

return function(t1: {[any]: any}) -- line: 21
	-- upvalues: useQRCode (copy), React (copy), DisplayQRCodeFromMatrix (copy), Dash (copy)
	local t2 = {
		qrCodeMatrix = useQRCode(t1)
	}

	return React.createElement(DisplayQRCodeFromMatrix, Dash.join(t1, t2))
end
