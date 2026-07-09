local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(CorePackages.Packages.React)
require(CorePackages.Workspace.Packages.Navigation)

local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local AppPageProperties = require(Modules.LuaApp.AppPageProperties)
local SystemBarVisibility = require(Modules.LuaApp.Enum.SystemBarVisibility)
local TenFootUiCommon = require(CorePackages.Workspace.Packages.TenFootUiCommon)
local ScreenKind = TenFootUiCommon.TenFootUiRNTypes.ScreenKind
local GlobalNavDisplayOption = TenFootUiCommon.TenFootUiRNTypes.GlobalNavDisplayOption
local api = require(Modules.LuaApp.Components.DiscoverabilityModal.api)
local SocialNetworksInEditProfileIXP = require(CorePackages.Workspace.Packages.EditProfile.Flags).SocialNetworksInEditProfileIXP
local FFlagEnableSocialProofUserList = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSocialProofUserList
local FFlagProfilePlatformAddTC = require(CorePackages.Workspace.Packages.SharedFlags).FFlagProfilePlatformAddTC
local FFlagTCShareLinkErrorModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagTCShareLinkErrorModal
local FFlagUseNewDiscoverabilityModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNewDiscoverabilityModal
local FFlagCreateConnectionsHub = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCreateConnectionsHub
local FFlagCiDeprecateFindFriendsModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCiDeprecateFindFriendsModal
local FFlagEnableSocialProofVerticalUserListSheet = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSocialProofVerticalUserListSheet
local FFlagEnableMobileGameJoinCard = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableMobileGameJoinCard
local FFlagEnableSocialTabsPage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSocialTabsPage
local FFlagEnableSchoolEntry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSchoolEntry

return function() -- line: 36
	-- upvalues: AppPage (copy), Modules (copy), AppPageProperties (copy), CorePackages (copy), SocialNetworksInEditProfileIXP (copy), SystemBarVisibility (copy), ScreenKind (copy), GlobalNavDisplayOption (copy), FFlagCreateConnectionsHub (copy), FFlagUseNewDiscoverabilityModal (copy), api (copy), FFlagCiDeprecateFindFriendsModal (copy), FFlagProfilePlatformAddTC (copy), FFlagTCShareLinkErrorModal (copy), FFlagEnableSocialProofUserList (copy), FFlagEnableSocialTabsPage (copy), FFlagEnableSocialProofVerticalUserListSheet (copy), FFlagEnableMobileGameJoinCard (copy), FFlagEnableSchoolEntry (copy)
	return {
		{
			[AppPage.SocialUnableToJoinExperience] = {
				getScreen = function() -- line: 40
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.SocialUnableToJoinExperience)
				end,
				navigationOptions = AppPageProperties[AppPage.SocialUnableToJoinExperience]
			}
		},
		{
			[AppPage.SocialToast] = {
				getScreen = function() -- line: 48
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.SocialToast).ToastScreen
				end,
				navigationOptions = AppPageProperties[AppPage.SocialToast]
			}
		},
		{
			[AppPage.SocialPurchaseExperience] = {
				getScreen = function() -- line: 56
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.SocialExperienceJoin).PurchaseExperienceModal
				end,
				navigationOptions = AppPageProperties[AppPage.SocialPurchaseExperience]
			}
		},
		{
			[AppPage.SetNicknameModal] = {
				getScreen = function() -- line: 64
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.FriendRequestNicknames).SetNicknameModal
				end,
				navigationOptions = AppPageProperties[AppPage.SetNicknameModal]
			}
		},
		{
			[AppPage.ContentFeed] = {
				getScreen = function() -- line: 72
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.ContentFeed).App
				end,
				navigationOptions = AppPageProperties[AppPage.ContentFeed]
			}
		},
		if not SocialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled() then nil else {
			[AppPage.EditSocialNetworks] = {
				getScreen = function() -- line: 81
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.EditProfile.EditSocialLinksModal)
				end,
				navigationOptions = AppPageProperties[AppPage.EditSocialNetworks]
			}
		},
		if not SocialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled() then nil else {
			[AppPage.EditSocialNetworksError] = {
				getScreen = function() -- line: 91
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.EditProfile.EditSocialNetworksErrorModal)
				end,
				navigationOptions = AppPageProperties[AppPage.EditSocialNetworksError]
			}
		},
		{
			[AppPage.ViewFriends] = {
				getScreen = function() -- line: 100
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.FriendsLanding.FriendsLandingUniversalAppWrapper.Container)
				end,
				navigationOptions = {
					hasSubNavigation = true,
					nativeWrapper = false,
					renderUnderlyingPage = false,
					tabBarHidden = SystemBarVisibility.PolicyDependent
				}
			}
		},
		{
			[AppPage.AddFriendsPage] = {
				getScreen = function() -- line: 114
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.AddFriends.AddFriendsUniversalAppWrapper)
				end,
				navigationOptions = {
					nativeWrapper = false,
					bottomTabBarHidden = true,
					sideTabBarHidden = false,
					tabBarHidden = SystemBarVisibility.PolicyDependent,
					screenKind = ScreenKind.Default,
					globalNavDisplayOption = GlobalNavDisplayOption.OptionGroupOnly
				}
			}
		},
		if not FFlagCreateConnectionsHub then nil else {
			[AppPage.ConnectionsHub] = {
				getScreen = function() -- line: 130
					return require(script.Parent.ConnectionsHub.ConnectionsHubNavigator)
				end
			}
		},
		{
			[AppPage.UserSearch] = {
				getScreen = function() -- line: 138
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.UserSearch.UserSearchScreenUniversalWrapper.UserSearchScreenUniversalWrapper)
				end,
				navigationOptions = {
					tabBarHidden = SystemBarVisibility.PolicyDependent
				}
			}
		},
		{
			[AppPage.DiscoverabilityOverlay] = {
				getScreen = function() -- line: 150
					-- upvalues: FFlagUseNewDiscoverabilityModal (copy), api (copy)
					if FFlagUseNewDiscoverabilityModal then
						return api.DiscoverabilityWithAudit
					end

					return api.DiscoverabilityOverlay
				end,
				navigationOptions = AppPageProperties[AppPage.DiscoverabilityOverlay]
			}
		},
		{
			[AppPage.ContactImporter] = {
				getScreen = function() -- line: 163
					-- upvalues: FFlagCiDeprecateFindFriendsModal (copy), Modules (copy)
					if FFlagCiDeprecateFindFriendsModal then
						return require(Modules.LuaApp.Components.ContactImporter.api).ContactImporterLandingPage
					end

					return require(Modules.LuaApp.Components.ContactImporter.api).FindFriendsModal
				end,
				navigationOptions = AppPageProperties[AppPage.ContactImporter]
			}
		},
		{
			[AppPage.FindFriendsModal] = {
				getScreen = function() -- line: 175
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.ContactImporter.api).FindFriendsModal
				end,
				navigationOptions = AppPageProperties[AppPage.FindFriendsModal]
			}
		},
		{
			[AppPage.ContactsList] = {
				getScreen = function() -- line: 183
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.ContactImporter.ContactsListUniversalAppWrapper)
				end,
				navigationOptions = AppPageProperties[AppPage.ContactsList]
			}
		},
		{
			[AppPage.ContactsRevokedAccessDialog] = {
				getScreen = function() -- line: 192
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.ContactImporter.api).ContactsRevokedAccessDialog
				end,
				navigationOptions = AppPageProperties[AppPage.ContactsRevokedAccessDialog]
			}
		},
		{
			[AppPage.TrustedContactsEducationModal] = {
				getScreen = function() -- line: 200
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.TrustedContacts).TrustedContactsEducationModal
				end,
				navigationOptions = AppPageProperties[AppPage.TrustedContactsEducationModal]
			}
		},
		{
			[AppPage.SettingsPermissionInteractiveAlert] = {
				getScreen = function() -- line: 208
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.SocialCommon).Components.SettingsPermissionInteractiveAlert
				end,
				navigationOptions = AppPageProperties[AppPage.SettingsPermissionInteractiveAlert]
			}
		},
		if not FFlagProfilePlatformAddTC then nil else {
			[AppPage.TrustedContactsModal] = {
				getScreen = function() -- line: 217
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.TrustedContacts).TrustedFriendsModalEntry
				end,
				navigationOptions = AppPageProperties[AppPage.TrustedContactsModal]
			}
		},
		{
			[AppPage.FriendsRenameInfoModal] = {
				getScreen = function() -- line: 227
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.TrustedContacts).FriendsRenameInfoModal
				end,
				navigationOptions = AppPageProperties[AppPage.FriendsRenameInfoModal]
			}
		},
		if not FFlagTCShareLinkErrorModal then nil else {
			[AppPage.TrustedFriendsShareLinkErrorModal] = {
				getScreen = function() -- line: 236
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.TrustedContacts).TrustedFriendsShareLinkErrorModal
				end,
				navigationOptions = AppPageProperties[AppPage.TrustedFriendsShareLinkErrorModal]
			}
		},
		{
			[AppPage.BlockingModal] = {
				getScreen = function() -- line: 245
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.SocialBlockingModal).BlockingModal
				end,
				navigationOptions = AppPageProperties[AppPage.BlockingModal]
			}
		},
		if not FFlagEnableSocialProofUserList then nil else {
			[AppPage.FriendsOwnedUserList] = {
				getScreen = function() -- line: 254
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.SocialProof).UserLists.FriendsOwnedUserList
				end,
				navigationOptions = AppPageProperties[AppPage.FriendsOwnedUserList]
			}
		},
		{
			[AppPage.MutualConnectionList] = {
				getScreen = function() -- line: 263
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.ProfilePlatform.UserLists).MutualConnectionList
				end,
				navigationOptions = AppPageProperties[AppPage.MutualConnectionList]
			}
		},
		if not FFlagEnableSocialTabsPage then nil else {
			[AppPage.SocialTabsPage] = {
				getScreen = function() -- line: 273
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.SocialTabsPage).SocialTabsPageNavigator
				end,
				navigationOptions = AppPageProperties[AppPage.SocialTabsPage]
			}
		},
		{
			[AppPage.AboutDetailsSheet] = {
				getScreen = function() -- line: 282
					-- upvalues: CorePackages (copy)
					return (require(CorePackages.Workspace.Packages.ProfilePlatform.AboutDetailsSheet))
				end,
				navigationOptions = AppPageProperties[AppPage.AboutDetailsSheet]
			}
		},
		if not FFlagEnableSocialProofVerticalUserListSheet then nil else {
			[AppPage.SocialProofVerticalUserListSheet] = {
				getScreen = function() -- line: 291
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.SocialProof).UserLists.SocialProofVerticalUserListSheet
				end,
				navigationOptions = AppPageProperties[AppPage.SocialProofVerticalUserListSheet]
			}
		},
		if not FFlagEnableMobileGameJoinCard then nil else {
			[AppPage.GameJoinCard] = {
				getScreen = function() -- line: 301
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.GameJoinCard).MobileGameJoinCard
				end,
				navigationOptions = AppPageProperties[AppPage.GameJoinCard]
			}
		},
		if not FFlagEnableSchoolEntry then nil else {
			[AppPage.Schools] = {
				getScreen = function() -- line: 311
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.Schools.SchoolsNavigator)
				end,
				navigationOptions = {
					hasSubNavigation = true,
					transparent = true,
					overlayEnabled = true
				}
			}
		}
	}
end
