local parent = script:FindFirstAncestor("SocialProof").Parent

local React = require(parent.React)
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
local UserList = require(parent.UserList)
local VerticalUserList = UserList.VerticalUserList.VerticalUserList
local EntityType = UserList.Enums.EntityType
local Foundation = require(parent.Foundation)
local Button = Foundation.Button
local View = Foundation.View
local Text = Foundation.Text
local Sheet = Foundation.Sheet
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local snapPoints = { 0.55, 1 }

return function(props)
	local v = useDispatch()

	local onClose = React.useCallback(function()
		if FFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
		else
			v(NavigateBack(true))
		end
	end, { v })

	local v2 = useLocalization({ showMore = "Feature.Friends.Action.ShowMore" })

	local entities = React.useMemo(function()
		local result = {}

		for _, user in ipairs(props.users) do
			table.insert(result, { id = tostring(user), type = EntityType.User })
		end

		return result
	end, { props.users })

	local onRowSelected = React.useCallback(function(p: string)
		if props.onUserSelected then
			props.onUserSelected(p)
		end
	end, { props.onUserSelected })

	local createElement = React.createElement
	local root = Sheet.Root

	local createElement2 = React.createElement
	local header = Sheet.Header
	local title

	if props.title then
		title = React.createElement(View, { tag = "align-x-left size-full auto-y" }, {
			TitleText = React.createElement(Text, {
				tag = "auto-xy text-heading-small text-align-x-left content-emphasis",
				Text = props.title
			})
		})
	end

	local children = {
		Header = createElement2(header, { hasCloseAffordance = true }, { Title = title }),
		Content = 0
	}

	local createElement3 = React.createElement
	local content = Sheet.Content
	local createElement4 = React.createElement

	local v3 = {
		UserList = React.createElement(VerticalUserList, {
			entities = entities,
			onRowSelected = onRowSelected,
			initialRowCount = #props.users,
			layoutOrder = 1
		}),
		ShowMoreButton = 0
	}
	local showMoreButton

	if props.hasMore and props.onLoadMore then
		showMoreButton = React.createElement(Button, {
			LayoutOrder = 2,
			onActivated = props.onLoadMore,
			text = v2.showMore
		})
	end

	v3.ShowMoreButton = showMoreButton
	children.Content = createElement3(content, nil, {
		ListContainer = createElement4(View, { tag = "size-full auto-y padding-y-large" }, v3)
	})
	return createElement(root, {
		onClose = onClose,
		preferCenterSheet = true,
		snapPoints = snapPoints
	}, children)
end
