local GameGetGameInfoStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/GameGetGameInfoStore")
local GameGetVotesStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/GameGetVotesStore")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local PlaceVersionHistory = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/PlaceVersionHistory")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local Time = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Time")

local FFlagBuildEventsUpdate1 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildEventsUpdate1")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local launchExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/launchExperience")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local VersionHistoryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/VersionHistoryUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/LiveVersionCard/LiveVersionCardView")

local dateHelper = Time.DateHelper
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization
local useLocalization = Localization.Hooks.useLocalization

local function useLiveVersionCardViewModel(data)
	local placeVersionHistoryStore = PlaceVersionHistory.getPlaceVersionHistoryStore()
	local v5 = React.useMemo(function()
		return placeVersionHistoryStore.getLiveVersion(data.placeId)
	end, { data.placeId, placeVersionHistoryStore })
	local v6 = SignalsReact.useSignalState(v5.data)

	React.useEffect(function()
		placeVersionHistoryStore.fetchLiveVersion(data.placeId)
	end, { data.placeId, placeVersionHistoryStore })
	local universeId

	if data.universeId == nil or data.universeId == 0 then
		universeId = nil
	else
		universeId = tostring(data.universeId)
	end

	local function getGameInfo(p2)
		local v7 = GameGetGameInfoStore(p2)

		if universeId == nil then
			return nil
		end

		return (v7.getAndFetchGameInfo(universeId).data(p2))
	end

	local v7 = SignalsReact.useSignalState(getGameInfo)
	local function getIsGameInfoLoading(p2)
		local v8 = GameGetGameInfoStore(p2)
		local isGameInfoLoading = not (universeId == nil)
			and v8.getAndFetchGameInfo(universeId).status(p2) == "NotReady"
		return isGameInfoLoading
	end

	local v8 = SignalsReact.useSignalState(getIsGameInfoLoading)

	local function getVotes(p2)
		local v9 = GameGetVotesStore(p2)

		if universeId == nil then
			return nil
		end

		return (v9.getAndFetchVote(universeId).data(p2))
	end

	local v9 = SignalsReact.useSignalState(getVotes)
	local function getAreVotesLoading(p2)
		local v10 = GameGetVotesStore(p2)
		local areVotesLoading = not (universeId == nil)
			and v10.getAndFetchVote(universeId).status(p2) == "NotReady"
		return areVotesLoading
	end

	local v10 = SignalsReact.useSignalState(getAreVotesLoading)

	local placeVersion = if v6 then v6.placeVersion else nil
	local v11 = not placeVersion and 0 or VersionHistoryUtils.getVersionNumber(placeVersion)
	local v12, v13, v14

	if placeVersion then
		v12, v13, v14 = VersionHistoryUtils.getCreatedDateParts(placeVersion.createdTime)
	else
		v12 = 1
		v13 = 0
		v14 = ""
	end

	local v15 = useLocalization(dateHelper.MonthsLocalizationKeys)
	local v20 = useLocalization({
		createdDate = {
			LocalizationStrings.LIVE_VERSION_CARD_CREATED_DATE,
			MONTH = v15[v12],
			DAY = v13,
			YEAR = v14
		},
		fallbackDescription = LocalizationStrings.LIVE_VERSION_CARD_FALLBACK_DESCRIPTION,
		play = LocalizationStrings.LIVE_VERSION_CARD_PLAY,
		versionNumber = {
			if v11 < 10 then LocalizationStrings.LIVE_VERSION_CARD_VERSION_PADDED else LocalizationStrings.LIVE_VERSION_CARD_VERSION_COMPACT,
			VERSION_NUMBER = v11
		},
		versionTitle = {
			LocalizationStrings.LIVE_VERSION_CARD_VERSION_TITLE,
			VERSION = v11
		}
	})

	local v21 = useLocalization({
		versionLabel = {
			LocalizationStrings.VERSION_HISTORY_VERSION_LABEL,
			VERSION = v20.versionNumber,
			CREATED_DATE = v20.createdDate
		}
	})

	local v23 = if v9 then v9.upVotes else nil
	local v24 = useAbbreviatedNumberLocalization(v23)
	local v26 = if v7 then v7.totalVisits else nil
	local v27 = useAbbreviatedNumberLocalization(v26)

	local v28 = React.useCallback(function()
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

	local v29 = {
		versionLabel = v21.versionLabel,
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
	local v30 = if placeVersion.title == nil or placeVersion.title == "" then v20.versionTitle else placeVersion.title
	v29.title = v30

	local v31 = if placeVersion.description == nil or placeVersion.description == "" then v20.fallbackDescription else placeVersion.description
	v29.description = v31

	v29.totalUpVotes = v24
	v29.totalVisits = v27
	v29.isTotalUpVotesLoading = v10
	v29.isTotalVisitsLoading = v8
	v29.playText = v20.play
	v29.isPlayDisabled = data.isPlayDisabled
	v29.onPlayActivated = v28
	v29.layoutOrder = data.layoutOrder
	v29.testId = data.testId
	return v29
end

return useLiveVersionCardViewModel
