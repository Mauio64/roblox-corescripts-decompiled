local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local parent = SocialServerDrivenUi.Parent
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiVerificationUpsellActions = SharedFlags.FFlagLuaAppSduiVerificationUpsellActions
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEditProfileFramesEnabled = SharedFlags2.FFlagEditProfileFramesEnabled
local SharedFlags3 = require(parent.SharedFlags)
local FFlagAddSDUIEditProfileFramesAction = SharedFlags3.FFlagAddSDUIEditProfileFramesAction

local SharedFlags4 = require(parent.SharedFlags)
local FFlagAppChatConversationTrustedFriendUpsellBanner = SharedFlags4.FFlagAppChatConversationTrustedFriendUpsellBanner

local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppExperienceLeaderboardSeeAllEnabled = SharedFlags5.FFlagLuaAppExperienceLeaderboardSeeAllEnabled

local function registerSocialActions()
	local v = {
		[SduiActionType.OpenFacialAgeEstimation] = not FFlagLuaAppSduiVerificationUpsellActions and {
			lazyHandler = function()
				return require(SocialServerDrivenUi.Actions.SduiOpenFacialAgeEstimationAction)
			end
		} or nil,
		[SduiActionType.OpenAddConnectionsPage] = {
			lazyHandler = function()
				return require(SocialServerDrivenUi.Actions.SduiOpenAddConnectionsPageAction)
			end
		},
		[SduiActionType.OpenMarketplace] = {
			lazyHandler = function()
				return require(SocialServerDrivenUi.Actions.SduiOpenMarketplaceAction)
			end
		},
		[SduiActionType.HideProfileCompletion] = {
			lazyHandler = function()
				return require(SocialServerDrivenUi.Actions.SduiHideProfileCompletionAction)
			end
		},
		[SduiActionType.RequestFriendship] = {
			lazyHandler = function()
				return require(SocialServerDrivenUi.Actions.SduiRequestFriendshipAction)
			end,
			skipUnifiedLogging = true
		},
		[SduiActionType.OpenProfileFramesEditor] = FFlagEditProfileFramesEnabled and FFlagAddSDUIEditProfileFramesAction and {
			lazyHandler = function()
				return require(SocialServerDrivenUi.Actions.SduiOpenProfileFramesEditorAction)
			end
		} or nil,
		[SduiActionType.OpenTrustedFriendsUpsellModal] = FFlagAppChatConversationTrustedFriendUpsellBanner and {
			lazyHandler = function()
				return require(SocialServerDrivenUi.Actions.SduiOpenTrustedFriendsUpsellModalAction)
			end
		} or nil,
		[SduiActionType.RecordPartyChatConversationUpsellAcknowledgement] = FFlagAppChatConversationTrustedFriendUpsellBanner and {
			lazyHandler = function()
				return require(SocialServerDrivenUi.Actions.SduiRecordPartyChatConversationUpsellAcknowledgementAction)
			end,
			skipUnifiedLogging = true
		} or nil,
		[SduiActionType.OpenExperienceLeaderboardSeeAll] = FFlagLuaAppExperienceLeaderboardSeeAllEnabled and {
			lazyHandler = function()
				return require(SocialServerDrivenUi.Actions.SduiOpenExperienceLeaderboardSeeAllAction)
			end
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v)
end

return registerSocialActions
