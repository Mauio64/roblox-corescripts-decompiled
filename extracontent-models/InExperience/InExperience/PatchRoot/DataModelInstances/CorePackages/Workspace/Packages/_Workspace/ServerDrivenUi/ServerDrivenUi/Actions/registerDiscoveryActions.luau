local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiUpdateUserSettingsAction = SharedFlags.FFlagLuaAppSduiUpdateUserSettingsAction

local SharedFlags2 = require(parent.SharedFlags)
local FFlagMoveSduiUpdateUserSettingsToAccountManagement = SharedFlags2.FFlagMoveSduiUpdateUserSettingsToAccountManagement
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiOpenSearchResultsTabAction = SharedFlags3.FFlagSduiOpenSearchResultsTabAction
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppSduiOpenExternalLinkAction = SharedFlags4.FFlagLuaAppSduiOpenExternalLinkAction

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local SharedFlags5 = require(parent.SharedFlags)
local FFlagSduiActionsUpdateFiresOwnTelemetry = SharedFlags5.FFlagSduiActionsUpdateFiresOwnTelemetry
local SharedFlags6 = require(parent.SharedFlags)
local FFlagSduiCommunitySectionSupport = SharedFlags6.FFlagSduiCommunitySectionSupport
local SharedFlags7 = require(parent.SharedFlags)
local FFlagSduiDevStoreSeeAllSupport = SharedFlags7.FFlagSduiDevStoreSeeAllSupport
local SharedFlags8 = require(parent.SharedFlags)
local FFlagSduiChartsSortDetailGenreFilter = SharedFlags8.FFlagSduiChartsSortDetailGenreFilter
local SharedFlags9 = require(parent.SharedFlags)
local FFlagSduiAiOverviewEnabled = SharedFlags9.FFlagSduiAiOverviewEnabled
local SharedFlags10 = require(parent.SharedFlags)
local FFlagSduiPinShortcutAction = SharedFlags10.FFlagSduiPinShortcutAction
local SharedFlags11 = require(parent.SharedFlags)
local FFlagLuaAppSduiHomePageSupport = SharedFlags11.FFlagLuaAppSduiHomePageSupport
local SharedFlags12 = require(parent.SharedFlags)
local FFlagLuaAppSduiGameTileFeedback = SharedFlags12.FFlagLuaAppSduiGameTileFeedback

local function registerDiscoveryActions()
	local v = {
		[SduiActionType.DismissDialog] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiDismissDialogAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.Link] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiLinkAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.OpenFaeTrialUpsell] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenFaeTrialUpsellAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.OpenAbuseReport] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenAbuseReportAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.OpenGameDetails] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenGameDetailsAction)
			end,
			skipUnifiedLogging = FFlagSduiActionsUpdateFiresOwnTelemetry and true or false
		},
		[SduiActionType.OpenBadgeDetails] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenBadgeDetailsAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.OpenBadgesSeeAll] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenBadgesSeeAllAction)
			end,
			lazyTelemetryHandler = function()
				return require(ServerDrivenUi.Actions.TelemetryHandlers.SduiGameDetailsSubpageTelemetryHandler)
			end
		},
		[SduiActionType.OpenExperienceStoreSeeAll] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenExperienceStoreSeeAllAction)
			end,
			lazyTelemetryHandler = function()
				return require(ServerDrivenUi.Actions.TelemetryHandlers.SduiGameDetailsSubpageTelemetryHandler)
			end
		},
		[SduiActionType.OpenProfile] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenProfileAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.OpenJoinFriends] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenJoinFriendsAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.OpenSeeAll] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenSeeAllAction)
			end,
			skipUnifiedLogging = FFlagSduiActionsUpdateFiresOwnTelemetry and true or false
		},
		[SduiActionType.OpenSearchResultsTab] = FFlagSduiOpenSearchResultsTabAction and {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenSearchResultsTabAction)
			end,
			skipUnifiedLogging = false
		} or nil,
		[SduiActionType.OpenSearchResultsWithQuery] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenSearchResultsWithQueryAction)
			end,
			lazyTelemetryHandler = function()
				return require(ServerDrivenUi.Actions.TelemetryHandlers.SduiOpenSearchResultsWithQueryTelemetryHandler)
			end,
			skipUnifiedLogging = true
		},
		[SduiActionType.OpenExternalLink] = FFlagLuaAppSduiOpenExternalLinkAction and {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenExternalLinkAction)
			end,
			skipUnifiedLogging = false
		} or nil,
		[SduiActionType.OpenSocialLink] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenSocialLinkAction)
			end,
			lazyTelemetryHandler = function()
				return require(ServerDrivenUi.Actions.TelemetryHandlers.SduiLeavingRobloxTelemetryHandler)
			end,
			skipUnifiedLogging = true
		},
		[SduiActionType.OpenSongDetail] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenSongDetailAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.OpenAmpWizard] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenAmpWizardAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.ToggleExperienceFavorite] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiToggleExperienceFavoriteAction)
			end
		},
		[SduiActionType.ToggleExperienceFollow] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiToggleExperienceFollowAction)
			end
		},
		[SduiActionType.ToggleExperienceVote] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiToggleExperienceVoteAction)
			end
		},
		[SduiActionType.DismissGameFeedback] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiDismissGameFeedbackAction)
			end
		},
		[SduiActionType.OpenGameFeedbackForm] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenGameFeedbackFormAction)
			end
		},
		[SduiActionType.AiOverviewFeedback] = FFlagSduiAiOverviewEnabled and {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiAiOverviewFeedbackAction)
			end,
			skipUnifiedLogging = true
		} or nil,
		[SduiActionType.OpenSponsoredTooltip] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenSponsoredTooltipAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.SetGameTileNotInterested] = FFlagLuaAppSduiGameTileFeedback and {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiSetGameTileNotInterestedAction)
			end,
			skipUnifiedLogging = true
		} or nil,
		[SduiActionType.UndoGameTileNotInterested] = FFlagLuaAppSduiGameTileFeedback and {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiUndoGameTileNotInterestedAction)
			end,
			skipUnifiedLogging = true
		} or nil,
		[SduiActionType.OpenMarketplaceTryOn] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenMarketplaceTryOnAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.UpdateUserSettings] = FFlagLuaAppSduiUpdateUserSettingsAction and not FFlagMoveSduiUpdateUserSettingsToAccountManagement and {
			lazyHandler = function()
				local SettingsSdui = require(parent.SettingsSdui)
				return SettingsSdui.getSduiUpdateUserSettingsAction()
			end,
			skipUnifiedLogging = false
		} or nil,
		[SduiActionType.PlayButtonClick] = {
			lazyHandler = function(): nil
				return nil
			end,
			skipUnifiedLogging = FFlagSduiActionsUpdateFiresOwnTelemetry and true or false
		},
		[SduiActionType.OpenTooltip] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenTooltipAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.RemoveBadgeFromInventory] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiRemoveBadgeFromInventoryAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.RsvpToEvent] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiRsvpToEventAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.OpenEventDetails] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenEventDetailsAction)
			end,
			firesOwnTelemetry = false
		},
		[SduiActionType.OpenGameInvite] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenGameInviteAction)
			end,
			skipUnifiedLogging = true
		},
		[SduiActionType.LaunchExperience] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiLaunchExperienceAction)
			end,
			firesOwnTelemetry = false
		},
		[SduiActionType.OpenChartsSortDetail] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenChartsSortDetailAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.OpenPurchasePrompt] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.OpenPurchasePrompt.SduiOpenPurchasePromptAction)
			end
		},
		[SduiActionType.OpenSubscriptionPurchasePage] = FFlagSduiDevStoreSeeAllSupport and {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenSubscriptionPurchasePageAction)
			end
		} or nil,
		[SduiActionType.OpenSduiOverlay] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiOpenSduiOverlayAction)
			end,
			firesOwnTelemetry = false
		},
		[SduiActionType.ApplyChartsFilter] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiApplyChartsFilterAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.RefreshGamePasses] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiRefreshGamePassesAction)
			end
		},
		[SduiActionType.RefreshPlayability] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiRefreshPlayabilityAction)
			end
		},
		[SduiActionType.EnableEventNotifications] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiEnableEventNotificationsAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.DismissEventNotificationsModal] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiDismissEventNotificationsModalAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.ReportSurfaceLoadTimeMilestone] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiReportSurfaceLoadTimeMilestoneAction)
			end,
			skipUnifiedLogging = true
		},
		[SduiActionType.RefreshOmniRecommendationFeedItem] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiRefreshOmniRecommendationFeedItemAction)
			end,
			skipUnifiedLogging = false
		},
		[SduiActionType.RefreshHome] = FFlagLuaAppSduiHomePageSupport and {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiRefreshHomeAction)
			end,
			skipUnifiedLogging = false
		} or nil,
		[SduiActionType.RefreshChartsSortDetail] = FFlagSduiChartsSortDetailGenreFilter and {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiRefreshChartsSortDetailAction)
			end,
			skipUnifiedLogging = false
		} or nil,
		[SduiActionType.PinExperienceShortcut] = FFlagSduiPinShortcutAction and {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiPinShortcutAction)
			end,
			skipUnifiedLogging = false
		} or nil,
		[SduiActionType.JoinCommunity] = FFlagSduiCommunitySectionSupport and {
			lazyHandler = function()
				return require(ServerDrivenUi.Actions.SduiJoinCommunityAction)
			end,
			skipUnifiedLogging = false
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v)
end

return registerDiscoveryActions
