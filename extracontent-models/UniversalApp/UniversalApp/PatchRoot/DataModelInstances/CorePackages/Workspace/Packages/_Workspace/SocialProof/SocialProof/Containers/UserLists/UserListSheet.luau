local Parent = script:FindFirstAncestor("SocialProof").Parent
local React = require(Parent.React)
local RoactUtils = require(Parent.RoactUtils)
local NavigateBack = require(Parent.NavigationRodux).Thunks.NavigateBack
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v6 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local UserList = require(Parent.UserList)
local VerticalUserList = UserList.VerticalUserList.VerticalUserList
local EntityType = UserList.Enums.EntityType
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local View = Foundation.View
local FoundationText = Foundation.Text
local Sheet = Foundation.Sheet
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local t1 = {
	0.55,
	1
}

return function(t2: {[any]: any}) -- line: 35
	-- upvalues: useDispatch (copy), React (copy), FFlagSignalsNavP3Dispatch (copy), v6 (copy), NavigateBack (copy), useLocalization (copy), EntityType (copy), Sheet (copy), t1 (copy), View (copy), FoundationText (copy), VerticalUserList (copy), Button (copy)
	local v19 = useDispatch()
	local v20 = React.useCallback(function() -- line: 38
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v6 (copy), v19 (copy), NavigateBack (copy)
		if FFlagSignalsNavP3Dispatch then
			v6.back(true)

			return
		end

		v19(NavigateBack(true))
	end, { v19 })
	local v21 = useLocalization({
		showMore = "Feature.Friends.Action.ShowMore"
	})
	local v22 = React.useMemo(function() -- line: 50
		-- upvalues: t2 (copy), EntityType (copy)
		local t3 = {}

		for _, v in ipairs(t2.users) do
			table.insert(t3, {
				id = tostring(v),
				type = EntityType.User
			})
		end

		return t3
	end, { t2.users })
	local v23 = React.useCallback(function(s1: string) -- line: 58
		-- upvalues: t2 (copy)
		if t2.onUserSelected then
			t2.onUserSelected(s1)
		end
	end, { t2.onUserSelected })

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = v20,
		snapPoints = t1
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = true
		}, {
			Title = if not t2.title then nil else React.createElement(View, {
				tag = "align-x-left size-full auto-y"
			}, {
				TitleText = React.createElement(FoundationText, {
					tag = "auto-xy text-heading-small text-align-x-left content-emphasis",
					Text = t2.title
				})
			})
		}),
		Content = React.createElement(Sheet.Content, nil, {
			ListContainer = React.createElement(View, {
				tag = "size-full auto-y padding-y-large"
			}, {
				UserList = React.createElement(VerticalUserList, {
					layoutOrder = 1,
					entities = v22,
					onRowSelected = v23,
					initialRowCount = #t2.users
				}),
				ShowMoreButton = if not t2.hasMore or not t2.onLoadMore then nil else React.createElement(Button, {
					LayoutOrder = 2,
					onActivated = t2.onLoadMore,
					text = v21.showMore
				})
			})
		})
	})
end
