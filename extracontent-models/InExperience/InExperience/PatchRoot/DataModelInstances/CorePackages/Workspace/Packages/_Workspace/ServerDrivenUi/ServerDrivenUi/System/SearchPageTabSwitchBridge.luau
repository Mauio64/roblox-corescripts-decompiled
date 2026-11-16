local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local AppCommonLib = require(parent.AppCommonLib)
local signal = AppCommonLib.Signal.new()
local SearchPageTabSwitchBridge = {}

function SearchPageTabSwitchBridge.switchTab(p: string, p2: string)
	signal:fire(p, p2)
end

function SearchPageTabSwitchBridge:connect()
	return signal:connect(self)
end

return SearchPageTabSwitchBridge
