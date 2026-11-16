local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local Foundation = require(parent.Foundation)
local Enums = require(UserList.Common.Enums)
require(UserList.Common.Types)

local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonTypes = Enums.ButtonTypes
local handlerEntriesByViewProfile = {
	[Enums.ClientCtaActions.ViewProfile] = {
		buttonType = ButtonTypes.View,
		handlerKey = ButtonTypes.View,
		variant = ButtonVariant.Standard
	}
}

local function mapClientActionsToRowCta(p, p2: string, flag: boolean, data, p3: number?)
	local clientActions

	if data then
		clientActions = data.clientActions
	end

	if not clientActions or flag then
		return nil
	end

	for _, clientAction in clientActions do
		local v = handlerEntriesByViewProfile[clientAction]
		local v2

		if v then
			v2 = p[v.handlerKey]
		end

		if v and v2 then
			local v3 = v2
			local primaryCta = {
				type = v.buttonType,
				onActivated = function()
					v3(p2, p3)
				end,
				variant = v.variant,
				minWidth = 0,
				maxWidth = 0
			}
			local minWidth

			if data then
				minWidth = data.primaryCtaMinWidth
			end

			primaryCta.minWidth = minWidth
			local maxWidth

			if data then
				maxWidth = data.primaryCtaMaxWidth
			end

			primaryCta.maxWidth = maxWidth
			return { primaryCta = primaryCta, secondaryCta = nil }
		end
	end

	return nil
end

return mapClientActionsToRowCta
