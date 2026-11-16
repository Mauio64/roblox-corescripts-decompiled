local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local React = require(parent.React)

local SearchBarContainer = require(BuildExperience.Components.SearchBar.SearchBarContainer)
local SearchEmptyState = require(BuildExperience.Components.SearchEmptyState.SearchEmptyState)

local refreshScrollingFrame = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.RefreshScrollingFrame

local HeaderBar = Foundation.HeaderBar
local IconButton = Foundation.IconButton
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function SearchPageView(props)
	local v

	if props.showEmptyState then
		v = {
			EmptyState = React.createElement(SearchEmptyState, { testId = "SearchPage.EmptyState" })
		}
	else
		v = {
			Content = React.createElement(
				View,
				{ tag = "col size-full-0 auto-y", testId = "SearchPage.Content" },
				props.children
			)
		}
	end

	local element = React.createElement(
		View,
		{
			tag = "composition-content-body col size-full-0 auto-y",
			testId = "SearchPage.ContentBody"
		},
		v
	)

	local v2 = {
		ContentLayout = React.createElement(
			View,
			{
				tag = "composition-layout-detail size-full-0 auto-y",
				testId = "SearchPage.ContentLayout"
			},
			{ ContentBody = element }
		)
	}

	local element2 = React.createElement(
		View,
		{
			tag = "composition-content-body row align-y-center gap-small size-full",
			testId = "SearchPage.SearchBarContentBody"
		},
		{
			Back = React.createElement(IconButton, {
				LayoutOrder = 1,
				icon = IconName.ChevronLargeLeft,
				isCircular = true,
				onActivated = props.onBack,
				size = InputSize.Large,
				testId = "SearchPage.Back",
				variant = ButtonVariant.Utility
			}),
			Search = React.createElement(View, { LayoutOrder = 2, tag = "fill auto-y" }, {
				SearchBar = React.createElement(SearchBarContainer, props.searchBarProps)
			})
		}
	)

	local element3 = React.createElement(
		View,
		{ tag = "composition-layout-detail size-full", testId = "SearchPage.SearchBarLayout" },
		{ ContentBody = element2 }
	)

	return React.createElement(View, { tag = "col size-full", testId = "SearchPage" }, {
		Header = React.createElement(HeaderBar.Root, {
			LayoutOrder = 1,
			testId = "SearchPage.Header"
		}, {
			Content = React.createElement(HeaderBar.Content, nil, { Layout = element3 })
		}),
		Results = React.createElement(refreshScrollingFrame, {
			createFooter = props.createFooter,
			onCanvasPositionChangedCallback = props.onCanvasPositionChangedCallback,
			onCanvasSizeChangedCallback = props.onCanvasSizeChangedCallback,
			ref = props.scrollingFrameRef,
			refresh = props.refresh,
			scrollingElementProps = props.scrollingElementProps,
			usesBuilderIcon = true
		}, v2)
	})
end

return SearchPageView
