local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums")

local buttonVariant = Foundation.Enums.ButtonVariant
local appPage = RobloxAppEnums.AppPage

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UrlBuilder").UrlBase

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Http").Url
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ToastRodux").Actions.SetCurrentToastMessage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local contexts = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialLuaAnalytics").Analytics.Enums.Contexts

local NetworkingFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/NetworkingFriends")
local getProfilePlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/getProfilePlatform")
local refreshProfilePlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatform")
local getAvailableCommunityComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/getAvailableCommunityComponents")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local makeViewGroupPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/makeViewGroupPage")
local profileTypes = Enums.ProfileTypes

local formatted = `{url.BASE_URL}share/g/%s`

return {
	[Enums.ProfileActions.CopyLink] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.CopyLink],
			onActivated = {
				[profileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonCopyLink, {
						buttonSurface = data.buttonSurface
					})

					default:setClipboardText({
						context = contexts.ProfileCard,
						text = string.format(formatted, data.profileId)
					})

					data.dispatch(setCurrentToastMessage({
						toastMessage = TextKeys.LinkCopied
					}))
				end
			}
		}
	end,
	[Enums.ProfileActions.JoinCommunity] = function(data)
		return {
			variant = buttonVariant.Emphasis,
			text = data.localized[Enums.ProfileActions.JoinCommunity],
			onActivated = {
				[profileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonJoinCommunity, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					return data.dispatch(NetworkingFriends.JoinGroup.API({
						groupId = data.profileId
					})):andThen(function()
						data.dispatch(getProfilePlatform.API({
							profileType = data.profileType,
							profileId = data.profileId,
							components = getAvailableCommunityComponents(),
							includeComponentOrdering = true
						}))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.CancelJoinCommunityRequest] = function(data)
		return {
			variant = buttonVariant.Standard,
			text = data.localized[Enums.ProfileActions.CancelJoinCommunityRequest],
			onActivated = {
				[profileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonCancelJoinCommunityRequest, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					return data.dispatch(NetworkingFriends.CancelJoinGroupRequest.API({
						groupId = data.profileId,
						userId = data.localUserId
					})):andThen(function()
						data.dispatch(refreshProfilePlatform({
							profileType = data.profileType,
							profileId = data.profileId,
							components = { Enums.Components.Actions }
						}))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.ViewCommunity] = function(data)
		return {
			variant = buttonVariant.SubEmphasis,
			text = data.localized[Enums.ProfileActions.ViewCommunity],
			onActivated = {
				[profileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonViewCommunity, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					local v8 = makeViewGroupPage(data.profileId, function()
						data.dispatch(getProfilePlatform.API({
							profileType = data.profileType,
							profileId = data.profileId,
							components = getAvailableCommunityComponents(),
							includeComponentOrdering = true
						}))
					end)

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v8))
					else
						data.dispatch(navigateDown(v8))
					end
				end
			}
		}
	end,
	[Enums.ProfileActions.ViewFullProfile] = function(data)
		return {
			variant = buttonVariant.SubEmphasis,
			text = data.localized[Enums.ProfileActions.ViewFullProfile],
			onActivated = {
				[profileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonViewFullProfile, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					local v8 = {
						name = appPage.GenericWebPage,
						detail = urlBuilder.new({
							base = urlBase.WWW,
							path = `profiles/{data.profileId}`
						})(),
						extraProps = {
							titleKey = TextKeys.Profile,
							onClose = function()
								data.dispatch(getProfilePlatform.API({
									profileType = data.profileType,
									profileId = data.profileId,
									components = getAvailableCommunityComponents(),
									includeComponentOrdering = true
								}))
							end
						}
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v8))
					else
						data.dispatch(navigateDown(v8))
					end
				end
			}
		}
	end,
	[Enums.ProfileActions.LeaveCommunity] = function(data)
		if data.profileType == profileTypes.Community and data.viewerOwnsOpenCommunity then
			return nil
		end

		return {
			text = data.localized[Enums.ProfileActions.LeaveCommunity],
			onActivated = {
				[profileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonLeaveCommunity, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					return data.dispatch(NetworkingFriends.LeaveGroup.API({
						groupId = data.profileId,
						userId = data.localUserId
					})):andThen(function()
						data.dispatch(getProfilePlatform.API({
							profileType = data.profileType,
							profileId = data.profileId,
							components = getAvailableCommunityComponents(),
							includeComponentOrdering = true
						}))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.MakePrimaryCommunity] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.MakePrimaryCommunity],
			onActivated = {
				[profileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonMakePrimaryCommunity, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					return data.dispatch(NetworkingFriends.MakePrimaryGroup.API({
						groupId = data.profileId
					})):andThen(function()
						data.dispatch(refreshProfilePlatform({
							profileType = data.profileType,
							profileId = data.profileId,
							components = { Enums.Components.Actions }
						}))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.RemovePrimaryCommunity] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.RemovePrimaryCommunity],
			onActivated = {
				[profileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonRemovePrimaryCommunity, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					return data.dispatch(NetworkingFriends.RemovePrimaryGroup.API()):andThen(function()
						data.dispatch(refreshProfilePlatform({
							profileType = data.profileType,
							profileId = data.profileId,
							components = { Enums.Components.Actions }
						}))
					end)
				end
			}
		}
	end
}
