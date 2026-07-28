local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local DataHydration = require(BuildExperienceParent.DataHydration)
local Localization = require(BuildExperienceParent.Localization)
local PlaceVersionHistory = require(BuildExperienceParent.DataHydration.PlaceVersionHistory)
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local Time = require(BuildExperienceParent.Time)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FFlagisPublishOnBuildRevert = require(BuildExperience.Flags.FFlagisPublishOnBuildRevert)
local GetPlaytestLoadingStore = require(BuildExperience.Stores.GetPlaytestLoadingStore)
local rollbackPlaceWithRetry = require(BuildExperience.utils.rollbackPlaceWithRetry)
local VersionHistoryBottomSheet = require(script.Parent.VersionHistoryBottomSheet)
local VersionHistoryUtils = require(script.Parent.VersionHistoryUtils)
local useScrollToTopAfterRestore = require(script.Parent.useScrollToTopAfterRestore)
local DataStatus = DataHydration.DataStatus
local DateHelper = Time.DateHelper
local useLocalization = Localization.Hooks.useLocalization

local function toNumber(p1) -- line: 36
	if type(p1) == "number" then
		return p1
	end

	if type(p1) == "string" then
		return (tonumber(p1))
	end

	return nil
end
local function getVersionNumber(p2) -- line: 46
	local version = p2.version

	return assert(if type(version) ~= "number" then if type(version) ~= "string" then nil else tonumber(version) else version, `Place version must be numeric: { p2.version }`)
end
local function getRequiredString(s1: string?, s2: string) -- line: 50
	assert(type(s1) == "string" and s1 ~= "", `Place version { s2 } must not be empty`)

	return s1
end
local function formatCreatedDate(s3: string?, t1: {[any]: any}) -- line: 55
	-- upvalues: LocalizationStrings (copy)
	assert(type(s3) == "string" and s3 ~= "", "Place version createdTime must not be empty")

	local v34, v35, v36 = string.match(s3, "^(%d%d%d%d)%-(%d%d)%-(%d%d)")
	local v37 = if not v35 then nil else tonumber(v35)
	local v38 = if not v36 then nil else tonumber(v36)

	assert(v34 ~= nil and (v37 ~= nil and (v38 ~= nil and t1[v37] ~= nil)), `Place version createdTime must be an ISO date: { s3 }`)

	return LocalizationStrings.formatVersionHistoryCreatedDate(t1[v37], v38, v34)
end
local function mapVersionToEntry(p3, t2: {[any]: any}) -- line: 68
	-- upvalues: LocalizationStrings (copy), formatCreatedDate (copy), VersionHistoryUtils (copy)
	local version = p3.version
	local v42 = assert(if type(version) ~= "number" then if type(version) ~= "string" then nil else tonumber(version) else version, `Place version must be numeric: { p3.version }`)
	local v43 = if p3.title == nil or p3.title == "" then LocalizationStrings.formatVersionHistoryVersionTitle(v42) else p3.title
	local v44 = if p3.description == nil or p3.description == "" then LocalizationStrings.VERSION_HISTORY_FALLBACK_DESCRIPTION else p3.description
	local v45 = formatCreatedDate(p3.createdTime, t2)

	return {
		id = tostring(v42),
		versionNumber = v42,
		versionLabel = LocalizationStrings.formatVersionHistoryVersionLabel(v42, v45),
		title = v43,
		description = v44,
		noteTitle = p3.title,
		noteDescription = p3.description,
		badgeText = VersionHistoryUtils.getBadgeText(p3)
	}
end
local function mapHistoryToEntries(p4, t3: {[any]: any}) -- line: 90
	-- upvalues: mapVersionToEntry (copy)
	if p4 == nil or p4.placeVersions == nil then
		return {}
	end

	local t4 = {}

	for _, v50 in p4.placeVersions do
		table.insert(t4, (mapVersionToEntry(v50, t3)))
	end

	return t4
end
local function getStatusText(s4: string, t5: {[any]: any}, s5: string?) -- line: 105
	-- upvalues: DataStatus (copy), LocalizationStrings (copy)
	if s5 ~= nil then
		return s5
	end

	if s4 == DataStatus.NotReady then
		return LocalizationStrings.VERSION_HISTORY_LOADING
	end

	if s4 == DataStatus.Failed then
		return LocalizationStrings.VERSION_HISTORY_LOAD_FAILED
	end

	if #t5 == 0 then
		return LocalizationStrings.VERSION_HISTORY_EMPTY
	end

	return nil
end
local function VersionHistoryContainer(t6: {[any]: any}) -- line: 119
	-- upvalues: useLocalization (copy), DateHelper (copy), React (copy), PlaceVersionHistory (copy), SignalsReact (copy), useScrollToTopAfterRestore (copy), GetPlaytestLoadingStore (copy), mapHistoryToEntries (copy), DataStatus (copy), LocalizationStrings (copy), rollbackPlaceWithRetry (copy), FFlagisPublishOnBuildRevert (copy), VersionHistoryBottomSheet (copy)
	local v55 = useLocalization(DateHelper.MonthsLocalizationKeys)
	local v56 = React.useMemo(function() -- line: 121
		-- upvalues: t6 (copy), PlaceVersionHistory (copy)
		return t6.store or PlaceVersionHistory.getPlaceVersionHistoryStore()
	end, { t6.store })
	local v57 = React.useMemo(function() -- line: 124
		-- upvalues: v56 (copy), t6 (copy)
		return v56.getAndFetchHistory(t6.placeId)
	end, {
		v56,
		t6.placeId
	})
	local v58 = SignalsReact.useSignalState(v57.data)
	local v59 = SignalsReact.useSignalState(v57.status)
	local v60, v61 = React.useState(false)
	local v62, v63 = React.useState(nil)
	local v64 = useScrollToTopAfterRestore()
	local v65 = React.useCallback(function(p5) -- line: 132
		-- upvalues: GetPlaytestLoadingStore (copy), t6 (copy)
		return GetPlaytestLoadingStore(p5).getAgentStatusForPlaceId(t6.placeId)(p5) == "Loading"
	end, { t6.placeId })
	local v66 = SignalsReact.useSignalState(v65)
	local v67 = React.useMemo(function() -- line: 137
		-- upvalues: mapHistoryToEntries (copy), v58 (copy), v55 (copy)
		return (mapHistoryToEntries(v58, v55))
	end, {
		v58,
		v55
	})
	local v68 = if v62 == nil then if v59 ~= DataStatus.NotReady then if v59 ~= DataStatus.Failed then if #v67 ~= 0 then nil else LocalizationStrings.VERSION_HISTORY_EMPTY else LocalizationStrings.VERSION_HISTORY_LOAD_FAILED else LocalizationStrings.VERSION_HISTORY_LOADING else v62
	local v69 = React.useCallback(function(p6) -- line: 142
		-- upvalues: v60 (copy), v66 (copy), v61 (copy), v63 (copy), rollbackPlaceWithRetry (copy), t6 (copy), FFlagisPublishOnBuildRevert (copy), v64 (copy), LocalizationStrings (copy)
		if v60 or v66 then
			return
		end

		v61(true)
		v63(nil)
		rollbackPlaceWithRetry(t6.placeId, p6.versionNumber, {
			debugSource = "version_history restore",
			note = {
				title = p6.noteTitle,
				description = p6.noteDescription
			},
			published = FFlagisPublishOnBuildRevert
		}):andThen(function() -- line: 157
			-- upvalues: v64 (copy)
			v64.scrollToTopAfterRestore()
		end):catch(function(_) -- line: 160
			-- upvalues: v63 (copy), LocalizationStrings (copy)
			v63(LocalizationStrings.VERSION_HISTORY_RESTORE_FAILED)
		end):finally(function() -- line: 163
			-- upvalues: v61 (copy)
			v61(false)
		end)
	end, {
		v60,
		v66,
		v64,
		v56,
		t6.placeId
	})

	return React.createElement(VersionHistoryBottomSheet, {
		isOpen = t6.isOpen,
		entries = v67,
		statusText = v68,
		isRestoreDisabled = v60 or v66,
		onClose = t6.onClose,
		onRestore = v69,
		scrollingFrameRef = v64.scrollingFrameRef,
		testId = t6.testId
	})
end

return VersionHistoryContainer
