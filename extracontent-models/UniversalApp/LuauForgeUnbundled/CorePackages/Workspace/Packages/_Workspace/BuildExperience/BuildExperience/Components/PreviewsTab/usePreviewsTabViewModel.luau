local GameDetail = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/GameDetail")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RoactUtils").Hooks.RoactRodux.useStore

local descriptionWithGroupIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/descriptionWithGroupIcon")
local getGameDetailsNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/getGameDetailsNavigation")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PreviewsTab/PreviewsTabView")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PreviewsTab/usePreviewResults")

local openGameDetails = GameDetail.OpenGameDetails
local getRootNavigation = Navigation.getRootNavigation
local useLocalization = Localization.Hooks.useLocalization
local useNavigation = Navigation.useNavigation

local function usePreviewsTabViewModel(p2)
	local v5 = useNavigation()
	local v6 = useStore()
	local v7 = useLocalization({
		loadError = LocalizationStrings.MY_CREATIONS_LOAD_ERROR,
		noGames = LocalizationStrings.MY_CREATIONS_NO_GAMES
	})

	local results = p2.results
	local loadMore = results.loadMore

	local v8 = React.useCallback(function(p3)
		sendBuildExperienceEvent("PREVIEW_CLICK", { universeId = p3 }, { context = "BuildPreviews" })

		openGameDetails(tostring(p3), getGameDetailsNavigation(getRootNavigation(v5)), {
			source = "BuildPreviews"
		})(v6)
	end, { v5, v6 })

	local v9 = React.useMemo(function()
		local result = table.create(#results.items)

		for k, item in results.items do
			local v10 = {
				universeId = item.universeId,
				title = item.experienceName,
				description = 0,
				gameIcon = 0,
				onActivated = 0
			}
			local v11 = if item.isGroupGame then descriptionWithGroupIcon(nil, true, item.creatorName) else item.creatorName
			v10.description = v11

			v10.gameIcon = item.gameIcon
			function v10.onActivated()
				v8(item.universeId)
			end

			table.insert(result, v10)
		end

		return result
	end, { v8, results.items })

	local v10 = React.useCallback(function(data)
		local y = data.AbsoluteCanvasSize.Y

		if data.CanvasPosition.Y <= 0 or y <= 0 or data.AbsoluteWindowSize.Y <= 0 then
			return
		end

		if math.max(0, y - data.AbsoluteWindowSize.Y - 250) < data.CanvasPosition.Y then
			loadMore()
		end
	end, { loadMore })

	return {
		rows = v9,
		listStatus = results.status,
		loadError = v7.loadError,
		isLoadingMore = results.isLoadingMore,
		failedLoadMore = results.failedLoadMore,
		refresh = results.refresh,
		loadMoreIfNeeded = v10,
		retryLoadMore = loadMore,
		emptyText = v7.noGames
	}
end

return usePreviewsTabViewModel
