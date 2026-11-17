local LocalizationService = game:GetService("LocalizationService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)
local FFlagBuildExperienceToolLocalization = require(BuildExperience.Flags.FFlagBuildExperienceToolLocalization)

local SharedFlags = require(parent.SharedFlags)

local FFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet
local FFlagEnableTeamTestLua = SharedFlags.FFlagEnableTeamTestLua

local v = {
	ask_for_logs = {
		completed = "Feature.Build.Label.ToolLogsDone",
		failed = "Feature.Build.Label.ToolLogsFailed",
		running = "Feature.Build.Label.ToolLogsRunning"
	},
	ask_user = {
		completed = "Feature.Build.Label.ToolQuestionDone",
		failed = "Feature.Build.Label.ToolQuestionFailed",
		running = "Feature.Build.Label.ToolQuestionRunning"
	},
	execute_luau = {
		completed = "Feature.Build.Label.ToolLuauDone",
		failed = "Feature.Build.Label.ToolLuauFailed",
		running = "Feature.Build.Label.ToolLuauRunning"
	},
	generate_image = {
		completed = "Feature.Build.Label.ToolImageDone",
		failed = "Feature.Build.Label.ToolImageFailed",
		running = "Feature.Build.Label.ToolImageRunning"
	},
	generate_model = {
		completed = "Feature.Build.Label.ToolModelDone",
		failed = "Feature.Build.Label.ToolModelFailed",
		running = "Feature.Build.Label.ToolModelRunning"
	},
	generate_primitive = {
		completed = "Feature.Build.Label.ToolPrimitiveDone",
		failed = "Feature.Build.Label.ToolPrimitiveFailed",
		running = "Feature.Build.Label.ToolPrimitiveRunning"
	},
	insert_asset = {
		completed = "Feature.Build.Label.ToolAssetDone",
		failed = "Feature.Build.Label.ToolAssetFailed",
		running = "Feature.Build.Label.ToolAssetRunning"
	},
	invoke_script = {
		completed = "Feature.Build.Label.ToolScriptDone",
		failed = "Feature.Build.Label.ToolScriptFailed",
		running = "Feature.Build.Label.ToolScriptRunning"
	},
	list_skills = {
		completed = "Feature.Build.Label.ToolSkillsDone",
		failed = "Feature.Build.Label.ToolSkillsFailed",
		running = "Feature.Build.Label.ToolSkillsRunning"
	},
	load_skill = {
		completed = "Feature.Build.Label.ToolSkillLoadDone",
		failed = "Feature.Build.Label.ToolSkillLoadFailed",
		running = "Feature.Build.Label.ToolSkillLoadRunning"
	},
	manage_plan = {
		completed = "Feature.Build.Label.ToolPlanUpdateDone",
		failed = "Feature.Build.Label.ToolPlanUpdateFailed",
		running = "Feature.Build.Label.ToolPlanUpdateRunning"
	},
	manage_requirements = {
		completed = "Feature.Build.Label.ToolReqUpdateDone",
		failed = "Feature.Build.Label.ToolReqUpdateFailed",
		running = "Feature.Build.Label.ToolReqUpdateRunning"
	},
	manage_tasks = {
		completed = "Feature.Build.Label.ToolTasksPlanDone",
		failed = "Feature.Build.Label.ToolTasksPlanFailed",
		running = "Feature.Build.Label.ToolTasksPlanRunning"
	},
	present_plan = {
		completed = "Feature.Build.Label.ToolPlanPresentDone",
		failed = "Feature.Build.Label.ToolPlanPresentFailed",
		running = "Feature.Build.Label.ToolPlanPresentRunning"
	},
	save_and_publish = {
		completed = "Feature.Build.Label.ToolGameSaveDone",
		failed = "Feature.Build.Label.ToolGameSaveFailed",
		running = "Feature.Build.Label.ToolGameSaveRunning"
	},
	search_assets = {
		completed = "Feature.Build.Label.ToolAssetSearchDone",
		failed = "Feature.Build.Label.ToolAssetSearchFailed",
		running = "Feature.Build.Label.ToolAssetSearchRunning"
	},
	set_game_thumbnail = {
		completed = "Feature.Build.Label.ToolThumbnailDone",
		failed = "Feature.Build.Label.ToolThumbnailFailed",
		running = "Feature.Build.Label.ToolThumbnailRunning"
	},
	update_game_info = {
		completed = "Feature.Build.Label.ToolGameInfoDone",
		failed = "Feature.Build.Label.ToolGameInfoFailed",
		running = "Feature.Build.Label.ToolGameInfoRunning"
	}
}

if FFlagBuildExperienceMonetizationNativeUI then
	v.manage_developer_product = {
		completed = "Feature.Build.Title.DeveloperProduct",
		failed = "Feature.Build.Title.DeveloperProduct",
		running = "Feature.Build.Title.DeveloperProduct"
	}

	v.manage_game_pass = {
		completed = "Feature.Build.Title.GamePass",
		failed = "Feature.Build.Title.GamePass",
		running = "Feature.Build.Title.GamePass"
	}

	v.manage_subscription = {
		completed = "Feature.Build.Title.Subscription",
		failed = "Feature.Build.Title.Subscription",
		running = "Feature.Build.Title.Subscription"
	}

	if SharedFlags.FFlagBuildExperienceManageMonetizationTool then
		v.manage_monetization = {
			completed = "Feature.Build.Title.Monetization",
			failed = "Feature.Build.Title.Monetization",
			running = "Feature.Build.Title.Monetization"
		}
	end
end

v.inspect_client_instance = {
	completed = "Feature.Build.Label.ToolInspectDone",
	failed = "Feature.Build.Label.ToolInspectFailed",
	running = "Feature.Build.Label.ToolInspectRunning"
}

v.search_client_datamodel = {
	completed = "Feature.Build.Label.ToolClientDMDone",
	failed = "Feature.Build.Label.ToolClientDMFailed",
	running = "Feature.Build.Label.ToolClientDMRunning"
}

if FFlagBuildExperienceToolLocalization then
	v.ask_analytics_agent = {
		completed = "Feature.Build.Label.ToolAnalyticsDone",
		failed = "Feature.Build.Label.ToolAnalyticsFailed",
		running = "Feature.Build.Label.ToolAnalyticsRunning"
	}

	v.check_ad_campaign_eligibility = {
		completed = "Feature.Build.Label.ToolAdEligibilityDone",
		failed = "Feature.Build.Label.ToolAdEligibilityFailed",
		running = "Feature.Build.Label.ToolAdEligibilityRunning"
	}

	v.compile_luau = {
		completed = "Feature.Build.Label.ToolCompileDone",
		failed = "Feature.Build.Label.ToolCompileFailed",
		running = "Feature.Build.Label.ToolCompileRunning"
	}

	v.verify_luau = {
		completed = "Feature.Build.Label.ToolVerifyDone",
		failed = "Feature.Build.Label.ToolVerifyFailed",
		running = "Feature.Build.Label.ToolVerifyRunning"
	}

	v.lookup_engine_api_docs = {
		completed = "Feature.Build.Label.ToolApiDocsDone",
		failed = "Feature.Build.Label.ToolApiDocsFailed",
		running = "Feature.Build.Label.ToolApiDocsRunning"
	}

	v.restore_version = {
		completed = "Feature.Build.Label.ToolRestoreVersionDone",
		failed = "Feature.Build.Label.ToolRestoreVersionFailed",
		running = "Feature.Build.Label.ToolRestoreVersionRunning"
	}
end

local LocalizationStrings = {}
LocalizationStrings.AD_UPSELL_CARD_CREATE = "Feature.Build.Action.Create"
LocalizationStrings.AD_UPSELL_CARD_DESC = "Feature.Build.Description.BoostAudienceForPlays"
LocalizationStrings.AD_UPSELL_CARD_DONT_SHOW_AGAIN = "Feature.Build.Action.DontShowAgain"
LocalizationStrings.AD_UPSELL_CARD_TITLE = "Feature.Build.Title.PromoteGameFree"
LocalizationStrings.AD_UPSELL_FREE_TITLE = "Feature.Build.Title.PromoteGameFreeSingular"
LocalizationStrings.AD_UPSELL_FREE_TITLE_PLURAL = "Feature.Build.Title.PromoteGameFreePlural"
LocalizationStrings.AD_UPSELL_FREE_DESC = "Feature.Build.Description.PromoteGameFree"
LocalizationStrings.AD_UPSELL_NO_FREE_TITLE = "Feature.Build.Title.PromoteGamePaid"
LocalizationStrings.AD_UPSELL_NO_FREE_DESC = "Feature.Build.Description.PromoteGamePaid"
LocalizationStrings.AD_UPSELL_CONGRATS = "Feature.Build.Message.PublishPromotionUpsell"
LocalizationStrings.AD_UPSELL_CONGRATS_SINGULAR = "Feature.Build.Message.PublishPromotionUpsellSingular"
LocalizationStrings.AGENT_PLAN_BUILD = "Feature.Build.Action.Build"
LocalizationStrings.AGENT_PLAN_OVERVIEW = "Feature.Build.Header.Overview"
LocalizationStrings.AGENT_PLAN_VIEW = "Feature.Build.Action.View"
LocalizationStrings.AGENT_DEV_PRODUCT_APPROVE = "Feature.Build.Action.Approve"
LocalizationStrings.AGENT_DEV_PRODUCT_ACTIVATE = "Feature.Build.Description.ActivateDeveloperProduct"
LocalizationStrings.AGENT_DEV_PRODUCT_CREATE = "Feature.Build.Description.CreateDeveloperProduct"
LocalizationStrings.AGENT_DEV_PRODUCT_DEFAULT_NAME = "Feature.Build.Label.DefaultDeveloperProductName"
LocalizationStrings.AGENT_DEV_PRODUCT_DEACTIVATE = "Feature.Build.Description.DeactivateDeveloperProduct"
LocalizationStrings.AGENT_DEV_PRODUCT_DESCRIPTION = "Feature.Build.Label.DeveloperProductDescription"
LocalizationStrings.AGENT_DEV_PRODUCT_MANAGE = "Feature.Build.Description.ManageDeveloperProduct"
LocalizationStrings.AGENT_DEV_PRODUCT_NAME = "Feature.Build.Label.DeveloperProductName"
LocalizationStrings.AGENT_DEV_PRODUCT_PRICE = "Feature.Build.Label.DeveloperProductPrice"
LocalizationStrings.AGENT_DEV_PRODUCT_PRICE_UNAVAILABLE = "Feature.Build.Label.DeveloperProductPriceUnavailable"
LocalizationStrings.AGENT_DEV_PRODUCT_REJECT = "Feature.Build.Action.Reject"
LocalizationStrings.AGENT_DEV_PRODUCT_TITLE = "Feature.Build.Title.DeveloperProduct"
LocalizationStrings.AGENT_DEV_PRODUCT_UPDATE = "Feature.Build.Description.UpdateDeveloperProduct"
LocalizationStrings.AGENT_GAME_PASS_ACTIVATE = "Feature.Build.Description.ActivateGamePass"
LocalizationStrings.AGENT_GAME_PASS_CREATE = "Feature.Build.Description.CreateGamePass"
LocalizationStrings.AGENT_GAME_PASS_DEACTIVATE = "Feature.Build.Description.DeactivateGamePass"
LocalizationStrings.AGENT_GAME_PASS_TITLE = "Feature.Build.Title.GamePass"
LocalizationStrings.AGENT_GAME_PASS_UPDATE = "Feature.Build.Description.UpdateGamePass"
LocalizationStrings.AGENT_MONETIZATION_CREATE_TITLE = "Feature.Build.Label.MonetizationCreateTitle"
LocalizationStrings.AGENT_SUBSCRIPTION_ACTIVATE = "Feature.Build.Description.ActivateSubscription"
LocalizationStrings.AGENT_SUBSCRIPTION_CREATE = "Feature.Build.Description.CreateSubscription"
LocalizationStrings.AGENT_SUBSCRIPTION_DEACTIVATE = "Feature.Build.Description.DeactivateSubscription"
LocalizationStrings.AGENT_SUBSCRIPTION_DEACTIVATE_CANCEL_RENEWALS = "Feature.Build.Description.DeactivateSubscriptionCancelRenewals"
LocalizationStrings.AGENT_SUBSCRIPTION_DELETE = "Feature.Build.Description.DeleteSubscription"
LocalizationStrings.AGENT_SUBSCRIPTION_PRODUCT_TYPE = "Feature.Build.Label.SubscriptionProductType"
LocalizationStrings.AGENT_SUBSCRIPTION_PRODUCT_TYPE_CONSUMABLE = "Feature.Build.Label.SubscriptionProductTypeConsumable"
LocalizationStrings.AGENT_SUBSCRIPTION_PRODUCT_TYPE_CURRENCY = "Feature.Build.Label.SubscriptionProductTypeCurrency"
LocalizationStrings.AGENT_SUBSCRIPTION_PRODUCT_TYPE_DURABLE = "Feature.Build.Label.SubscriptionProductTypeDurable"
LocalizationStrings.AGENT_SUBSCRIPTION_TITLE = "Feature.Build.Title.Subscription"
LocalizationStrings.AGENT_SUBSCRIPTION_UPDATE = "Feature.Build.Description.UpdateSubscription"
LocalizationStrings.ANALYTICS_DURATION_TEMPLATE = "Feature.Build.Analytics.DurationHours"
LocalizationStrings.ANALYTICS_METRIC_TITLE_ARPPU = "Feature.Build.Analytics.Title.Arppu"
LocalizationStrings.ANALYTICS_METRIC_TITLE_D1_RETENTION = "Feature.Build.Analytics.Title.D1Retention"
LocalizationStrings.ANALYTICS_METRIC_TITLE_DAILY_ACTIVE_USERS = "Feature.Build.Analytics.Title.DailyActiveUsers"
LocalizationStrings.ANALYTICS_METRIC_TITLE_PAYER_CONVERSION = "Feature.Build.Analytics.Title.PayerConversion"
LocalizationStrings.ANALYTICS_METRIC_TITLE_PLAYTHROUGH_RATE = "Feature.Build.Analytics.Title.PlaythroughRate"
LocalizationStrings.ANALYTICS_METRIC_TITLE_TOTAL_PLAYTIME = "Feature.Build.Analytics.Title.TotalPlaytime"
LocalizationStrings.ANALYTICS_PERCENT_TEMPLATE = "Feature.Build.Analytics.Percent"
LocalizationStrings.ADS_STATS_AD_CLICKS = "Feature.Build.Label.AdClicks"
LocalizationStrings.ADS_STATS_AD_VIEWS = "Feature.Build.Label.AdViews"
LocalizationStrings.ADS_STATS_ADS_MANAGER = "Feature.Build.Label.AdsManager"
LocalizationStrings.ADS_STATS_DATE_RANGE = "Feature.Build.Label.DateRange"
LocalizationStrings.ADS_STATS_ERROR = "Feature.Build.Message.AdPerformanceLoadFailed"
LocalizationStrings.ADS_STATS_GAME_PLAYS = "Feature.Build.Label.GamePlays"
LocalizationStrings.ADS_STATS_PAGE_TITLE = "Feature.Build.Title.GetUsers"
LocalizationStrings.ADS_STATS_PAST_CAMPAIGNS = "Feature.Build.Header.PastCampaigns"
LocalizationStrings.ADS_STATS_PLAY_TIME = "Feature.Build.Label.PlayTime"
LocalizationStrings.ANSWER_FORM_CUSTOM_OPTION = "Feature.Build.Action.AddCustomOption"
LocalizationStrings.ANSWER_FORM_ANSWERS = "Feature.Build.Header.Answers"
LocalizationStrings.ANSWER_STACK_CUSTOM_ANSWER = "Feature.Build.Header.CustomAnswer"
LocalizationStrings.ANSWER_STACK_NEXT = "Feature.Build.Action.Next"
LocalizationStrings.ANSWER_STACK_SELECT_AN_OPTION = "Feature.Build.Label.SelectOption"
LocalizationStrings.ANSWER_STACK_SUBMIT = "Feature.Build.Action.Submit"
LocalizationStrings.ARCHIVE_GAME_ARCHIVE = "Feature.Build.Action.Archive"
LocalizationStrings.ARCHIVE_GAME_CANCEL = "Feature.Build.Action.Cancel"
LocalizationStrings.ARCHIVE_GAME_DESCRIPTION = "Feature.Build.Description.ArchiveRemoval"
LocalizationStrings.ARCHIVE_GAME_TITLE = "Feature.Build.Title.ArchiveThisGame"
LocalizationStrings.BUILD_ASSISTANT_FALLBACK_NAME = "Feature.Build.Action.Build"
LocalizationStrings.BUILD_ELIGIBILITY_DIALOG_ACTION = "Feature.Build.Action.OK"
LocalizationStrings.BUILD_ELIGIBILITY_ERROR_DESCRIPTION = "Feature.Build.Message.TryAgain"
LocalizationStrings.BUILD_ELIGIBILITY_ERROR_TITLE = "Feature.Build.Title.GenericError"
LocalizationStrings.BUILD_ELIGIBILITY_INELIGIBLE_DESCRIPTION = "Feature.Build.Message.AccountRequirements"
LocalizationStrings.BUILD_ELIGIBILITY_INELIGIBLE_TITLE = "Feature.Build.Title.BuildUnavailable"
LocalizationStrings.BUILD_GREETING = "Feature.Build.Label.Hi"
LocalizationStrings.BUILD_GREETING_WITH_NAME = "Feature.Build.Message.HiDisplayName"
LocalizationStrings.BUILD_HEADER_TITLE = "Feature.Build.Action.Build"
LocalizationStrings.BUILD_HOME_TAB_GAMES = "Feature.Build.Label.GamesTab"
LocalizationStrings.BUILD_HOME_TAB_PREVIEWS = "Feature.Build.Label.PreviewsTab"
LocalizationStrings.BUILD_SEARCH_PLACEHOLDER = "Feature.Build.Label.SearchGames"
LocalizationStrings.BUILD_SUBLINE = "Feature.Build.Message.WhatToCreate"
LocalizationStrings.BUILD_MENU_AUDIENCE = "Feature.Build.Title.Audience"
LocalizationStrings.BUILD_MENU_BACK_TO_BUILD = "Feature.Build.Label.BackToBuild"
LocalizationStrings.BUILD_MENU_GET_USERS = "Feature.Build.Title.GetUsers"
LocalizationStrings.BUILD_MENU_GET_USERS_FREE_TAG = "Feature.Build.Label.Free"
LocalizationStrings.PROMOTION_CREATE_BUTTON = "Feature.Build.Action.Create"
LocalizationStrings.ADS_STATS_EMPTY_TITLE = "Feature.Build.Title.AdsStatsEmpty"
LocalizationStrings.ADS_STATS_EMPTY_SUBTITLE = "Feature.Build.Message.AdsStatsEmpty"
LocalizationStrings.ADS_STATS_EMPTY_TITLE_FREE = "Feature.Build.Title.AdsStatsEmptyFree"
LocalizationStrings.ADS_STATS_EMPTY_SUBTITLE_FREE = "Feature.Build.Message.AdsStatsEmptyFree"
LocalizationStrings.ADS_STATS_CREATE_SUCCESS = "Feature.Build.Title.AdCreatedPeriod"
LocalizationStrings.BUILD_MENU_INVITE_TO_PLAYTEST = "Feature.Build.Action.AddToPlaytest"
LocalizationStrings.BUILD_MENU_LOADING = "Feature.Build.Label.Loading"
LocalizationStrings.MODEL_PICKER_TITLE = "Feature.Build.Title.ChooseModel"
LocalizationStrings.MODEL_PICKER_UNAVAILABLE = "Feature.Build.Label.ModelUnavailable"
LocalizationStrings.MODEL_PICKER_DEFAULT_LABEL = "Feature.Build.Label.DefaultModel"
LocalizationStrings.MODEL_PICKER_DEFAULT_DESCRIPTION = "Feature.Build.Description.DefaultModel"
LocalizationStrings.MODEL_PICKER_ADVANCED_LABEL = "Feature.Build.Label.AdvancedModel"
LocalizationStrings.MODEL_PICKER_ADVANCED_DESCRIPTION = "Feature.Build.Description.AdvancedModel"
LocalizationStrings.MODEL_PICKER_INTERNAL_LABEL = "Feature.Build.Label.InternalTesting"
LocalizationStrings.MODEL_PICKER_INTERNAL_DESCRIPTION = "Feature.Build.Description.InternalTesting"
LocalizationStrings.MODEL_PICKER_INTERNAL_SPEC_LABEL = "Feature.Build.Label.InternalSpec"
LocalizationStrings.MODEL_PICKER_INTERNAL_SPEC_PLACEHOLDER = "Feature.Build.Placeholder.InternalSpec"
LocalizationStrings.MODEL_PICKER_INTERNAL_SPEC_HINT = "Feature.Build.Description.InternalSpec"
LocalizationStrings.BUILD_MENU_PLAYTEST = "Feature.Build.Action.Playtest"
LocalizationStrings.BUILD_MENU_PUBLISH = "Feature.Build.Action.Publish"
LocalizationStrings.BUILD_MENU_PUBLISH_LATEST = "Feature.Build.Action.PublishLatest"
LocalizationStrings.CREATOR_CREDIT_BUY = "Feature.Build.Action.Buy"
LocalizationStrings.CREATOR_CREDIT_MENU_ITEM = "Feature.Build.Label.Usage"
LocalizationStrings.CREATOR_CREDIT_PAGE_TITLE = "Feature.Build.Title.BuildUsage"
LocalizationStrings.CREATOR_CREDIT_FREE_USAGE_LABEL = "Feature.Build.Label.FreeBuildUsage"
LocalizationStrings.CREATOR_CREDIT_FREE_USAGE_CAPTION = "Feature.Build.Label.ResetsDaily"
LocalizationStrings.CREATOR_CREDIT_FREE_USAGE_CAPTION_WEEKLY = "Feature.Build.Label.ResetsWeekly"
LocalizationStrings.CREATOR_CREDIT_FREE_USAGE_CAPTION_MONTHLY = "Feature.Build.Label.ResetsMonthly"
LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_USAGE_LABEL = "Feature.Build.Label.GetMoreBuildUsage"
LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_DAILY_USAGE_LABEL = "Feature.Build.Label.AdditionalUsage"
LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_USED = "Feature.Build.Label.AdditionalUsed"
LocalizationStrings.CREATOR_CREDIT_AMOUNT_AVAILABLE = "Feature.Build.Label.AmountAvailable"
LocalizationStrings.CREATOR_CREDIT_AVAILABLE_SUFFIX = "Feature.Build.Label.Available"
LocalizationStrings.CREATOR_CREDIT_ADDITIONAL_USAGE_DESCRIPTION = "Feature.Build.Description.AutoBuyUsage"
LocalizationStrings.CREATOR_CREDIT_SET_DAILY_LIMIT = "Feature.Build.Action.SetDailyLimit"
LocalizationStrings.CREATOR_CREDIT_MANAGE_LIMIT = "Feature.Build.Action.ManageLimit"
LocalizationStrings.CREATOR_CREDIT_SETTINGS_SAVE_ERROR = "Feature.Build.Message.SaveChangesFailed"
LocalizationStrings.CREATOR_CREDIT_LIMIT_SHEET_TITLE = "Feature.Build.Action.SetDailyLimit"
LocalizationStrings.CREATOR_CREDIT_LIMIT_SHEET_CONFIRM = "Feature.Build.Action.SetLimit"
LocalizationStrings.CREATOR_CREDIT_LIMIT_BELOW_SPEND = "Feature.Build.Message.LimitBelowSpend"
LocalizationStrings.CREATOR_CREDIT_LIMIT_SHEET_NO_LIMIT = "Feature.Build.Label.NoLimit"
LocalizationStrings.CREATOR_CREDIT_PERCENT_USED = "Feature.Build.Label.PercentUsed"
LocalizationStrings.CREATOR_CREDIT_RESET_HOURS = "Feature.Build.Message.ResetHours"
LocalizationStrings.CREATOR_CREDIT_RESET_ONE_HOUR = "Feature.Build.Message.ResetOneHour"
LocalizationStrings.CREATOR_CREDIT_ROBUX_USAGE = "Feature.Build.Label.RobuxUsage"
LocalizationStrings.CREATOR_CREDIT_USAGE_USED = "Feature.Build.Label.UsageUsed"
LocalizationStrings.CREATOR_CREDIT_UNLIMITED_USED = "Feature.Build.Label.UnlimitedUsed"
LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_BUTTON = "Feature.Build.Action.BuyRobux"
LocalizationStrings.CREATOR_CREDIT_BUY_MORE_ROBUX_TITLE = "Feature.Build.Title.NoRobuxForUsage"
LocalizationStrings.CREATOR_CREDIT_BUY_MORE_ROBUX_DESCRIPTION = "Feature.Build.Description.BuyRobuxToCreate"
LocalizationStrings.CREATOR_CREDIT_INSUFFICIENT_ROBUX_TITLE = "Feature.Build.Title.InsufficientRobuxForModel"
LocalizationStrings.CREATOR_CREDIT_INSUFFICIENT_ROBUX_DEFAULT_AMOUNT_DESCRIPTION = "Feature.Build.Description.RequiredRobuxForDefault"
LocalizationStrings.CREATOR_CREDIT_INSUFFICIENT_ROBUX_ADVANCED_AMOUNT_DESCRIPTION = "Feature.Build.Description.RequiredRobuxForAdvanced"
LocalizationStrings.CREATOR_CREDIT_FREE_LIMIT_REACHED_TITLE = "Feature.Build.Title.FreeLimitReached"
LocalizationStrings.CREATOR_CREDIT_FREE_LIMIT_REACHED_DESCRIPTION = "Feature.Build.Description.EnableUsageOrWait"
LocalizationStrings.CREATOR_CREDIT_MANAGE_USAGE_BUTTON = "Feature.Build.Action.ManageUsage"
LocalizationStrings.CREATOR_CREDIT_FREE_TRIAL_EXHAUSTED_TITLE = "Feature.Build.Title.FreeUsageReached"
LocalizationStrings.CREATOR_CREDIT_FREE_TRIAL_EXHAUSTED_DESCRIPTION = "Feature.Build.Description.BuyUsageOrWait"
LocalizationStrings.CREATOR_CREDIT_DAILY_LIMIT_REACHED_TITLE = "Feature.Build.Title.DailyRobuxReached"
LocalizationStrings.CREATOR_CREDIT_DAILY_LIMIT_REACHED_DESCRIPTION = "Feature.Build.Description.RaiseLimitOrWait"
LocalizationStrings.CREATOR_CREDIT_ADJUST_LIMIT_BUTTON = "Feature.Build.Action.ManageLimit"
LocalizationStrings.CREATOR_CREDIT_VIEW_USAGE_BUTTON = "Feature.Build.Action.ViewUsage"
LocalizationStrings.CREATOR_CREDIT_NOT_NOW_BUTTON = "Feature.Build.Action.NotNow"
LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_SHEET_TITLE = "Feature.Build.Action.BuyRobux"
LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_SHEET_CONFIRM = "Feature.Build.Action.Buy"
LocalizationStrings.BUILD_MENU_SETTINGS = "Feature.Build.Action.Settings"
LocalizationStrings.BUILD_MENU_SHARE = "Feature.Build.Action.Share"
LocalizationStrings.BUILD_MENU_STATS = "Feature.Build.Action.Stats"
LocalizationStrings.BUILD_MENU_VERSION_HISTORY = "Feature.Build.Title.VersionHistory"
LocalizationStrings.BUILD_MENU_VERSIONS = "Feature.Build.Title.Versions"
LocalizationStrings.MONETIZATION_OPTIONS = "Feature.Build.Action.Options"
LocalizationStrings.MONETIZATION_PRICING_OPTIONS = "Feature.Build.Label.PricingOptions"
LocalizationStrings.MONETIZATION_PRICING_OPTIONS_DESCRIPTION = "Feature.Build.Description.PricingRules"
LocalizationStrings.MONETIZATION_MANAGED_PRICING = "Feature.Build.Label.ManagedPricing"
LocalizationStrings.MONETIZATION_MANAGED_PRICING_DESCRIPTION = "Feature.Build.Description.ManagedPricingCurrentProducts"
LocalizationStrings.MONETIZATION_SHOP_UI = "Feature.Build.Label.ShopUi"
LocalizationStrings.MONETIZATION_SHOP_BUTTON = "Feature.Build.Label.ShopButton"
LocalizationStrings.MONETIZATION_SHOP_BUTTON_DESCRIPTION = "Feature.Build.Description.ShopButton"
LocalizationStrings.MONETIZATION_OPTIONS_LOAD_ERROR = "Feature.Build.Error.MonetizationOptionsLoad"
LocalizationStrings.MONETIZATION_PERMISSION_DENIED = "Feature.Build.Error.MonetizationPermissionDenied"
LocalizationStrings.MONETIZATION_MANAGED_PRICING_MIXED = "Feature.Build.Label.ManagedPricingMixed"
LocalizationStrings.MONETIZATION_MANAGED_PRICING_UNAVAILABLE = "Feature.Build.Description.ManagedPricingUnavailable"
LocalizationStrings.MONETIZATION_NO_ELIGIBLE_PRODUCTS = "Feature.Build.Description.NoEligibleManagedPricingProducts"
LocalizationStrings.MONETIZATION_OPTIONS_UPDATE_ERROR = "Feature.Build.Error.MonetizationOptionUpdate"
LocalizationStrings.MONETIZATION_MANAGED_PRICING_PARTIAL_ERROR = "Feature.Build.Error.ManagedPricingPartialUpdate"
LocalizationStrings.MONETIZATION_MANAGED_PRICING_ACK_TITLE = "Feature.Build.Title.ManagedPricingAcknowledgement"
LocalizationStrings.MONETIZATION_MANAGED_PRICING_ACK_DESCRIPTION = "Feature.Build.Description.ManagedPricingAcknowledgement"
LocalizationStrings.MONETIZATION_AGREE = "Feature.Build.Action.AgreeAndEnable"
LocalizationStrings.CHAT_ASSIGNING_TASKS = "Feature.Build.Message.WorkingOnTasks"
LocalizationStrings.CHAT_ASSISTANT_DISABLED = "Feature.Build.Title.ChatBuildUnavailable"
LocalizationStrings.CHAT_ASSISTANT_LOADING = "Feature.Build.Label.Thinking"
LocalizationStrings.CHAT_ASSISTANT_RESPONSE_FAILED = "Feature.Build.Message.BuildResponseFailed"
LocalizationStrings.CHAT_ASSISTANT_STILL_WORKING = "Feature.Build.Message.BuildStillWorking"
LocalizationStrings.CHAT_ASSISTANT_STOPPED = "Feature.Build.Message.BuildStopped"
LocalizationStrings.CHAT_ASSISTANT_TAKING_LONGER = "Feature.Build.Message.BuildTakingLonger"
LocalizationStrings.CHAT_BUILD_CHAT_PAGE_TITLE = "New Game"
LocalizationStrings.CHAT_COMPLETED_GAME_CREATION_DESCRIPTION = FFlagEnableTeamTestLua
	and "Feature.Build.Description.GameSavedPlaytest"
	or "Feature.Build.Description.GameCreationDone"
LocalizationStrings.CHAT_COMPLETED_GAME_CREATION_TITLE = "Feature.Build.Title.GameCreationDone"
LocalizationStrings.CHAT_COMPOSER_PLACEHOLDER = "Feature.Build.Label.DescribeIdea"
LocalizationStrings.CHAT_COPY_TEXT = "Feature.Build.Action.CopyText"
LocalizationStrings.CHAT_CAPTURE_GALLERY_ADD = "Feature.Build.Action.Add"
LocalizationStrings.CHAT_CAPTURE_GALLERY_EMPTY = "Feature.Build.Message.NoCapturesAvailable"
LocalizationStrings.CHAT_CAPTURE_GALLERY_EMPTY_DESCRIPTION = "Feature.Build.Description.CaptureWhilePlaytesting"
LocalizationStrings.CHAT_CAPTURE_GALLERY_EMPTY_DISMISS = "Feature.Build.Action.OK"
LocalizationStrings.CHAT_CAPTURE_GALLERY_HOW_TO_STEP_1 = "Feature.Build.Label.CaptureStepPlaytest"
LocalizationStrings.CHAT_CAPTURE_GALLERY_HOW_TO_STEP_2 = "Feature.Build.Label.CaptureStepTapCamera"
LocalizationStrings.CHAT_CAPTURE_GALLERY_HOW_TO_STEP_3 = "Feature.Build.Label.CaptureStepAddImages"
LocalizationStrings.CHAT_CAPTURE_GALLERY_SELECTION_COUNT = "Feature.Build.Label.CaptureSelectionCount"
LocalizationStrings.CHAT_CAPTURE_GALLERY_SHOW_MORE = "Feature.Build.Action.ShowMore"
LocalizationStrings.CHAT_CAPTURE_GALLERY_TITLE = "Feature.Build.Title.AddImages"
LocalizationStrings.CHAT_CAPTURE_UPLOAD_ERROR = "Feature.Build.Message.ImageUploadFailed"
LocalizationStrings.CHAT_CREATE_UNIVERSE_ERROR = "Feature.Build.Message.GameNotCreated"
LocalizationStrings.CHAT_DEFAULT_FAILURE = "Feature.Build.Message.BuildConnectFailed"
LocalizationStrings.CHAT_ERROR_CONFLICT = "Feature.Build.Message.BuildBusy"
LocalizationStrings.CHAT_ERROR_CODE_TEXT = "Feature.Build.Message.ErrorCodeText"
LocalizationStrings.CHAT_ERROR_FORBIDDEN = "Feature.Build.Message.BuildAccountBlocked"
LocalizationStrings.CHAT_ERROR_GONE = "Feature.Build.Message.ConversationGone"
LocalizationStrings.CHAT_ERROR_INTERNAL = "Feature.Build.Message.BuildInternalError"
LocalizationStrings.CHAT_ERROR_INVALID_PARAMS = "Feature.Build.Message.InvalidMessage"
LocalizationStrings.CHAT_ERROR_NOT_FOUND = "Feature.Build.Message.ConversationNotFound"
LocalizationStrings.CHAT_ERROR_OUT_OF_CREDITS = "Feature.Build.Message.OutOfBuildUsage"
LocalizationStrings.CHAT_ERROR_UNAUTHORIZED = "Feature.Build.Message.SignedOut"
LocalizationStrings.CHAT_ERROR_UPSTREAM_UNAVAILABLE = "Feature.Build.Message.BuildTemporarilyDown"
LocalizationStrings.CHAT_MISSING_PROJECT = "Feature.Build.Message.CreateGameToUseBuild"
LocalizationStrings.CHAT_NOTIFICATION_DISABLED_DESCRIPTION = "Feature.Build.Description.EnableBuildNotifs"
LocalizationStrings.CHAT_NOTIFICATION_PROMPT_DESCRIPTION = "Feature.Build.Description.BuildReplyNotif"
LocalizationStrings.CHAT_NOTIFICATION_PROMPT_TITLE = "Feature.Build.Title.PushNotifications"
LocalizationStrings.CHAT_DONT_ASK_AGAIN = "Feature.Build.Action.DontAskAgain"
LocalizationStrings.CHAT_NOTIFY_ME = "Feature.Build.Action.NotifyMe"
LocalizationStrings.CHAT_ONE_TASK_COMPLETED = "Feature.Build.Message.OneTaskCompleted"
LocalizationStrings.CHAT_OPEN_SETTINGS = "Feature.Build.Action.OpenSettings"
LocalizationStrings.CHAT_PLAYTEST = "Feature.Build.Action.Playtest"
LocalizationStrings.CHAT_POLICY_REJECTION = "Feature.Build.Message.SafetyPolicy"
LocalizationStrings.CHAT_PORTRAIT_REQUIRED = "Feature.Build.Message.TurnToPortrait"
LocalizationStrings.CHAT_QUESTION_COMPOSER_ANSWER = "Feature.Build.Message.AnswerBuildQuestion"
LocalizationStrings.CHAT_QUESTION_MULTIPLE = "Feature.Build.Title.BuildQuestions"
LocalizationStrings.CHAT_QUESTION_SINGLE = "Feature.Build.Title.BuildQuestion"
LocalizationStrings.CHAT_REVERT_CONFIRMATION_ACTION = "Feature.Build.Action.Revert"
LocalizationStrings.CHAT_REVERT_CONFIRMATION_DESCRIPTION = "Feature.Build.Description.RestoreLatest"
LocalizationStrings.CHAT_REVERT_CONFIRMATION_TITLE = "Feature.Build.Title.RevertLastChange"
LocalizationStrings.CHAT_REVERT_TO_VERSION = "Feature.Build.Description.RevertToVersion"
LocalizationStrings.CHAT_REVERT_FAILURE = FFlagEnableTeamTestLua and "Feature.Build.Message.RevertVersionFail"
	or "Feature.Build.Message.PublishNotReverted"
LocalizationStrings.CHAT_SEND_UNCONFIRMED = "Feature.Build.Message.BuildSendUnconfirmed"
LocalizationStrings.CHAT_STOP_CONFIRMATION_ACTION = "Feature.Build.Action.Stop"
LocalizationStrings.CHAT_STOP_CONFIRMATION_CANCEL = "Feature.Build.Action.KeepBuilding"
LocalizationStrings.CHAT_STOP_CONFIRMATION_DESCRIPTION = "Feature.Build.Description.StopBuild"
LocalizationStrings.CHAT_STOP_CONFIRMATION_TITLE = "Feature.Build.Title.StopBuild"
LocalizationStrings.CHAT_TOOL = "Feature.Build.Label.Tool"
LocalizationStrings.CHAT_TOOL_FAILED = "Feature.Build.Message.FailedTitle"
LocalizationStrings.CHAT_TOOL_FINISHED = "Feature.Build.Message.FinishedTitle"
LocalizationStrings.CHAT_TOOL_RUNNING = "Feature.Build.Message.RunningTitle"
LocalizationStrings.CHAT_TASKS_COMPLETED = "Feature.Build.Message.TasksCompleted"
LocalizationStrings.CHAT_THINKING_SECONDS = "Feature.Build.Message.ThinkingSeconds"
LocalizationStrings.CHAT_TURN_ACTIVITY = "Feature.Build.Title.TurnActivity"
LocalizationStrings.CHAT_UPDATE_WITH_CHANGES = "Feature.Build.Action.UpdateWithChanges"
LocalizationStrings.CHAT_WORKED_MINUTES_SECONDS = "Feature.Build.Message.WorkedMinutesSeconds"
LocalizationStrings.CHAT_WORKED_SECONDS = "Feature.Build.Message.WorkedSeconds"
LocalizationStrings.GAME_CONFIGURATION_ACCESS = "Feature.Build.Label.Access"
LocalizationStrings.GAME_CONFIGURATION_ACCESS_AND_SHARING = "Feature.Build.Header.AccessSharing"
LocalizationStrings.GAME_CONFIGURATION_ACCESS_BODY = "Feature.Build.Description.PlayAfterPublish"
LocalizationStrings.GAME_CONFIGURATION_ARCHIVE_GAME = "Feature.Build.Action.ArchiveGame"
LocalizationStrings.GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER = "Feature.Build.Message.QuestionnaireNeeded"
LocalizationStrings.GAME_CONFIGURATION_AUDIENCE = "Feature.Build.Title.Audience"
LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_BANNER = "Feature.Build.Message.ExpandAudience"
LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_BODY = "Feature.Build.Description.PlayAfterPublish"
LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_FRIENDS = "Feature.Build.Label.Friends"
LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_FRIENDS_ONLY = "Feature.Build.Label.FriendsOnly"
LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_NOT_ELIGIBLE = "Feature.Build.Message.AudienceIneligible"
LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_NOT_ELIGIBLE_DESCRIPTION = "Feature.Build.Message.ExpandAudience"
LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PAGE_TITLE = "Feature.Build.Title.ExperienceAudience"
LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PRIVATE = "Feature.Build.Label.Private"
LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLIC = "Feature.Build.Label.Public"
LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLISH_REQUIRED = "Feature.Build.Message.PublishExpandAudience"
LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLISH_REQUIRED_DESCRIPTION = "Feature.Build.Description.MakeAudienceAvail"
LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_UNKNOWN = "Feature.Build.Label.Unknown"
LocalizationStrings.GAME_CONFIGURATION_CONTENT_RATING = "Feature.Build.Label.ContentRating"
LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB = "Feature.Build.Label.CreatorHub"
LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB_DESCRIPTION = "Feature.Build.Description.HubSettings"
LocalizationStrings.GAME_CONFIGURATION_GAME_CONFIGURATION = "Feature.Build.Header.GameConfiguration"
LocalizationStrings.GAME_CONFIGURATION_GAME_CONFIGURATION_BODY = "Feature.Build.Description.GameConfiguration"
LocalizationStrings.GAME_CONFIGURATION_GAME_DETAILS = "Feature.Build.Header.GameDetails"
LocalizationStrings.GAME_CONFIGURATION_GAME_DETAILS_BODY = "Feature.Build.Description.ManageAppearance"
LocalizationStrings.GAME_CONFIGURATION_ICON_AND_THUMBNAILS = "Feature.Build.Label.IconThumbnails"
LocalizationStrings.GAME_CONFIGURATION_SALES_OPTIONS = "Feature.Build.Label.SalesOptions"
LocalizationStrings.GAME_CONFIGURATION_LINK_COPIED = not FFlagEnableShareSheet and "Feature.Build.Message.LinkCopied"
	or nil
LocalizationStrings.GAME_CONFIGURATION_LOADING = "Feature.Build.Label.Loading"
LocalizationStrings.GAME_CONFIGURATION_PREVIEW = "Feature.Build.Action.Preview"
LocalizationStrings.GAME_CONFIGURATION_PUBLISH = "Feature.Build.Action.Publish"
LocalizationStrings.GAME_CONFIGURATION_PUBLISH_ACCOUNT_TOO_NEW_ERROR = "Feature.Build.Message.AccountTooNew"
LocalizationStrings.GAME_CONFIGURATION_PUBLISH_AUDIENCE_ERROR = "Feature.Build.Message.PublicPublishFailed"
LocalizationStrings.GAME_CONFIGURATION_PUBLISH_ERROR = "Feature.Build.Message.GamePublishFailed"
LocalizationStrings.GAME_CONFIGURATION_PUBLISH_SUCCESS = "Feature.Build.Message.ReadyToPlay"
LocalizationStrings.GAME_CONFIGURATION_SHARE = "Feature.Build.Action.Share"
LocalizationStrings.GAME_CONFIGURATION_UPDATE_RATING = "Feature.Build.Action.UpdateRating"
LocalizationStrings.GAME_CONFIGURATION_TITLE_AND_DESCRIPTION = "Feature.Build.Label.TitleDescription"
LocalizationStrings.LIBRARY_TITLE = "Feature.Build.Title.AssetLibrary"
LocalizationStrings.LIBRARY_EMPTY = "Feature.Build.Message.NoAssetsFound"
LocalizationStrings.LIBRARY_SEARCH_EMPTY = "Feature.Build.Message.NoSearchResultsFound"
LocalizationStrings.LIBRARY_OBJECTS_3D = "Feature.Build.Label.Objects3D"
LocalizationStrings.LIBRARY_IMAGES_2D = "Feature.Build.Label.Images2D"
LocalizationStrings.LIBRARY_SOUNDS = "Feature.Build.Label.Sounds"
LocalizationStrings.LIBRARY_OBJECT = "Feature.Build.Label.Object"
LocalizationStrings.LIBRARY_WORLD = "Feature.Build.Label.World"
LocalizationStrings.LIBRARY_MODEL_UNAVAILABLE = "Feature.Build.Message.AssetDetailsUnavailable"
LocalizationStrings.LIBRARY_SEARCH_PLACEHOLDER = "CommonUI.Controls.Action.Search"
LocalizationStrings.LIBRARY_SELECT_ALL = "Feature.Build.Action.SelectAll"
LocalizationStrings.LIBRARY_SELECT_FIRST = "Feature.Build.Action.SelectFirstCount"
LocalizationStrings.MEDIA_SELECTION_CAPTURE_LIBRARY = "Feature.Build.Label.CaptureLibrary"
LocalizationStrings.MEDIA_SELECTION_DELETE = "Feature.Build.Action.Delete"
LocalizationStrings.MEDIA_SELECTION_SHOW_MORE = "Feature.Build.Action.ShowMore"
LocalizationStrings.MEDIA_SELECTION_TITLE = "Feature.Build.Label.IconThumbnails"
LocalizationStrings.MEDIA_SELECTION_VIDEO = "Feature.Build.Label.Video"
LocalizationStrings.MY_CREATIONS_BUILD_WITH_AI = "Feature.Build.Description.BuildIdeaGame"
LocalizationStrings.MY_CREATIONS_BUILDING = "Feature.Build.Label.Building"
LocalizationStrings.MY_CREATIONS_CREATE_NEW_GAME = "Feature.Build.Action.CreateNewGame"
LocalizationStrings.MY_CREATIONS_INPUT_NEEDED = "Feature.Build.Label.InputNeeded"
LocalizationStrings.MY_CREATIONS_LOAD_ERROR = "Feature.Build.Message.ExperiencesLoadFailed"
LocalizationStrings.MY_CREATIONS_NEW_GAME = "Feature.Build.Content.NewGame"
LocalizationStrings.MY_CREATIONS_NO_GAMES = "Feature.Build.Message.NoGamesYet"
LocalizationStrings.MY_CREATIONS_LIVE = "Feature.Build.Label.Live"
LocalizationStrings.MY_CREATIONS_PRIVATE = "Feature.Build.Label.Private"
LocalizationStrings.MY_CREATIONS_PUBLIC = "Feature.Build.Label.Public"
LocalizationStrings.MY_CREATIONS_PUBLICLY_UNAVAILABLE = "Feature.Build.Label.PubliclyUnavailable"
LocalizationStrings.MY_CREATIONS_READY = "Feature.Build.Label.Ready"
LocalizationStrings.MY_CREATIONS_RESTRICTED = "Feature.Build.Label.Limited"
LocalizationStrings.MY_CREATIONS_UNIVERSE_NAME = "Feature.Build.Label.UniverseNumber"
LocalizationStrings.MY_CREATIONS_FILTER_ALL = "Feature.Build.Label.All"
LocalizationStrings.MY_CREATIONS_FILTER_ALL_GAMES = "Feature.Build.Label.AllGames"
LocalizationStrings.MY_CREATIONS_FILTER_APPLY = "CommonUI.Messages.Action.Apply"
LocalizationStrings.MY_CREATIONS_FILTER_GAMES = "CommonUI.Features.Label.Games"
LocalizationStrings.MY_CREATIONS_FILTER_GROUP_GAMES = "Feature.Build.Label.GroupGames"
LocalizationStrings.MY_CREATIONS_FILTER_GROUPS = "Feature.Build.Label.Groups"
LocalizationStrings.MY_CREATIONS_FILTER_MY_GAMES = "Feature.Build.Label.MyGames"
LocalizationStrings.MY_CREATIONS_FILTER_RESET = "CommonUI.Messages.Action.Reset"
LocalizationStrings.MY_CREATIONS_FILTER_SAVE = "Feature.Build.Action.SaveFilters"
LocalizationStrings.MY_CREATIONS_FILTER_SEARCH_GROUPS = "Feature.Build.Label.Search"
LocalizationStrings.MY_CREATIONS_FILTER_SHARED_GAMES = "Feature.Build.Label.SharedWithMe"
LocalizationStrings.MY_CREATIONS_FILTER_TITLE = "Feature.Build.Label.Filters"
LocalizationStrings.PLAYTEST_DISABLED_TOOLTIP = "Feature.Build.Description.PlaytestLocked"
LocalizationStrings.PLAYTEST_TITLE = "Feature.Build.Action.Playtest"
LocalizationStrings.PRIVATE_INVITES_ADD_ERROR = "Feature.Build.Message.PlaytesterRequestFailed"
LocalizationStrings.PRIVATE_INVITES_ADD_ERROR_ACTION = "Feature.Build.Action.OK"
LocalizationStrings.PRIVATE_INVITES_ADD_ERROR_TITLE = "Feature.Build.Title.GenericError"
LocalizationStrings.PRIVATE_INVITES_ADD_REJECTED_TITLE = "Feature.Build.Title.PlaytestersAddRejected"
LocalizationStrings.PRIVATE_INVITES_ADD_PLAYTESTER = "Feature.Build.Action.AddPlaytester"
LocalizationStrings.PRIVATE_INVITES_ADD_PLAYTESTERS = "Feature.Build.Action.AddPlaytesters"
LocalizationStrings.PRIVATE_INVITES_ALL_FRIENDS_ADDED = "Feature.Build.Message.AllFriendsAdded"
LocalizationStrings.PRIVATE_INVITES_FRIENDS_LOAD_ERROR = "Feature.Build.Message.FriendsLoadFailed"
LocalizationStrings.PRIVATE_INVITES_INVITE_BUTTON = "Feature.Build.Action.AddFriends"
LocalizationStrings.PRIVATE_INVITES_COUNT = "Feature.Build.Label.InviteCount"
LocalizationStrings.PRIVATE_INVITES_NO_FRIENDS = "Feature.Build.Message.NoFriendsToAdd"
LocalizationStrings.PRIVATE_INVITES_PAGE_TITLE = "Feature.Build.Title.Playtesters"
LocalizationStrings.PRIVATE_INVITES_ROW_DESCRIPTION = "Feature.Build.Description.ChoosePlaytesters"
LocalizationStrings.PRIVATE_INVITES_ROW_LOAD_ERROR = "Feature.Build.Message.InvitesLoadFailed"
LocalizationStrings.PRIVATE_INVITES_ROW_TITLE = "Feature.Build.Title.Playtesters"
LocalizationStrings.PRIVATE_INVITES_ROW_TITLE_EMPTY = "Feature.Build.Action.AddToPlaytest"
LocalizationStrings.PRIVATE_INVITES_SEARCH_PLACEHOLDER = "Feature.Build.Label.Search"
LocalizationStrings.PRIVATE_INVITES_SENT = "Feature.Build.Message.PlaytestersAdded"
LocalizationStrings.PRIVATE_INVITES_SHARE_LINK = "Feature.Build.Action.ShareLink"
LocalizationStrings.PRIVATE_INVITES_SHARE_LINK_ERROR = "Feature.Build.Message.ShareLinkFailed"
LocalizationStrings.PRIVATE_INVITES_SUBTITLE = "Feature.Build.Description.InviteFriendLimit"
LocalizationStrings.PRIVATE_INVITES_TITLE = "Feature.Build.Title.AddFriendsToPlaytest"
LocalizationStrings.PRIVATE_INVITES_UNKNOWN_USER = "Feature.Build.Label.Unknown"
LocalizationStrings.PUBLISH_CONTENT_BODY = "Feature.Build.Description.RatingAgreement"
LocalizationStrings.PUBLISH_CONTENT_MATURITY = "Feature.Build.Header.ContentMaturity"
LocalizationStrings.PUBLISH_CONTENT_TITLE = "Feature.Build.Title.Content"
LocalizationStrings.PUBLISH_VERSION_INFORMATION_BODY = "Feature.Build.Description.ShareLatest"
LocalizationStrings.PUBLISH_VERSION_INFORMATION_TITLE = "Feature.Build.Header.UpdateDetails"
LocalizationStrings.PUBLISH_VERSION_TITLE_DESCRIPTION = "Feature.Build.Label.UpdateTitleDesc"
LocalizationStrings.SHARE_AUDIENCE_CANCEL = "Feature.Build.Action.Cancel"
LocalizationStrings.SHARE_AUDIENCE_FRIENDS_ONLY_DESCRIPTION = "Feature.Build.Description.FriendsLinkOnly"
LocalizationStrings.SHARE_AUDIENCE_FRIENDS_ONLY_TITLE = "Feature.Build.Title.FriendsOnlyPlay"
LocalizationStrings.SHARE_AUDIENCE_PLAYTESTERS_ONLY_DESCRIPTION = "Feature.Build.Description.PlaytesterAccess"
LocalizationStrings.SHARE_AUDIENCE_PLAYTESTERS_ONLY_TITLE = "Feature.Build.Title.PlaytestersOnlyPlay"
LocalizationStrings.SHARE_AUDIENCE_SHARE = "Feature.Build.Action.Share"
LocalizationStrings.SHARE_EXPERIENCE = "Feature.Build.Message.ShareExperience"
LocalizationStrings.SHARE_GAME_SHARED = "Feature.Build.Message.GameShared"
LocalizationStrings.SHARE_GAME_SHARED_WITH_TARGET = "Feature.Build.Message.GameSharedWith"
LocalizationStrings.SUBAGENT_STATUS_AGENTS = "Feature.Build.Title.Tasks"
LocalizationStrings.SUBAGENT_STATUS_ALL = "Feature.Build.Label.All"
LocalizationStrings.SUBAGENT_STATUS_BUILDING = "Feature.Build.Label.Building"
LocalizationStrings.SUBAGENT_STATUS_COMPLETED_TASKS = "Feature.Build.Message.CompletedTasks"
LocalizationStrings.SUBAGENT_STATUS_DELETED = "Feature.Build.Label.Deleted"
LocalizationStrings.SUBAGENT_STATUS_DONE = "Feature.Build.Label.Done"
LocalizationStrings.SUBAGENT_STATUS_ERROR = "Feature.Build.Label.Error"
LocalizationStrings.SUBAGENT_STATUS_IN_PROGRESS = "Feature.Build.Label.InProgress"
LocalizationStrings.SUBAGENT_STATUS_NOT_STARTED = "Feature.Build.Label.NotStarted"
LocalizationStrings.SUBAGENT_STATUS_PENDING = "Feature.Build.Label.Pending"
LocalizationStrings.SUBAGENT_STATUS_SEARCH_TASKS = "Feature.Build.Label.SearchTasks"
LocalizationStrings.SUBAGENT_STATUS_VERSION = "Feature.Build.Label.Version"
LocalizationStrings.TITLE_DESCRIPTION_DESCRIPTION_LABEL = "Feature.Build.Label.Description"
LocalizationStrings.TITLE_DESCRIPTION_TITLE_LABEL = "Feature.Build.Label.Title"
LocalizationStrings.TITLE_DESCRIPTION_TITLE = "Feature.Build.Label.TitleDescription"
LocalizationStrings.UNPUBLISHED_PLAYTEST_MODE_TOOLTIP_DESCRIPTION = "Feature.Build.Description.PlaytestLatest"
LocalizationStrings.UNPUBLISHED_PLAYTEST_MODE_TOOLTIP_TITLE = "Feature.Build.Title.ChangesNotLive"
LocalizationStrings.USER_PICKER_NO_RESULTS = "Feature.Build.Message.NoResults"
LocalizationStrings.USER_PICKER_USERNAME = "Feature.Build.Label.UsernameHandle"
LocalizationStrings.VERSION_HISTORY_AUTOSAVED = "Feature.Build.Label.Autosaved"
LocalizationStrings.VERSION_HISTORY_ALL_VERSIONS = "Feature.Build.Header.AllVersions"
LocalizationStrings.VERSION_HISTORY_CANCEL = "Feature.Build.Action.Cancel"
LocalizationStrings.VERSION_HISTORY_CREATED_DATE = "Feature.Build.Label.CreatedDate"
LocalizationStrings.VERSION_HISTORY_EMPTY = "Feature.Build.Message.NoVersionHistory"
LocalizationStrings.VERSION_HISTORY_FALLBACK_DESCRIPTION = "Feature.Build.Message.NoDescriptionProvided"
LocalizationStrings.VERSION_HISTORY_HIDE_AUTOSAVED = "Feature.Build.Action.HideAutosaved"
LocalizationStrings.VERSION_HISTORY_LOAD_FAILED = "Feature.Build.Message.VersionHistoryLoad"
LocalizationStrings.VERSION_HISTORY_LOADING = "Feature.Build.Message.LoadingVersions"
LocalizationStrings.VERSION_HISTORY_PREVIOUSLY_PUBLISHED = "Feature.Build.Label.PreviouslyPublished"
LocalizationStrings.VERSION_HISTORY_PUBLISHED = "Feature.Build.Label.Published"
LocalizationStrings.VERSION_HISTORY_RESTORED_BADGE = "Feature.Build.Label.RestoredVersion"
LocalizationStrings.VERSION_HISTORY_RESTORE = "Feature.Build.Action.Restore"
LocalizationStrings.VERSION_HISTORY_RESTORE_FAILED = "Feature.Build.Message.RestoreVersionFailed"
LocalizationStrings.VERSION_HISTORY_TITLE = "Feature.Build.Title.VersionInfo"
LocalizationStrings.LIVE_VERSION_CARD_CREATED_DATE = "Feature.Build.Label.CreatedDate"
LocalizationStrings.LIVE_VERSION_CARD_FALLBACK_DESCRIPTION = "Feature.Build.Message.NoDescriptionProvided"
LocalizationStrings.LIVE_VERSION_CARD_PLAY = "Feature.Build.Action.Play"
LocalizationStrings.LIVE_VERSION_CARD_VERSION_COMPACT = "Feature.Build.Label.VersionCompact"
LocalizationStrings.LIVE_VERSION_CARD_VERSION_PADDED = "Feature.Build.Label.VersionPadded"
LocalizationStrings.LIVE_VERSION_CARD_VERSION_TITLE = "Feature.Build.Title.VersionNumber"
LocalizationStrings.VERSION_HISTORY_VERSION_COMPACT = "Feature.Build.Label.VersionCompact"
LocalizationStrings.VERSION_HISTORY_VERSION_LABEL = "Feature.Build.Label.VersionDate"
LocalizationStrings.VERSION_HISTORY_VERSION_PADDED = "Feature.Build.Label.VersionPadded"
LocalizationStrings.VERSION_HISTORY_VERSION_TITLE = "Feature.Build.Title.VersionNumber"
LocalizationStrings.VERSION_HISTORY_VERSIONS_TITLE = "Feature.Build.Title.Versions"
LocalizationStrings.AD_CAMPAIGN_CARD_TITLE_FREE = "Feature.Build.Title.PromoteGameFree"
LocalizationStrings.AD_CAMPAIGN_CARD_TITLE_ACTIVE = "Feature.Build.Title.AdActive"
LocalizationStrings.AD_CAMPAIGN_CARD_TITLE_COMPLETE = "Feature.Build.Title.AdComplete"
LocalizationStrings.AD_CAMPAIGN_CARD_DESC_FREE = "Feature.Build.Description.BoostAudienceForPlays"
LocalizationStrings.AD_CAMPAIGN_CARD_ACTIVE_DESC = "Feature.Build.Description.CampaignRunDates"
LocalizationStrings.AD_CAMPAIGN_CARD_DESC_COMPLETE = "Feature.Build.Description.AdComplete"
LocalizationStrings.AD_CAMPAIGN_CARD_VIEW = "Feature.Build.Action.View"
LocalizationStrings.AD_CAMPAIGN_SHEET_TITLE = "Feature.Build.Title.PromoteGame"
LocalizationStrings.AD_CAMPAIGN_SHEET_DESCRIPTION = "Feature.Build.Description.PromoteGameWithAdCampaign"
LocalizationStrings.AD_CAMPAIGN_SHEET_CAMPAIGN_TITLE = "Feature.Build.Title.AdCampaignDuration"
LocalizationStrings.AD_CAMPAIGN_SHEET_RUN_DATES = "Feature.Build.Description.AdCampaignSheetRunDates"
LocalizationStrings.AD_CAMPAIGN_SHEET_FREE = "Feature.Build.Label.Free"
LocalizationStrings.AD_CAMPAIGN_SHEET_EARNED_ROBUX_DISCLAIMER = "Feature.Build.Description.EarnedRobuxAppliedFirst"
LocalizationStrings.AD_CAMPAIGN_SHEET_INCLUDED_TITLE = "Feature.Build.Title.WhatsIncluded"
LocalizationStrings.AD_CAMPAIGN_SHEET_MAXIMIZE_PLAYS = "Feature.Build.Label.MaximizeForGamePlays"
LocalizationStrings.AD_CAMPAIGN_SHEET_TARGET_PLAYERS = "Feature.Build.Label.TargetAllRobloxPlayers"
LocalizationStrings.AD_CAMPAIGN_SHEET_PERFORMANCE_REPORT = "Feature.Build.Label.EasyPerformanceReport"
LocalizationStrings.AD_CAMPAIGN_SHEET_LEGAL = "Feature.Build.Description.AdvertisingAgreement"
LocalizationStrings.AD_CAMPAIGN_SHEET_CREATE = "Feature.Build.Action.Create"
LocalizationStrings.AD_CAMPAIGN_SHEET_MODERATION_NOTICE = "Feature.Build.Description.AdCampaignModerationReview"
LocalizationStrings.AD_CAMPAIGN_SHEET_CREATE_ERROR = "Feature.Build.Message.AdCampaignCreateFailed"
LocalizationStrings.AD_CAMPAIGN_SHEET_FORBIDDEN_ERROR = "Feature.Build.Error.AdForbidden"
LocalizationStrings.AD_CAMPAIGN_SHEET_INSUFFICIENT_FUNDS_ERROR = "Feature.Build.Error.AdInsufficientFunds"
LocalizationStrings.AD_CAMPAIGN_SHEET_INTERNAL_ERROR = "Feature.Build.Error.AdInternalError"
LocalizationStrings.AD_CAMPAIGN_SHEET_MISSING_THUMBNAIL_ERROR = "Feature.Build.Error.AdMissingThumbnail"
LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_TITLE = "Feature.Build.Title.CreateYourAd"
LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_INTRODUCTION = "Feature.Build.Description.ChooseAdCampaignLength"
LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_CAMPAIGN_PICKER_TITLE = "Feature.Build.Title.PickCampaign"
LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_OPTION_TITLE = "Feature.Build.Title.AdCampaignOptionDurationShort"
LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_SHORT_DESCRIPTION = "Feature.Build.Description.ShortAdCampaign"
LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_LONG_DESCRIPTION = "Feature.Build.Description.LongAdCampaign"
LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_MODERATION_NOTICE = "Feature.Build.Description.AdModerationReview"
LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_AD_CREDITS_TITLE = "Feature.Build.Title.UseYourAdCredits"
LocalizationStrings.TWO_OPTIONS_AD_CAMPAIGN_SHEET_AD_CREDITS_ACTION = "Feature.Build.Description.UseAdCreditsInAdsManager"
LocalizationStrings.BUILD_MENU_MONETIZATION = "Feature.Build.Action.EarnRobux"
LocalizationStrings.MONETIZATION_TITLE = "Feature.Build.Action.EarnRobux"
LocalizationStrings.MONETIZATION_EMPTY_TITLE = "Feature.Build.Title.NoMonetizationProducts"
LocalizationStrings.MONETIZATION_EMPTY_DESCRIPTION = "Feature.Build.Description.NoMonetizationProducts"
LocalizationStrings.MONETIZATION_EMPTY_CREATE_PRODUCT = "Feature.Build.Action.CreateDeveloperProduct"
LocalizationStrings.MONETIZATION_CREATE_PRODUCT_PROMPT = "Feature.Build.Prompt.CreateDeveloperProduct"
LocalizationStrings.MONETIZATION_PRICING = "Feature.Build.Label.Pricing"
LocalizationStrings.MONETIZATION_REGIONAL_PRICING = "Feature.Build.Label.RegionalPricing"
LocalizationStrings.MONETIZATION_LOADING = "Feature.Build.Label.Loading"
LocalizationStrings.MONETIZATION_RETRY = "Feature.Build.Action.Retry"
LocalizationStrings.MONETIZATION_DEFAULT_PRODUCT_NAME = "Feature.Build.Label.DefaultDeveloperProduct"
LocalizationStrings.MONETIZATION_GAME_PASS = "Feature.InExperienceShop.GamePass"
LocalizationStrings.MONETIZATION_PASSES = "Feature.GamePass.Heading.PassesForThisGame"
LocalizationStrings.MONETIZATION_DEVELOPER_PRODUCTS = "Feature.Build.Label.DeveloperProducts"
LocalizationStrings.MONETIZATION_SUBSCRIPTIONS = "CommonUI.Features.Label.DevSubs"
LocalizationStrings.MONETIZATION_EMPTY_PASSES_TITLE = "Feature.Build.Title.NoMonetizationPasses"
LocalizationStrings.MONETIZATION_EMPTY_PASSES_DESCRIPTION = "Feature.Build.Description.NoMonetizationPasses"
LocalizationStrings.MONETIZATION_EMPTY_DEVELOPER_PRODUCTS_TITLE = "Feature.Build.Title.NoMonetizationDeveloperProducts"
LocalizationStrings.MONETIZATION_EMPTY_DEVELOPER_PRODUCTS_DESCRIPTION = "Feature.Build.Description.NoMonetizationDeveloperProducts"
LocalizationStrings.MONETIZATION_EMPTY_SUBSCRIPTIONS_TITLE = "Feature.Build.Title.NoMonetizationSubscriptions"
LocalizationStrings.MONETIZATION_EMPTY_SUBSCRIPTIONS_DESCRIPTION = "Feature.Build.Description.NoMonetizationSubscriptions"
LocalizationStrings.MONETIZATION_CREATE_PASS = "Feature.Build.Action.CreateMonetizationPass"
LocalizationStrings.MONETIZATION_CREATE_DEVELOPER_PRODUCT = "Feature.Build.Action.CreateMonetizationDeveloperProduct"
LocalizationStrings.MONETIZATION_CREATE_SUBSCRIPTION = "Feature.Build.Action.CreateMonetizationSubscription"
LocalizationStrings.MONETIZATION_CREATE_PASS_PROMPT = "Feature.Build.CreatePassDraft"
LocalizationStrings.MONETIZATION_CREATE_DEVELOPER_PRODUCT_PROMPT = "Feature.Build.CreateDeveloperProductDraft"
LocalizationStrings.MONETIZATION_CREATE_SUBSCRIPTION_PROMPT = "Feature.Build.CreateSubscriptionDraft"
LocalizationStrings.MONETIZATION_PRICE_UNAVAILABLE = "Feature.Build.Label.PriceUnavailable"
LocalizationStrings.MONETIZATION_ON_SALE = "Feature.Build.Label.OnSale"
LocalizationStrings.MONETIZATION_OFF_SALE = "Feature.Build.Label.OffSale"
LocalizationStrings.MONETIZATION_AVAILABLE_FOR_PURCHASE = "Feature.Build.Label.AvailableForPurchase"
LocalizationStrings.MONETIZATION_EDIT = "Feature.Build.Action.Edit"
LocalizationStrings.MONETIZATION_EDIT_PRODUCT = "Feature.Build.Title.EditDeveloperProduct"
LocalizationStrings.MONETIZATION_NAME = "Feature.Build.Label.Name"
LocalizationStrings.MONETIZATION_DESCRIPTION = "Feature.Build.Label.Description"
LocalizationStrings.MONETIZATION_PRICE = "Feature.Build.Label.Price"
LocalizationStrings.MONETIZATION_CANCEL = "Feature.Build.Action.Cancel"
LocalizationStrings.MONETIZATION_SAVE = "Feature.Build.Action.Save"
LocalizationStrings.MONETIZATION_NAME_REQUIRED_ERROR = "Feature.Build.Error.DeveloperProductNameRequired"
LocalizationStrings.MONETIZATION_NAME_LENGTH_ERROR = "Feature.Build.Error.DeveloperProductNameTooLong"
LocalizationStrings.MONETIZATION_DESCRIPTION_LENGTH_ERROR = "Feature.Build.Error.DeveloperProductDescriptionTooLong"
LocalizationStrings.MONETIZATION_PRICE_ERROR = "Feature.Build.Error.DeveloperProductPriceInvalid"
LocalizationStrings.MONETIZATION_PRICE_REQUIRED_FOR_SALE = "Feature.Build.Error.DeveloperProductPriceRequiredForSale"
LocalizationStrings.MONETIZATION_PRICE_REQUIRED_FOR_KIND_SALE = "Feature.Build.Error.MonetizationPriceRequiredForSale"
LocalizationStrings.MONETIZATION_PRICE_REQUIRED_FOR_REGIONAL_PRICING = "Feature.Build.Error.MonetizationPriceRequiredForRegionalPricing"
LocalizationStrings.MONETIZATION_MODERATION_ERROR = "Feature.Build.Error.DeveloperProductTextModerated"
LocalizationStrings.MONETIZATION_CAUSE_IMAGE_IN_REVIEW = "Feature.Build.Error.MonetizationImageInReview"
LocalizationStrings.MONETIZATION_CAUSE_IMAGE_PREPARING = "Feature.Build.Error.MonetizationImagePreparing"
LocalizationStrings.MONETIZATION_CAUSE_IMAGE_TOO_LARGE = "Feature.Build.Error.MonetizationImageTooLarge"
LocalizationStrings.MONETIZATION_CAUSE_IMAGE_TIMED_OUT = "Feature.Build.Error.MonetizationImageTimedOut"
LocalizationStrings.MONETIZATION_CAUSE_IMAGE_FAILED = "Feature.Build.Error.MonetizationImageFailed"
LocalizationStrings.MONETIZATION_CAUSE_NO_UNIVERSE = "Feature.Build.Error.MonetizationNoUniverse"
LocalizationStrings.MONETIZATION_CAUSE_RATE_LIMITED = "Feature.Build.Error.MonetizationRateLimited"
LocalizationStrings.MONETIZATION_COMPOSER_CATALOG = "Feature.Build.Placeholder.DescribeProduct"
LocalizationStrings.MONETIZATION_COMPOSER_EMPTY = "Feature.Build.Placeholder.DescribeProduct"
LocalizationStrings.MONETIZATION_COMPOSER_DETAIL = "Feature.Build.Placeholder.DescribeProductUpdate"

function LocalizationStrings.formatGameSharedWithTarget(p: string)
	if p == "" then
		return "Game shared"
	end

	return `Game shared with {p}`
end

function LocalizationStrings.formatShareExperience(p: string)
	return `Share {p}`
end

function LocalizationStrings.getChatToolActivityLocalizationKey(p: string?, p2: string?)
	if p == nil then
		return nil
	end

	local v2 = v[p]

	if v2 == nil then
		return nil
	end

	if p2 == "completed" then
		return v2.completed
	elseif p2 == "failed" then
		return v2.failed
	end

	return v2.running
end

function LocalizationStrings.formatAdCampaignSheetDate(p: number)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v = robloxLocaleId == "" and "en-us" or robloxLocaleId

	return DateTime.fromUnixTimestampMillis(p):FormatUniversalTime("MMM D", v)
end

function LocalizationStrings.formatAdCampaignSheetLocalDate(p: number)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v = robloxLocaleId == "" and "en-us" or robloxLocaleId

	return DateTime.fromUnixTimestampMillis(p):FormatLocalTime("MMM D", v)
end

function LocalizationStrings.formatCampaignDate(p: number)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v = robloxLocaleId == "" and "en-us" or robloxLocaleId

	return DateTime.fromUnixTimestampMillis(p):FormatLocalTime("MMM D", v)
end

return LocalizationStrings
