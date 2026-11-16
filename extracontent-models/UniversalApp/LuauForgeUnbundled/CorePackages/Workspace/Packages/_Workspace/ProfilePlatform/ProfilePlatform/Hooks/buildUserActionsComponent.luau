local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialCommon")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Types/Component")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local getSupportedActionsForProfileType = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/getSupportedActionsForProfileType")

local FFlagProfilePlatformEnableVR = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableVR")

local fFlagProfilePlatformEnableCurrencyTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableTradeItems = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableTradeItems")

local function filterSupportedActions(data)
	local v5 = getSupportedActionsForProfileType(Enums.ProfileTypes.User)

	return Cryo.List.filter(v5, function(p2): boolean
		if p2 == Enums.ProfileActions.QrCode then
			if data and data.isProfileQrCodeEnabled then
				return true
			end
		elseif p2 == Enums.ProfileActions.EditProfile then
			if data and data.areWebViewsSupported then
				return true
			end
		elseif
			fFlagProfilePlatformEnableCurrencyTransfer
			and p2 == Enums.ProfileActions.CurrencyTransfer
		then
			if data and data.canRenderTransferInProfile then
				return true
			end
		elseif FFlagProfilePlatformEnableTradeItems and p2 == Enums.ProfileActions.TradeItems then
			if data and data.areWebViewsSupported then
				return true
			end
		elseif p2 ~= Enums.ProfileActions.Chat or data and data.canSeeChatTab ~= false then
			return true
		end

		return false
	end)
end

local function buildUserActionsComponent(p2, data)
	local offNetworkFriendRequest

	if p2 == SocialCommon.Enums.ContextualInfoTypes.OffNetworkFriendRequest then
		offNetworkFriendRequest = Enums.ContextualTypes.OffNetworkFriendRequest
	end

	local v5 = data and data.isSelfView and true or nil

	if not FFlagProfilePlatformEnableVR then
		return {
			component = Enums.Components.Actions,
			context = offNetworkFriendRequest,
			supportedActions = getSupportedActionsForProfileType(Enums.ProfileTypes.User),
			excludeContextualActions = v5,
			isActionsV2Supported = true
		}
	end

	local v6 = {
		component = Enums.Components.Actions,
		context = offNetworkFriendRequest,
		supportedActions = 0,
		excludeContextualActions = 0,
		isActionsV2Supported = true
	}
	local v7 = getSupportedActionsForProfileType(Enums.ProfileTypes.User)

	v6.supportedActions = Cryo.List.filter(v7, function(p3): boolean
		if p3 == Enums.ProfileActions.QrCode then
			if data and data.isProfileQrCodeEnabled then
				return true
			end
		elseif p3 == Enums.ProfileActions.EditProfile then
			if data and data.areWebViewsSupported then
				return true
			end
		elseif
			fFlagProfilePlatformEnableCurrencyTransfer
			and p3 == Enums.ProfileActions.CurrencyTransfer
		then
			if data and data.canRenderTransferInProfile then
				return true
			end
		elseif FFlagProfilePlatformEnableTradeItems and p3 == Enums.ProfileActions.TradeItems then
			if data and data.areWebViewsSupported then
				return true
			end
		elseif p3 ~= Enums.ProfileActions.Chat or data and data.canSeeChatTab ~= false then
			return true
		end

		return false
	end)
	v6.excludeContextualActions = v5
	return v6
end

return buildUserActionsComponent
