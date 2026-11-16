local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local SocialCommon = require(parent.SocialCommon)
local Cryo = require(parent.Cryo)

require(ProfilePlatform.Types.Component)
local Enums = require(ProfilePlatform.Common.Enums)
local buildUserActionsComponent = require(ProfilePlatform.Hooks.buildUserActionsComponent)
local getSupportedActionsForProfileType = require(ProfilePlatform.Hooks.getSupportedActionsForProfileType)

local FFlagProfilePlatformEnableFavoriteExperiences = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableFavoriteExperiences)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformEnableInventory = SharedFlags.FFlagProfilePlatformEnableInventory

local FFlagProfilePlatformEnableSendPlayedTogetherContextToProfilePlatformService = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableSendPlayedTogetherContextToProfilePlatformService)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableStore = SharedFlags2.FFlagProfilePlatformEnableStore
local FFlagProfilePlatformEnableVR = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableVR)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagExperiencesOnProfile = SharedFlags3.FFlagExperiencesOnProfile
local FFlagProfilePlatformAddCurrentlyPlaying = require(ProfilePlatform.Flags.FFlagProfilePlatformAddCurrentlyPlaying)
local FFlagProfilePlatformEnableMoments = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableMoments)

local SharedFlags4 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags4.FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableTradeItems = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableTradeItems)
local SharedFlags5 = require(parent.SharedFlags)
local FFlagEnableProfileCompletion = SharedFlags5.FFlagEnableProfileCompletion

local FFlagProfilePlatformRefreshActionsRespectPolicies = require(ProfilePlatform.Flags.FFlagProfilePlatformRefreshActionsRespectPolicies)
local FFlagProfilePlatformGracefulVisibility = require(ProfilePlatform.Flags.FFlagProfilePlatformGracefulVisibility)

local v = {
	[SocialCommon.Enums.ContextualInfoTypes.MutualFriends] = Enums.ContextualTypes.MutualFriends,
	[SocialCommon.Enums.ContextualInfoTypes.Frequents] = Enums.ContextualTypes.PlayedTogether
}

return function(p, data)
	local v2

	if FFlagProfilePlatformEnableVR then
		local v3

		if FFlagProfilePlatformRefreshActionsRespectPolicies then
			v3 = buildUserActionsComponent(p, data)
		else
			local supportedActionsForProfileType = getSupportedActionsForProfileType(Enums.ProfileTypes.User)
			local filtered = Cryo.List.filter(supportedActionsForProfileType, function(p2): boolean
				if p2 == Enums.ProfileActions.QrCode then
					if data and data.isProfileQrCodeEnabled then
						return true
					end
				elseif p2 == Enums.ProfileActions.EditProfile then
					if data and data.areWebViewsSupported then
						return true
					end
				elseif FFlagProfilePlatformEnableCurrencyTransfer and p2 == Enums.ProfileActions.CurrencyTransfer then
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

			v3 = {
				component = Enums.Components.Actions,
				context = 0,
				supportedActions = 0,
				excludeContextualActions = 0,
				isActionsV2Supported = true
			}
			local context

			if p == SocialCommon.Enums.ContextualInfoTypes.OffNetworkFriendRequest then
				context = Enums.ContextualTypes.OffNetworkFriendRequest
			end

			v3.context = context

			v3.supportedActions = filtered
			v3.excludeContextualActions = data and data.isSelfView and true or nil
		end

		v2 = { nil, nil, nil, nil, nil }
		local v4 = { component = Enums.Components.UserProfileHeader, context = 0 }
		local context

		if FFlagProfilePlatformEnableSendPlayedTogetherContextToProfilePlatformService then
			context = v[p]
		elseif p == SocialCommon.Enums.ContextualInfoTypes.MutualFriends then
			context = Enums.ContextualTypes.MutualFriends
		end

		v4.context = context

		v2[1], v2[2], v2[3], v2[4], v2[5] = v4, { component = Enums.Components.SocialLinks }, { component = Enums.Components.About }, { component = Enums.Components.CurrentlyWearing }, v3

		table.insert(v2, { component = Enums.Components.ProfileBackground })

		if data and data.areWebViewsSupported then
			table.insert(v2, { component = Enums.Components.ViewFullProfile })
		end
	else
		local v3

		if FFlagProfilePlatformRefreshActionsRespectPolicies then
			v3 = buildUserActionsComponent(p, data)
		else
			v3 = {
				component = Enums.Components.Actions,
				context = 0,
				supportedActions = 0,
				excludeContextualActions = 0,
				isActionsV2Supported = true
			}
			local context

			if p == SocialCommon.Enums.ContextualInfoTypes.OffNetworkFriendRequest then
				context = Enums.ContextualTypes.OffNetworkFriendRequest
			end

			v3.context = context

			v3.supportedActions = getSupportedActionsForProfileType(Enums.ProfileTypes.User)
			v3.excludeContextualActions = data and data.isSelfView and true or nil
		end

		v2 = { nil, nil, nil, nil, nil, nil }
		local v4 = { component = Enums.Components.UserProfileHeader, context = 0 }
		local context

		if p == SocialCommon.Enums.ContextualInfoTypes.MutualFriends then
			context = Enums.ContextualTypes.MutualFriends
		end

		v4.context = context

		v2[1], v2[2], v2[3], v2[4], v2[5], v2[6] = v4, { component = Enums.Components.SocialLinks }, { component = Enums.Components.About }, { component = Enums.Components.CurrentlyWearing }, { component = Enums.Components.ViewFullProfile }, v3

		table.insert(v2, { component = Enums.Components.ProfileBackground })
	end

	if
		FFlagProfilePlatformEnableFavoriteExperiences
		and (not FFlagProfilePlatformEnableVR or data and data.areWebViewsSupported)
	then
		table.insert(v2, { component = Enums.Components.FavoriteExperiences })
	end

	if
		FFlagProfilePlatformEnableInventory
		and (not FFlagProfilePlatformEnableVR or data and data.areWebViewsSupported)
	then
		table.insert(v2, { component = Enums.Components.Inventory })
	end

	if FFlagProfilePlatformEnableStore and (not FFlagProfilePlatformEnableVR or data and data.areWebViewsSupported) then
		table.insert(v2, { component = Enums.Components.Store })
	end

	if FFlagExperiencesOnProfile then
		table.insert(v2, { component = Enums.Components.Experiences })
	end

	if FFlagEnableProfileCompletion then
		table.insert(v2, { component = Enums.Components.ProfileCompletion })
	end

	if FFlagProfilePlatformAddCurrentlyPlaying then
		table.insert(v2, { component = Enums.Components.CurrentlyPlaying })
	end

	if FFlagProfilePlatformGracefulVisibility then
		table.insert(v2, { component = Enums.Components.Friends })
	end

	if FFlagProfilePlatformEnableMoments then
		table.insert(v2, { component = Enums.Components.Moments })
	end

	return v2
end
