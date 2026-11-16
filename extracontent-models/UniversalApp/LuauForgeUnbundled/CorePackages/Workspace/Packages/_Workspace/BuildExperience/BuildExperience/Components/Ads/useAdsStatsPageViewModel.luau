local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local useLocalization = Localization.Hooks.useLocalization

local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local useGetAdCampaigns = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useGetAdCampaigns")
local useGetCampaignStats = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useGetCampaignStats")
local useGetAdCampaignEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useGetAdCampaignEligibility")
local useCreateAdCampaign = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useCreateAdCampaign")
local adCampaignEligibilityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignEligibilityUtils")
local adCampaignScheduleUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignScheduleUtils")
local getAdsManagerUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/getAdsManagerUrl")
local useOpenWebViewWithResumeRefresh = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useOpenWebViewWithResumeRefresh")
local CampaignStats = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CampaignStats")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdsStatsView")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/PastCampaignRow")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/StatsCard/StatsCard")
local AnalyticsUnit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsUnit")
local StatsCardValueFormat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/StatsCard/StatsCardValueFormat")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local FFlagEnablePaidAds = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagEnablePaidAds")
local FFlagBuildAdsManagerUniverseUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdsManagerUniverseUrl")

local iconName = Foundation.Enums.IconName
local iconPosition = Foundation.Enums.IconPosition

local MS_PER_DAY = adCampaignScheduleUtils.MS_PER_DAY
local toStartMs = adCampaignScheduleUtils.toStartMs
local campaignEndMs = adCampaignScheduleUtils.campaignEndMs
local campaignEndExclusiveMs = adCampaignScheduleUtils.campaignEndExclusiveMs

local WINDOW_DAYS = CampaignStats.WINDOW_DAYS
local v5 = { plays = 0, adClicks = 0, adViews = 0, playtimeSeconds = 0 }

local function toPlaytimeMinutes(p2)
	return p2 / 60
end

local function formatDateRange(dateRange, startMs, endMs)
	if startMs == nil or endMs == nil or startMs <= 0 then
		return nil
	end

	local v6 = {
		startDate = LocalizationStrings.formatCampaignDate(startMs),
		endDate = LocalizationStrings.formatCampaignDate(endMs)
	}

	return (string.gsub(dateRange, "{(%w+)}", function(p2)
		return v6[p2] or "{" .. p2 .. "}"
	end))
end

local function scalarCard(p2, p3, p4, p5)
	return {
		title = p2,
		statValue = p3,
		statUnit = AnalyticsUnit.Scalar,
		statValueFormat = StatsCardValueFormat.Regular,
		statIcon = p4,
		statIconPosition = iconPosition.Left,
		deltaValue = 0,
		deltaUnit = AnalyticsUnit.Percent,
		hasData = p5
	}
end

local function useAdsStatsPageViewModel(p2, p3, p4, p5, p6, p7)
	local v6, v7 = useGetAdCampaigns(p3)

	local flag = false

	if v6 ~= nil and p2 ~= nil then
		local v8 = tostring(p2)

		for k, v10 in v6 do
			if v10.targetUniverseId == v8 then
				flag = true
				break
			end
		end
	end

	local v8 = if flag then p2 else nil
	local v9, v10, v11 = useGetCampaignStats(v8, p4)
	local v12, v13 = useGetAdCampaignEligibility(p2, p6)
	local v14 = useCreateAdCampaign(p2, nil, p7)
	local state, setState = React.useState(false)

	local state2, setState2 = React.useState(nil)
	local state3, setState3

	if FFlagEnablePaidAds then
		state3, setState3 = React.useState(nil)
	else
		setState3 = nil
	end

	local state4, setState4 = React.useState(false)
	local ref = React.useRef(nil)

	local v15 = React.useCallback(function()
		setState(false)

		if FFlagEnablePaidAds then
			v14.clearCreateError()
		end
	end, { v14.clearCreateError })

	local state5, setState5 = React.useState(false)
	local v16 = React.useCallback(function()
		setState5(false)
	end, {})

	local ref2 = React.useRef(false)
	React.useEffect(function()
		local current = ref2.current
		ref2.current = v14.isCreatePending

		if current and not (v14.isCreatePending or v14.hasCreateError) then
			setState(false)
			setState5(true)
			setState4(ref.current ~= nil)
		end
	end, { v14.isCreatePending, v14.hasCreateError })

	React.useEffect(function()
		local v17 = v13 == "Ready" and v12 ~= nil and v12 ~= ref.current

		if state4 and (v17 or v13 == "Failed") then
			ref.current = nil
			setState4(false)
		end
	end, { state4, v13, v12 })

	React.useEffect(function()
		ref.current = nil
		setState4(false)

		if FFlagEnablePaidAds then
			setState3(nil)
		end
	end, { p2 })

	local v17 = React.useMemo(function()
		if p5 == nil then
			return DateTime.now().UnixTimestampMillis
		end

		return p5
	end, { p5 })

	local v18 = useLocalization({
		gamePlays = LocalizationStrings.ADS_STATS_GAME_PLAYS,
		adClicks = LocalizationStrings.ADS_STATS_AD_CLICKS,
		adViews = LocalizationStrings.ADS_STATS_AD_VIEWS,
		playTime = LocalizationStrings.ADS_STATS_PLAY_TIME,
		pastCampaigns = LocalizationStrings.ADS_STATS_PAST_CAMPAIGNS,
		error = LocalizationStrings.ADS_STATS_ERROR,
		dateRange = LocalizationStrings.ADS_STATS_DATE_RANGE,
		create = LocalizationStrings.PROMOTION_CREATE_BUTTON,
		emptyTitle = LocalizationStrings.ADS_STATS_EMPTY_TITLE,
		emptySubtitle = LocalizationStrings.ADS_STATS_EMPTY_SUBTITLE,
		emptyTitleFree = LocalizationStrings.ADS_STATS_EMPTY_TITLE_FREE,
		emptySubtitleFree = LocalizationStrings.ADS_STATS_EMPTY_SUBTITLE_FREE,
		adsManager = LocalizationStrings.ADS_STATS_ADS_MANAGER,
		createSuccess = LocalizationStrings.ADS_STATS_CREATE_SUCCESS
	})

	local gamePlays = v18.gamePlays
	local adClicks = v18.adClicks
	local adViews = v18.adViews
	local playTime = v18.playTime
	local pastCampaigns = v18.pastCampaigns
	local err = v18.error

	local dateRange = v18.dateRange

	local v19 = {
		p2,
		v6,
		v9,
		v11,
		v17,
		gamePlays,
		adClicks,
		adViews,
		playTime,
		dateRange,
		v18[Localization.RobloxLocaleIdKey]
	}
	local v20 = React.useMemo(function()
		local v22 = v9 or {}
		local v23 = v17 - WINDOW_DAYS * MS_PER_DAY

		local v24 = if p2 ~= nil then tostring(p2) else nil

		local v25 = {}
		local v26 = {}

		for k, v27 in v6 or {} do
			if not (v24 ~= nil and v27.targetUniverseId == v24) then
				continue
			end

			local v28 = v22[v27.id] or v5
			local v29 = toStartMs(v27.schedule.startTime)
			local v30 = campaignEndMs(v29, v27.schedule.durationInDays)

			local v31 = v27.status == "CANCELLED"
			local v32 = campaignEndExclusiveMs(v29, v27.schedule.durationInDays)

			if not v31 and v17 < v32 then
				table.insert(v25, {
					id = v27.id,
					stats = v28,
					startMs = v29,
					endMs = v30
				})
			elseif v23 <= v29 then
				table.insert(v26, { stats = v28, startMs = v29, endMs = v30 })
			end
		end

		table.sort(v25, function(a, b): boolean
			if a.startMs == b.startMs then
				return a.id < b.id
			end

			return a.startMs > b.startMs
		end)

		table.sort(v26, function(a, b): boolean
			return a.endMs > b.endMs
		end)

		local function buildSummaryCards(stats)
			local plays = stats.plays
			local circlePlay = iconName.CirclePlay
			local v28 = not v11.plays
			local v29 = {
				title = gamePlays,
				statValue = plays,
				statUnit = AnalyticsUnit.Scalar,
				statValueFormat = StatsCardValueFormat.Regular,
				statIcon = circlePlay,
				statIconPosition = iconPosition.Left,
				deltaValue = 0,
				deltaUnit = AnalyticsUnit.Percent,
				hasData = v28
			}

			local adClicks2 = stats.adClicks
			local crosshairs = iconName.Crosshairs
			local v31 = not v11.adClicks
			local v32 = {
				title = adClicks,
				statValue = adClicks2,
				statUnit = AnalyticsUnit.Scalar,
				statValueFormat = StatsCardValueFormat.Regular,
				statIcon = crosshairs,
				statIconPosition = iconPosition.Left,
				deltaValue = 0,
				deltaUnit = AnalyticsUnit.Percent,
				hasData = v31
			}

			local adViews2 = stats.adViews
			local eye = iconName.Eye
			local v34 = not v11.adViews
			return {
				v29,
				v32,
				{
					title = adViews,
					statValue = adViews2,
					statUnit = AnalyticsUnit.Scalar,
					statValueFormat = StatsCardValueFormat.Regular,
					statIcon = eye,
					statIconPosition = iconPosition.Left,
					deltaValue = 0,
					deltaUnit = AnalyticsUnit.Percent,
					hasData = v34
				},
				{
					title = playTime,
					statValue = stats.playtimeSeconds / 60,
					statUnit = AnalyticsUnit.Temporal,
					statIcon = iconName.Clock,
					statIconPosition = iconPosition.Left,
					deltaValue = 0,
					deltaUnit = AnalyticsUnit.Percent,
					hasData = not v11.playtimeSeconds
				}
			}
		end

		local v27 = {}

		for k, v28 in v25 do
			table.insert(v27, {
				id = v28.id,
				dateText = formatDateRange(dateRange, v28.startMs, v28.endMs) or "",
				summaryCards = buildSummaryCards(v28.stats)
			})
		end

		local v28 = {}

		for k, v29 in v26 do
			local v30 = {
				dateText = formatDateRange(dateRange, v29.startMs, v29.endMs) or "",
				adViews = 0,
				adClicks = 0,
				gamePlays = 0,
				labels = 0
			}
			local v31 = if not v11.adViews then v29.stats.adViews else nil
			v30.adViews = v31
			local v32 = if not v11.adClicks then v29.stats.adClicks else nil
			v30.adClicks = v32
			local v33 = if not v11.plays then v29.stats.plays else nil
			v30.gamePlays = v33
			v30.labels = {
				adViews = adViews,
				adClicks = adClicks,
				gamePlays = gamePlays
			}
			table.insert(v28, v30)
		end

		return { activeCampaigns = v27, pastCampaigns = v28 }
	end, v19)

	local v21 = #v20.activeCampaigns > 0 or #v20.pastCampaigns > 0

	local v22 = v7 == "Failed" or flag and v10 == "Failed"
	local v23 = not v21

	if v23 then
		v23 = not (p2 == nil) and v13 == "NotReady"
	end

	local v24 = not v22

	if v24 then
		v24 = v7 == "NotReady" or (if flag then v10 == "NotReady" or v23 else v23)
	end

	local offer = if v12 ~= nil then v12.offer else nil

	local v26 = if FFlagEnablePaidAds then adCampaignEligibilityUtils.getSelectableOffers(v12) else nil

	local durationDays = if offer ~= nil then offer.durationDays else nil
	local v27

	if not (state2 == nil or durationDays == nil) then
		v27 = state2 + math.max(0, durationDays - 1) * MS_PER_DAY
	end

	local freeCredit = adCampaignEligibilityUtils.hasFreeCredit(v12)

	local v28 = adCampaignEligibilityUtils.isEligibleForFreePromotion(v12) and freeCredit

	local canCreateCampaign = adCampaignEligibilityUtils.canCreateCampaign(v12)

	local v29 = if v28 then v18.emptyTitleFree else v18.emptyTitle
	local v30 = if v28 then v18.emptySubtitleFree else v18.emptySubtitle

	local adsManager = v18.adsManager
	local v31

	if FFlagBuildAdsManagerUniverseUrl then
		v31 = useOpenWebViewWithResumeRefresh(getAdsManagerUrl.getAdsManagerUrl(p2), adsManager, v14.refresh)
	else
		v31 = useOpenWebViewWithResumeRefresh(getAdsManagerUrl.getDefaultAdsManagerUrl(), adsManager, v14.refresh)
	end

	local v32 = React.useCallback(function()
		if state4 then
			return
		end

		if not canCreateCampaign then
			v31()

			return
		end

		setState5(false)

		if not FFlagEnablePaidAds then
			v14.clearCreateError()
		end

		setState2(DateTime.now().UnixTimestampMillis)

		if FFlagEnablePaidAds then
			setState3(function(p8)
				if v14.hasCreateError and p8 ~= nil then
					return p8
				end

				return v26
			end)
		end

		setState(true)
	end, {
		state4,
		canCreateCampaign,
		v31,
		v14.clearCreateError,
		v14.hasCreateError,
		v26
	})

	local v33 = React.useCallback(function(p8)
		ref.current = v12
		local createCampaign = v14.createCampaign

		if not FFlagEnablePaidAds then
			p8 = nil
		end

		createCampaign(p8)
	end, { v12, v14.createCampaign })

	local v34 = {
		activeCampaigns = v20.activeCampaigns,
		universeId = if FFlagBuildAdsManagerUniverseUrl then p2 else nil,
		pastCampaignsTitle = pastCampaigns,
		pastCampaigns = v20.pastCampaigns,
		errorText = err,
		isLoading = v24,
		isFailed = v22,
		hasCampaigns = v21,
		emptyTitle = v29,
		emptySubtitle = v30,
		createButtonText = v18.create,
		createButtonIsExternal = not canCreateCampaign,
		isPromotionCreatePending = v14.isCreatePending or state4,
		hasPromotionCreateError = v14.hasCreateError,
		promotionCreateErrorKind = v14.createErrorKind,
		showCreateSuccessToast = state5 and not (v24 or v22),
		createSuccessToastText = v18.createSuccess,
		onDismissCreateSuccessToast = v16,
		isPromotionSheetOpen = state,
		adCampaignDurationDays = durationDays,
		adCampaignEstimatedPriceRobux = 0,
		adCampaignOffers = 0,
		adCampaignRunStartTimeMs = 0,
		adCampaignRunEndTimeMs = 0,
		onCreatePrimary = 0,
		onClosePromotionSheet = 0,
		onCreateCampaign = 0
	}

	local v36 = if offer ~= nil then offer.displayAmountRobux else nil
	v34.adCampaignEstimatedPriceRobux = v36
	v34.adCampaignOffers = state3
	v34.adCampaignRunStartTimeMs = state2
	v34.adCampaignRunEndTimeMs = v27
	v34.onCreatePrimary = v32
	v34.onClosePromotionSheet = v15
	v34.onCreateCampaign = v33
	return v34
end

return useAdsStatsPageViewModel
