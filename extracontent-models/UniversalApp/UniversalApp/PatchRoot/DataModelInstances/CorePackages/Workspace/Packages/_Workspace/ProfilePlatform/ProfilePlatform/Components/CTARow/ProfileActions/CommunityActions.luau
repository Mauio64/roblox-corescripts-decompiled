local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Foundation = require(ProfilePlatformParent.Foundation)
local RobloxAppEnums = require(ProfilePlatformParent.RobloxAppEnums)
local ButtonVariant = Foundation.Enums.ButtonVariant
local AppPage = RobloxAppEnums.AppPage
local UrlBuilder = require(ProfilePlatformParent.UrlBuilder).UrlBuilder
local UrlBase = require(ProfilePlatformParent.UrlBuilder).UrlBase
local default = require(ProfilePlatformParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local Url = require(ProfilePlatformParent.Http).Url
local SetCurrentToastMessage = require(ProfilePlatformParent.ToastRodux).Actions.SetCurrentToastMessage
local NavigateDown = require(ProfilePlatformParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ProfilePlatformParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v14 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands
local Contexts = require(ProfilePlatformParent.SocialLuaAnalytics).Analytics.Enums.Contexts
local GroupsNetworking = require(ProfilePlatform.Networking.GroupsNetworking)
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)
local refreshProfilePlatform = require(ProfilePlatform.Networking.refreshProfilePlatform)
local getAvailableCommunityComponents = require(ProfilePlatform.Hooks.getAvailableCommunityComponents)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes
local FFlagProfilePlatformUpdateUXForNonSocialCommunities = require(ProfilePlatform.Flags.FFlagProfilePlatformUpdateUXForNonSocialCommunities)
local v25 = `{ Url.BASE_URL }share/g/%s`

return {
	[Enums.ProfileActions.CopyLink] = function(p1) -- line: 41
		-- upvalues: Enums (copy), ProfileTypes (copy), EventNames (copy), default (copy), Contexts (copy), v25 (copy), SetCurrentToastMessage (copy), TextKeys (copy)
		return {
			text = p1.localized[Enums.ProfileActions.CopyLink],
			onActivated = {
				[ProfileTypes.Community] = function() -- line: 45
					-- upvalues: p1 (copy), EventNames (copy), default (copy), Contexts (copy), v25 (copy), SetCurrentToastMessage (copy), TextKeys (copy)
					p1.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonCopyLink, {
						buttonSurface = p1.buttonSurface
					})
					default:setClipboardText({
						context = Contexts.ProfileCard,
						text = string.format(v25, p1.profileId)
					})
					p1.dispatch(SetCurrentToastMessage({
						toastMessage = TextKeys.LinkCopied
					}))
				end
			}
		}
	end,
	[Enums.ProfileActions.JoinCommunity] = function(p2) -- line: 62
		-- upvalues: ButtonVariant (copy), Enums (copy), ProfileTypes (copy), EventNames (copy), GroupsNetworking (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy)
		return {
			variant = ButtonVariant.Emphasis,
			text = p2.localized[Enums.ProfileActions.JoinCommunity],
			onActivated = {
				[ProfileTypes.Community] = function() -- line: 67
					-- upvalues: p2 (copy), EventNames (copy), GroupsNetworking (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy)
					p2.analytics.fireAnalyticsEvent(EventNames.CTAButtonJoinCommunity, {
						buttonSurface = p2.buttonSurface,
						btnContext = p2.profileWrapperContext.sourceInfo.source
					})

					return p2.dispatch(GroupsNetworking.JoinGroup.API({
						groupId = p2.profileId
					})):andThen(function() -- line: 77
						-- upvalues: p2 (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy)
						p2.dispatch(getProfilePlatform.API({
							includeComponentOrdering = true,
							profileType = p2.profileType,
							profileId = p2.profileId,
							components = getAvailableCommunityComponents()
						}))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.CancelJoinCommunityRequest] = function(p3) -- line: 90
		-- upvalues: ButtonVariant (copy), Enums (copy), ProfileTypes (copy), EventNames (copy), GroupsNetworking (copy), refreshProfilePlatform (copy)
		return {
			variant = ButtonVariant.Standard,
			text = p3.localized[Enums.ProfileActions.CancelJoinCommunityRequest],
			onActivated = {
				[ProfileTypes.Community] = function() -- line: 95
					-- upvalues: p3 (copy), EventNames (copy), GroupsNetworking (copy), refreshProfilePlatform (copy), Enums (copy)
					p3.analytics.fireAnalyticsEvent(EventNames.CTAButtonCancelJoinCommunityRequest, {
						buttonSurface = p3.buttonSurface,
						btnContext = p3.profileWrapperContext.sourceInfo.source
					})

					return p3.dispatch(GroupsNetworking.CancelJoinGroupRequest.API({
						groupId = p3.profileId,
						userId = p3.localUserId
					})):andThen(function() -- line: 106
						-- upvalues: p3 (copy), refreshProfilePlatform (copy), Enums (copy)
						p3.dispatch(refreshProfilePlatform({
							profileType = p3.profileType,
							profileId = p3.profileId,
							components = { Enums.Components.Actions }
						}))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.ViewCommunity] = function(p4) -- line: 120
		-- upvalues: ButtonVariant (copy), Enums (copy), ProfileTypes (copy), EventNames (copy), AppPage (copy), UrlBuilder (copy), TextKeys (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateDown (copy)
		return {
			variant = ButtonVariant.SubEmphasis,
			text = p4.localized[Enums.ProfileActions.ViewCommunity],
			onActivated = {
				[ProfileTypes.Community] = function() -- line: 125
					-- upvalues: p4 (copy), EventNames (copy), AppPage (copy), UrlBuilder (copy), TextKeys (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateDown (copy)
					p4.analytics.fireAnalyticsEvent(EventNames.CTAButtonViewCommunity, {
						buttonSurface = p4.buttonSurface,
						btnContext = p4.profileWrapperContext.sourceInfo.source
					})

					local t1 = {
						name = AppPage.GenericWebPage,
						detail = UrlBuilder.user.group({
							groupId = p4.profileId
						}),
						extraProps = {
							titleKey = TextKeys.Community,
							onClose = function() -- line: 136
								-- upvalues: p4 (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy)
								p4.dispatch(getProfilePlatform.API({
									includeComponentOrdering = true,
									profileType = p4.profileType,
									profileId = p4.profileId,
									components = getAvailableCommunityComponents()
								}))
							end
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v14.down(v14.fromLegacyPage(t1))

						return
					end

					p4.dispatch(NavigateDown(t1))
				end
			}
		}
	end,
	[Enums.ProfileActions.ViewFullProfile] = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities then nil else function(p5) -- line: 157
		-- upvalues: ButtonVariant (copy), Enums (copy), ProfileTypes (copy), EventNames (copy), AppPage (copy), UrlBuilder (copy), UrlBase (copy), TextKeys (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateDown (copy)
		return {
			variant = ButtonVariant.SubEmphasis,
			text = p5.localized[Enums.ProfileActions.ViewFullProfile],
			onActivated = {
				[ProfileTypes.Community] = function() -- line: 162
					-- upvalues: p5 (copy), EventNames (copy), AppPage (copy), UrlBuilder (copy), UrlBase (copy), TextKeys (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateDown (copy)
					p5.analytics.fireAnalyticsEvent(EventNames.CTAButtonViewFullProfile, {
						buttonSurface = p5.buttonSurface,
						btnContext = p5.profileWrapperContext.sourceInfo.source
					})

					local t2 = {
						name = AppPage.GenericWebPage,
						detail = UrlBuilder.new({
							base = UrlBase.WWW,
							path = `profiles/{ p5.profileId }`
						})(),
						extraProps = {
							titleKey = TextKeys.Profile,
							onClose = function() -- line: 176
								-- upvalues: p5 (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy)
								p5.dispatch(getProfilePlatform.API({
									includeComponentOrdering = true,
									profileType = p5.profileType,
									profileId = p5.profileId,
									components = getAvailableCommunityComponents()
								}))
							end
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v14.down(v14.fromLegacyPage(t2))

						return
					end

					p5.dispatch(NavigateDown(t2))
				end
			}
		}
	end,
	[Enums.ProfileActions.LeaveCommunity] = function(p6) -- line: 197
		-- upvalues: Enums (copy), ProfileTypes (copy), EventNames (copy), GroupsNetworking (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy)
		return {
			text = p6.localized[Enums.ProfileActions.LeaveCommunity],
			onActivated = {
				[ProfileTypes.Community] = function() -- line: 201
					-- upvalues: p6 (copy), EventNames (copy), GroupsNetworking (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy)
					p6.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonLeaveCommunity, {
						buttonSurface = p6.buttonSurface,
						btnContext = p6.profileWrapperContext.sourceInfo.source
					})

					return p6.dispatch(GroupsNetworking.LeaveGroup.API({
						groupId = p6.profileId,
						userId = p6.localUserId
					})):andThen(function() -- line: 212
						-- upvalues: p6 (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy)
						p6.dispatch(getProfilePlatform.API({
							includeComponentOrdering = true,
							profileType = p6.profileType,
							profileId = p6.profileId,
							components = getAvailableCommunityComponents()
						}))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.MakePrimaryCommunity] = function(p7) -- line: 225
		-- upvalues: Enums (copy), ProfileTypes (copy), EventNames (copy), GroupsNetworking (copy), refreshProfilePlatform (copy)
		return {
			text = p7.localized[Enums.ProfileActions.MakePrimaryCommunity],
			onActivated = {
				[ProfileTypes.Community] = function() -- line: 229
					-- upvalues: p7 (copy), EventNames (copy), GroupsNetworking (copy), refreshProfilePlatform (copy), Enums (copy)
					p7.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonMakePrimaryCommunity, {
						buttonSurface = p7.buttonSurface,
						btnContext = p7.profileWrapperContext.sourceInfo.source
					})

					return p7.dispatch(GroupsNetworking.MakePrimaryGroup.API({
						groupId = p7.profileId
					})):andThen(function() -- line: 239
						-- upvalues: p7 (copy), refreshProfilePlatform (copy), Enums (copy)
						p7.dispatch(refreshProfilePlatform({
							profileType = p7.profileType,
							profileId = p7.profileId,
							components = { Enums.Components.Actions }
						}))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.RemovePrimaryCommunity] = function(p8) -- line: 253
		-- upvalues: Enums (copy), ProfileTypes (copy), EventNames (copy), GroupsNetworking (copy), refreshProfilePlatform (copy)
		return {
			text = p8.localized[Enums.ProfileActions.RemovePrimaryCommunity],
			onActivated = {
				[ProfileTypes.Community] = function() -- line: 257
					-- upvalues: p8 (copy), EventNames (copy), GroupsNetworking (copy), refreshProfilePlatform (copy), Enums (copy)
					p8.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonRemovePrimaryCommunity, {
						buttonSurface = p8.buttonSurface,
						btnContext = p8.profileWrapperContext.sourceInfo.source
					})

					return p8.dispatch(GroupsNetworking.RemovePrimaryGroup.API()):andThen(function() -- line: 263
						-- upvalues: p8 (copy), refreshProfilePlatform (copy), Enums (copy)
						p8.dispatch(refreshProfilePlatform({
							profileType = p8.profileType,
							profileId = p8.profileId,
							components = { Enums.Components.Actions }
						}))
					end)
				end
			}
		}
	end
}
