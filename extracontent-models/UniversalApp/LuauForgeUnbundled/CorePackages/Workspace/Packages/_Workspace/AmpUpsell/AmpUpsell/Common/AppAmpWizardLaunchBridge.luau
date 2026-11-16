local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AppCommonLib").Signal
require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Types")

local v5 = signal.new()

return {
	requestOpen = function(p2)
		local v6 = { params = p2, handled = false }

		v5:fire(v6)
		return v6.handled
	end,
	subscribe = function(callback)
		return v5:connect(function(state)
			if state.handled then
				return
			end

			state.handled = true
			callback(state.params)
		end)
	end
}
