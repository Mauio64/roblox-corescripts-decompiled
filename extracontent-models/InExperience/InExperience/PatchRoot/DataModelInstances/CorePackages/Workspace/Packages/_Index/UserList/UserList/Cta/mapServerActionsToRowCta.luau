local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local Foundation = require(parent.Foundation)
local Enums = require(UserList.Common.Enums)
require(UserList.Common.Types)

local FFlagUserListCanonicalCtaAnalytics = require(UserList.Flags.FFlagUserListCanonicalCtaAnalytics)
local SharedFlags = require(parent.SharedFlags)
local FFlagUserListActionsV2 = SharedFlags.FFlagUserListActionsV2
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserListHideNotJoinableJoin = SharedFlags2.FFlagUserListHideNotJoinableJoin

local IconName = Foundation.Enums.IconName
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonTypes = Enums.ButtonTypes
local Joinability = Enums.Joinability

local v = {
	AddFriend = { buttonType = ButtonTypes.Add, handlerKey = ButtonTypes.Add },
	AcceptFriendRequest = {
		buttonType = ButtonTypes.Accept,
		handlerKey = ButtonTypes.Accept,
		supportsDismiss = true
	},
	PendingFriendRequest = { buttonType = ButtonTypes.Pending, isDisabled = true },
	CannotAddFriend = { buttonType = ButtonTypes.Add, isDisabled = true },
	Chat = {
		buttonType = ButtonTypes.Chat,
		handlerKey = ButtonTypes.Chat,
		variant = ButtonVariant.Standard
	},
	JoinExperience = { buttonType = ButtonTypes.Join }
}

local function fn() end

local function isSupported(supportedActions, kind: string): boolean -- 1 equivalent call inferred from this helper
	if not supportedActions then
		return true
	end

	for _, item in supportedActions do
		if item == kind then
			return true
		end
	end

	return false
end

local function isJoinable(p, p2): boolean
	if p2 and p2.enableJoinabilityCheck and p.type == ButtonTypes.JoinExperience then
		return p.joinability ~= Joinability.NotJoinable
	end

	return true
end

local function mapServerActionsToRowCta(p, p2, p3: string, data, p4: number?)
	if not (p and p.buttons) then
		return { primaryCta = nil, secondaryCta = nil }
	end

	local supportedActions

	if data then
		supportedActions = data.supportedActions
	end

	for _, button in p.buttons do
		local v2 = v[button.type]

		if
			(not FFlagUserListHideNotJoinableJoin or not data or not data.enableJoinabilityCheck or button.type ~= ButtonTypes.JoinExperience or button.joinability ~= Joinability.NotJoinable)
			and v2
			and isSupported(supportedActions, button.type) -- inferred equivalent call
		then
			local v3

			if v2.handlerKey then
				v3 = p2[v2.handlerKey]
			end

			local primaryCta = {
				type = v2.buttonType,
				onActivated = 0,
				isDisabled = 0,
				disabledReason = 0,
				variant = 0,
				minWidth = 0,
				maxWidth = 0
			}
			local onActivated

			if v3 then
				local v4 = v3

				onActivated = function()
					local v5

					if FFlagUserListCanonicalCtaAnalytics then
						v5 = p4
					end

					v4(p3, v5)
				end
			else
				onActivated = fn
			end

			primaryCta.onActivated = onActivated
			local isDisabled

			if FFlagUserListActionsV2 then
				isDisabled = (v2.isDisabled or button.disabledReason ~= nil) and true or nil
			else
				isDisabled = v2.isDisabled
			end

			primaryCta.isDisabled = isDisabled

			primaryCta.disabledReason = button.disabledReason
			primaryCta.variant = v2.variant
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
			local secondaryCta

			if v2.supportsDismiss and data and data.showDismissForRequests then
				local v4 = p2[ButtonTypes.Dismiss]
				secondaryCta = { type = ButtonTypes.Dismiss, icon = IconName.X, onActivated = 0 }
				local onActivated2

				if v4 then
					onActivated2 = function()
						local v5

						if FFlagUserListCanonicalCtaAnalytics then
							v5 = p4
						end

						v4(p3, v5)
					end
				else
					onActivated2 = fn
				end

				secondaryCta.onActivated = onActivated2
			end

			return { primaryCta = primaryCta, secondaryCta = secondaryCta }
		end
	end

	return { primaryCta = nil, secondaryCta = nil }
end

return mapServerActionsToRowCta
