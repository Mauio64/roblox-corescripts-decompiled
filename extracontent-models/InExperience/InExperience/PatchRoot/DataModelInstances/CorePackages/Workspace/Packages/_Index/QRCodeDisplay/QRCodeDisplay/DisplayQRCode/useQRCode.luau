local QRCodeDisplay = script:FindFirstAncestor("QRCodeDisplay")
local parent = QRCodeDisplay.Parent
local React = require(parent.React)
local QRCode = require(parent.QRCode)
local ecToNumber = require(script.Parent.ecToNumber)
require(QRCodeDisplay.Common.ECLevels)

return function(p)
	return React.useMemo(function()
		local _, v = QRCode.qrcode(p.toEncode, ecToNumber(p.ecLevel))

		return v
	end, { p.toEncode, p.ecLevel })
end
