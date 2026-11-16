local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local DataHydration = require(parent.DataHydration)
local Localization = require(parent.Localization)
local Navigation = require(parent.Navigation)
local PlaceVersionHistory = require(parent.DataHydration.PlaceVersionHistory)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local launchPlaytestWithLoadingState = require(parent.BuildExperiencePlaytestLaunch.launchPlaytestWithLoadingState)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local GetPlaytestLoadingStore = require(parent.BuildExperiencePlaytestLaunch.GetPlaytestLoadingStore)
local VersionHistoryUtils = require(script.Parent.Parent.VersionHistoryUtils)
require(script.Parent.LatestVersionCardView)
require(BuildExperience.useGamePermissions)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)

local DataStatus = DataHydration.DataStatus
local useLocalization = Localization.Hooks.useLocalization
local useNavigation = Navigation.useNavigation

local function useLatestVersionCardViewModel(data)
	local placeVersionHistoryStore = PlaceVersionHistory.getPlaceVersionHistoryStore()
	local v = React.useMemo(function()
		return placeVersionHistoryStore.getLiveVersion(data.placeId)
	end, { data.placeId, placeVersionHistoryStore })
	local v2 = SignalsReact.useSignalState(v.data)
	local v3 = SignalsReact.useSignalState(v.status)

	React.useEffect(function()
		placeVersionHistoryStore.fetchLiveVersion(data.placeId)
	end, { data.placeId, placeVersionHistoryStore })

	local v4 = React.useCallback(function(p)
		return GetPlaytestLoadingStore(p).getIsPlaytestLoadingForPlaceId(data.placeId)(p)
	end, { data.placeId })
	local v5 = SignalsReact.useSignalState(v4)

	local v6 = useLocalization({
		playtest = LocalizationStrings.BUILD_MENU_PLAYTEST,
		publish = LocalizationStrings.BUILD_MENU_PUBLISH
	})

	local v7 = useNavigation()

	local onPlaytestActivated = React.useCallback(function()
		sendBuildExperienceEvent("PLAYTEST_CLICK", {
			universeId = data.universeId,
			placeId = data.placeId
		}, {
			context = "LatestVersionCard"
		})
		launchPlaytestWithLoadingState(data.placeId, "LatestVersionCard", true)
	end, { data.placeId, data.universeId })

	local onPublishActivated = React.useCallback(function()
		if v7 == nil then
			return
		end

		sendBuildExperienceEvent("PUBLISH_CLICK", {
			universeId = data.universeId,
			placeId = data.placeId
		}, {
			context = "LatestVersionCard"
		})

		if data.onClose then
			data.onClose()
		end

		v7.navigate("BuildPublish", {
			target = v7.getParam("target") or {
				universeId = data.universeId,
				placeId = data.placeId
			}
		})
	end, { data.placeId, data.universeId, data.onClose, v7 })

	local entry = data.entry

	if entry == nil then
		return nil
	end

	local placeVersion

	if v2 then
		placeVersion = v2.placeVersion
	end

	local v8

	if placeVersion then
		v8 = VersionHistoryUtils.getVersionNumber(placeVersion)
	end

	local v9 = v3 == DataStatus.NotReady
	local v10 = not FFlagBuildCheckGamePermissions or data.permissions.canEdit
	local v11 = not FFlagBuildCheckGamePermissions or data.permissions.canPublish

	return {
		versionLabel = entry.versionLabel,
		title = entry.title,
		description = entry.description,
		playtestText = v6.playtest,
		publishText = v6.publish,
		isPlaytestDisabled = v5 or not v10,
		isPublishDisabled = v9 or v8 == entry.versionNumber or not v11,
		onPlaytestActivated = onPlaytestActivated,
		onPublishActivated = onPublishActivated,
		layoutOrder = data.layoutOrder,
		testId = data.testId
	}
end

return useLatestVersionCardViewModel
