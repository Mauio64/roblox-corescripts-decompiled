local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Foundation = require(parent.Foundation)
local RobloxAppEnums = require(parent.RobloxAppEnums)

local ButtonVariant = Foundation.Enums.ButtonVariant
local AppPage = RobloxAppEnums.AppPage

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local Http = require(parent.Http)
local Url = Http.Url
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local GroupsNetworking = require(ProfilePlatform.Networking.GroupsNetworking)
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)
local refreshProfilePlatform = require(ProfilePlatform.Networking.refreshProfilePlatform)
local getAvailableCommunityComponents = require(ProfilePlatform.Hooks.getAvailableCommunityComponents)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local makeViewGroupPage = require(ProfilePlatform.Utils.makeViewGroupPage)
local ProfileTypes = Enums.ProfileTypes

local formatted = `{Url.BASE_URL}share/g/%s`

return {
	[Enums.ProfileActions.CopyLink] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.CopyLink],
			onActivated = {
				[ProfileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonCopyLink, {
						buttonSurface = data.buttonSurface
					})

					default:setClipboardText({
						context = Contexts.ProfileCard,
						text = string.format(formatted, data.profileId)
					})

					data.dispatch(SetCurrentToastMessage({ toastMessage = TextKeys.LinkCopied }))
				end
			}
		}
	end,
	[Enums.ProfileActions.JoinCommunity] = function(data)
		return {
			variant = ButtonVariant.Emphasis,
			text = data.localized[Enums.ProfileActions.JoinCommunity],
			onActivated = {
				[ProfileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonJoinCommunity, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					return data.dispatch(GroupsNetworking.JoinGroup.API({ groupId = data.profileId })):andThen(function()
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
			variant = ButtonVariant.Standard,
			text = data.localized[Enums.ProfileActions.CancelJoinCommunityRequest],
			onActivated = {
				[ProfileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonCancelJoinCommunityRequest, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					return data.dispatch(GroupsNetworking.CancelJoinGroupRequest.API({
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
			variant = ButtonVariant.SubEmphasis,
			text = data.localized[Enums.ProfileActions.ViewCommunity],
			onActivated = {
				[ProfileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonViewCommunity, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					local viewGroupPage = makeViewGroupPage(data.profileId, function()
						data.dispatch(getProfilePlatform.API({
							profileType = data.profileType,
							profileId = data.profileId,
							components = getAvailableCommunityComponents(),
							includeComponentOrdering = true
						}))
					end)

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(viewGroupPage))
					else
						data.dispatch(NavigateDown(viewGroupPage))
					end
				end
			}
		}
	end,
	[Enums.ProfileActions.ViewFullProfile] = function(data)
		return {
			variant = ButtonVariant.SubEmphasis,
			text = data.localized[Enums.ProfileActions.ViewFullProfile],
			onActivated = {
				[ProfileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonViewFullProfile, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					local v = {
						name = AppPage.GenericWebPage,
						detail = urlBuilder.new({
							base = UrlBase.WWW,
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

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v))
					else
						data.dispatch(NavigateDown(v))
					end
				end
			}
		}
	end,
	[Enums.ProfileActions.LeaveCommunity] = function(data)
		if data.profileType == ProfileTypes.Community and data.viewerOwnsOpenCommunity then
			return nil
		end

		return {
			text = data.localized[Enums.ProfileActions.LeaveCommunity],
			onActivated = {
				[ProfileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonLeaveCommunity, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					return data.dispatch(GroupsNetworking.LeaveGroup.API({
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
				[ProfileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonMakePrimaryCommunity, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					return data.dispatch(GroupsNetworking.MakePrimaryGroup.API({
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
				[ProfileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonRemovePrimaryCommunity, {
						buttonSurface = data.buttonSurface,
						btnContext = data.profileWrapperContext.sourceInfo.source
					})

					return data.dispatch(GroupsNetworking.RemovePrimaryGroup.API()):andThen(function()
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
