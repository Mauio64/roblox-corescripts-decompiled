local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RobloxAppHooks")
local PeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/PeekView")
local peekViewWithTopBar = PeekView.PeekViewWithTopBar
local peekViewState = PeekView.PeekViewState
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RoactUtils")
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/NavigationRodux").Thunks.NavigateBack
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RobloxAppNavigation").NavigationCommands else nil

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Deprecated/Components/UserList")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation")
local button = Foundation.Button
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local UserListPeekViewTopBar = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Deprecated/Components/UserListPeekViewTopBar")
local view = Foundation.View
local text = Foundation.Text
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Localization").Hooks.useLocalization

return function(props)
	local udim = UDim.new(0.55, 0)
	local v5 = useTopBarHeight()
	local v6 = useDispatch()

	local v7 = React.useCallback(function()
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
		else
			v6(navigateBack(true))
		end
	end, { v6 })

	local v8 = React.useCallback(function(p2, p3, p4)
		if p2 == peekViewState.Closed then
			v7()
		end
	end, { v7 })

	local v9 = useLocalization({ showMore = "Feature.Friends.Action.ShowMore" })

	local createElement = React.createElement
	local v11 = {
		briefViewContentHeight = udim,
		fullViewContentHeight = UDim.new(1, -v5),
		onViewStateChanged = v8,
		topBarHeight = v5,
		topBarSlot = React.createElement(UserListPeekViewTopBar, { navigateBack = v7 }),
		contentSlot = 0
	}

	local createElement2 = React.createElement
	local v13 = {
		Size = UDim2.new(1, 0, 1, -v5),
		tag = "auto-y align-x-center col padding-top-xlarge padding-x-xlarge padding-bottom-large gap-large"
	}

	local v14 = if props.title then React.createElement(text, {
		LayoutOrder = 1,
		tag = "text-heading-small size-full-0 text-align-x-left content-emphasis auto-y",
		Text = props.title
	}) else nil
	local children = {
		Title = v14,
		UserList = React.createElement(module5, {
			userIds = props.users,
			onUserSelected = props.onUserSelected,
			layoutOrder = 2
		}),
		ButtonContainer = 0
	}

	local createElement3 = React.createElement

	local v18 = if props.hasMore and props.onLoadMore then React.createElement(button, {
		onActivated = props.onLoadMore,
		text = v9.showMore
	}) else nil
	children.ButtonContainer = createElement3(
		view,
		{
			LayoutOrder = 3,
			tag = "size-full-0 auto-y align-x-center col padding-top-xlarge padding-x-xlarge padding-bottom-large gap-large"
		},
		{ ShowMoreButton = v18 }
	)
	v11.contentSlot = createElement2(view, v13, children)
	return createElement(peekViewWithTopBar, v11)
end
