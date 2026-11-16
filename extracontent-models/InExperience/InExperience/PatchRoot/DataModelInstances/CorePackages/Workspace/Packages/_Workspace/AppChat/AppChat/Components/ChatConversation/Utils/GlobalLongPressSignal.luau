local parent = script:FindFirstAncestor("AppChat").Parent

local AppCommonLib = require(parent.AppCommonLib)
local signal = AppCommonLib.Signal.new()

return {
	dismissed = signal,
	dismiss = function()
		signal:fire()
	end
}
