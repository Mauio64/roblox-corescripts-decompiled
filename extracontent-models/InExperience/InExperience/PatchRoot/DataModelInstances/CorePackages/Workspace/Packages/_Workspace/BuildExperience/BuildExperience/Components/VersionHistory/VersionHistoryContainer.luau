local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local DataHydration = require(parent.DataHydration)
local Localization = require(parent.Localization)
local PlaceVersionHistory = require(parent.DataHydration.PlaceVersionHistory)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Time = require(parent.Time)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local GetAgentRollbackRequestStore = require(BuildExperience.Stores.GetAgentRollbackRequestStore)
local GetPlaytestLoadingStore = require(parent.BuildExperiencePlaytestLaunch.GetPlaytestLoadingStore)
local AgentRollbackSnackbar = require(script.Parent.AgentRollbackSnackbar)
local useLatestVersionCardViewModel = require(script.Parent.LatestVersionCard.useLatestVersionCardViewModel)
local useLiveVersionCardViewModel = require(script.Parent.LiveVersionCard.useLiveVersionCardViewModel)
local useNextHistoryPage = require(script.Parent.useNextHistoryPage)
local VersionHistoryBottomSheet = require(script.Parent.VersionHistoryBottomSheet)
local VersionHistoryUtils = require(script.Parent.VersionHistoryUtils)
local useScrollToTopAfterRestore = require(script.Parent.useScrollToTopAfterRestore)
local useGamePermissions = require(BuildExperience.useGamePermissions)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)

local DataStatus = DataHydration.DataStatus
local DateHelper = Time.DateHelper
local useLocalization = Localization.Hooks.useLocalization

local function formatLocalizedVersionNumber(p: number, object) -- 2 equivalent calls inferred from this helper
	local v

	if p < 10 then
		v = LocalizationStrings.VERSION_HISTORY_VERSION_PADDED
	else
		v = LocalizationStrings.VERSION_HISTORY_VERSION_COMPACT
	end

	return object:Format(v, { VERSION_NUMBER = p })
end

local function formatLocalizedCreatedDate(createdTime: string?, p, object)
	local createdDateParts, day, year = VersionHistoryUtils.getCreatedDateParts(createdTime)
	assert(p[createdDateParts] ~= nil, `No localized month found for month {createdDateParts}`)

	return object:Format(LocalizationStrings.VERSION_HISTORY_CREATED_DATE, {
		MONTH = p[createdDateParts],
		DAY = day,
		YEAR = year
	})
end

local function formatLocalizedBadge(data, badgeKind: string?, object)
	if badgeKind == "published" then
		return object:Format(LocalizationStrings.VERSION_HISTORY_PUBLISHED)
	elseif badgeKind == "previouslyPublished" then
		return object:Format(LocalizationStrings.VERSION_HISTORY_PREVIOUSLY_PUBLISHED)
	end

	if badgeKind == "restored" and data.parentAssetVersionId ~= nil then
		return object:Format(LocalizationStrings.VERSION_HISTORY_RESTORED_BADGE, {
			VERSION = formatLocalizedVersionNumber(data.parentAssetVersionId, object) -- inferred equivalent call
		})
	elseif badgeKind == "autosaved" then
		return object:Format(LocalizationStrings.VERSION_HISTORY_AUTOSAVED)
	else
		return nil
	end
end

local function mapLocalizedVersionToEntry(placeVersion, p, description: string, object)
	local versionNumber = VersionHistoryUtils.getVersionNumber(placeVersion)
	local title

	if placeVersion.title == nil or placeVersion.title == "" then
		title = object:Format(LocalizationStrings.VERSION_HISTORY_VERSION_TITLE, {
			VERSION = versionNumber
		})
	else
		title = placeVersion.title
	end

	if placeVersion.description ~= nil and placeVersion.description ~= "" then
		description = placeVersion.description
	end

	local v = formatLocalizedCreatedDate(placeVersion.createdTime, p, object)
	local badgeKind = VersionHistoryUtils.getBadgeKind(placeVersion)

	return {
		id = tostring(versionNumber),
		versionNumber = versionNumber,
		versionLabel = object:Format(LocalizationStrings.VERSION_HISTORY_VERSION_LABEL, {
			VERSION = formatLocalizedVersionNumber(versionNumber, object), -- inferred equivalent call
			CREATED_DATE = v
		}),
		title = title,
		description = description,
		noteTitle = placeVersion.title,
		noteDescription = placeVersion.description,
		badgeText = formatLocalizedBadge(placeVersion, badgeKind, object),
		isAutosaved = badgeKind == "autosaved"
	}
end

local function mapLocalizedHistoryToEntries(p, p2, fallbackDescription: string, p3)
	if p == nil or p.placeVersions == nil then
		return {}
	end

	local result = {}

	for _, placeVersion in p.placeVersions do
		table.insert(result, mapLocalizedVersionToEntry(placeVersion, p2, fallbackDescription, p3))
	end

	return result
end

local function getStatusText(p: string, list) -- 1 equivalent call inferred from this helper
	if p == DataStatus.NotReady then
		return LocalizationStrings.VERSION_HISTORY_LOADING
	end

	if p == DataStatus.Failed then
		return LocalizationStrings.VERSION_HISTORY_LOAD_FAILED
	end

	if #list == 0 then
		return LocalizationStrings.VERSION_HISTORY_EMPTY
	end

	return nil
end

local function localizeStatusText(p: string?, loading: string, loadFailed: string, empty: string) -- 1 equivalent call inferred from this helper
	if p == LocalizationStrings.VERSION_HISTORY_LOADING then
		return loading
	end

	if p == LocalizationStrings.VERSION_HISTORY_LOAD_FAILED then
		return loadFailed
	end

	if p == LocalizationStrings.VERSION_HISTORY_EMPTY then
		return empty
	end

	return p
end

local function useAgentRollbackRestore(props, restoreFailed: string, flag: boolean)
	local state, setState = React.useState(nil)
	local ref = React.useRef(false)
	local agentRollbackRequestStore = GetAgentRollbackRequestStore(false)
	local isPendingForPlaceId = agentRollbackRequestStore.getIsPendingForPlaceId(props.placeId)
	local isPending = SignalsReact.useSignalState(isPendingForPlaceId)

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
		isPending = isPending,
		onRestore = React.useCallback(function(data)
			if isPendingForPlaceId(false) or flag then
				return
			end

			setState(nil)
			local request = agentRollbackRequestStore.request(
				{ universeId = props.universeId, placeId = props.placeId },
				{
					versionNumber = data.versionNumber,
					noteTitle = data.noteTitle,
					noteDescription = data.noteDescription
				}
			)

			request:catch(function()
				if ref.current then
					setState(restoreFailed)
				end
			end)
			return request
		end, {
			flag,
			isPendingForPlaceId,
			agentRollbackRequestStore,
			props.universeId,
			props.placeId,
			restoreFailed
		})
	}
end

local function VersionHistoryContainer(props)
	local v = useLocalization(DateHelper.MonthsLocalizationKeys)
	local v2 = useLocalization({
		empty = LocalizationStrings.VERSION_HISTORY_EMPTY,
		fallbackDescription = LocalizationStrings.VERSION_HISTORY_FALLBACK_DESCRIPTION,
		loadFailed = LocalizationStrings.VERSION_HISTORY_LOAD_FAILED,
		loading = LocalizationStrings.VERSION_HISTORY_LOADING,
		restoreFailed = LocalizationStrings.VERSION_HISTORY_RESTORE_FAILED
	})

	local v3 = React.useContext(Localization.LocalizationRoactContext)
	local restoreFailed = v2.restoreFailed
	local fallbackDescription = v2.fallbackDescription
	local v4 = React.useMemo(function()
		return props.store or PlaceVersionHistory.getPlaceVersionHistoryStore()
	end, { props.store })
	local v5 = React.useMemo(function()
		return v4.fetchHistory(props.placeId)
	end, { v4, props.placeId })
	local v6 = SignalsReact.useSignalState(v5.data)
	local v7 = SignalsReact.useSignalState(v5.status)
	local onEndReached = useNextHistoryPage(v4, props.placeId, v6)
	local v8 = useScrollToTopAfterRestore()
	local v9 = React.useCallback(function(p): boolean
		return GetPlaytestLoadingStore(p).getAgentStatusForPlaceId(props.placeId)(p) == "Loading"
	end, { props.placeId })
	local v10 = SignalsReact.useSignalState(v9)
	local v11 = { placeId = props.placeId, universeId = props.universeId, testId = 0 }
	local testId

	if props.testId then
		testId = `{props.testId}-live-version-card`
	end

	v11.testId = testId
	local liveVersion = useLiveVersionCardViewModel(v11)

	local v12 = useAgentRollbackRestore(props, restoreFailed, v10)

	local entries = React.useMemo(function()
		return mapLocalizedHistoryToEntries(v6, v, fallbackDescription, v3)
	end, { v6, v, fallbackDescription, v3, v2[Localization.RobloxLocaleIdKey] })
	local permissions

	if FFlagBuildCheckGamePermissions then
		permissions = useGamePermissions({ universeId = props.universeId })
	end

	local v13 = not FFlagBuildCheckGamePermissions or permissions.canEditOnBuild
	local v14 = {
		entry = entries[1],
		placeId = props.placeId,
		universeId = props.universeId,
		onClose = props.onClose,
		permissions = permissions,
		layoutOrder = 0,
		testId = 0
	}
	local testId2

	if props.testId then
		testId2 = `{props.testId}-latest-version-card`
	end

	v14.testId = testId2
	local latestVersion = useLatestVersionCardViewModel(v14)

	local statusText = localizeStatusText(getStatusText(v7, entries), v2.loading, v2.loadFailed, v2.empty) -- inferred equivalent call

	local createElement = React.createElement
	local fragment = React.Fragment
	local v15 = {
		BottomSheet = React.createElement(VersionHistoryBottomSheet, {
			isOpen = props.isOpen,
			entries = entries,
			statusText = statusText,
			isRestoreDisabled = v12.isPending or v10 or not v13,
			onClose = props.onClose,
			onRestore = v12.onRestore,
			onRestoreStarted = props.onAgentRollbackStarted,
			scrollingFrameRef = v8.scrollingFrameRef,
			onEndReached = onEndReached,
			testId = props.testId,
			liveVersion = liveVersion,
			latestVersion = latestVersion
		}),
		RestoreErrorSnackbar = 0
	}
	local restoreErrorSnackbar

	if v12.errorText ~= nil then
		restoreErrorSnackbar = React.createElement(AgentRollbackSnackbar, {
			title = v12.errorText,
			onClose = v12.clearError
		})
	end

	v15.RestoreErrorSnackbar = restoreErrorSnackbar
	return createElement(fragment, nil, v15)
end

return VersionHistoryContainer
