local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.React)
require("@game/CorePackages/Workspace/Packages/Navigation")
local createLazyComponent = require("@game/CorePackages/Workspace/Packages/RoactUtils").Components.createLazyComponent
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local module = require("@luauforge/bundled/dGJ")
local module2 = require("@luauforge/bundled/dGK")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane
local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/dIW") else nil

local module3 = require("@luauforge/bundled/cxg")

local socialNetworksInEditProfileIXP = require("@luauforge/bundled/dKb").SocialNetworksInEditProfileIXP

local fFlagEnableSocialProofUserList = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSocialProofUserList
local fFlagProfilePlatformAddTC = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagProfilePlatformAddTC
local fFlagTCShareLinkErrorModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagTCShareLinkErrorModal
local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagCreateConnectionsHub

local fFlagCiDeprecateFindFriendsModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagCiDeprecateFindFriendsModal

local fFlagEnableSocialProofVerticalUserListSheet = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSocialProofVerticalUserListSheet
local fFlagEnableMobileGameJoinCard = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableMobileGameJoinCard

local fFlagSocialCarouselBuildPresence = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSocialCarouselBuildPresence

local fFlagLuaAppExperienceLeaderboardSeeAllEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppExperienceLeaderboardSeeAllEnabled

local fFlagEnableUserRecentActivityEntryPoint = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableUserRecentActivityEntryPoint

local fFlagEnableRecentActivityInspectAndBuy = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableRecentActivityInspectAndBuy
local fFlagEnableSocialTabsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSocialTabsPage

local fFlagSocialTabsPageSplitPaneLayout = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSocialTabsPageSplitPaneLayout
local fFlagEnableSchoolEntry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSchoolEntry
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagProfileMomentsFeedRootRoute = SharedFlags.FFlagProfileMomentsFeedRootRoute
local fFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local fFlagProfileMomentsFeedAboveSplitPane = SharedFlags.FFlagProfileMomentsFeedAboveSplitPane

return function()
	local v7 = {
		[appPage.SocialUnableToJoinExperience] = {
			getScreen = function()
				return require("@luauforge/deferred/dKr")
			end,
			navigationOptions = module[appPage.SocialUnableToJoinExperience]
		}
	}

	local v8 = {
		[appPage.SocialToast] = {
			getScreen = function()
				return require("@luauforge/deferred/dXC").ToastScreen
			end,
			navigationOptions = module[appPage.SocialToast]
		}
	}

	local v9 = {
		[appPage.SocialPurchaseExperience] = {
			getScreen = function()
				return require("@luauforge/bundled/cAK").PurchaseExperienceModal
			end,
			navigationOptions = module[appPage.SocialPurchaseExperience]
		}
	}

	local v10 = {
		[appPage.ContentFeed] = {
			getScreen = function()
				return require("@luauforge/deferred/dXO").App
			end,
			navigationOptions = module[appPage.ContentFeed]
		}
	}
	local v11

	if socialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled() then
		v11 = {}
		v11[appPage.EditSocialNetworks] = {
			getScreen = function()
				return require("@luauforge/deferred/ebB")
			end,
			navigationOptions = module[appPage.EditSocialNetworks]
		}
	end

	local v12

	if socialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled() then
		v12 = {}
		v12[appPage.EditSocialNetworksError] = {
			getScreen = function()
				return require("@luauforge/deferred/ecj")
			end,
			navigationOptions = module[appPage.EditSocialNetworksError]
		}
	end

	local v13 = {
		[appPage.ViewFriends] = {
			getScreen = function()
				return require("@luauforge/deferred/ecl")
			end,
			navigationOptions = {
				hasSubNavigation = true,
				tabBarHidden = module2.PolicyDependent,
				nativeWrapper = false,
				renderUnderlyingPage = false
			}
		}
	}

	local v14 = {
		[appPage.AddFriendsPage] = {
			getScreen = function()
				return require("@luauforge/deferred/eih")
			end,
			navigationOptions = {
				tabBarHidden = module2.PolicyDependent,
				nativeWrapper = false,
				bottomTabBarHidden = true,
				sideTabBarHidden = false
			}
		}
	}
	local v15

	if fFlagCreateConnectionsHub then
		v15 = {}
		v15[appPage.ConnectionsHub] = {
			getScreen = function()
				return require("@luauforge/deferred/emH")
			end
		}
	end

	local v6 = {
		v7,
		v8,
		v9,
		v10,
		v11,
		v12,
		v13,
		v14,
		v15,
		{
			[appPage.UserSearch] = {
				getScreen = function()
					return require("@luauforge/deferred/eoQ")
				end,
				navigationOptions = { tabBarHidden = module2.PolicyDependent }
			}
		},
		{
			[appPage.DiscoverabilityOverlay] = {
				getScreen = function()
					return module3.DiscoverabilityWithAudit
				end,
				navigationOptions = module[appPage.DiscoverabilityOverlay]
			}
		},
		{
			[appPage.ContactImporter] = {
				getScreen = function()
					if fFlagCiDeprecateFindFriendsModal then
						return require("@luauforge/bundled/cqV").ContactImporterLandingPage
					end

					return require("@luauforge/bundled/cqV").FindFriendsModal
				end,
				navigationOptions = module[appPage.ContactImporter]
			}
		},
		{
			[appPage.FindFriendsModal] = {
				getScreen = function()
					return require("@luauforge/bundled/cqV").FindFriendsModal
				end,
				navigationOptions = module[appPage.FindFriendsModal]
			}
		},
		{
			[appPage.ContactsList] = {
				getScreen = function()
					return require("@luauforge/deferred/eoR")
				end,
				navigationOptions = module[appPage.ContactsList]
			}
		},
		{
			[appPage.ContactsRevokedAccessDialog] = {
				getScreen = function()
					return require("@luauforge/bundled/cqV").ContactsRevokedAccessDialog
				end,
				navigationOptions = module[appPage.ContactsRevokedAccessDialog]
			}
		},
		{
			[appPage.TrustedContactsEducationModal] = {
				getScreen = function()
					return require("@luauforge/bundled/eoS").TrustedContactsEducationModal
				end,
				navigationOptions = module[appPage.TrustedContactsEducationModal]
			}
		},
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	}

	local v23 = {
		[appPage.SettingsPermissionInteractiveAlert] = {
			getScreen = function()
				return require("@luauforge/bundled/eoT").Components.SettingsPermissionInteractiveAlert
			end,
			navigationOptions = module[appPage.SettingsPermissionInteractiveAlert]
		}
	}
	local v24

	if fFlagProfilePlatformAddTC then
		v24 = {}
		v24[appPage.TrustedContactsModal] = {
			getScreen = function()
				return require("@luauforge/bundled/eoS").TrustedFriendsModalEntry
			end,
			navigationOptions = module[appPage.TrustedContactsModal]
		}
	end

	local v25 = {
		[appPage.FriendsRenameInfoModal] = {
			getScreen = function()
				return require("@luauforge/bundled/eoS").FriendsRenameInfoModal
			end,
			navigationOptions = module[appPage.FriendsRenameInfoModal]
		}
	}
	local v26

	if fFlagTCShareLinkErrorModal then
		v26 = {}
		v26[appPage.TrustedFriendsShareLinkErrorModal] = {
			getScreen = function()
				return require("@luauforge/bundled/eoS").TrustedFriendsShareLinkErrorModal
			end,
			navigationOptions = module[appPage.TrustedFriendsShareLinkErrorModal]
		}
	end

	local v27 = {
		[appPage.BlockingModal] = {
			getScreen = function()
				return require("@luauforge/bundled/cDA").BlockingModal
			end,
			navigationOptions = module[appPage.BlockingModal]
		}
	}
	local v28

	if fFlagEnableSocialProofUserList then
		v28 = {}
		v28[appPage.FriendsOwnedUserList] = {
			getScreen = function()
				return require("@luauforge/bundled/cEn").UserLists.FriendsOwnedUserList
			end,
			navigationOptions = module[appPage.FriendsOwnedUserList]
		}
	end

	local mutualConnectionList = appPage.MutualConnectionList
	local v30 = {
		getScreen = function()
			return require("@luauforge/deferred/eoU").MutualConnectionList
		end,
		navigationOptions = 0
	}
	local v31

	if fFlagEnableSplitPane then
		v31 = function()
			local profileRoutePresentation = v5.SplitPaneVariant.getProfileRoutePresentation(v5.SplitPaneStore.getStore().getSupportPaneModeIfActive(false))

			return {
				renderUnderlyingPage = true,
				isPeekView = true,
				overlayEnabled = profileRoutePresentation.rendersOverlay,
				transparent = profileRoutePresentation.rendersAboveSplitPane,
				splitPaneEligibility = profileRoutePresentation.splitPaneEligibility
			}
		end
	else
		v31 = module[appPage.MutualConnectionList]
	end

	v30.navigationOptions = v31
	local v29 = { [mutualConnectionList] = v30 }
	local v32

	if fFlagEnableSocialTabsPage then
		v32 = {}
		local socialTabsPage = appPage.SocialTabsPage
		local v33 = {
			getScreen = function()
				return require("@luauforge/bundled/cEZ").SocialTabsPageNavigator
			end,
			navigationOptions = 0
		}
		local v34

		if fFlagSocialTabsPageSplitPaneLayout then
			v34 = function()
				local profileRoutePresentation = v5.SplitPaneVariant.getProfileRoutePresentation(v5.SplitPaneStore.getStore().getSupportPaneModeIfActive(false))

				local clone = table.clone(module[appPage.SocialTabsPage])
				clone.overlayEnabled = profileRoutePresentation.rendersOverlay
				clone.transparent = profileRoutePresentation.rendersAboveSplitPane
				clone.splitPaneEligibility = profileRoutePresentation.splitPaneEligibility
				return clone
			end
		else
			v34 = module[appPage.SocialTabsPage]
		end

		v33.navigationOptions = v34
		v32[socialTabsPage] = v33
	end

	local v33 = {
		[appPage.AboutDetailsSheet] = {
			getScreen = function()
				return require("@luauforge/deferred/eun")
			end,
			navigationOptions = module[appPage.AboutDetailsSheet]
		}
	}
	local v34

	if fFlagProfileMomentsFeedRootRoute or fFlagProfileRenderAvatarMoments then
		v34 = {}
		local profileMomentsFeed = appPage.ProfileMomentsFeed
		local v35 = {
			getScreen = function()
				return require("@luauforge/deferred/eus")
			end,
			navigationOptions = 0
		}
		local v36

		if fFlagProfileMomentsFeedAboveSplitPane then
			v36 = function()
				local clone = table.clone(module[appPage.ProfileMomentsFeed])

				if v5.SplitPaneStore.getStore().getIsSplitPaneActive(false) then
					clone.overlayEnabled = nil
					clone.transparent = true
				end

				return clone
			end
		else
			v36 = module[appPage.ProfileMomentsFeed]
		end

		v35.navigationOptions = v36
		v34[profileMomentsFeed] = v35
	end

	local v35

	if fFlagEnableSocialProofVerticalUserListSheet then
		v35 = {}
		v35[appPage.SocialProofVerticalUserListSheet] = {
			getScreen = function()
				return require("@luauforge/bundled/cEn").UserLists.SocialProofVerticalUserListSheet
			end,
			navigationOptions = module[appPage.SocialProofVerticalUserListSheet]
		}
	end

	local v36

	if fFlagEnableMobileGameJoinCard then
		v36 = {}
		v36[appPage.GameJoinCard] = {
			getScreen = function()
				return require("@luauforge/deferred/eYv").MobileGameJoinCard
			end,
			navigationOptions = module[appPage.GameJoinCard]
		}
	end

	local v37

	if fFlagSocialCarouselBuildPresence then
		v37 = {}
		v37[appPage.BuildJoinCard] = {
			getScreen = function()
				return require("@luauforge/deferred/eYv").BuildJoinCardSheet
			end,
			navigationOptions = module[appPage.BuildJoinCard]
		}
	end

	local v38

	if fFlagLuaAppExperienceLeaderboardSeeAllEnabled then
		v38 = {}
		v38[appPage.ExperienceLeaderboardSeeAll] = {
			screen = createLazyComponent(function()
				return require("@luauforge/bundled/eYw").ExperienceLeaderboardSeeAllPage
			end)
		}
	end

	local v39

	if fFlagEnableUserRecentActivityEntryPoint then
		v39 = {}
		v39[appPage.UserRecentActivity] = {
			getScreen = function()
				return require("@luauforge/bundled/eYN").UserRecentActivity
			end,
			navigationOptions = module[appPage.UserRecentActivity]
		}
	end

	local v40

	if fFlagEnableRecentActivityInspectAndBuy then
		v40 = {}
		v40[appPage.RecentActivityInspectAndBuy] = {
			getScreen = function()
				return require("@luauforge/bundled/eYZ")
			end,
			navigationOptions = module[appPage.RecentActivityInspectAndBuy]
		}
	end

	v6[17], v6[18], v6[19], v6[20], v6[21], v6[22], v6[23], v6[24], v6[25], v6[26], v6[27], v6[28], v6[29], v6[30], v6[31], v6[32] = v23, v24, v25, v26, v27, v28, v29, v32, v33, v34, v35, v36, v37, v38, v39, v40
	local v41

	if fFlagEnableSchoolEntry then
		v41 = {}
		v41[appPage.Schools] = {
			getScreen = function()
				return require("@luauforge/deferred/fbp")
			end,
			navigationOptions = {
				hasSubNavigation = true,
				transparent = true,
				overlayEnabled = true
			}
		}
	end

	v6[33] = v41
	return v6
end
