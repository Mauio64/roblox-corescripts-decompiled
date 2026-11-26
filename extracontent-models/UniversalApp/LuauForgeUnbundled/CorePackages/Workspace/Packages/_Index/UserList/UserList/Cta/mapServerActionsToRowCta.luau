local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local FFlagUserListCanonicalCtaAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListCanonicalCtaAnalytics")
local fFlagUserListActionsV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListActionsV2
local fFlagUserListHideNotJoinableJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListHideNotJoinableJoin

local iconName = Foundation.Enums.IconName
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonTypes = Enums.ButtonTypes
local joinability = Enums.Joinability

local v5 = {
	AddFriend = { buttonType = buttonTypes.Add, handlerKey = buttonTypes.Add },
	AcceptFriendRequest = {
		buttonType = buttonTypes.Accept,
		handlerKey = buttonTypes.Accept,
		supportsDismiss = true
	},
	PendingFriendRequest = { buttonType = buttonTypes.Pending, isDisabled = true },
	CannotAddFriend = { buttonType = buttonTypes.Add, isDisabled = true },
	Chat = {
		buttonType = buttonTypes.Chat,
		handlerKey = buttonTypes.Chat,
		variant = buttonVariant.Standard
	},
	JoinExperience = { buttonType = buttonTypes.Join }
}

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

local function isJoinable(p2, p3): boolean
	if p3 and p3.enableJoinabilityCheck and p2.type == buttonTypes.JoinExperience then
		return p2.joinability ~= joinability.NotJoinable
	end

	return true
end

local function mapServerActionsToRowCta(p2, p3, p4, data, p5)
	if not (p2 and p2.buttons) then
		return { primaryCta = nil, secondaryCta = nil }
	end

	local supportedActions = if data then data.supportedActions else nil

	for k, button in p2.buttons do
		local v6 = v5[button.type]

		if not ((not fFlagUserListHideNotJoinableJoin or not data or not data.enableJoinabilityCheck or button.type ~= buttonTypes.JoinExperience or button.joinability ~= joinability.NotJoinable) and v6) then
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
			local v7 = if v6.handlerKey then p3[v6.handlerKey] else nil
			local v8 = {
				type = v6.buttonType,
				onActivated = 0,
				isDisabled = 0,
				disabledReason = 0,
				variant = 0,
				minWidth = 0,
				maxWidth = 0
			}
			local v9

			if v7 then
				local v10 = v7

				v9 = function()
					v10(p4, if FFlagUserListCanonicalCtaAnalytics then p5 else nil)
				end
			else
				v9 = fn
			end

			v8.onActivated = v9

			local v10 = if fFlagUserListActionsV2 then (v6.isDisabled or button.disabledReason ~= nil) and true or nil else v6.isDisabled
			v8.isDisabled = v10

			v8.disabledReason = button.disabledReason
			v8.variant = v6.variant
			local v11 = if data then data.primaryCtaMinWidth else nil
			v8.minWidth = v11
			local v12 = if data then data.primaryCtaMaxWidth else nil
			v8.maxWidth = v12
			local v13

			if v6.supportsDismiss and data and data.showDismissForRequests then
				local v14 = p3[buttonTypes.Dismiss]
				v13 = { type = buttonTypes.Dismiss, icon = iconName.X, onActivated = 0 }
				local v15

				if v14 then
					v15 = function()
						v14(p4, if FFlagUserListCanonicalCtaAnalytics then p5 else nil)
					end
				else
					v15 = fn
				end

				v13.onActivated = v15
			end

			return { primaryCta = v8, secondaryCta = v13 }
		end
	end

	return { primaryCta = nil, secondaryCta = nil }
end

return mapServerActionsToRowCta
