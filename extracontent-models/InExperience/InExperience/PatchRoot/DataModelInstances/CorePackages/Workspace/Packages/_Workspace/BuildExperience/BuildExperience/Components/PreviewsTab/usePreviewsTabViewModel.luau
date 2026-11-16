local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local GameDetail = require(parent.GameDetail)
local Localization = require(parent.Localization)
local Navigation = require(parent.Navigation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore

local descriptionWithGroupIcon = require(BuildExperience.utils.descriptionWithGroupIcon)
local getGameDetailsNavigation = require(BuildExperience.utils.getGameDetailsNavigation)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
require(script.Parent.PreviewsTabView)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
require(script.Parent.usePreviewResults)

local OpenGameDetails = GameDetail.OpenGameDetails
local getRootNavigation = Navigation.getRootNavigation
local useLocalization = Localization.Hooks.useLocalization
local useNavigation = Navigation.useNavigation

local function usePreviewsTabViewModel(p)
	local v = useNavigation()
	local v2 = useStore()
	local v3 = useLocalization({
		loadError = LocalizationStrings.MY_CREATIONS_LOAD_ERROR,
		noGames = LocalizationStrings.MY_CREATIONS_NO_GAMES
	})

	local results = p.results
	local loadMore = results.loadMore

	local v4 = React.useCallback(function(universeId: number)
		sendBuildExperienceEvent("PREVIEW_CLICK", { universeId = universeId }, {
			context = "BuildPreviews"
		})

		OpenGameDetails(tostring(universeId), getGameDetailsNavigation(getRootNavigation(v)), {
			source = "BuildPreviews"
		})(v2)
	end, { v, v2 })

	local rows = React.useMemo(function()
		local result = table.create(#results.items)

		for _, item in results.items do
			local v5 = {
				universeId = item.universeId,
				title = item.experienceName,
				description = 0,
				gameIcon = 0,
				onActivated = 0
			}
			local description

			if item.isGroupGame then
				description = descriptionWithGroupIcon(nil, true, item.creatorName)
			else
				description = item.creatorName
			end

			v5.description = description

			v5.gameIcon = item.gameIcon
			function v5.onActivated()
				v4(item.universeId)
			end

			table.insert(result, v5)
		end

		return result
	end, { v4, results.items })

	local loadMoreIfNeeded = React.useCallback(function(data)
		local y = data.AbsoluteCanvasSize.Y

		if data.CanvasPosition.Y <= 0 or y <= 0 or data.AbsoluteWindowSize.Y <= 0 then
			return
		end

		if math.max(0, y - data.AbsoluteWindowSize.Y - 250) < data.CanvasPosition.Y then
			loadMore()
		end
	end, { loadMore })

	return {
		rows = rows,
		listStatus = results.status,
		loadError = v3.loadError,
		isLoadingMore = results.isLoadingMore,
		failedLoadMore = results.failedLoadMore,
		refresh = results.refresh,
		loadMoreIfNeeded = loadMoreIfNeeded,
		retryLoadMore = loadMore,
		emptyText = v3.noGames
	}
end

return usePreviewsTabViewModel
