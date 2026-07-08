local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local DataHydration = require(BuildExperienceParent.DataHydration)
local Localization = require(BuildExperienceParent.Localization)
local PlaceVersionHistory = require(BuildExperienceParent.DataHydration.PlaceVersionHistory)
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local Time = require(BuildExperienceParent.Time)
local GetPlaytestLoadingStore = require(BuildExperience.Stores.GetPlaytestLoadingStore)
local rollbackPlaceWithRetry = require(BuildExperience.utils.rollbackPlaceWithRetry)
local VersionHistoryBottomSheet = require(script.Parent.VersionHistoryBottomSheet)
local useScrollToTopAfterRestore = require(script.Parent.useScrollToTopAfterRestore)
local DataStatus = DataHydration.DataStatus
local DateHelper = Time.DateHelper
local useLocalization = Localization.Hooks.useLocalization

local function toNumber(p1) -- line: 39
	if type(p1) == "number" then
		return p1
	end

	if type(p1) == "string" then
		return (tonumber(p1))
	end

	return nil
end
local function getVersionNumber(p2) -- line: 49
	local version = p2.version

	return assert(if type(version) ~= "number" then if type(version) ~= "string" then nil else tonumber(version) else version, `Place version must be numeric: { p2.version }`)
end
local function getRequiredString(s1: string?, s2: string) -- line: 53
	assert(type(s1) == "string" and s1 ~= "", `Place version { s2 } must not be empty`)

	return s1
end
local function formatVersionNumber(n1: number) -- line: 58
	if n1 < 10 then
		return `v0{ n1 }`
	end

	return `v{ n1 }`
end
local function formatCreatedDate(s3: string?, t1: {[any]: any}) -- line: 66
	assert(type(s3) == "string" and s3 ~= "", "Place version createdTime must not be empty")

	local v34, v35, v36 = string.match(s3, "^(%d%d%d%d)%-(%d%d)%-(%d%d)")
	local v37 = if not v35 then nil else tonumber(v35)
	local v38 = if not v36 then nil else tonumber(v36)

	assert(v34 ~= nil and (v37 ~= nil and (v38 ~= nil and t1[v37] ~= nil)), `Place version createdTime must be an ISO date: { s3 }`)

	return `{ t1[v37] } { v38 }, { v34 }`
end
local function getBadgeText(p3) -- line: 79
	if p3.isPublished == true then
		return "Published"
	end

	if p3.parentAssetVersionId ~= nil then
		local parentAssetVersionId = p3.parentAssetVersionId

		return `Restored { (if not (parentAssetVersionId < 10) then `v{ parentAssetVersionId }` else `v0{ parentAssetVersionId }`) }`
	end

	return nil
end
local function mapVersionToEntry(p4, t2: {[any]: any}) -- line: 89
	-- upvalues: formatCreatedDate (copy)
	local version = p4.version
	local v44 = assert(if type(version) ~= "number" then if type(version) ~= "string" then nil else tonumber(version) else version, `Place version must be numeric: { p4.version }`)
	local v45 = if p4.title == nil or p4.title == "" then `Version { v44 }` else p4.title
	local v46 = (p4.description == nil or p4.description == "") and "No description provided." or p4.description
	local t3 = {
		id = tostring(v44),
		versionNumber = v44,
		versionLabel = `{ (if not (v44 < 10) then `v{ v44 }` else `v0{ v44 }`) } · { formatCreatedDate(p4.createdTime, t2) }`,
		title = v45,
		description = v46,
		noteTitle = p4.title,
		noteDescription = p4.description
	}
	local s4

	if p4.isPublished == true then
		s4 = "Published"
	elseif p4.parentAssetVersionId ~= nil then
		local parentAssetVersionId = p4.parentAssetVersionId

		s4 = `Restored { (if not (parentAssetVersionId < 10) then `v{ parentAssetVersionId }` else `v0{ parentAssetVersionId }`) }`
	else
		s4 = nil
	end

	t3.badgeText = s4

	return t3
end
local function mapHistoryToEntries(p5, t4: {[any]: any}) -- line: 111
	-- upvalues: mapVersionToEntry (copy)
	if p5 == nil or p5.placeVersions == nil then
		return {}
	end

	local t5 = {}

	for _, v54 in p5.placeVersions do
		table.insert(t5, (mapVersionToEntry(v54, t4)))
	end

	return t5
end
local function getStatusText(s5: string, t6: {[any]: any}, s6: string?) -- line: 126
	-- upvalues: DataStatus (copy)
	if s6 ~= nil then
		return s6
	end

	if s5 == DataStatus.NotReady then
		return "Loading version history..."
	end

	if s5 == DataStatus.Failed then
		return "Version history couldn't load."
	end

	if #t6 == 0 then
		return "No version history yet."
	end

	return nil
end
local function VersionHistoryContainer(t7: {[any]: any}) -- line: 140
	-- upvalues: useLocalization (copy), DateHelper (copy), React (copy), PlaceVersionHistory (copy), SignalsReact (copy), useScrollToTopAfterRestore (copy), GetPlaytestLoadingStore (copy), mapHistoryToEntries (copy), DataStatus (copy), rollbackPlaceWithRetry (copy), VersionHistoryBottomSheet (copy)
	local v59 = useLocalization(DateHelper.MonthsLocalizationKeys)
	local v60 = React.useMemo(function() -- line: 142
		-- upvalues: t7 (copy), PlaceVersionHistory (copy)
		return t7.store or PlaceVersionHistory.getPlaceVersionHistoryStore()
	end, { t7.store })
	local v61 = React.useMemo(function() -- line: 145
		-- upvalues: v60 (copy), t7 (copy)
		return v60.getAndFetchHistory(t7.placeId)
	end, {
		v60,
		t7.placeId
	})
	local v62 = SignalsReact.useSignalState(v61.data)
	local v63 = SignalsReact.useSignalState(v61.status)
	local v64, v65 = React.useState(false)
	local v66, v67 = React.useState(nil)
	local v68 = useScrollToTopAfterRestore()
	local v69 = React.useCallback(function(p6) -- line: 153
		-- upvalues: GetPlaytestLoadingStore (copy), t7 (copy)
		return GetPlaytestLoadingStore(p6).getAgentStatusForPlaceId(t7.placeId)(p6) == "Loading"
	end, { t7.placeId })
	local v70 = SignalsReact.useSignalState(v69)
	local v71 = React.useMemo(function() -- line: 158
		-- upvalues: mapHistoryToEntries (copy), v62 (copy), v59 (copy)
		return (mapHistoryToEntries(v62, v59))
	end, {
		v62,
		v59
	})
	local v72 = if v66 == nil then if v63 ~= DataStatus.NotReady then if v63 ~= DataStatus.Failed then if #v71 ~= 0 then nil else "No version history yet." else "Version history couldn't load." else "Loading version history..." else v66
	local v73 = React.useCallback(function(p7) -- line: 163
		-- upvalues: v64 (copy), v70 (copy), v65 (copy), v67 (copy), rollbackPlaceWithRetry (copy), t7 (copy), v68 (copy)
		if v64 or v70 then
			return
		end

		v65(true)
		v67(nil)
		rollbackPlaceWithRetry(t7.placeId, p7.versionNumber, {
			debugSource = "version_history restore",
			note = {
				title = p7.noteTitle,
				description = p7.noteDescription
			}
		}):andThen(function() -- line: 177
			-- upvalues: v68 (copy)
			v68.scrollToTopAfterRestore()
		end):catch(function(_) -- line: 180
			-- upvalues: v67 (copy)
			v67("Couldn't restore this version. Try again.")
		end):finally(function() -- line: 183
			-- upvalues: v65 (copy)
			v65(false)
		end)
	end, {
		v64,
		v70,
		v68,
		v60,
		t7.placeId
	})

	return React.createElement(VersionHistoryBottomSheet, {
		isOpen = t7.isOpen,
		entries = v71,
		statusText = v72,
		isRestoreDisabled = v64 or v70,
		onClose = t7.onClose,
		onRestore = v73,
		scrollingFrameRef = v68.scrollingFrameRef,
		testId = t7.testId
	})
end

return VersionHistoryContainer
