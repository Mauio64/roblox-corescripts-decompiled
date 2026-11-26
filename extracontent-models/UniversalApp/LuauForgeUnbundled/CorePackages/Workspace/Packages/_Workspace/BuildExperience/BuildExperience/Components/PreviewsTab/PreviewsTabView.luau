local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/LuaSocialLibrariesDeps")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local BuildEmptyState = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildEmptyState/BuildEmptyState")
local ExperienceResultsLoadingSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsTab/ExperienceResultsLoadingSkeleton")

local list = Foundation.List
local view = Foundation.View
local refreshScrollingFrame = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.RefreshScrollingFrame

local dataStatus = DataHydration.DataStatus
local inputSize = Foundation.Enums.InputSize

local function PreviewsTabView(props)
	local v5 = #props.rows == 0 and props.listStatus == dataStatus.Ready
	local children = {}

	if #props.rows > 0 then
		for k, row in props.rows do
			children[`U{row.universeId}`] = React.createElement(list.Item, {
				LayoutOrder = k,
				leading = { iconName = row.gameIcon },
				title = row.title,
				description = row.description,
				testId = `PreviewsTab.PreviewRow.{row.universeId}`,
				onActivated = row.onActivated
			})
		end
	elseif props.listStatus == dataStatus.NotReady then
		for i = 1, 2 do
			children[`Loading{i}`] = React.createElement(ExperienceResultsLoadingSkeleton, {
				LayoutOrder = i,
				index = i,
				testIdPrefix = "PreviewsTab"
			})
		end
	end

	if props.listStatus == dataStatus.Failed then
		children.Error = React.createElement(list.Item, {
			LayoutOrder = #props.rows + 1,
			title = props.loadError,
			testId = "PreviewsTab.LoadError"
		})
	end

	if props.failedLoadMore then
		children.LoadMoreError = React.createElement(list.Item, {
			LayoutOrder = #props.rows + 2,
			title = props.loadError,
			testId = "PreviewsTab.LoadMoreError",
			onActivated = props.retryLoadMore
		})
	end

	local isLoadingMore = props.isLoadingMore
	local v6 = React.useCallback(function()
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
	local v8 = {
		refresh = props.refresh,
		onCanvasPositionChangedCallback = props.loadMoreIfNeeded,
		onCanvasSizeChangedCallback = props.loadMoreIfNeeded,
		createFooter = v6,
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
	local v16

	if v5 then
		v16 = {
			EmptyContent = React.createElement(view, { tag = "col size-full" }, {
				EmptyState = React.createElement(
					view,
					{
						tag = "col align-x-center align-y-center fill size-full-0 padding-large",
						testId = "PreviewsTab.Empty"
					},
					{
						Content = React.createElement(BuildEmptyState, {
							message = props.emptyText
						})
					}
				)
			})
		}
	else
		v16 = {
			List = React.createElement(list.Root, {
				hasDivider = false,
				isContained = { isContained = false, hasMargin = false },
				size = inputSize.Large
			}, children)
		}
	end

	local element = createElement(refreshScrollingFrame, v8, {
		ContentLayout = createElement2(
			view,
			{
				tag = "composition-layout-detail size-full-0 auto-y",
				testId = "PreviewsTab.ContentLayout"
			},
			{
				ContentBody = createElement3(
					view,
					{ tag = "composition-content-body col size-full-0 auto-y" },
					v16
				)
			}
		)
	})

	return React.createElement(view, {
		LayoutOrder = props.LayoutOrder,
		tag = "col fill size-full"
	}, {
		Filter = props.filterHeader,
		Results = element
	})
end

return PreviewsTabView
