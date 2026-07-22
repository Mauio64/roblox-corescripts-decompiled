local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local SocialCommon = require(ProfilePlatformParent.SocialCommon)
local Cryo = require(ProfilePlatformParent.Cryo)

require(ProfilePlatform.Types.Component)

local Enums = require(ProfilePlatform.Common.Enums)
local getSupportedActionsForProfileType = require(ProfilePlatform.Hooks.getSupportedActionsForProfileType)
local FFlagProfilePlatformEnableVR = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableVR)
local FFlagProfilePlatformEnableCurrencyTransfer = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformCTAsRefactor = require(ProfilePlatform.Flags.FFlagProfilePlatformCTAsRefactor)

local function filterSupportedActions(t1: {[any]: any}?) -- line: 23
	-- upvalues: FFlagProfilePlatformCTAsRefactor (copy), getSupportedActionsForProfileType (copy), Enums (copy), Cryo (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy)
	local v13 = if not FFlagProfilePlatformCTAsRefactor then Cryo.Dictionary.values(Enums.ProfileActions) else getSupportedActionsForProfileType(Enums.ProfileTypes.User)

	return Cryo.List.filter(v13, function(p1) -- line: 28
		-- upvalues: Enums (copy), t1 (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy)
		if p1 == Enums.ProfileActions.QrCode then
			if t1 and t1.isProfileQrCodeEnabled then
				return true
			end

			return false
		end

		if p1 == Enums.ProfileActions.EditProfile then
			if t1 and t1.areWebViewsSupported then
				return true
			end

			return false
		end

		if FFlagProfilePlatformEnableCurrencyTransfer and p1 == Enums.ProfileActions.CurrencyTransfer then
			if t1 and t1.canRenderTransferInProfile then
				return true
			end

			return false
		end

		if p1 == Enums.ProfileActions.Chat then
			if t1 and t1.canSeeChatTab ~= false then
				return true
			end

			return false
		end

		return true
	end)
end
local function buildUserActionsComponent(p2, t2: {[any]: any}?) -- line: 50
	-- upvalues: SocialCommon (copy), Enums (copy), FFlagProfilePlatformCTAsRefactor (copy), FFlagProfilePlatformEnableVR (copy), filterSupportedActions (copy), getSupportedActionsForProfileType (copy)
	local v16 = if p2 ~= SocialCommon.Enums.ContextualInfoTypes.OffNetworkFriendRequest then nil else Enums.ContextualTypes.OffNetworkFriendRequest
	local v17 = FFlagProfilePlatformCTAsRefactor and (not not t2 and not not t2.isSelfView) or nil
	local v18 = not not FFlagProfilePlatformCTAsRefactor or nil

	if FFlagProfilePlatformEnableVR then
		return {
			component = Enums.Components.Actions,
			context = v16,
			supportedActions = filterSupportedActions(t2),
			excludeContextualActions = v17,
			isActionsV2Supported = v18
		}
	end

	return {
		component = Enums.Components.Actions,
		context = v16,
		supportedActions = if not FFlagProfilePlatformCTAsRefactor then nil else getSupportedActionsForProfileType(Enums.ProfileTypes.User),
		excludeContextualActions = v17,
		isActionsV2Supported = v18
	}
end

return buildUserActionsComponent
