local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
local AnalyticsKeys = require(BuildExperience.Analytics.AnalyticsKeys)
local AnalyticsUnit = require(BuildExperience.Analytics.AnalyticsUnit)
local AnalyticsMetric = require(BuildExperience.Analytics.AnalyticsMetric)
local GoalLockedActionId = require(BuildExperience.Analytics.Goals.GoalLockedActionId)
local GoalMetricSummarySources = require(BuildExperience.Analytics.Goals.GoalMetricSummarySources)
require(BuildExperience.Analytics.Goals.GoalTypes)

local MetricId = CreatorAnalytics.MetricId

local v = {
	Charts = AnalyticsKeys.ANALYTICS_ACQUISITION_SOURCE_CHARTS,
	ContinueToPlay = AnalyticsKeys.ANALYTICS_ACQUISITION_SOURCE_CONTINUE_TO_PLAY,
	CrossGame = AnalyticsKeys.ANALYTICS_ACQUISITION_SOURCE_CROSS_GAME,
	Curation = AnalyticsKeys.ANALYTICS_ACQUISITION_SOURCE_CURATION,
	Friends = AnalyticsKeys.ANALYTICS_ACQUISITION_SOURCE_FRIENDS,
	HomeNonRecommendation = AnalyticsKeys.ANALYTICS_ACQUISITION_SOURCE_HOME_NON_RECOMMENDATION,
	HomeRecommendation = AnalyticsKeys.ANALYTICS_ACQUISITION_SOURCE_HOME_RECOMMENDATION,
	Moments = AnalyticsKeys.ANALYTICS_ACQUISITION_SOURCE_MOMENTS,
	Others = AnalyticsKeys.ANALYTICS_ACQUISITION_SOURCE_OTHERS,
	PortalAds = AnalyticsKeys.ANALYTICS_ACQUISITION_SOURCE_PORTAL_ADS,
	Search = AnalyticsKeys.ANALYTICS_ACQUISITION_SOURCE_SEARCH,
	SearchAds = AnalyticsKeys.ANALYTICS_ACQUISITION_SOURCE_SEARCH_ADS,
	SponsoredAds = AnalyticsKeys.ANALYTICS_ACQUISITION_SOURCE_SPONSORED_ADS
}

return {
	Goals = {
		{
			id = "GetMorePlayers",
			titleKey = AnalyticsKeys.ANALYTICS_GOAL_TITLE_GET_MORE_PLAYERS,
			unlockMilestone = "universe_dau_5_achieved",
			charts = { AnalyticsMetric.DailyActiveUsers, AnalyticsMetric.PlaythroughRate },
			metricSummaries = {
				{
					kind = "number",
					id = "DailyActiveUsers",
					titleKey = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_DAILY_ACTIVE_USERS,
					source = GoalMetricSummarySources.summary({ metric = MetricId.DailyActiveUsers }),
					format = { unit = AnalyticsUnit.Scalar }
				},
				{
					kind = "number",
					id = "PlaythroughRate",
					titleKey = AnalyticsKeys.ANALYTICS_METRIC_TITLE_PLAYTHROUGH_RATE,
					requiredMilestone = "universe_first_home_recommendation_impression_achieved",
					source = GoalMetricSummarySources.summary({
						metric = MetricId.RFYPlayThroughRate
					}),
					format = { unit = AnalyticsUnit.Percent }
				},
				{
					kind = "breakdown",
					id = "TopAcquisitionSource",
					titleKey = AnalyticsKeys.ANALYTICS_METRIC_TITLE_TOP_ACQUISITION_SOURCE,
					source = GoalMetricSummarySources.topBreakdown({
						metric = MetricId.UniqueUsersWithPlaySessions,
						dimension = "SessionAcquisitionSource"
					}),
					format = {
						type = "translated",
						translationKeyFor = function(_, p)
							return v[p.value]
						end
					}
				}
			},
			locked = {
				messageKey = AnalyticsKeys.ANALYTICS_GOAL_LOCKED_GET_MORE_PLAYERS,
				actions = {
					primary = {
						id = GoalLockedActionId.CreateAd,
						textKey = AnalyticsKeys.ANALYTICS_GOAL_ACTION_CREATE_AD
					},
					secondary = {
						id = GoalLockedActionId.ShareWithFriends,
						textKey = AnalyticsKeys.ANALYTICS_GOAL_ACTION_SHARE_WITH_FRIENDS
					}
				}
			}
		},
		{
			id = "FirstImpression",
			titleKey = AnalyticsKeys.ANALYTICS_GOAL_TITLE_FIRST_IMPRESSION,
			unlockMilestone = "universe_dau_5_achieved",
			charts = { AnalyticsMetric.NewUserSessionTime },
			metricSummaries = {
				{
					kind = "number",
					id = "NewUserSessionTime",
					titleKey = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_NEW_USER_SESSION_TIME,
					source = GoalMetricSummarySources.summary({
						metric = MetricId.AveragePlayTimeMinutesPerDAU,
						filters = {
							{
								dimension = "IsNewUser",
								values = { "New" },
								operation = "Equals"
							}
						}
					}),
					format = { unit = AnalyticsUnit.Minutes }
				},
				{
					kind = "number",
					id = "FirstSessionRetention",
					titleKey = AnalyticsKeys.ANALYTICS_METRIC_TITLE_FIRST_SESSION_RETENTION,
					source = GoalMetricSummarySources.firstSessionRetention({
						durationSeconds = 300
					}),
					format = { unit = AnalyticsUnit.Percent }
				},
				{
					kind = "breakdown",
					id = "TopDropOffStep",
					titleKey = AnalyticsKeys.ANALYTICS_METRIC_TITLE_TOP_DROP_OFF_STEP,
					source = GoalMetricSummarySources.topBreakdown({
						metric = MetricId.FunnelUserChurnRate,
						dimension = "FunnelStep",
						filters = {
							{
								dimension = "FunnelName",
								values = { "FUNNEL_TYPE_ONBOARDING" },
								operation = "Equals"
							}
						}
					}),
					format = {
						type = "custom",
						formatter = function(_, p)
							local displayValue = p.displayValue

							if displayValue == nil or displayValue == "" then
								return p.value
							end

							return `{p.value}. {displayValue}`
						end
					}
				}
			},
			locked = { messageKey = AnalyticsKeys.ANALYTICS_GOAL_LOCKED_FIRST_IMPRESSION }
		},
		{
			id = "KeepPlayersComingBack",
			titleKey = AnalyticsKeys.ANALYTICS_GOAL_TITLE_KEEP_PLAYERS_COMING_BACK,
			unlockMilestone = "universe_first_returning_user_achieved",
			charts = { AnalyticsMetric.D1Retention, AnalyticsMetric.D7Retention },
			metricSummaries = {
				{
					kind = "number",
					id = "ForwardD1Retention",
					titleKey = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_D1_RETENTION,
					source = GoalMetricSummarySources.summary({
						metric = MetricId.ForwardD1Retention,
						endOffsetDays = 1
					}),
					format = { unit = AnalyticsUnit.Percent }
				},
				{
					kind = "number",
					id = "ForwardD7Retention",
					titleKey = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_D7_RETENTION,
					source = GoalMetricSummarySources.summary({
						metric = MetricId.ForwardD7Retention,
						endOffsetDays = 7
					}),
					format = { unit = AnalyticsUnit.Percent }
				}
			},
			locked = { messageKey = AnalyticsKeys.ANALYTICS_GOAL_LOCKED_KEEP_PLAYERS_COMING_BACK }
		},
		{
			id = "EarnRobux",
			titleKey = AnalyticsKeys.ANALYTICS_GOAL_TITLE_EARN_ROBUX,
			unlockMilestone = "universe_first_robux_spent_achieved",
			charts = { AnalyticsMetric.RobuxSpent, AnalyticsMetric.PayerConversion },
			metricSummaries = {
				{
					kind = "number",
					id = "DailyRevenue",
					titleKey = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_ROBUX_SPENT,
					icon = Foundation.Enums.IconName.Robux,
					source = GoalMetricSummarySources.summary({ metric = MetricId.DailyRevenue }),
					format = { unit = AnalyticsUnit.Scalar }
				},
				{
					kind = "number",
					id = "PayingUsersCVR",
					titleKey = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_PAYER_CONVERSION,
					source = GoalMetricSummarySources.summary({ metric = MetricId.PayingUsersCVR }),
					format = { unit = AnalyticsUnit.Percent }
				}
			},
			locked = {
				messageKey = AnalyticsKeys.ANALYTICS_GOAL_LOCKED_EARN_ROBUX,
				actions = {
					primary = {
						id = GoalLockedActionId.SellItems,
						textKey = AnalyticsKeys.ANALYTICS_GOAL_ACTION_SELL_ITEMS
					}
				}
			}
		}
	}
}
