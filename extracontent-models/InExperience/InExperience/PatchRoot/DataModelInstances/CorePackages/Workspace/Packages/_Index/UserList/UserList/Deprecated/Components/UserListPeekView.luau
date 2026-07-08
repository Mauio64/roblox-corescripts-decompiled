local Parent = script:FindFirstAncestor("UserList").Parent
local React = require(Parent.React)
local RobloxAppHooks = require(Parent.RobloxAppHooks)
local PeekView = require(Parent.PeekView)
local PeekViewWithTopBar = PeekView.PeekViewWithTopBar
local PeekViewState = PeekView.PeekViewState
local RoactUtils = require(Parent.RoactUtils)
local NavigateBack = require(Parent.NavigationRodux).Thunks.NavigateBack
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local UserList = require(script.Parent.UserList)
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local UserListPeekViewTopBar = require(script.Parent.UserListPeekViewTopBar)
local View = Foundation.View
local FoundationText = Foundation.Text
local useLocalization = require(Parent.Localization).Hooks.useLocalization

return function(t1: {[any]: any}) -- line: 34
	-- upvalues: useTopBarHeight (copy), useDispatch (copy), React (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateBack (copy), PeekViewState (copy), useLocalization (copy), PeekViewWithTopBar (copy), UserListPeekViewTopBar (copy), View (copy), FoundationText (copy), UserList (copy), Button (copy)
	local uDim = UDim.new(0.55, 0)
	local v22 = useTopBarHeight()
	local v23 = useDispatch()
	local v24 = React.useCallback(function() -- line: 39
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v10 (copy), v23 (copy), NavigateBack (copy)
		if FFlagSignalsNavP3Dispatch then
			v10.back(true)

			return
		end

		v23(NavigateBack(true))
	end, { v23 })
	local v25 = React.useCallback(function(p1, _, _) -- line: 47
		-- upvalues: PeekViewState (copy), v24 (copy)
		if p1 == PeekViewState.Closed then
			v24()
		end
	end, { v24 })
	local v26 = useLocalization({
		showMore = "Feature.Friends.Action.ShowMore"
	})

	return React.createElement(PeekViewWithTopBar, {
		briefViewContentHeight = uDim,
		fullViewContentHeight = UDim.new(1, -v22),
		onViewStateChanged = v25,
		topBarHeight = v22,
		topBarSlot = React.createElement(UserListPeekViewTopBar, {
			navigateBack = v24
		}),
		contentSlot = React.createElement(View, {
			tag = "auto-y align-x-center col padding-top-xlarge padding-x-xlarge padding-bottom-large gap-large",
			Size = UDim2.new(1, 0, 1, -v22)
		}, {
			Title = if not t1.title then nil else React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "text-heading-small size-full-0 text-align-x-left content-emphasis auto-y",
				Text = t1.title
			}),
			UserList = React.createElement(UserList, {
				layoutOrder = 2,
				userIds = t1.users,
				onUserSelected = t1.onUserSelected
			}),
			ButtonContainer = React.createElement(View, {
				LayoutOrder = 3,
				tag = "size-full-0 auto-y align-x-center col padding-top-xlarge padding-x-xlarge padding-bottom-large gap-large"
			}, {
				ShowMoreButton = if not t1.hasMore or not t1.onLoadMore then nil else React.createElement(Button, {
					onActivated = t1.onLoadMore,
					text = v26.showMore
				})
			})
		})
	})
end
