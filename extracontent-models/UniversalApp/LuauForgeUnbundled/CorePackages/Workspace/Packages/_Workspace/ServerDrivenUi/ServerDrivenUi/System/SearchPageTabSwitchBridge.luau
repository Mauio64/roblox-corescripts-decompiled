local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AppCommonLib").Signal.new()

return {
	switchTab = function(p2, p3)
		signal:fire(p2, p3)
	end,
	connect = function(p2)
		return signal:connect(p2)
	end
}
