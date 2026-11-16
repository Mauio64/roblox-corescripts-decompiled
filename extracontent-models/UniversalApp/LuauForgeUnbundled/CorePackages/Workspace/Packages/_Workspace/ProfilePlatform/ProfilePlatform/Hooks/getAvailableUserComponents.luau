local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialCommon")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Types/Component")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local buildUserActionsComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/buildUserActionsComponent")
local getSupportedActionsForProfileType = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/getSupportedActionsForProfileType")

local FFlagProfilePlatformEnableFavoriteExperiences = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableFavoriteExperiences")
local fFlagProfilePlatformEnableInventory = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableInventory

local FFlagProfilePlatformEnableSendPlayedTogetherContextToProfilePlatformService = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableSendPlayedTogetherContextToProfilePlatformService")
local fFlagProfilePlatformEnableStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableStore
local FFlagProfilePlatformEnableVR = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableVR")
local fFlagExperiencesOnProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagExperiencesOnProfile
local FFlagProfilePlatformAddCurrentlyPlaying = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformAddCurrentlyPlaying")
local FFlagProfilePlatformEnableMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableMoments")

local fFlagProfilePlatformEnableCurrencyTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableTradeItems = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableTradeItems")
local fFlagEnableProfileCompletion = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableProfileCompletion

local FFlagProfilePlatformRefreshActionsRespectPolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformRefreshActionsRespectPolicies")
local FFlagProfilePlatformGracefulVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformGracefulVisibility")

local v5 = {
	[SocialCommon.Enums.ContextualInfoTypes.MutualFriends] = Enums.ContextualTypes.MutualFriends,
	[SocialCommon.Enums.ContextualInfoTypes.Frequents] = Enums.ContextualTypes.PlayedTogether
}

return function(p2, data)
	local v6

	if FFlagProfilePlatformEnableVR then
		local v7

		if FFlagProfilePlatformRefreshActionsRespectPolicies then
			v7 = buildUserActionsComponent(p2, data)
		else
			local v8 = getSupportedActionsForProfileType(Enums.ProfileTypes.User)
			local filtered = Cryo.List.filter(v8, function(p3): boolean
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

			v7 = {
				component = Enums.Components.Actions,
				context = 0,
				supportedActions = 0,
				excludeContextualActions = 0,
				isActionsV2Supported = true
			}
			local v9 = if p2 == SocialCommon.Enums.ContextualInfoTypes.OffNetworkFriendRequest then Enums.ContextualTypes.OffNetworkFriendRequest else nil
			v7.context = v9

			v7.supportedActions = filtered
			v7.excludeContextualActions = data and data.isSelfView and true or nil
		end

		v6 = { nil, nil, nil, nil, nil }
		local v8 = { component = Enums.Components.UserProfileHeader, context = 0 }
		local v9

		if FFlagProfilePlatformEnableSendPlayedTogetherContextToProfilePlatformService then
			v9 = v5[p2]
		elseif p2 == SocialCommon.Enums.ContextualInfoTypes.MutualFriends then
			v9 = Enums.ContextualTypes.MutualFriends
		end

		v8.context = v9

		v6[1], v6[2], v6[3], v6[4], v6[5] = v8, { component = Enums.Components.SocialLinks }, { component = Enums.Components.About }, { component = Enums.Components.CurrentlyWearing }, v7

		table.insert(v6, { component = Enums.Components.ProfileBackground })

		if data and data.areWebViewsSupported then
			table.insert(v6, { component = Enums.Components.ViewFullProfile })
		end
	else
		local v7

		if FFlagProfilePlatformRefreshActionsRespectPolicies then
			v7 = buildUserActionsComponent(p2, data)
		else
			v7 = {
				component = Enums.Components.Actions,
				context = 0,
				supportedActions = 0,
				excludeContextualActions = 0,
				isActionsV2Supported = true
			}
			local v8 = if p2 == SocialCommon.Enums.ContextualInfoTypes.OffNetworkFriendRequest then Enums.ContextualTypes.OffNetworkFriendRequest else nil
			v7.context = v8

			v7.supportedActions = getSupportedActionsForProfileType(Enums.ProfileTypes.User)
			v7.excludeContextualActions = data and data.isSelfView and true or nil
		end

		v6 = { nil, nil, nil, nil, nil, nil }
		local v8 = { component = Enums.Components.UserProfileHeader, context = 0 }

		local v9 = if p2 == SocialCommon.Enums.ContextualInfoTypes.MutualFriends then Enums.ContextualTypes.MutualFriends else nil
		v8.context = v9

		v6[1], v6[2], v6[3], v6[4], v6[5], v6[6] = v8, { component = Enums.Components.SocialLinks }, { component = Enums.Components.About }, { component = Enums.Components.CurrentlyWearing }, { component = Enums.Components.ViewFullProfile }, v7

		table.insert(v6, { component = Enums.Components.ProfileBackground })
	end

	if FFlagProfilePlatformEnableFavoriteExperiences and (not FFlagProfilePlatformEnableVR or data and data.areWebViewsSupported) then
		table.insert(v6, { component = Enums.Components.FavoriteExperiences })
	end

	if fFlagProfilePlatformEnableInventory and (not FFlagProfilePlatformEnableVR or data and data.areWebViewsSupported) then
		table.insert(v6, { component = Enums.Components.Inventory })
	end

	if fFlagProfilePlatformEnableStore and (not FFlagProfilePlatformEnableVR or data and data.areWebViewsSupported) then
		table.insert(v6, { component = Enums.Components.Store })
	end

	if fFlagExperiencesOnProfile then
		table.insert(v6, { component = Enums.Components.Experiences })
	end

	if fFlagEnableProfileCompletion then
		table.insert(v6, { component = Enums.Components.ProfileCompletion })
	end

	if FFlagProfilePlatformAddCurrentlyPlaying then
		table.insert(v6, { component = Enums.Components.CurrentlyPlaying })
	end

	if FFlagProfilePlatformGracefulVisibility then
		table.insert(v6, { component = Enums.Components.Friends })
	end

	if FFlagProfilePlatformEnableMoments then
		table.insert(v6, { component = Enums.Components.Moments })
	end

	return v6
end
