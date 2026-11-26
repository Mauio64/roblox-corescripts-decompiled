local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local fFlagLuaAppSduiVerificationUpsellActions = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags").FFlagLuaAppSduiVerificationUpsellActions
local fFlagEditProfileFramesEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags").FFlagEditProfileFramesEnabled
local fFlagAddSDUIEditProfileFramesAction = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags").FFlagAddSDUIEditProfileFramesAction

local fFlagAppChatConversationTrustedFriendUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags").FFlagAppChatConversationTrustedFriendUpsellBanner

local fFlagLuaAppExperienceLeaderboardSeeAllEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags").FFlagLuaAppExperienceLeaderboardSeeAllEnabled

local function registerSocialActions()
	local v5 = {
		[sduiActionType.OpenFacialAgeEstimation] = not fFlagLuaAppSduiVerificationUpsellActions and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Actions/SduiOpenFacialAgeEstimationAction")
			end
		} or nil,
		[sduiActionType.OpenAddConnectionsPage] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Actions/SduiOpenAddConnectionsPageAction")
			end
		},
		[sduiActionType.OpenMarketplace] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Actions/SduiOpenMarketplaceAction")
			end
		},
		[sduiActionType.HideProfileCompletion] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Actions/SduiHideProfileCompletionAction")
			end
		},
		[sduiActionType.RequestFriendship] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Actions/SduiRequestFriendshipAction")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.OpenProfileFramesEditor] = fFlagEditProfileFramesEnabled and fFlagAddSDUIEditProfileFramesAction and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Actions/SduiOpenProfileFramesEditorAction")
			end
		} or nil,
		[sduiActionType.OpenTrustedFriendsUpsellModal] = fFlagAppChatConversationTrustedFriendUpsellBanner and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Actions/SduiOpenTrustedFriendsUpsellModalAction")
			end
		} or nil,
		[sduiActionType.RecordPartyChatConversationUpsellAcknowledgement] = fFlagAppChatConversationTrustedFriendUpsellBanner and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Actions/SduiRecordPartyChatConversationUpsellAcknowledgementAction")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenExperienceLeaderboardSeeAll] = fFlagLuaAppExperienceLeaderboardSeeAllEnabled and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Actions/SduiOpenExperienceLeaderboardSeeAllAction")
			end
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerSocialActions
