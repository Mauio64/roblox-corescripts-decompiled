local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/LuaSocialLibrariesDeps")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local SearchBarContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SearchBar/SearchBarContainer")
local SearchEmptyState = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SearchEmptyState/SearchEmptyState")

local refreshScrollingFrame = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.RefreshScrollingFrame

local headerBar = Foundation.HeaderBar
local iconButton = Foundation.IconButton
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local function SearchPageView(props)
	local v5

	if props.showEmptyState then
		v5 = {
			EmptyState = React.createElement(SearchEmptyState, {
				testId = "SearchPage.EmptyState"
			})
		}
	else
		v5 = {
			Content = React.createElement(
				view,
				{ tag = "col size-full-0 auto-y", testId = "SearchPage.Content" },
				props.children
			)
		}
	end

	local element = React.createElement(
		view,
		{
			tag = "composition-content-body col size-full-0 auto-y",
			testId = "SearchPage.ContentBody"
		},
		v5
	)

	local v6 = {
		ContentLayout = React.createElement(
			view,
			{
				tag = "composition-layout-detail size-full-0 auto-y",
				testId = "SearchPage.ContentLayout"
			},
			{ ContentBody = element }
		)
	}

	local element2 = React.createElement(
		view,
		{
			tag = "composition-content-body row align-y-center gap-small size-full",
			testId = "SearchPage.SearchBarContentBody"
		},
		{
			Back = React.createElement(iconButton, {
				LayoutOrder = 1,
				icon = iconName.ChevronLargeLeft,
				isCircular = true,
				onActivated = props.onBack,
				size = inputSize.Large,
				testId = "SearchPage.Back",
				variant = buttonVariant.Utility
			}),
			Search = React.createElement(view, {
				LayoutOrder = 2,
				tag = "fill auto-y"
			}, {
				SearchBar = React.createElement(SearchBarContainer, props.searchBarProps)
			})
		}
	)

	local element3 = React.createElement(
		view,
		{
			tag = "composition-layout-detail size-full",
			testId = "SearchPage.SearchBarLayout"
		},
		{ ContentBody = element2 }
	)

	return React.createElement(view, { tag = "col size-full", testId = "SearchPage" }, {
		Header = React.createElement(headerBar.Root, {
			LayoutOrder = 1,
			testId = "SearchPage.Header"
		}, {
			Content = React.createElement(headerBar.Content, nil, {
				Layout = element3
			})
		}),
		Results = React.createElement(refreshScrollingFrame, {
			createFooter = props.createFooter,
			onCanvasPositionChangedCallback = props.onCanvasPositionChangedCallback,
			onCanvasSizeChangedCallback = props.onCanvasSizeChangedCallback,
			ref = props.scrollingFrameRef,
			refresh = props.refresh,
			scrollingElementProps = props.scrollingElementProps,
			usesBuilderIcon = true
		}, v6)
	})
end

return SearchPageView
