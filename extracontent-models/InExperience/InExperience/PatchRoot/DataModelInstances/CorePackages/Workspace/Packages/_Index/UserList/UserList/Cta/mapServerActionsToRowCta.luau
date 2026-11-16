local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local Foundation = require(parent.Foundation)
local Enums = require(UserList.Common.Enums)
require(UserList.Common.Types)

local FFlagUserListChatCtaStandardVariant = require(UserList.Flags.FFlagUserListChatCtaStandardVariant)
local FFlagUserListCanonicalCtaAnalytics = require(UserList.Flags.FFlagUserListCanonicalCtaAnalytics)

local IconName = Foundation.Enums.IconName
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonTypes = Enums.ButtonTypes

local v = {
	AddFriend = { buttonType = ButtonTypes.Add, handlerKey = ButtonTypes.Add },
	AcceptFriendRequest = {
		buttonType = ButtonTypes.Accept,
		handlerKey = ButtonTypes.Accept,
		supportsDismiss = true
	},
	PendingFriendRequest = { buttonType = ButtonTypes.Pending, isDisabled = true },
	CannotAddFriend = { buttonType = ButtonTypes.Add, isDisabled = true },
	Chat = 0,
	JoinExperience = 0
}
local chat = { buttonType = ButtonTypes.Chat, handlerKey = ButtonTypes.Chat, variant = 0 }
local variant

if FFlagUserListChatCtaStandardVariant then
	variant = ButtonVariant.Standard
end

chat.variant = variant
v.Chat = chat

v.JoinExperience = { buttonType = ButtonTypes.Join }

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

		if v2 and isSupported(supportedActions, button.type) then -- inferred equivalent call
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

			primaryCta.isDisabled = v2.isDisabled
			primaryCta.disabledReason = button.disabledReason
			local variant2

			if FFlagUserListChatCtaStandardVariant then
				variant2 = v2.variant
			end

			primaryCta.variant = variant2
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
