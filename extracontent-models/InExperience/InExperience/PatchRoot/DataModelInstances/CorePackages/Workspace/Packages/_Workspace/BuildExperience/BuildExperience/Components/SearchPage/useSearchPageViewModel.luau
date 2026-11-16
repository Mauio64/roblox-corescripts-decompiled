local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Cryo = require(parent.Cryo)
require(parent.Promise)
local React = require(parent.React)

require(BuildExperience.Components.SearchBar.SearchBarContainer)
require(script.Parent.SearchPageView)

local v = {
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1,
	CanvasSize = UDim2.new(1, 0, 1, 1),
	LayoutOrder = 2,
	ScrollBarThickness = 0,
	ScrollingDirection = Enum.ScrollingDirection.Y,
	Size = UDim2.fromScale(1, 1),
	[React.Tag] = "fill"
}

local function useSearchPageViewModel(data, scrollingFrameRef)
	local scrollingElementProps = React.useMemo(function()
		return Cryo.Dictionary.join(v, data.scrollingElementProps or {})
	end, { data.scrollingElementProps })
	return {
		children = data.children,
		createFooter = data.createFooter,
		onBack = data.onBack,
		onCanvasPositionChangedCallback = data.onCanvasPositionChangedCallback,
		onCanvasSizeChangedCallback = data.onCanvasSizeChangedCallback,
		refresh = data.refresh,
		scrollingElementProps = scrollingElementProps,
		scrollingFrameRef = scrollingFrameRef,
		searchBarProps = data.searchBarProps,
		showEmptyState = data.showEmptyState
	}
end

return useSearchPageViewModel
