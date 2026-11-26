local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Signal.new()

return {
	dismissed = signal,
	dismiss = function()
		signal:fire()
	end
}
