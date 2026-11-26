local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local join = Cryo.Dictionary.join

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local module2 = require("@luauforge/bundled/dzD")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local navigateDown = NavigationRodux.Thunks.NavigateDown
local navigateDownToNotifications = NavigationRodux.Thunks.NavigateDownToNotifications
local module5 = require("@luauforge/deferred/hGk")
local navigateDownToPrivacySettings = NavigationRodux.Thunks.NavigateDownToPrivacySettings
local navigateDownToReportAbuse = NavigationRodux.Thunks.NavigateDownToReportAbuse
local navigateDownToViewUserProfile = NavigationRodux.Thunks.NavigateDownToViewUserProfile
local navigateDownToGroups = NavigationRodux.Thunks.NavigateDownToGroups
local module6 = require("@luauforge/deferred/hGl")
local module7 = require("@luauforge/deferred/ehV")
local module8 = require("@luauforge/deferred/hGm")
local module9 = require("@luauforge/bundled/ehA")
local module10 = require("@luauforge/bundled/ehk")
local setTabBarVisibleFromChat = require("@luauforge/bundled/dzQ").Thunks.SetTabBarVisibleFromChat

local getUnreadConversationCount = require("@luauforge/bundled/hGn").Requests.GetUnreadConversationCount
local module11 = require("@luauforge/bundled/dFm")
local module12 = require("@luauforge/bundled/dKt")
local module13 = require("@luauforge/deferred/hGH")
local module14 = require("@luauforge/bundled/ehj")
local module15 = require("@luauforge/deferred/gDj")
local module16 = require("@luauforge/deferred/hGI")

local module17 = require("@luauforge/deferred/hGJ")
local module18 = require("@luauforge/bundled/fCM")
local module19 = require("@luauforge/bundled/ehW")
local openAmpWizardContainer = require("@luauforge/bundled/eif").OpenAmpWizardContainer
local module20 = require("@luauforge/bundled/eia")

local module21 = require("@luauforge/deferred/ehX")

local getFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints
local fFlagAmpWizardEntryPointEventCtxFallback = SharedFlags.FFlagAmpWizardEntryPointEventCtxFallback
local fFlagDeprecatePeopleListContextualMenu = SharedFlags.FFlagDeprecatePeopleListContextualMenu

return function(callback)
	return {
		navigateBack = function()
			callback(RobloxAppToastsRodux())
		end,
		navigateDownToMomentsImmersive = function(value, value2)
			assert(type(value) == "string", "Expected targetId to be a string")
			assert(value2 == nil or type(value2) == "string", "Expected targetIdType to be a string or nil")
			callback(navigateDown({
				name = appPage.MomentsImmersive,
				source = "app_chat_share_card",
				extraProps = { postId = value, targetIdType = value2 }
			}))
		end,
		navigateDownToNotifications = function(p2)
			callback(navigateDownToNotifications(p2))
		end,
		navigateDownToPrivacySettings = function(p2)
			callback(navigateDownToPrivacySettings(p2))
		end,
		navigateDownToReportAbuse = function(p2, p3, p4)
			callback(navigateDownToReportAbuse(p2, p3, p4))
		end,
		openReportDialog = getFFlagLuafiedReportEntryPoints() and function(p2, p3)
			callback(module16({
				reportEntryPoint = module2.ReportDialogEntryPoints.Chat,
				userId = p2,
				conversationId = p3
			}))
		end or nil,
		navigateDownToViewUserProfile = function(p2, p3)
			callback(navigateDownToViewUserProfile(p2, p3))
		end,
		navigateDownToAddFriends = function(p2)
			callback(module6(p2))
		end,
		navigateDownToFriendFinder = function(p2)
			callback(module7(p2))
		end,
		navigateDownToAddFriendsAccountProvider = function(p2, p3)
			callback(module8(p2, p3))
		end,
		openProfilePeekView = function(p2, p3)
			callback(module9(p2, p3))
		end,
		navigateDownToGroups = function(p2)
			callback(navigateDownToGroups(p2))
		end,
		openGroupsListPage = function(p2)
			callback(module5(p2))
		end,
		setTabBarVisibleFromChat = function(p2)
			callback(setTabBarVisibleFromChat(p2))
		end,
		openContextualMenu = fFlagDeprecatePeopleListContextualMenu and function() end or function(p2)
			callback(module10(join(p2, { analyticContext = "SocialTab" })))
		end,
		fetchUnreadConversationCount = function()
			callback(getUnreadConversationCount.API())
		end,
		openGameDetailsPeekView = function(value)
			assert(type(value) == "string", "Expected universeId to be a string")
			callback(module12(value))
		end,
		navigateToGameDetails = function(p2, p3)
			callback(module13(p2, p3))
		end,
		navigateToUserInfo = function(value, p2)
			assert(type(value) == "string", "Expected userId to be a string")
			callback(module14(value, p2))
		end or nil,
		openVerifiedBadgeModal = function()
			callback(module15())
		end,
		openLearnMoreLink = function()
			callback(module19())
		end,
		openDiscoverabilityModal = function(p2)
			callback(module17(p2))
		end,
		closeCentralOverlay = function()
			callback(module18())
		end,
		showToast = function(p2)
			callback(module11({ toastMessage = p2 }))
		end,
		navigateTo3DQRCodePage = function(p2)
			callback(module20(p2))
		end,
		openAmpWizardContainer = function(p2, p3)
			callback(openAmpWizardContainer(
				p2,
				p3,
				nil,
				fFlagAmpWizardEntryPointEventCtxFallback and "SocialTab" or nil
			))
		end,
		openPlayerContextualMenu = function(p2)
			callback(module21(p2))
		end
	}
end
