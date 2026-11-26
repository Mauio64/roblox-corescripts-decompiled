local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")

local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")

local function TopBarFromStore(p2)
	local screenName = p2.screenName
	local render = p2.render

	local v5 = GetTopBarStore(false)
	local screenTopBar = v5.getScreenTopBar(screenName)
	local v6 = SignalsReact.useSignalState(screenTopBar)

	return render((React.useMemo(function()
		return {
			getScreenTopBar = function(p3)
				if p3 == screenName then
					return v6
				end

				return v5.getScreenTopBar(p3)(false)
			end,
			setScreenTopBar = v5.setScreenTopBar
		}
	end, { screenName, v6, v5.getScreenTopBar, v5.setScreenTopBar })))
end

return TopBarFromStore
