local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local DataHydration = require(parent.DataHydration)
local Foundation = require(parent.Foundation)
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local React = require(parent.React)

local BuildEmptyState = require(BuildExperience.Components.BuildEmptyState.BuildEmptyState)
local ExperienceResultsLoadingSkeleton = require(BuildExperience.Components.MyCreationsTab.ExperienceResultsLoadingSkeleton)

local List = Foundation.List
local View = Foundation.View
local refreshScrollingFrame = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.RefreshScrollingFrame

local DataStatus = DataHydration.DataStatus
local InputSize = Foundation.Enums.InputSize

local function PreviewsTabView(props)
	local v

	if #props.rows == 0 then
		v = props.listStatus == DataStatus.Ready
	else
		v = false
	end

	local children = {}

	if #props.rows > 0 then
		for k, row in props.rows do
			children[`U{row.universeId}`] = React.createElement(List.Item, {
				LayoutOrder = k,
				leading = { iconName = row.gameIcon },
				title = row.title,
				description = row.description,
				testId = `PreviewsTab.PreviewRow.{row.universeId}`,
				onActivated = row.onActivated
			})
		end
	elseif props.listStatus == DataStatus.NotReady then
		for i = 1, 2 do
			children[`Loading{i}`] = React.createElement(ExperienceResultsLoadingSkeleton, {
				LayoutOrder = i,
				index = i,
				testIdPrefix = "PreviewsTab"
			})
		end
	end

	if props.listStatus == DataStatus.Failed then
		children.Error = React.createElement(List.Item, {
			LayoutOrder = #props.rows + 1,
			title = props.loadError,
			testId = "PreviewsTab.LoadError"
		})
	end

	if props.failedLoadMore then
		children.LoadMoreError = React.createElement(List.Item, {
			LayoutOrder = #props.rows + 2,
			title = props.loadError,
			testId = "PreviewsTab.LoadMoreError",
			onActivated = props.retryLoadMore
		})
	end

	local isLoadingMore = props.isLoadingMore
	local createFooter = React.useCallback(function()
		if isLoadingMore then
			return React.createElement(ExperienceResultsLoadingSkeleton, {
				LayoutOrder = 1,
				index = 1,
				testIdPrefix = "PreviewsTab"
			})
		end

		return nil
	end, { isLoadingMore })

	local createElement = React.createElement
	local v2 = {
		refresh = props.refresh,
		onCanvasPositionChangedCallback = props.loadMoreIfNeeded,
		onCanvasSizeChangedCallback = props.loadMoreIfNeeded,
		createFooter = createFooter,
		usesBuilderIcon = true,
		scrollingElementProps = {
			LayoutOrder = 1,
			ZIndex = 1,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ScrollBarThickness = 0,
			CanvasSize = UDim2.new(1, 0, 1, 1),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			[React.Tag] = "fill"
		}
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v3

	if v then
		v3 = {
			EmptyContent = React.createElement(View, { tag = "col size-full" }, {
				EmptyState = React.createElement(
					View,
					{
						tag = "col align-x-center align-y-center fill size-full-0 padding-large",
						testId = "PreviewsTab.Empty"
					},
					{
						Content = React.createElement(BuildEmptyState, { message = props.emptyText })
					}
				)
			})
		}
	else
		v3 = {
			List = React.createElement(List.Root, {
				hasDivider = false,
				isContained = { isContained = false, hasMargin = false },
				size = InputSize.Large
			}, children)
		}
	end

	local element = createElement(refreshScrollingFrame, v2, {
		ContentLayout = createElement2(
			View,
			{
				tag = "composition-layout-detail size-full-0 auto-y",
				testId = "PreviewsTab.ContentLayout"
			},
			{
				ContentBody = createElement3(View, {
					tag = "composition-content-body col size-full-0 auto-y"
				}, v3)
			}
		)
	})

	return React.createElement(View, { LayoutOrder = props.LayoutOrder, tag = "col fill size-full" }, {
		Filter = props.filterHeader,
		Results = element
	})
end

return PreviewsTabView
