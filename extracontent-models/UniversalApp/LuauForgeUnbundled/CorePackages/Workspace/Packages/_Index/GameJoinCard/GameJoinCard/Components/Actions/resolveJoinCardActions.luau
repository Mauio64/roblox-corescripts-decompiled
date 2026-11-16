local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/DataHydration")
local buttonVariant = Foundation.Enums.ButtonVariant

require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")
local actionFactories = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/actionFactories")

local function resolveJoinCardActions(p2, p3)
	local joinCardActions = {}

	if p2 == nil or p2.actions == nil then
		return joinCardActions
	end

	local flag = false

	for k, action in p2.actions do
		local v5 = actionFactories[action.type]

		if v5 == nil then
			continue
		end

		local v6 = v5(p3)

		if v6 == nil then
			continue
		end

		if v6.render == nil then
			if flag then
				if v6.variant ~= buttonVariant.Utility then
					v6.variant = buttonVariant.Standard
				end
			else
				v6.variant = v6.variant or buttonVariant.Emphasis
			end

			flag = true
		end

		table.insert(joinCardActions, v6)
	end

	return joinCardActions
end

return resolveJoinCardActions
