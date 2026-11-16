local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/AppCommonLib").Signal.new()

return {
	requestOpen = function(p2)
		signal:fire(p2)
	end,
	subscribe = function(p2)
		return signal:connect(p2)
	end
}
