local React = require("@game/CorePackages/Workspace/Packages/_Workspace/QRCodeDisplay/React")
local QRCode = require("@game/CorePackages/Workspace/Packages/_Workspace/QRCodeDisplay/QRCode")
local ecToNumber = require("@game/CorePackages/Workspace/Packages/_Index/QRCodeDisplay/QRCodeDisplay/DisplayQRCode/ecToNumber")
require("@game/CorePackages/Workspace/Packages/_Index/QRCodeDisplay/QRCodeDisplay/Common/ECLevels")

return function(p2)
	return React.useMemo(function()
		local qrcode, v5 = QRCode.qrcode(p2.toEncode, ecToNumber(p2.ecLevel))

		return v5
	end, { p2.toEncode, p2.ecLevel })
end
