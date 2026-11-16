local parent = script:FindFirstAncestor("GameJoinCard").Parent

require(parent.React)
local UserCtaCommon = require(parent.UserCtaCommon)
local UserCtaAction = UserCtaCommon.Enums.UserCtaAction

require(script.Parent.Types)

local function buildJoinCardActionsComponent(items, data, callback, callback2)
	local v = nil
	local result = {}

	for k, item in items do
		if v == nil then
			if item.id == UserCtaAction.JoinExperience then
				v = { title = data.playTogether }
			else
				v = item.id == UserCtaAction.PlayExperience
					and { title = data.playTogetherSoon, subtitle = data.differentServer }
					or nil
			end
		end

		local v2

		if item.keepOpenOnActivate then
			v2 = item
		else
			v2 = table.clone(item)
			function v2.onActivated(...)
				item.onActivated(...)
				callback()
			end
		end

		local formatted = `Action_{k}`
		local v3

		if v2.render == nil then
			v3 = callback2(v2, k)
		else
			v3 = v2.render(v2, k)
		end

		result[formatted] = v3
	end

	return result, v
end

return buildJoinCardActionsComponent
