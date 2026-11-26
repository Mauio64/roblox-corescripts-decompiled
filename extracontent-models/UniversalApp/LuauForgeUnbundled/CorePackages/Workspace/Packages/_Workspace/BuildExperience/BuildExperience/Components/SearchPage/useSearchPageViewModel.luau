local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SearchBar/SearchBarContainer")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SearchPage/SearchPageView")

local v5 = {
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1,
	CanvasSize = UDim2.new(1, 0, 1, 1),
	LayoutOrder = 2,
	ScrollBarThickness = 0,
	ScrollingDirection = Enum.ScrollingDirection.Y,
	Size = UDim2.fromScale(1, 1),
	[React.Tag] = "fill"
}

local function useSearchPageViewModel(data, p2)
	local v6 = React.useMemo(function()
		return Cryo.Dictionary.join(v5, data.scrollingElementProps or {})
	end, { data.scrollingElementProps })
	return {
		children = data.children,
		createFooter = data.createFooter,
		onBack = data.onBack,
		onCanvasPositionChangedCallback = data.onCanvasPositionChangedCallback,
		onCanvasSizeChangedCallback = data.onCanvasSizeChangedCallback,
		refresh = data.refresh,
		scrollingElementProps = v6,
		scrollingFrameRef = p2,
		searchBarProps = data.searchBarProps,
		showEmptyState = data.showEmptyState
	}
end

return useSearchPageViewModel
