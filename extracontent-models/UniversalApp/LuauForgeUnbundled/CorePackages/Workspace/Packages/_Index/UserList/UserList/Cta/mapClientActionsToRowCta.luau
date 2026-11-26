local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local buttonVariant = Foundation.Enums.ButtonVariant
local buttonTypes = Enums.ButtonTypes
local handlerEntriesByViewProfile = {
	[Enums.ClientCtaActions.ViewProfile] = {
		buttonType = buttonTypes.View,
		handlerKey = buttonTypes.View,
		variant = buttonVariant.Standard
	}
}

local function mapClientActionsToRowCta(p2, p3, p4, data, p5)
	local clientActions = if data then data.clientActions else nil

	if not clientActions or p4 then
		return nil
	end

	for k, clientAction in clientActions do
		local v5 = handlerEntriesByViewProfile[clientAction]
		local v6 = if v5 then p2[v5.handlerKey] else nil

		if v5 and v6 then
			local v7 = v6
			local v8 = {
				type = v5.buttonType,
				onActivated = function()
					v7(p3, p5)
				end,
				variant = v5.variant,
				minWidth = 0,
				maxWidth = 0
			}
			local v9 = if data then data.primaryCtaMinWidth else nil
			v8.minWidth = v9
			local v10 = if data then data.primaryCtaMaxWidth else nil
			v8.maxWidth = v10
			return { primaryCta = v8, secondaryCta = nil }
		end
	end

	return nil
end

return mapClientActionsToRowCta
