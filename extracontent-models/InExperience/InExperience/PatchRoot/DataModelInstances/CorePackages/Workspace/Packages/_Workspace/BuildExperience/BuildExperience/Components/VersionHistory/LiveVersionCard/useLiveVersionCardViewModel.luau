local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local GameGetGameInfoStore = require(parent.DataHydration.GameGetGameInfoStore)
local GameGetVotesStore = require(parent.DataHydration.GameGetVotesStore)
local Localization = require(parent.Localization)
local PlaceVersionHistory = require(parent.DataHydration.PlaceVersionHistory)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Time = require(parent.Time)

local FFlagBuildEventsUpdate1 = require(BuildExperience.Flags.FFlagBuildEventsUpdate1)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local launchExperience = require(parent.BuildExperiencePlaytestLaunch.launchExperience)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local VersionHistoryUtils = require(script.Parent.Parent.VersionHistoryUtils)
require(script.Parent.LiveVersionCardView)

local DateHelper = Time.DateHelper
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization
local useLocalization = Localization.Hooks.useLocalization

local function useLiveVersionCardViewModel(data)
	local placeVersionHistoryStore = PlaceVersionHistory.getPlaceVersionHistoryStore()
	local v = React.useMemo(function()
		return placeVersionHistoryStore.getLiveVersion(data.placeId)
	end, { data.placeId, placeVersionHistoryStore })
	local v2 = SignalsReact.useSignalState(v.data)

	React.useEffect(function()
		placeVersionHistoryStore.fetchLiveVersion(data.placeId)
	end, { data.placeId, placeVersionHistoryStore })
	local universeId

	if data.universeId == nil or data.universeId == 0 then
		universeId = nil
	else
		universeId = tostring(data.universeId)
	end

	local function getGameInfo(p)
		local gameGetGameInfoStore = GameGetGameInfoStore(p)

		if universeId == nil then
			return nil
		end

		return (gameGetGameInfoStore.getAndFetchGameInfo(universeId).data(p))
	end

	local v3 = SignalsReact.useSignalState(getGameInfo)
	local function getIsGameInfoLoading(p)
		local gameGetGameInfoStore = GameGetGameInfoStore(p)
		local isGameInfoLoading

		if universeId == nil then
			isGameInfoLoading = false
		else
			isGameInfoLoading = gameGetGameInfoStore.getAndFetchGameInfo(universeId).status(p) == "NotReady"
		end

		return isGameInfoLoading
	end

	local isTotalVisitsLoading = SignalsReact.useSignalState(getIsGameInfoLoading)

	local function getVotes(p)
		local gameGetVotesStore = GameGetVotesStore(p)

		if universeId == nil then
			return nil
		end

		return (gameGetVotesStore.getAndFetchVote(universeId).data(p))
	end

	local v4 = SignalsReact.useSignalState(getVotes)
	local function getAreVotesLoading(p)
		local gameGetVotesStore = GameGetVotesStore(p)
		local areVotesLoading

		if universeId == nil then
			areVotesLoading = false
		else
			areVotesLoading = gameGetVotesStore.getAndFetchVote(universeId).status(p) == "NotReady"
		end

		return areVotesLoading
	end

	local isTotalUpVotesLoading = SignalsReact.useSignalState(getAreVotesLoading)
	local placeVersion

	if v2 then
		placeVersion = v2.placeVersion
	end

	local version = not placeVersion and 0 or VersionHistoryUtils.getVersionNumber(placeVersion)
	local v5, day, year

	if placeVersion then
		v5, day, year = VersionHistoryUtils.getCreatedDateParts(placeVersion.createdTime)
	else
		v5 = 1
		day = 0
		year = ""
	end

	local v6 = useLocalization(DateHelper.MonthsLocalizationKeys)
	local v7 = {
		createdDate = {
			LocalizationStrings.LIVE_VERSION_CARD_CREATED_DATE,
			MONTH = v6[v5],
			DAY = day,
			YEAR = year
		},
		fallbackDescription = LocalizationStrings.LIVE_VERSION_CARD_FALLBACK_DESCRIPTION,
		play = LocalizationStrings.LIVE_VERSION_CARD_PLAY,
		versionNumber = 0,
		versionTitle = 0
	}
	local v8

	if version < 10 then
		v8 = LocalizationStrings.LIVE_VERSION_CARD_VERSION_PADDED
	else
		v8 = LocalizationStrings.LIVE_VERSION_CARD_VERSION_COMPACT
	end

	v7.versionNumber = {
		v8,
		VERSION_NUMBER = version
	}

	v7.versionTitle = {
		LocalizationStrings.LIVE_VERSION_CARD_VERSION_TITLE,
		VERSION = version
	}
	local v9 = useLocalization(v7)

	local v10 = useLocalization({
		versionLabel = {
			LocalizationStrings.VERSION_HISTORY_VERSION_LABEL,
			VERSION = v9.versionNumber,
			CREATED_DATE = v9.createdDate
		}
	})
	local v11

	if v4 then
		v11 = v4.upVotes
	end

	local totalUpVotes = useAbbreviatedNumberLocalization(v11)
	local v12

	if v3 then
		v12 = v3.totalVisits
	end

	local totalVisits = useAbbreviatedNumberLocalization(v12)

	local onPlayActivated = React.useCallback(function()
		sendBuildExperienceEvent(
			FFlagBuildEventsUpdate1 and "PLAYTEST_CLICK" or "PLAY_CLICK",
			{ universeId = data.universeId, placeId = data.placeId },
			FFlagBuildEventsUpdate1 and { context = "LiveVersionCard" } or nil
		)
		launchExperience(data.placeId, "LiveVersionCard")

		if data.onPlayActivated then
			data.onPlayActivated()
		end
	end, { data.placeId, data.universeId, data.onPlayActivated })

	if placeVersion == nil then
		return nil
	end

	local v13 = {
		versionLabel = v10.versionLabel,
		title = 0,
		description = 0,
		totalUpVotes = 0,
		totalVisits = 0,
		isTotalUpVotesLoading = 0,
		isTotalVisitsLoading = 0,
		playText = 0,
		isPlayDisabled = 0,
		onPlayActivated = 0,
		layoutOrder = 0,
		testId = 0
	}
	local title

	if placeVersion.title == nil or placeVersion.title == "" then
		title = v9.versionTitle
	else
		title = placeVersion.title
	end

	v13.title = title
	local description

	if placeVersion.description == nil or placeVersion.description == "" then
		description = v9.fallbackDescription
	else
		description = placeVersion.description
	end

	v13.description = description

	v13.totalUpVotes = totalUpVotes
	v13.totalVisits = totalVisits
	v13.isTotalUpVotesLoading = isTotalUpVotesLoading
	v13.isTotalVisitsLoading = isTotalVisitsLoading
	v13.playText = v9.play
	v13.isPlayDisabled = data.isPlayDisabled
	v13.onPlayActivated = onPlayActivated
	v13.layoutOrder = data.layoutOrder
	v13.testId = data.testId
	return v13
end

return useLiveVersionCardViewModel
