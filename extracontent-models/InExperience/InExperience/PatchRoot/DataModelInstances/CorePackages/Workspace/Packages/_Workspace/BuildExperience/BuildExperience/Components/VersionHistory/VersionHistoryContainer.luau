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
local SaveType = PlaceVersionHistory.SaveType
local PublishStatus = PlaceVersionHistory.PublishStatus

local function toNumber(p1) -- line: 41
	if type(p1) == "number" then
		return p1
	end

	if type(p1) == "string" then
		return (tonumber(p1))
	end

	return nil
end
local function getVersionNumber(p2) -- line: 51
	local version = p2.version

	return assert(if type(version) ~= "number" then if type(version) ~= "string" then nil else tonumber(version) else version, `Place version must be numeric: { p2.version }`)
end
local function getRequiredString(s1: string?, s2: string) -- line: 55
	assert(type(s1) == "string" and s1 ~= "", `Place version { s2 } must not be empty`)

	return s1
end
local function formatVersionNumber(n1: number) -- line: 60
	if n1 < 10 then
		return `v0{ n1 }`
	end

	return `v{ n1 }`
end
local function formatCreatedDate(s3: string?, t1: {[any]: any}) -- line: 68
	assert(type(s3) == "string" and s3 ~= "", "Place version createdTime must not be empty")

	local v36, v37, v38 = string.match(s3, "^(%d%d%d%d)%-(%d%d)%-(%d%d)")
	local v39 = if not v37 then nil else tonumber(v37)
	local v40 = if not v38 then nil else tonumber(v38)

	assert(v36 ~= nil and (v39 ~= nil and (v40 ~= nil and t1[v39] ~= nil)), `Place version createdTime must be an ISO date: { s3 }`)

	return `{ t1[v39] } { v40 }, { v36 }`
end
local function getBadgeText(p3) -- line: 81
	-- upvalues: PublishStatus (copy), SaveType (copy)
	if p3.publishStatus == PublishStatus.Live then
		return "Published"
	end

	if p3.publishStatus == PublishStatus.PreviouslyPublished then
		return "Previously Published"
	end

	if p3.parentAssetVersionId ~= nil then
		local parentAssetVersionId = p3.parentAssetVersionId

		return `Restored { (if not (parentAssetVersionId < 10) then `v{ parentAssetVersionId }` else `v0{ parentAssetVersionId }`) }`
	end

	if p3.saveType == SaveType.AutoSave then
		return "Autosave"
	end

	return nil
end
local function mapVersionToEntry(p4, t2: {[any]: any}) -- line: 97
	-- upvalues: formatCreatedDate (copy), PublishStatus (copy), SaveType (copy)
	local version = p4.version
	local v46 = assert(if type(version) ~= "number" then if type(version) ~= "string" then nil else tonumber(version) else version, `Place version must be numeric: { p4.version }`)
	local v47 = if p4.title == nil or p4.title == "" then `Version { v46 }` else p4.title
	local v48 = (p4.description == nil or p4.description == "") and "No description provided." or p4.description
	local t3 = {
		id = tostring(v46),
		versionNumber = v46,
		versionLabel = `{ (if not (v46 < 10) then `v{ v46 }` else `v0{ v46 }`) } · { formatCreatedDate(p4.createdTime, t2) }`,
		title = v47,
		description = v48,
		noteTitle = p4.title,
		noteDescription = p4.description
	}
	local s4

	if p4.publishStatus == PublishStatus.Live then
		s4 = "Published"
	elseif p4.publishStatus == PublishStatus.PreviouslyPublished then
		s4 = "Previously Published"
	elseif p4.parentAssetVersionId ~= nil then
		local parentAssetVersionId = p4.parentAssetVersionId

		s4 = `Restored { (if not (parentAssetVersionId < 10) then `v{ parentAssetVersionId }` else `v0{ parentAssetVersionId }`) }`
	else
		s4 = if p4.saveType ~= SaveType.AutoSave then nil else "Autosave"
	end

	t3.badgeText = s4

	return t3
end
local function mapHistoryToEntries(p5, t4: {[any]: any}) -- line: 119
	-- upvalues: mapVersionToEntry (copy)
	if p5 == nil or p5.placeVersions == nil then
		return {}
	end

	local t5 = {}

	for _, v56 in p5.placeVersions do
		table.insert(t5, (mapVersionToEntry(v56, t4)))
	end

	return t5
end
local function getStatusText(s5: string, t6: {[any]: any}, s6: string?) -- line: 134
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
local function VersionHistoryContainer(t7: {[any]: any}) -- line: 148
	-- upvalues: useLocalization (copy), DateHelper (copy), React (copy), PlaceVersionHistory (copy), SignalsReact (copy), useScrollToTopAfterRestore (copy), GetPlaytestLoadingStore (copy), mapHistoryToEntries (copy), DataStatus (copy), rollbackPlaceWithRetry (copy), VersionHistoryBottomSheet (copy)
	local v61 = useLocalization(DateHelper.MonthsLocalizationKeys)
	local v62 = React.useMemo(function() -- line: 150
		-- upvalues: t7 (copy), PlaceVersionHistory (copy)
		return t7.store or PlaceVersionHistory.getPlaceVersionHistoryStore()
	end, { t7.store })
	local v63 = React.useMemo(function() -- line: 153
		-- upvalues: v62 (copy), t7 (copy)
		return v62.getAndFetchHistory(t7.placeId)
	end, {
		v62,
		t7.placeId
	})
	local v64 = SignalsReact.useSignalState(v63.data)
	local v65 = SignalsReact.useSignalState(v63.status)
	local v66, v67 = React.useState(false)
	local v68, v69 = React.useState(nil)
	local v70 = useScrollToTopAfterRestore()
	local v71 = React.useCallback(function(p6) -- line: 161
		-- upvalues: GetPlaytestLoadingStore (copy), t7 (copy)
		return GetPlaytestLoadingStore(p6).getAgentStatusForPlaceId(t7.placeId)(p6) == "Loading"
	end, { t7.placeId })
	local v72 = SignalsReact.useSignalState(v71)
	local v73 = React.useMemo(function() -- line: 166
		-- upvalues: mapHistoryToEntries (copy), v64 (copy), v61 (copy)
		return (mapHistoryToEntries(v64, v61))
	end, {
		v64,
		v61
	})
	local v74 = if v68 == nil then if v65 ~= DataStatus.NotReady then if v65 ~= DataStatus.Failed then if #v73 ~= 0 then nil else "No version history yet." else "Version history couldn't load." else "Loading version history..." else v68
	local v75 = React.useCallback(function(p7) -- line: 171
		-- upvalues: v66 (copy), v72 (copy), v67 (copy), v69 (copy), rollbackPlaceWithRetry (copy), t7 (copy), v70 (copy)
		if v66 or v72 then
			return
		end

		v67(true)
		v69(nil)
		rollbackPlaceWithRetry(t7.placeId, p7.versionNumber, {
			debugSource = "version_history restore",
			note = {
				title = p7.noteTitle,
				description = p7.noteDescription
			}
		}):andThen(function() -- line: 185
			-- upvalues: v70 (copy)
			v70.scrollToTopAfterRestore()
		end):catch(function(_) -- line: 188
			-- upvalues: v69 (copy)
			v69("Couldn't restore this version. Try again.")
		end):finally(function() -- line: 191
			-- upvalues: v67 (copy)
			v67(false)
		end)
	end, {
		v66,
		v72,
		v70,
		v62,
		t7.placeId
	})

	return React.createElement(VersionHistoryBottomSheet, {
		isOpen = t7.isOpen,
		entries = v73,
		statusText = v74,
		isRestoreDisabled = v66 or v72,
		onClose = t7.onClose,
		onRestore = v75,
		scrollingFrameRef = v70.scrollingFrameRef,
		testId = t7.testId
	})
end

return VersionHistoryContainer
