local parent = script:FindFirstAncestor("UserList").Parent

local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local PeekView = require(parent.PeekView)
local PeekViewWithTopBar = PeekView.PeekViewWithTopBar
local PeekViewState = PeekView.PeekViewState
local RoactUtils = require(parent.RoactUtils)
local NavigationRodux = require(parent.NavigationRodux)
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local UserList = require(script.Parent.UserList)
local Foundation = require(parent.Foundation)
local Button = Foundation.Button
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local UserListPeekViewTopBar = require(script.Parent.UserListPeekViewTopBar)
local View = Foundation.View
local Text = Foundation.Text
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

return function(props)
	local udim = UDim.new(0.55, 0)
	local topBarHeight = useTopBarHeight()
	local v = useDispatch()

	local navigateBack = React.useCallback(function()
		if FFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
		else
			v(NavigateBack(true))
		end
	end, { v })

	local onViewStateChanged = React.useCallback(function(p, _, _)
		if p == PeekViewState.Closed then
			navigateBack()
		end
	end, { navigateBack })

	local v2 = useLocalization({ showMore = "Feature.Friends.Action.ShowMore" })

	local createElement = React.createElement
	local v3 = {
		briefViewContentHeight = udim,
		fullViewContentHeight = UDim.new(1, -topBarHeight),
		onViewStateChanged = onViewStateChanged,
		topBarHeight = topBarHeight,
		topBarSlot = React.createElement(UserListPeekViewTopBar, { navigateBack = navigateBack }),
		contentSlot = 0
	}

	local createElement2 = React.createElement
	local v4 = {
		Size = UDim2.new(1, 0, 1, -topBarHeight),
		tag = "auto-y align-x-center col padding-top-xlarge padding-x-xlarge padding-bottom-large gap-large"
	}
	local title

	if props.title then
		title = React.createElement(Text, {
			LayoutOrder = 1,
			tag = "text-heading-small size-full-0 text-align-x-left content-emphasis auto-y",
			Text = props.title
		})
	end

	local children = {
		Title = title,
		UserList = React.createElement(UserList, {
			userIds = props.users,
			onUserSelected = props.onUserSelected,
			layoutOrder = 2
		}),
		ButtonContainer = 0
	}

	local createElement3 = React.createElement
	local showMoreButton

	if props.hasMore and props.onLoadMore then
		showMoreButton = React.createElement(Button, {
			onActivated = props.onLoadMore,
			text = v2.showMore
		})
	end

	children.ButtonContainer = createElement3(
		View,
		{
			LayoutOrder = 3,
			tag = "size-full-0 auto-y align-x-center col padding-top-xlarge padding-x-xlarge padding-bottom-large gap-large"
		},
		{ ShowMoreButton = showMoreButton }
	)
	v3.contentSlot = createElement2(View, v4, children)
	return createElement(PeekViewWithTopBar, v3)
end
