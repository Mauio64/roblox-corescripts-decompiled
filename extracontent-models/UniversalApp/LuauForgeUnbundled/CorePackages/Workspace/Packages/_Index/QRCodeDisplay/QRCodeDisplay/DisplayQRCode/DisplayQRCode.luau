local React = require("@game/CorePackages/Workspace/Packages/_Workspace/QRCodeDisplay/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/QRCodeDisplay/Dash")
local DisplayQRCodeFromMatrix = require("@game/CorePackages/Workspace/Packages/_Index/QRCodeDisplay/QRCodeDisplay/DisplayQRCodeFromMatrix/DisplayQRCodeFromMatrix")
require("@game/CorePackages/Workspace/Packages/_Index/QRCodeDisplay/QRCodeDisplay/Common/ECLevels")
local useQRCode = require("@game/CorePackages/Workspace/Packages/_Index/QRCodeDisplay/QRCodeDisplay/DisplayQRCode/useQRCode")

return function(p2)
	local v5 = { qrCodeMatrix = useQRCode(p2) }

	return React.createElement(DisplayQRCodeFromMatrix, Dash.join(p2, v5))
end
