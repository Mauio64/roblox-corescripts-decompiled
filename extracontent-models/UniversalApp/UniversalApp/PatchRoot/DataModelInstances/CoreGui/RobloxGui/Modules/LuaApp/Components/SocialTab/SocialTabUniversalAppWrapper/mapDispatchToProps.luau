local CorePackages = game:GetService("CorePackages")
local join = require(CorePackages.Packages.Cryo).Dictionary.join
local Modules = script:FindFirstAncestor("Modules")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Constants = require(Modules.LuaApp.Constants)
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local NavigateDownToNotifications = NavigationRodux.Thunks.NavigateDownToNotifications
local OpenGroupsListPage = require(Modules.LuaApp.Thunks.OpenGroupsListPage)
local NavigateDownToPrivacySettings = NavigationRodux.Thunks.NavigateDownToPrivacySettings
local NavigateDownToReportAbuse = NavigationRodux.Thunks.NavigateDownToReportAbuse
local NavigateDownToViewUserProfile = NavigationRodux.Thunks.NavigateDownToViewUserProfile
local NavigateDownToGroups = NavigationRodux.Thunks.NavigateDownToGroups
local NavigateDownToAddFriends = require(Modules.LuaApp.Thunks.NavigateDownToAddFriends)
local NavigateDownToFriendRequests = require(Modules.LuaApp.Thunks.NavigateDownToFriendRequests)
local NavigateDownToAddFriendsAccountProvider = require(Modules.LuaApp.Thunks.NavigateDownToAddFriendsAccountProvider)
local OpenProfilePeekView = require(Modules.LuaApp.Thunks.OpenProfilePeekView)
local OpenCentralOverlayForPeopleList = require(Modules.LuaApp.Thunks.OpenCentralOverlayForPeopleList)
local SetTabBarVisibleFromChat = require(CorePackages.Workspace.Packages.AppTabBarRodux).Thunks.SetTabBarVisibleFromChat
local ToggleChatPaused = require(CorePackages.Workspace.Packages.AppChat.ToggleChatPaused)
local GetUnreadConversationCount = require(CorePackages.Workspace.Packages.SocialTabState).Requests.GetUnreadConversationCount
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local OpenGameDetails = require(Modules.LuaApp.Thunks.OpenGameDetails)
local openGameDetailsPageFromChat = require(Modules.LuaApp.Thunks.openGameDetailsPageFromChat)
local NavigateToUserInfo = require(Modules.LuaApp.Thunks.NavigateToUserInfo)
local OpenVerifiedBadgeModal = require(Modules.LuaApp.Thunks.OpenVerifiedBadgeModal)
local OpenReportDialog = require(Modules.LuaApp.Thunks.OpenReportDialog)
local OpenCentralOverlayForDiscoverabilityUpsell = require(Modules.LuaApp.Thunks.OpenCentralOverlayForDiscoverabilityUpsell)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local OpenContactImporterLearnMoreLink = require(Modules.LuaApp.Thunks.OpenContactImporterLearnMoreLink)
local OpenAmpWizardContainer = require(CorePackages.Workspace.Packages.AmpUpsell).OpenAmpWizardContainer
local NavigateDownTo3DQRCodePage = require(Modules.LuaApp.Thunks.NavigateDownTo3DQRCodePage)
local OpenCentralOverlayForPlayerContextualMenu = require(Modules.LuaApp.Thunks.OpenCentralOverlayForPlayerContextualMenu)
local GetFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints

return function(p1) -- line: 43
	-- upvalues: NavigateBack (copy), NavigateDownToNotifications (copy), NavigateDownToPrivacySettings (copy), NavigateDownToReportAbuse (copy), GetFFlagLuafiedReportEntryPoints (copy), OpenReportDialog (copy), Constants (copy), NavigateDownToViewUserProfile (copy), NavigateDownToAddFriends (copy), NavigateDownToFriendRequests (copy), NavigateDownToAddFriendsAccountProvider (copy), OpenProfilePeekView (copy), NavigateDownToGroups (copy), OpenGroupsListPage (copy), SetTabBarVisibleFromChat (copy), ToggleChatPaused (copy), OpenCentralOverlayForPeopleList (copy), join (copy), GetUnreadConversationCount (copy), OpenGameDetails (copy), openGameDetailsPageFromChat (copy), NavigateToUserInfo (copy), OpenVerifiedBadgeModal (copy), OpenContactImporterLearnMoreLink (copy), OpenCentralOverlayForDiscoverabilityUpsell (copy), CloseCentralOverlay (copy), SetCurrentToastMessage (copy), NavigateDownTo3DQRCodePage (copy), OpenAmpWizardContainer (copy), OpenCentralOverlayForPlayerContextualMenu (copy)
	return {
		navigateBack = function() -- line: 45
			-- upvalues: p1 (copy), NavigateBack (copy)
			p1(NavigateBack())
		end,
		navigateDownToNotifications = function(p2) -- line: 48
			-- upvalues: p1 (copy), NavigateDownToNotifications (copy)
			p1(NavigateDownToNotifications(p2))
		end,
		navigateDownToPrivacySettings = function(p3) -- line: 51
			-- upvalues: p1 (copy), NavigateDownToPrivacySettings (copy)
			p1(NavigateDownToPrivacySettings(p3))
		end,
		navigateDownToReportAbuse = function(p4, p5, p6) -- line: 54
			-- upvalues: p1 (copy), NavigateDownToReportAbuse (copy)
			p1(NavigateDownToReportAbuse(p4, p5, p6))
		end,
		openReportDialog = if not GetFFlagLuafiedReportEntryPoints() then nil else function(p7, p8) -- line: 58
			-- upvalues: p1 (copy), OpenReportDialog (copy), Constants (copy)
			p1(OpenReportDialog({
				reportEntryPoint = Constants.ReportDialogEntryPoints.Chat,
				userId = p7,
				conversationId = p8
			}))
		end,
		navigateDownToViewUserProfile = function(p9, p10) -- line: 66
			-- upvalues: p1 (copy), NavigateDownToViewUserProfile (copy)
			p1(NavigateDownToViewUserProfile(p9, p10))
		end,
		navigateDownToAddFriends = function(p11) -- line: 69
			-- upvalues: p1 (copy), NavigateDownToAddFriends (copy)
			p1(NavigateDownToAddFriends(p11))
		end,
		navigateDownToFriendFinder = function(p12) -- line: 72
			-- upvalues: p1 (copy), NavigateDownToFriendRequests (copy)
			p1(NavigateDownToFriendRequests(p12))
		end,
		navigateDownToAddFriendsAccountProvider = function(p13, p14) -- line: 75
			-- upvalues: p1 (copy), NavigateDownToAddFriendsAccountProvider (copy)
			p1(NavigateDownToAddFriendsAccountProvider(p13, p14))
		end,
		openProfilePeekView = function(p15, p16) -- line: 78
			-- upvalues: p1 (copy), OpenProfilePeekView (copy)
			p1(OpenProfilePeekView(p15, p16))
		end,
		navigateDownToGroups = function(p17) -- line: 81
			-- upvalues: p1 (copy), NavigateDownToGroups (copy)
			p1(NavigateDownToGroups(p17))
		end,
		openGroupsListPage = function(p18) -- line: 84
			-- upvalues: p1 (copy), OpenGroupsListPage (copy)
			p1(OpenGroupsListPage(p18))
		end,
		setTabBarVisibleFromChat = function(p19) -- line: 87
			-- upvalues: p1 (copy), SetTabBarVisibleFromChat (copy)
			p1(SetTabBarVisibleFromChat(p19))
		end,
		toggleChatPaused = function(p20) -- line: 90
			-- upvalues: p1 (copy), ToggleChatPaused (copy)
			p1(ToggleChatPaused(p20))
		end,
		openContextualMenu = function(p21) -- line: 93
			-- upvalues: p1 (copy), OpenCentralOverlayForPeopleList (copy), join (copy)
			p1(OpenCentralOverlayForPeopleList(join(p21, {
				analyticContext = "SocialTab"
			})))
		end,
		fetchUnreadConversationCount = function() -- line: 98
			-- upvalues: p1 (copy), GetUnreadConversationCount (copy)
			p1(GetUnreadConversationCount.API())
		end,
		openGameDetailsPeekView = function(p22) -- line: 101
			-- upvalues: p1 (copy), OpenGameDetails (copy)
			assert(type(p22) == "string", "Expected universeId to be a string")
			p1(OpenGameDetails(p22))
		end,
		navigateToGameDetails = function(p23, p24) -- line: 105
			-- upvalues: p1 (copy), openGameDetailsPageFromChat (copy)
			p1(openGameDetailsPageFromChat(p23, p24))
		end,
		navigateToUserInfo = function(p25, p26) -- line: 108
			-- upvalues: p1 (copy), NavigateToUserInfo (copy)
			assert(type(p25) == "string", "Expected userId to be a string")
			p1(NavigateToUserInfo(p25, p26))
		end or nil,
		openVerifiedBadgeModal = function() -- line: 112
			-- upvalues: p1 (copy), OpenVerifiedBadgeModal (copy)
			p1(OpenVerifiedBadgeModal())
		end,
		openLearnMoreLink = function() -- line: 115
			-- upvalues: p1 (copy), OpenContactImporterLearnMoreLink (copy)
			p1(OpenContactImporterLearnMoreLink())
		end,
		openDiscoverabilityModal = function(p27) -- line: 118
			-- upvalues: p1 (copy), OpenCentralOverlayForDiscoverabilityUpsell (copy)
			p1(OpenCentralOverlayForDiscoverabilityUpsell(p27))
		end,
		closeCentralOverlay = function() -- line: 121
			-- upvalues: p1 (copy), CloseCentralOverlay (copy)
			p1(CloseCentralOverlay())
		end,
		showToast = function(p28) -- line: 124
			-- upvalues: p1 (copy), SetCurrentToastMessage (copy)
			p1(SetCurrentToastMessage({
				toastMessage = p28
			}))
		end,
		navigateTo3DQRCodePage = function(p29) -- line: 129
			-- upvalues: p1 (copy), NavigateDownTo3DQRCodePage (copy)
			p1(NavigateDownTo3DQRCodePage(p29))
		end,
		openAmpWizardContainer = function(p30, p31) -- line: 132
			-- upvalues: p1 (copy), OpenAmpWizardContainer (copy)
			p1(OpenAmpWizardContainer(p30, p31))
		end,
		openPlayerContextualMenu = function(p32) -- line: 135
			-- upvalues: p1 (copy), OpenCentralOverlayForPlayerContextualMenu (copy)
			p1(OpenCentralOverlayForPlayerContextualMenu(p32))
		end
	}
end
