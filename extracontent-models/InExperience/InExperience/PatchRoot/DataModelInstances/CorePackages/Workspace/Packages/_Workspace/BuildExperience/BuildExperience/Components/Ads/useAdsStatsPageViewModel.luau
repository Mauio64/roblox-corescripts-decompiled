local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local useGetAdCampaigns = require(script.Parent.useGetAdCampaigns)
local useGetCampaignStats = require(script.Parent.useGetCampaignStats)
local useGetAdCampaignEligibility = require(script.Parent.useGetAdCampaignEligibility)
local useCreateAdCampaign = require(script.Parent.useCreateAdCampaign)
local adCampaignEligibilityUtils = require(script.Parent.adCampaignEligibilityUtils)
local adCampaignScheduleUtils = require(script.Parent.adCampaignScheduleUtils)
local getAdsManagerUrl = require(script.Parent.getAdsManagerUrl)
local useOpenWebViewWithResumeRefresh = require(BuildExperience.utils.useOpenWebViewWithResumeRefresh)
local CampaignStats = require(parent.DataHydration.CampaignStats)
require(script.Parent.AdsStatsView)
require(script.Parent.PastCampaignRow)
require(BuildExperience.Components.Analytics.StatsCard.StatsCard)
local AnalyticsUnit = require(BuildExperience.Analytics.AnalyticsUnit)
local StatsCardValueFormat = require(BuildExperience.Components.Analytics.StatsCard.StatsCardValueFormat)
local Foundation = require(parent.Foundation)
require(parent.DataHydration.CreatorAgentChat)
local FFlagEnablePaidAds = require(BuildExperience.Flags.FFlagEnablePaidAds)
local FFlagBuildAdsManagerUniverseUrl = require(BuildExperience.Flags.FFlagBuildAdsManagerUniverseUrl)

local IconName = Foundation.Enums.IconName
local IconPosition = Foundation.Enums.IconPosition

local MS_PER_DAY = adCampaignScheduleUtils.MS_PER_DAY
local toStartMs = adCampaignScheduleUtils.toStartMs
local campaignEndMs = adCampaignScheduleUtils.campaignEndMs
local campaignEndExclusiveMs = adCampaignScheduleUtils.campaignEndExclusiveMs

local WINDOW_DAYS = CampaignStats.WINDOW_DAYS
local v = { plays = 0, adClicks = 0, adViews = 0, playtimeSeconds = 0 }

local function toPlaytimeMinutes(playtimeSeconds: number) -- 1 equivalent call inferred from this helper
	return playtimeSeconds / 60
end

local function formatDateRange(dateRange: string, startMs: number?, endMs: number?)
	if startMs == nil or endMs == nil or startMs <= 0 then
		return nil
	end

	local v2 = {
		startDate = LocalizationStrings.formatCampaignDate(startMs),
		endDate = LocalizationStrings.formatCampaignDate(endMs)
	}

	return (string.gsub(dateRange, "{(%w+)}", function(p: string)
		return v2[p] or "{" .. p .. "}"
	end))
end

local function scalarCard(title: string, statValue: number, statIcon, hasData: boolean) -- 3 equivalent calls inferred from this helper
	return {
		title = title,
		statValue = statValue,
		statUnit = AnalyticsUnit.Scalar,
		statValueFormat = StatsCardValueFormat.Regular,
		statIcon = statIcon,
		statIconPosition = IconPosition.Left,
		deltaValue = 0,
		deltaUnit = AnalyticsUnit.Percent,
		hasData = hasData
	}
end

local function useAdsStatsPageViewModel(p: number?, p2, p3, p4: number?, p5, p6)
	local v2, v3 = useGetAdCampaigns(p2)

	local flag = false

	if v2 ~= nil and p ~= nil then
		local v4 = tostring(p)

		for _, v5 in v2 do
			if v5.targetUniverseId == v4 then
				flag = true
				break
			end
		end
	end

	local v4

	if flag then
		v4 = p
	end

	local v5, v6, v7 = useGetCampaignStats(v4, p3)
	local current2, v8 = useGetAdCampaignEligibility(p, p5)
	local v9 = useCreateAdCampaign(p, nil, p6)
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

	local onClosePromotionSheet = React.useCallback(function()
		setState(false)

		if FFlagEnablePaidAds then
			v9.clearCreateError()
		end
	end, { v9.clearCreateError })

	local state5, setState5 = React.useState(false)
	local onDismissCreateSuccessToast = React.useCallback(function()
		setState5(false)
	end, {})

	local ref2 = React.useRef(false)
	React.useEffect(function()
		local current = ref2.current
		ref2.current = v9.isCreatePending

		if current and not (v9.isCreatePending or v9.hasCreateError) then
			setState(false)
			setState5(true)
			setState4(ref.current ~= nil)
		end
	end, { v9.isCreatePending, v9.hasCreateError })

	React.useEffect(function()
		local v10

		if v8 == "Ready" and current2 ~= nil then
			v10 = current2 ~= ref.current
		else
			v10 = false
		end

		if state4 and (v10 or v8 == "Failed") then
			ref.current = nil
			setState4(false)
		end
	end, { state4, v8, current2 })

	React.useEffect(function()
		ref.current = nil
		setState4(false)

		if FFlagEnablePaidAds then
			setState3(nil)
		end
	end, { p })

	local v10 = React.useMemo(function()
		if p4 == nil then
			return DateTime.now().UnixTimestampMillis
		end

		return p4
	end, { p4 })

	local v11 = useLocalization({
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

	local gamePlays = v11.gamePlays
	local adClicks = v11.adClicks
	local adViews = v11.adViews
	local playTime = v11.playTime
	local pastCampaigns = v11.pastCampaigns
	local err = v11.error

	local dateRange = v11.dateRange

	local v12 = {
		p,
		v2,
		v5,
		v7,
		v10,
		gamePlays,
		adClicks,
		adViews,
		playTime,
		dateRange,
		v11[Localization.RobloxLocaleIdKey]
	}
	local v13 = React.useMemo(function()
		local v13 = v5 or {}
		local v14 = v10 - WINDOW_DAYS * MS_PER_DAY
		local v15

		if p ~= nil then
			v15 = tostring(p)
		end

		local v16 = {}
		local v17 = {}

		for _, v18 in v2 or {} do
			if not (v15 ~= nil and v18.targetUniverseId == v15) then
				continue
			end

			local stats = v13[v18.id] or v
			local startMs = toStartMs(v18.schedule.startTime)
			local endMs = campaignEndMs(startMs, v18.schedule.durationInDays)

			local v19 = v18.status == "CANCELLED"
			local v20 = campaignEndExclusiveMs(startMs, v18.schedule.durationInDays)

			if not v19 and v10 < v20 then
				table.insert(v16, { id = v18.id, stats = stats, startMs = startMs, endMs = endMs })
			elseif v14 <= startMs then
				table.insert(v17, { stats = stats, startMs = startMs, endMs = endMs })
			end
		end

		table.sort(v16, function(a, b): boolean
			if a.startMs == b.startMs then
				return a.id < b.id
			end

			return a.startMs > b.startMs
		end)

		table.sort(v17, function(a, b): boolean
			return a.endMs > b.endMs
		end)

		local function buildSummaryCards(stats)
			local v18 = scalarCard(gamePlays, stats.plays, IconName.CirclePlay, not v7.plays) -- inferred equivalent call

			local v19 = scalarCard(adClicks, stats.adClicks, IconName.Crosshairs, not v7.adClicks) -- inferred equivalent call
			return {
				v18,
				v19,
				scalarCard(adViews, stats.adViews, IconName.Eye, not v7.adViews), -- inferred equivalent call
				{
					title = playTime,
					statValue = toPlaytimeMinutes(stats.playtimeSeconds), -- inferred equivalent call
					statUnit = AnalyticsUnit.Temporal,
					statIcon = IconName.Clock,
					statIconPosition = IconPosition.Left,
					deltaValue = 0,
					deltaUnit = AnalyticsUnit.Percent,
					hasData = not v7.playtimeSeconds
				}
			}
		end

		local activeCampaigns = {}

		for _, v18 in v16 do
			table.insert(activeCampaigns, {
				id = v18.id,
				dateText = formatDateRange(dateRange, v18.startMs, v18.endMs) or "",
				summaryCards = buildSummaryCards(v18.stats)
			})
		end

		local pastCampaigns2 = {}

		for _, v18 in v17 do
			local v19 = {
				dateText = formatDateRange(dateRange, v18.startMs, v18.endMs) or "",
				adViews = 0,
				adClicks = 0,
				gamePlays = 0,
				labels = 0
			}
			local adViews2

			if not v7.adViews then
				adViews2 = v18.stats.adViews
			end

			v19.adViews = adViews2
			local adClicks2

			if not v7.adClicks then
				adClicks2 = v18.stats.adClicks
			end

			v19.adClicks = adClicks2
			local gamePlays2

			if not v7.plays then
				gamePlays2 = v18.stats.plays
			end

			v19.gamePlays = gamePlays2
			v19.labels = { adViews = adViews, adClicks = adClicks, gamePlays = gamePlays }
			table.insert(pastCampaigns2, v19)
		end

		return { activeCampaigns = activeCampaigns, pastCampaigns = pastCampaigns2 }
	end, v12)

	local hasCampaigns = #v13.activeCampaigns > 0 or #v13.pastCampaigns > 0

	local isFailed = v3 == "Failed" or flag and v6 == "Failed"
	local v14 = not hasCampaigns

	if v14 then
		if p == nil then
			v14 = false
		else
			v14 = v8 == "NotReady"
		end
	end

	local isLoading = not isFailed

	if isLoading then
		if v3 == "NotReady" then
			isLoading = true
		elseif flag then
			isLoading = v6 == "NotReady" or v14
		else
			isLoading = v14
		end
	end

	local offer

	if current2 ~= nil then
		offer = current2.offer
	end

	local v15

	if FFlagEnablePaidAds then
		v15 = adCampaignEligibilityUtils.getSelectableOffers(current2)
	else
		v15 = nil
	end

	local durationDays

	if offer ~= nil then
		durationDays = offer.durationDays
	end

	local adCampaignRunEndTimeMs

	if not (state2 == nil or durationDays == nil) then
		adCampaignRunEndTimeMs = state2 + math.max(0, durationDays - 1) * MS_PER_DAY
	end

	local freeCredit = adCampaignEligibilityUtils.hasFreeCredit(current2)

	local v16 = adCampaignEligibilityUtils.isEligibleForFreePromotion(current2) and freeCredit

	local canCreateCampaign = adCampaignEligibilityUtils.canCreateCampaign(current2)
	local emptyTitle

	if v16 then
		emptyTitle = v11.emptyTitleFree
	else
		emptyTitle = v11.emptyTitle
	end

	local emptySubtitle

	if v16 then
		emptySubtitle = v11.emptySubtitleFree
	else
		emptySubtitle = v11.emptySubtitle
	end

	local adsManager = v11.adsManager
	local v17

	if FFlagBuildAdsManagerUniverseUrl then
		v17 = useOpenWebViewWithResumeRefresh(getAdsManagerUrl.getAdsManagerUrl(p), adsManager, v9.refresh)
	else
		v17 = useOpenWebViewWithResumeRefresh(getAdsManagerUrl.getDefaultAdsManagerUrl(), adsManager, v9.refresh)
	end

	local onCreatePrimary = React.useCallback(function()
		if state4 then
			return
		end

		if not canCreateCampaign then
			v17()

			return
		end

		setState5(false)

		if not FFlagEnablePaidAds then
			v9.clearCreateError()
		end

		setState2(DateTime.now().UnixTimestampMillis)

		if FFlagEnablePaidAds then
			setState3(function(p7)
				if v9.hasCreateError and p7 ~= nil then
					return p7
				end

				return v15
			end)
		end

		setState(true)
	end, { state4, canCreateCampaign, v17, v9.clearCreateError, v9.hasCreateError, v15 })

	local onCreateCampaign = React.useCallback(function(p7)
		ref.current = current2
		local createCampaign = v9.createCampaign

		if not FFlagEnablePaidAds then
			p7 = nil
		end

		createCampaign(p7)
	end, { current2, v9.createCampaign })

	local v18 = {
		activeCampaigns = v13.activeCampaigns,
		universeId = 0,
		pastCampaignsTitle = 0,
		pastCampaigns = 0,
		errorText = 0,
		isLoading = 0,
		isFailed = 0,
		hasCampaigns = 0,
		emptyTitle = 0,
		emptySubtitle = 0,
		createButtonText = 0,
		createButtonIsExternal = 0,
		isPromotionCreatePending = 0,
		hasPromotionCreateError = 0,
		promotionCreateErrorKind = 0,
		showCreateSuccessToast = 0,
		createSuccessToastText = 0,
		onDismissCreateSuccessToast = 0,
		isPromotionSheetOpen = 0,
		adCampaignDurationDays = 0,
		adCampaignEstimatedPriceRobux = 0,
		adCampaignOffers = 0,
		adCampaignRunStartTimeMs = 0,
		adCampaignRunEndTimeMs = 0,
		onCreatePrimary = 0,
		onClosePromotionSheet = 0,
		onCreateCampaign = 0
	}
	local universeId

	if FFlagBuildAdsManagerUniverseUrl then
		universeId = p
	end

	v18.universeId = universeId
	v18.pastCampaignsTitle = pastCampaigns
	v18.pastCampaigns = v13.pastCampaigns
	v18.errorText = err
	v18.isLoading = isLoading
	v18.isFailed = isFailed
	v18.hasCampaigns = hasCampaigns
	v18.emptyTitle = emptyTitle
	v18.emptySubtitle = emptySubtitle
	v18.createButtonText = v11.create

	v18.createButtonIsExternal = not canCreateCampaign
	v18.isPromotionCreatePending = v9.isCreatePending or state4
	v18.hasPromotionCreateError = v9.hasCreateError
	v18.promotionCreateErrorKind = v9.createErrorKind
	v18.showCreateSuccessToast = state5 and not (isLoading or isFailed)
	v18.createSuccessToastText = v11.createSuccess
	v18.onDismissCreateSuccessToast = onDismissCreateSuccessToast
	v18.isPromotionSheetOpen = state
	v18.adCampaignDurationDays = durationDays
	local adCampaignEstimatedPriceRobux

	if offer ~= nil then
		adCampaignEstimatedPriceRobux = offer.displayAmountRobux
	end

	v18.adCampaignEstimatedPriceRobux = adCampaignEstimatedPriceRobux
	v18.adCampaignOffers = state3
	v18.adCampaignRunStartTimeMs = state2
	v18.adCampaignRunEndTimeMs = adCampaignRunEndTimeMs
	v18.onCreatePrimary = onCreatePrimary
	v18.onClosePromotionSheet = onClosePromotionSheet
	v18.onCreateCampaign = onCreateCampaign
	return v18
end

return useAdsStatsPageViewModel
