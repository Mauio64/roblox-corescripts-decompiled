local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local SocialCommon = require(parent.SocialCommon)
local Cryo = require(parent.Cryo)

require(ProfilePlatform.Types.Component)
local Enums = require(ProfilePlatform.Common.Enums)
local getSupportedActionsForProfileType = require(ProfilePlatform.Hooks.getSupportedActionsForProfileType)

local FFlagProfilePlatformEnableVR = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableVR)

local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableTradeItems = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableTradeItems)

local function filterSupportedActions(data) -- 1 equivalent call inferred from this helper
	local supportedActionsForProfileType = getSupportedActionsForProfileType(Enums.ProfileTypes.User)

	return Cryo.List.filter(supportedActionsForProfileType, function(p): boolean
		if p == Enums.ProfileActions.QrCode then
			if data and data.isProfileQrCodeEnabled then
				return true
			end
		elseif p == Enums.ProfileActions.EditProfile then
			if data and data.areWebViewsSupported then
				return true
			end
		elseif FFlagProfilePlatformEnableCurrencyTransfer and p == Enums.ProfileActions.CurrencyTransfer then
			if data and data.canRenderTransferInProfile then
				return true
			end
		elseif FFlagProfilePlatformEnableTradeItems and p == Enums.ProfileActions.TradeItems then
			if data and data.areWebViewsSupported then
				return true
			end
		elseif p ~= Enums.ProfileActions.Chat or data and data.canSeeChatTab ~= false then
			return true
		end

		return false
	end)
end

local function buildUserActionsComponent(p, data)
	local offNetworkFriendRequest

	if p == SocialCommon.Enums.ContextualInfoTypes.OffNetworkFriendRequest then
		offNetworkFriendRequest = Enums.ContextualTypes.OffNetworkFriendRequest
	end

	local excludeContextualActions = data and data.isSelfView and true or nil

	if not FFlagProfilePlatformEnableVR then
		return {
			component = Enums.Components.Actions,
			context = offNetworkFriendRequest,
			supportedActions = getSupportedActionsForProfileType(Enums.ProfileTypes.User),
			excludeContextualActions = excludeContextualActions,
			isActionsV2Supported = true
		}
	end

	return {
		component = Enums.Components.Actions,
		context = offNetworkFriendRequest,
		supportedActions = filterSupportedActions(data), -- inferred equivalent call
		excludeContextualActions = excludeContextualActions,
		isActionsV2Supported = true
	}
end

return buildUserActionsComponent
