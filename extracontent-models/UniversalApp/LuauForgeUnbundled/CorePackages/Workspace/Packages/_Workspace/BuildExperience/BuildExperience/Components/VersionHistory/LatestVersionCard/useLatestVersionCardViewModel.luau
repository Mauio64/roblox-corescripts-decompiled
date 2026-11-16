local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Navigation")
local PlaceVersionHistory = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/PlaceVersionHistory")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local launchPlaytestWithLoadingState = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/launchPlaytestWithLoadingState")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local GetPlaytestLoadingStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/GetPlaytestLoadingStore")
local VersionHistoryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/VersionHistoryUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/LatestVersionCard/LatestVersionCardView")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")

local dataStatus = DataHydration.DataStatus
local useLocalization = Localization.Hooks.useLocalization
local useNavigation = Navigation.useNavigation

local function useLatestVersionCardViewModel(data)
	local placeVersionHistoryStore = PlaceVersionHistory.getPlaceVersionHistoryStore()
	local v5 = React.useMemo(function()
		return placeVersionHistoryStore.getLiveVersion(data.placeId)
	end, { data.placeId, placeVersionHistoryStore })
	local v6 = SignalsReact.useSignalState(v5.data)
	local v7 = SignalsReact.useSignalState(v5.status)

	React.useEffect(function()
		placeVersionHistoryStore.fetchLiveVersion(data.placeId)
	end, { data.placeId, placeVersionHistoryStore })

	local v8 = React.useCallback(function(p2)
		return GetPlaytestLoadingStore(p2).getIsPlaytestLoadingForPlaceId(data.placeId)(p2)
	end, { data.placeId })
	local v9 = SignalsReact.useSignalState(v8)

	local v10 = useLocalization({
		playtest = LocalizationStrings.BUILD_MENU_PLAYTEST,
		publish = LocalizationStrings.BUILD_MENU_PUBLISH
	})

	local v11 = useNavigation()

	local v12 = React.useCallback(function()
		sendBuildExperienceEvent("PLAYTEST_CLICK", {
			universeId = data.universeId,
			placeId = data.placeId
		}, {
			context = "LatestVersionCard"
		})
		launchPlaytestWithLoadingState(data.placeId, "LatestVersionCard", true)
	end, { data.placeId, data.universeId })

	local v13 = React.useCallback(function()
		if v11 == nil then
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

		v11.navigate("BuildPublish", {
			target = v11.getParam("target") or {
				universeId = data.universeId,
				placeId = data.placeId
			}
		})
	end, { data.placeId, data.universeId, data.onClose, v11 })

	local entry = data.entry

	if entry == nil then
		return nil
	end

	local placeVersion = if v6 then v6.placeVersion else nil
	local v14 = if placeVersion then VersionHistoryUtils.getVersionNumber(placeVersion) else nil

	local v15 = v7 == dataStatus.NotReady
	local v16 = not FFlagBuildCheckGamePermissions or data.permissions.canEdit
	local v17 = not FFlagBuildCheckGamePermissions or data.permissions.canPublish

	return {
		versionLabel = entry.versionLabel,
		title = entry.title,
		description = entry.description,
		playtestText = v10.playtest,
		publishText = v10.publish,
		isPlaytestDisabled = v9 or not v16,
		isPublishDisabled = v15 or v14 == entry.versionNumber or not v17,
		onPlaytestActivated = v12,
		onPublishActivated = v13,
		layoutOrder = data.layoutOrder,
		testId = data.testId
	}
end

return useLatestVersionCardViewModel
