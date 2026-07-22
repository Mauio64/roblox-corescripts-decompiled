local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local SocialCommon = require(ProfilePlatformParent.SocialCommon)
local Cryo = require(ProfilePlatformParent.Cryo)

require(ProfilePlatform.Types.Component)

local Enums = require(ProfilePlatform.Common.Enums)
local buildUserActionsComponent = require(ProfilePlatform.Hooks.buildUserActionsComponent)
local getSupportedActionsForProfileType = require(ProfilePlatform.Hooks.getSupportedActionsForProfileType)
local FFlagProfilePlatformEnableFavoriteExperiences = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableFavoriteExperiences)
local FFlagProfilePlatformEnableInventory = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableInventory
local FFlagProfilePlatformEnableSendPlayedTogetherContextToProfilePlatformService = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableSendPlayedTogetherContextToProfilePlatformService)
local FFlagProfilePlatformEnableStore = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableStore
local FFlagProfilePlatformEnableVR = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableVR)
local FFlagExperiencesOnProfile = require(ProfilePlatformParent.SharedFlags).FFlagExperiencesOnProfile
local FFlagProfilePlatformAddCurrentlyPlaying = require(ProfilePlatform.Flags.FFlagProfilePlatformAddCurrentlyPlaying)
local FFlagProfilePlatformEnableMoments = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableMoments)
local FFlagProfilePlatformEnableCurrencyTransfer = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableCurrencyTransfer
local FFlagEnableProfileCompletion = require(ProfilePlatformParent.SharedFlags).FFlagEnableProfileCompletion
local FFlagProfilePlatformCTAsRefactor = require(ProfilePlatform.Flags.FFlagProfilePlatformCTAsRefactor)
local FFlagProfilePlatformRefreshActionsRespectPolicies = require(ProfilePlatform.Flags.FFlagProfilePlatformRefreshActionsRespectPolicies)
local t1 = {
	[SocialCommon.Enums.ContextualInfoTypes.MutualFriends] = Enums.ContextualTypes.MutualFriends,
	[SocialCommon.Enums.ContextualInfoTypes.Frequents] = Enums.ContextualTypes.PlayedTogether
}

return function(p1, t2: {[any]: any}?) -- line: 33
	-- upvalues: FFlagProfilePlatformEnableVR (copy), FFlagProfilePlatformRefreshActionsRespectPolicies (copy), buildUserActionsComponent (copy), FFlagProfilePlatformCTAsRefactor (copy), getSupportedActionsForProfileType (copy), Enums (copy), Cryo (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), SocialCommon (copy), FFlagProfilePlatformEnableSendPlayedTogetherContextToProfilePlatformService (copy), t1 (copy), FFlagProfilePlatformEnableFavoriteExperiences (copy), FFlagProfilePlatformEnableInventory (copy), FFlagProfilePlatformEnableStore (copy), FFlagExperiencesOnProfile (copy), FFlagEnableProfileCompletion (copy), FFlagProfilePlatformAddCurrentlyPlaying (copy), FFlagProfilePlatformEnableMoments (copy)
	local t3

	if FFlagProfilePlatformEnableVR then
		local v23

		if FFlagProfilePlatformRefreshActionsRespectPolicies then
			v23 = buildUserActionsComponent(p1, t2)
		else
			local v24 = if not FFlagProfilePlatformCTAsRefactor then Cryo.Dictionary.values(Enums.ProfileActions) else getSupportedActionsForProfileType(Enums.ProfileTypes.User)
			local v25 = Cryo.List.filter(v24, function(p2) -- line: 54
				-- upvalues: Enums (copy), t2 (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy)
				if p2 == Enums.ProfileActions.QrCode then
					if t2 and t2.isProfileQrCodeEnabled then
						return true
					end

					return false
				end

				if p2 == Enums.ProfileActions.EditProfile then
					if t2 and t2.areWebViewsSupported then
						return true
					end

					return false
				end

				if FFlagProfilePlatformEnableCurrencyTransfer and p2 == Enums.ProfileActions.CurrencyTransfer then
					if t2 and t2.canRenderTransferInProfile then
						return true
					end

					return false
				end

				if p2 == Enums.ProfileActions.Chat then
					if t2 and t2.canSeeChatTab ~= false then
						return true
					end

					return false
				end

				return true
			end)

			v23 = {
				component = Enums.Components.Actions,
				context = if p1 ~= SocialCommon.Enums.ContextualInfoTypes.OffNetworkFriendRequest then nil else Enums.ContextualTypes.OffNetworkFriendRequest,
				supportedActions = v25,
				excludeContextualActions = FFlagProfilePlatformCTAsRefactor and (not not t2 and not not t2.isSelfView) or nil,
				isActionsV2Supported = not not FFlagProfilePlatformCTAsRefactor or nil
			}
		end

		t3 = {
			{
				component = Enums.Components.UserProfileHeader,
				context = if not FFlagProfilePlatformEnableSendPlayedTogetherContextToProfilePlatformService then if p1 ~= SocialCommon.Enums.ContextualInfoTypes.MutualFriends then nil else Enums.ContextualTypes.MutualFriends else t1[p1]
			},
			{
				component = Enums.Components.SocialLinks
			},
			{
				component = Enums.Components.About
			},
			{
				component = Enums.Components.CurrentlyWearing
			},
			v23
		}
		table.insert(t3, {
			component = Enums.Components.ProfileBackground
		})

		if t2 and t2.areWebViewsSupported then
			table.insert(t3, {
				component = Enums.Components.ViewFullProfile
			})
		end
	else
		local v27 = if not FFlagProfilePlatformRefreshActionsRespectPolicies then {
			component = Enums.Components.Actions,
			context = if p1 ~= SocialCommon.Enums.ContextualInfoTypes.OffNetworkFriendRequest then nil else Enums.ContextualTypes.OffNetworkFriendRequest,
			supportedActions = if not FFlagProfilePlatformCTAsRefactor then nil else getSupportedActionsForProfileType(Enums.ProfileTypes.User),
			excludeContextualActions = FFlagProfilePlatformCTAsRefactor and (not not t2 and not not t2.isSelfView) or nil,
			isActionsV2Supported = not not FFlagProfilePlatformCTAsRefactor or nil
		} else buildUserActionsComponent(p1, t2)

		t3 = {
			{
				component = Enums.Components.UserProfileHeader,
				context = if p1 ~= SocialCommon.Enums.ContextualInfoTypes.MutualFriends then nil else Enums.ContextualTypes.MutualFriends
			},
			{
				component = Enums.Components.SocialLinks
			},
			{
				component = Enums.Components.About
			},
			{
				component = Enums.Components.CurrentlyWearing
			},
			{
				component = Enums.Components.ViewFullProfile
			},
			v27
		}
		table.insert(t3, {
			component = Enums.Components.ProfileBackground
		})
	end

	if FFlagProfilePlatformEnableFavoriteExperiences and (not FFlagProfilePlatformEnableVR or t2 and t2.areWebViewsSupported) then
		table.insert(t3, {
			component = Enums.Components.FavoriteExperiences
		})
	end

	if FFlagProfilePlatformEnableInventory and (not FFlagProfilePlatformEnableVR or t2 and t2.areWebViewsSupported) then
		table.insert(t3, {
			component = Enums.Components.Inventory
		})
	end

	if FFlagProfilePlatformEnableStore and (not FFlagProfilePlatformEnableVR or t2 and t2.areWebViewsSupported) then
		table.insert(t3, {
			component = Enums.Components.Store
		})
	end

	if FFlagExperiencesOnProfile then
		table.insert(t3, {
			component = Enums.Components.Experiences
		})
	end

	if FFlagEnableProfileCompletion then
		table.insert(t3, {
			component = Enums.Components.ProfileCompletion
		})
	end

	if FFlagProfilePlatformAddCurrentlyPlaying then
		table.insert(t3, {
			component = Enums.Components.CurrentlyPlaying
		})
	end

	if FFlagProfilePlatformEnableMoments then
		table.insert(t3, {
			component = Enums.Components.Moments
		})
	end

	return t3
end
