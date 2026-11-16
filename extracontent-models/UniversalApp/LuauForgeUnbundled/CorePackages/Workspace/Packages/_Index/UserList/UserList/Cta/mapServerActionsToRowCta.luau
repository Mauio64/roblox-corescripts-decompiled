local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local FFlagUserListChatCtaStandardVariant = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListChatCtaStandardVariant")
local FFlagUserListCanonicalCtaAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListCanonicalCtaAnalytics")

local iconName = Foundation.Enums.IconName
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonTypes = Enums.ButtonTypes

local v5 = {
	AddFriend = { buttonType = buttonTypes.Add, handlerKey = buttonTypes.Add },
	AcceptFriendRequest = {
		buttonType = buttonTypes.Accept,
		handlerKey = buttonTypes.Accept,
		supportsDismiss = true
	},
	PendingFriendRequest = { buttonType = buttonTypes.Pending, isDisabled = true },
	CannotAddFriend = { buttonType = buttonTypes.Add, isDisabled = true },
	Chat = 0,
	JoinExperience = 0
}
local v6 = { buttonType = buttonTypes.Chat, handlerKey = buttonTypes.Chat, variant = 0 }
local v7 = if FFlagUserListChatCtaStandardVariant then buttonVariant.Standard else nil
v6.variant = v7
v5.Chat = v6

v5.JoinExperience = { buttonType = buttonTypes.Join }

local function fn() end

local function isSupported(items, p2): boolean
	if not items then
		return true
	end

	for k, item in items do
		if item == p2 then
			return true
		end
	end

	return false
end

local function mapServerActionsToRowCta(p2, p3, p4, data, p5)
	if not (p2 and p2.buttons) then
		return { primaryCta = nil, secondaryCta = nil }
	end

	local supportedActions = if data then data.supportedActions else nil

	for k, button in p2.buttons do
		local v8 = v5[button.type]

		if not v8 then
			continue
		end

		local kind = button.type
		local flag

		if supportedActions then
			local flag2 = true

			for k2, supportedAction in supportedActions do
				if supportedAction == kind then
					flag = true
					flag2 = false
					break
				end
			end

			if flag2 then
				flag = false
			end
		else
			flag = true
		end

		if flag then
			local v9 = if v8.handlerKey then p3[v8.handlerKey] else nil
			local v10 = {
				type = v8.buttonType,
				onActivated = 0,
				isDisabled = 0,
				disabledReason = 0,
				variant = 0,
				minWidth = 0,
				maxWidth = 0
			}
			local v11

			if v9 then
				local v12 = v9

				v11 = function()
					v12(p4, if FFlagUserListCanonicalCtaAnalytics then p5 else nil)
				end
			else
				v11 = fn
			end

			v10.onActivated = v11

			v10.isDisabled = v8.isDisabled
			v10.disabledReason = button.disabledReason
			local v12 = if FFlagUserListChatCtaStandardVariant then v8.variant else nil
			v10.variant = v12
			local v13 = if data then data.primaryCtaMinWidth else nil
			v10.minWidth = v13
			local v14 = if data then data.primaryCtaMaxWidth else nil
			v10.maxWidth = v14
			local v15

			if v8.supportsDismiss and data and data.showDismissForRequests then
				local v16 = p3[buttonTypes.Dismiss]
				v15 = { type = buttonTypes.Dismiss, icon = iconName.X, onActivated = 0 }
				local v17

				if v16 then
					v17 = function()
						v16(p4, if FFlagUserListCanonicalCtaAnalytics then p5 else nil)
					end
				else
					v17 = fn
				end

				v15.onActivated = v17
			end

			return { primaryCta = v10, secondaryCta = v15 }
		end
	end

	return { primaryCta = nil, secondaryCta = nil }
end

return mapServerActionsToRowCta
