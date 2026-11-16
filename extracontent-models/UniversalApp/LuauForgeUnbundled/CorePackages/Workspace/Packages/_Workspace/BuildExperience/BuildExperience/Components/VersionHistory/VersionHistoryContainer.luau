local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local PlaceVersionHistory = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/PlaceVersionHistory")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local Time = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Time")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local GetAgentRollbackRequestStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAgentRollbackRequestStore")
local GetPlaytestLoadingStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/GetPlaytestLoadingStore")
local AgentRollbackSnackbar = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/AgentRollbackSnackbar")
local useLatestVersionCardViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/LatestVersionCard/useLatestVersionCardViewModel")
local useLiveVersionCardViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/LiveVersionCard/useLiveVersionCardViewModel")
local useNextHistoryPage = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/useNextHistoryPage")
local VersionHistoryBottomSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/VersionHistoryBottomSheet")
local VersionHistoryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/VersionHistoryUtils")
local useScrollToTopAfterRestore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/useScrollToTopAfterRestore")
local useGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")

local dataStatus = DataHydration.DataStatus
local dateHelper = Time.DateHelper
local useLocalization = Localization.Hooks.useLocalization

local function formatLocalizedVersionNumber(p2, object)
	local v5 = if p2 < 10 then LocalizationStrings.VERSION_HISTORY_VERSION_PADDED else LocalizationStrings.VERSION_HISTORY_VERSION_COMPACT
	return object:Format(v5, { VERSION_NUMBER = p2 })
end

local function formatLocalizedCreatedDate(createdTime, p2, object)
	local createdDateParts, v5, v6 = VersionHistoryUtils.getCreatedDateParts(createdTime)
	assert(p2[createdDateParts] ~= nil, `No localized month found for month {createdDateParts}`)

	return object:Format(LocalizationStrings.VERSION_HISTORY_CREATED_DATE, {
		MONTH = p2[createdDateParts],
		DAY = v5,
		YEAR = v6
	})
end

local function formatLocalizedBadge(data, badgeKind, object)
	if badgeKind == "published" then
		return object:Format(LocalizationStrings.VERSION_HISTORY_PUBLISHED)
	elseif badgeKind == "previouslyPublished" then
		return object:Format(LocalizationStrings.VERSION_HISTORY_PREVIOUSLY_PUBLISHED)
	end

	if badgeKind == "restored" and data.parentAssetVersionId ~= nil then
		local VERSION_HISTORY_RESTORED_BADGE = LocalizationStrings.VERSION_HISTORY_RESTORED_BADGE
		local parentAssetVersionId = data.parentAssetVersionId
		local v6

		if parentAssetVersionId < 10 then
			v6 = LocalizationStrings.VERSION_HISTORY_VERSION_PADDED
		else
			v6 = LocalizationStrings.VERSION_HISTORY_VERSION_COMPACT
		end

		return object:Format(VERSION_HISTORY_RESTORED_BADGE, {
			VERSION = object:Format(v6, { VERSION_NUMBER = parentAssetVersionId })
		})
	elseif badgeKind == "autosaved" then
		return object:Format(LocalizationStrings.VERSION_HISTORY_AUTOSAVED)
	else
		return nil
	end
end

local function mapLocalizedVersionToEntry(placeVersion, p2, description, object)
	local versionNumber = VersionHistoryUtils.getVersionNumber(placeVersion)
	local v5

	if placeVersion.title == nil or placeVersion.title == "" then
		v5 = object:Format(LocalizationStrings.VERSION_HISTORY_VERSION_TITLE, {
			VERSION = versionNumber
		})
	else
		v5 = placeVersion.title
	end

	if placeVersion.description ~= nil and placeVersion.description ~= "" then
		description = placeVersion.description
	end

	local v6 = formatLocalizedCreatedDate(placeVersion.createdTime, p2, object)
	local badgeKind = VersionHistoryUtils.getBadgeKind(placeVersion)

	local v7 = {
		id = tostring(versionNumber),
		versionNumber = versionNumber,
		versionLabel = 0,
		title = 0,
		description = 0,
		noteTitle = 0,
		noteDescription = 0,
		badgeText = 0,
		isAutosaved = 0
	}

	local VERSION_HISTORY_VERSION_LABEL = LocalizationStrings.VERSION_HISTORY_VERSION_LABEL
	local v9

	if versionNumber < 10 then
		v9 = LocalizationStrings.VERSION_HISTORY_VERSION_PADDED
	else
		v9 = LocalizationStrings.VERSION_HISTORY_VERSION_COMPACT
	end

	v7.versionLabel = object:Format(VERSION_HISTORY_VERSION_LABEL, {
		VERSION = object:Format(v9, { VERSION_NUMBER = versionNumber }),
		CREATED_DATE = v6
	})

	v7.title = v5
	v7.description = description
	v7.noteTitle = placeVersion.title
	v7.noteDescription = placeVersion.description
	v7.badgeText = formatLocalizedBadge(placeVersion, badgeKind, object)
	v7.isAutosaved = badgeKind == "autosaved"
	return v7
end

local function mapLocalizedHistoryToEntries(p2, p3, fallbackDescription, p4)
	if p2 == nil or p2.placeVersions == nil then
		return {}
	end

	local result = {}

	for k, placeVersion in p2.placeVersions do
		table.insert(result, mapLocalizedVersionToEntry(placeVersion, p3, fallbackDescription, p4))
	end

	return result
end

local function getStatusText(p2, list)
	if p2 == dataStatus.NotReady then
		return LocalizationStrings.VERSION_HISTORY_LOADING
	end

	if p2 == dataStatus.Failed then
		return LocalizationStrings.VERSION_HISTORY_LOAD_FAILED
	end

	if #list == 0 then
		return LocalizationStrings.VERSION_HISTORY_EMPTY
	end

	return nil
end

local function localizeStatusText(p2, p3, p4, p5)
	if p2 == LocalizationStrings.VERSION_HISTORY_LOADING then
		return p3
	end

	if p2 == LocalizationStrings.VERSION_HISTORY_LOAD_FAILED then
		return p4
	end

	if p2 == LocalizationStrings.VERSION_HISTORY_EMPTY then
		return p5
	end

	return p2
end

local function useAgentRollbackRestore(props, restoreFailed, p2)
	local state, setState = React.useState(nil)
	local ref = React.useRef(false)
	local v5 = GetAgentRollbackRequestStore(false)
	local isPendingForPlaceId = v5.getIsPendingForPlaceId(props.placeId)
	local v6 = SignalsReact.useSignalState(isPendingForPlaceId)

	React.useEffect(function()
		ref.current = true
		return function()
			ref.current = false
		end
	end, {})

	return {
		clearError = React.useCallback(function()
			setState(nil)
		end, {}),
		errorText = state,
		isPending = v6,
		onRestore = React.useCallback(function(data)
			if isPendingForPlaceId(false) or p2 then
				return
			end

			setState(nil)
			local request = v5.request({
				universeId = props.universeId,
				placeId = props.placeId
			}, {
				versionNumber = data.versionNumber,
				noteTitle = data.noteTitle,
				noteDescription = data.noteDescription
			})

			request:catch(function()
				if ref.current then
					setState(restoreFailed)
				end
			end)
			return request
		end, {
			p2,
			isPendingForPlaceId,
			v5,
			props.universeId,
			props.placeId,
			restoreFailed
		})
	}
end

local function VersionHistoryContainer(props)
	local v5 = useLocalization(dateHelper.MonthsLocalizationKeys)
	local v6 = useLocalization({
		empty = LocalizationStrings.VERSION_HISTORY_EMPTY,
		fallbackDescription = LocalizationStrings.VERSION_HISTORY_FALLBACK_DESCRIPTION,
		loadFailed = LocalizationStrings.VERSION_HISTORY_LOAD_FAILED,
		loading = LocalizationStrings.VERSION_HISTORY_LOADING,
		restoreFailed = LocalizationStrings.VERSION_HISTORY_RESTORE_FAILED
	})

	local v7 = React.useContext(Localization.LocalizationRoactContext)
	local restoreFailed = v6.restoreFailed
	local fallbackDescription = v6.fallbackDescription
	local v8 = React.useMemo(function()
		return props.store or PlaceVersionHistory.getPlaceVersionHistoryStore()
	end, { props.store })
	local v9 = React.useMemo(function()
		return v8.fetchHistory(props.placeId)
	end, { v8, props.placeId })
	local v10 = SignalsReact.useSignalState(v9.data)
	local v11 = SignalsReact.useSignalState(v9.status)
	local v12 = useNextHistoryPage(v8, props.placeId, v10)
	local v13 = useScrollToTopAfterRestore()
	local v14 = React.useCallback(function(p2): boolean
		return GetPlaytestLoadingStore(p2).getAgentStatusForPlaceId(props.placeId)(p2) == "Loading"
	end, { props.placeId })
	local v15 = SignalsReact.useSignalState(v14)
	local v17 = { placeId = props.placeId, universeId = props.universeId, testId = 0 }
	local v18 = if props.testId then `{props.testId}-live-version-card` else nil
	v17.testId = v18
	local v19 = useLiveVersionCardViewModel(v17)

	local v20 = useAgentRollbackRestore(props, restoreFailed, v15)

	local v21 = React.useMemo(function()
		return mapLocalizedHistoryToEntries(v10, v5, fallbackDescription, v7)
	end, { v10, v5, fallbackDescription, v7, v6[Localization.RobloxLocaleIdKey] })
	local v22

	if FFlagBuildCheckGamePermissions then
		v22 = useGamePermissions({ universeId = props.universeId })
	end

	local v23 = not FFlagBuildCheckGamePermissions or v22.canEditOnBuild
	local v25 = {
		entry = v21[1],
		placeId = props.placeId,
		universeId = props.universeId,
		onClose = props.onClose,
		permissions = v22,
		layoutOrder = 0,
		testId = 0
	}

	local v26 = if props.testId then `{props.testId}-latest-version-card` else nil
	v25.testId = v26
	local v27 = useLatestVersionCardViewModel(v25)
	local v28

	if v11 == dataStatus.NotReady then
		v28 = LocalizationStrings.VERSION_HISTORY_LOADING
	elseif v11 == dataStatus.Failed then
		v28 = LocalizationStrings.VERSION_HISTORY_LOAD_FAILED
	elseif #v21 == 0 then
		v28 = LocalizationStrings.VERSION_HISTORY_EMPTY
	end

	local loading = v6.loading
	local loadFailed = v6.loadFailed
	local empty = v6.empty

	if v28 == LocalizationStrings.VERSION_HISTORY_LOADING then
		v28 = loading
	elseif v28 == LocalizationStrings.VERSION_HISTORY_LOAD_FAILED then
		v28 = loadFailed
	elseif v28 == LocalizationStrings.VERSION_HISTORY_EMPTY then
		v28 = empty
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v30 = {
		BottomSheet = React.createElement(VersionHistoryBottomSheet, {
			isOpen = props.isOpen,
			entries = v21,
			statusText = v28,
			isRestoreDisabled = v20.isPending or v15 or not v23,
			onClose = props.onClose,
			onRestore = v20.onRestore,
			onRestoreStarted = props.onAgentRollbackStarted,
			scrollingFrameRef = v13.scrollingFrameRef,
			onEndReached = v12,
			testId = props.testId,
			liveVersion = v19,
			latestVersion = v27
		}),
		RestoreErrorSnackbar = 0
	}

	local v31 = if v20.errorText ~= nil then React.createElement(AgentRollbackSnackbar, {
		title = v20.errorText,
		onClose = v20.clearError
	}) else nil
	v30.RestoreErrorSnackbar = v31
	return createElement(fragment, nil, v30)
end

return VersionHistoryContainer
