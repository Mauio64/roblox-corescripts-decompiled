require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local userCtaAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserCtaCommon").Enums.UserCtaAction

require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")

local function buildJoinCardActionsComponent(items, data, callback, callback2)
	local v5 = nil
	local result = {}

	for k, item in items do
		if v5 == nil then
			if item.id == userCtaAction.JoinExperience then
				v5 = { title = data.playTogether }
			else
				v5 = item.id == userCtaAction.PlayExperience
					and {
						title = data.playTogetherSoon,
						subtitle = data.differentServer
					}
					or nil
			end
		end

		local v6

		if item.keepOpenOnActivate then
			v6 = item
		else
			v6 = table.clone(item)
			function v6.onActivated(...)
				item.onActivated(...)
				callback()
			end
		end

		local formatted = `Action_{k}`
		local v7 = if v6.render == nil then callback2(v6, k) else v6.render(v6, k)
		result[formatted] = v7
	end

	return result, v5
end

return buildJoinCardActionsComponent
