local fFlagLuaAppSduiUpdateUserSettingsAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiUpdateUserSettingsAction

local fFlagMoveSduiUpdateUserSettingsToAccountManagement = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagMoveSduiUpdateUserSettingsToAccountManagement
local fFlagSduiOpenSearchResultsTabAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiOpenSearchResultsTabAction
local fFlagLuaAppSduiOpenExternalLinkAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiOpenExternalLinkAction

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local fFlagSduiActionsUpdateFiresOwnTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiActionsUpdateFiresOwnTelemetry
local fFlagSduiCommunitySectionSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiCommunitySectionSupport
local fFlagSduiDevStoreSeeAllSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiDevStoreSeeAllSupport
local fFlagSduiChartsSortDetailGenreFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiChartsSortDetailGenreFilter
local fFlagSduiAiOverviewEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiAiOverviewEnabled
local fFlagSduiPinShortcutAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiPinShortcutAction
local fFlagLuaAppSduiHomePageSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiHomePageSupport
local fFlagLuaAppSduiGameTileFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiGameTileFeedback

local function registerDiscoveryActions()
	local v5 = {
		[sduiActionType.DismissDialog] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiDismissDialogAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.Link] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiLinkAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.OpenFaeTrialUpsell] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenFaeTrialUpsellAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.OpenAbuseReport] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenAbuseReportAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.OpenGameDetails] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenGameDetailsAction")
			end,
			skipUnifiedLogging = fFlagSduiActionsUpdateFiresOwnTelemetry and true or false
		},
		[sduiActionType.OpenBadgeDetails] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenBadgeDetailsAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.OpenBadgesSeeAll] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenBadgesSeeAllAction")
			end,
			lazyTelemetryHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiGameDetailsSubpageTelemetryHandler")
			end
		},
		[sduiActionType.OpenExperienceStoreSeeAll] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenExperienceStoreSeeAllAction")
			end,
			lazyTelemetryHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiGameDetailsSubpageTelemetryHandler")
			end
		},
		[sduiActionType.OpenProfile] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenProfileAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.OpenJoinFriends] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenJoinFriendsAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.OpenSeeAll] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenSeeAllAction")
			end,
			skipUnifiedLogging = fFlagSduiActionsUpdateFiresOwnTelemetry and true or false
		},
		[sduiActionType.OpenSearchResultsTab] = fFlagSduiOpenSearchResultsTabAction and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenSearchResultsTabAction")
			end,
			skipUnifiedLogging = false
		} or nil,
		[sduiActionType.OpenSearchResultsWithQuery] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenSearchResultsWithQueryAction")
			end,
			lazyTelemetryHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiOpenSearchResultsWithQueryTelemetryHandler")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.OpenExternalLink] = fFlagLuaAppSduiOpenExternalLinkAction and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenExternalLinkAction")
			end,
			skipUnifiedLogging = false
		} or nil,
		[sduiActionType.OpenSocialLink] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenSocialLinkAction")
			end,
			lazyTelemetryHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiLeavingRobloxTelemetryHandler")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.OpenSongDetail] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenSongDetailAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.OpenAmpWizard] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenAmpWizardAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.ToggleExperienceFavorite] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiToggleExperienceFavoriteAction")
			end
		},
		[sduiActionType.ToggleExperienceFollow] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiToggleExperienceFollowAction")
			end
		},
		[sduiActionType.ToggleExperienceVote] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiToggleExperienceVoteAction")
			end
		},
		[sduiActionType.DismissGameFeedback] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiDismissGameFeedbackAction")
			end
		},
		[sduiActionType.OpenGameFeedbackForm] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenGameFeedbackFormAction")
			end
		},
		[sduiActionType.AiOverviewFeedback] = fFlagSduiAiOverviewEnabled and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiAiOverviewFeedbackAction")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenSponsoredTooltip] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenSponsoredTooltipAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.SetGameTileNotInterested] = fFlagLuaAppSduiGameTileFeedback and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiSetGameTileNotInterestedAction")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.UndoGameTileNotInterested] = fFlagLuaAppSduiGameTileFeedback and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiUndoGameTileNotInterestedAction")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenMarketplaceTryOn] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenMarketplaceTryOnAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.UpdateUserSettings] = fFlagLuaAppSduiUpdateUserSettingsAction and not fFlagMoveSduiUpdateUserSettingsToAccountManagement and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SettingsSdui").getSduiUpdateUserSettingsAction()
			end,
			skipUnifiedLogging = false
		} or nil,
		[sduiActionType.PlayButtonClick] = {
			lazyHandler = function(): nil
				return nil
			end,
			skipUnifiedLogging = fFlagSduiActionsUpdateFiresOwnTelemetry and true or false
		},
		[sduiActionType.OpenTooltip] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenTooltipAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.RemoveBadgeFromInventory] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiRemoveBadgeFromInventoryAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.RsvpToEvent] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiRsvpToEventAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.OpenEventDetails] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenEventDetailsAction")
			end,
			firesOwnTelemetry = false
		},
		[sduiActionType.OpenGameInvite] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenGameInviteAction")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.LaunchExperience] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiLaunchExperienceAction")
			end,
			firesOwnTelemetry = false
		},
		[sduiActionType.OpenChartsSortDetail] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenChartsSortDetailAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.OpenPurchasePrompt] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/OpenPurchasePrompt/SduiOpenPurchasePromptAction")
			end
		},
		[sduiActionType.OpenSubscriptionPurchasePage] = fFlagSduiDevStoreSeeAllSupport and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenSubscriptionPurchasePageAction")
			end
		} or nil,
		[sduiActionType.OpenSduiOverlay] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiOpenSduiOverlayAction")
			end,
			firesOwnTelemetry = false
		},
		[sduiActionType.ApplyChartsFilter] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiApplyChartsFilterAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.RefreshGamePasses] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiRefreshGamePassesAction")
			end
		},
		[sduiActionType.RefreshPlayability] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiRefreshPlayabilityAction")
			end
		},
		[sduiActionType.EnableEventNotifications] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiEnableEventNotificationsAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.DismissEventNotificationsModal] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiDismissEventNotificationsModalAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.ReportSurfaceLoadTimeMilestone] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiReportSurfaceLoadTimeMilestoneAction")
			end,
			skipUnifiedLogging = true
		},
		[sduiActionType.RefreshOmniRecommendationFeedItem] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiRefreshOmniRecommendationFeedItemAction")
			end,
			skipUnifiedLogging = false
		},
		[sduiActionType.RefreshHome] = fFlagLuaAppSduiHomePageSupport and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiRefreshHomeAction")
			end,
			skipUnifiedLogging = false
		} or nil,
		[sduiActionType.RefreshChartsSortDetail] = fFlagSduiChartsSortDetailGenreFilter and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiRefreshChartsSortDetailAction")
			end,
			skipUnifiedLogging = false
		} or nil,
		[sduiActionType.PinExperienceShortcut] = fFlagSduiPinShortcutAction and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiPinShortcutAction")
			end,
			skipUnifiedLogging = false
		} or nil,
		[sduiActionType.JoinCommunity] = fFlagSduiCommunitySectionSupport and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/SduiJoinCommunityAction")
			end,
			skipUnifiedLogging = false
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerDiscoveryActions
