local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

local AppCommonLib = require(parent.AppCommonLib)
local signal = AppCommonLib.Signal.new()
local OpenProfileQRCodePageBridge = {}

function OpenProfileQRCodePageBridge.requestOpen(p)
	signal:fire(p)
end

function OpenProfileQRCodePageBridge.subscribe(callback)
	return signal:connect(callback)
end

return OpenProfileQRCodePageBridge
