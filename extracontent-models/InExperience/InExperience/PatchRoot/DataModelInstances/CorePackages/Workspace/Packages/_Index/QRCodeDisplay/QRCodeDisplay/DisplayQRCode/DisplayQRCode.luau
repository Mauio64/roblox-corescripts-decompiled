local QRCodeDisplay = script:FindFirstAncestor("QRCodeDisplay")
local parent = QRCodeDisplay.Parent
local React = require(parent.React)
local Dash = require(parent.Dash)
local DisplayQRCodeFromMatrix = require(script.Parent.Parent.DisplayQRCodeFromMatrix.DisplayQRCodeFromMatrix)
require(QRCodeDisplay.Common.ECLevels)
local useQRCode = require(script.Parent.useQRCode)

return function(p)
	local v = { qrCodeMatrix = useQRCode(p) }

	return React.createElement(DisplayQRCodeFromMatrix, Dash.join(p, v))
end
