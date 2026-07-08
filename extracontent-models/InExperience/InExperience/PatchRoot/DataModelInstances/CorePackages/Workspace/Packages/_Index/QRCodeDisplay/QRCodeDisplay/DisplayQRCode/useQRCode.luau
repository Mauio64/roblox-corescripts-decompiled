local QRCodeDisplay = script:FindFirstAncestor("QRCodeDisplay")
local QRCodeDisplayParent = QRCodeDisplay.Parent
local React = require(QRCodeDisplayParent.React)
local QRCode = require(QRCodeDisplayParent.QRCode)
local ecToNumber = require(script.Parent.ecToNumber)

require(QRCodeDisplay.Common.ECLevels)

return function(t1: {[any]: any}) -- line: 8
	-- upvalues: React (copy), QRCode (copy), ecToNumber (copy)
	return React.useMemo(function() -- line: 9
		-- upvalues: QRCode (copy), t1 (copy), ecToNumber (copy)
		local _, v8 = QRCode.qrcode(t1.toEncode, ecToNumber(t1.ecLevel))

		return v8
	end, {
		t1.toEncode,
		t1.ecLevel
	})
end
