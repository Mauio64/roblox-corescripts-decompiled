local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RoactUtils")
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/NavigationRodux").Thunks.NavigateBack
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RobloxAppNavigation").NavigationCommands else nil

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/UserList")
local verticalUserList = module3.VerticalUserList.VerticalUserList
local entityType = module3.Enums.EntityType
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/Foundation")
local button = Foundation.Button
local view = Foundation.View
local text = Foundation.Text
local sheet = Foundation.Sheet
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/Localization").Hooks.useLocalization

local v5 = { 0.55, 1 }

return function(props)
	local v6 = useDispatch()

	local v7 = React.useCallback(function()
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
		else
			v6(navigateBack(true))
		end
	end, { v6 })

	local v8 = useLocalization({ showMore = "Feature.Friends.Action.ShowMore" })

	local v9 = React.useMemo(function()
		local result = {}

		for i, user in ipairs(props.users) do
			table.insert(result, { id = tostring(user), type = entityType.User })
		end

		return result
	end, { props.users })

	local v10 = React.useCallback(function(p2)
		if props.onUserSelected then
			props.onUserSelected(p2)
		end
	end, { props.onUserSelected })

	local createElement = React.createElement
	local root = sheet.Root

	local createElement2 = React.createElement
	local header = sheet.Header

	local v14 = if props.title then React.createElement(view, {
		tag = "align-x-left size-full auto-y"
	}, {
		TitleText = React.createElement(text, {
			tag = "auto-xy text-heading-small text-align-x-left content-emphasis",
			Text = props.title
		})
	}) else nil
	local children = {
		Header = createElement2(header, { hasCloseAffordance = true }, { Title = v14 }),
		Content = 0
	}

	local createElement3 = React.createElement
	local content = sheet.Content
	local createElement4 = React.createElement

	local v19 = {
		UserList = React.createElement(verticalUserList, {
			entities = v9,
			onRowSelected = v10,
			initialRowCount = #props.users,
			layoutOrder = 1
		}),
		ShowMoreButton = 0
	}

	local v20 = if props.hasMore and props.onLoadMore then React.createElement(button, {
		LayoutOrder = 2,
		onActivated = props.onLoadMore,
		text = v8.showMore
	}) else nil
	v19.ShowMoreButton = v20
	children.Content = createElement3(content, nil, {
		ListContainer = createElement4(view, {
			tag = "size-full auto-y padding-y-large"
		}, v19)
	})
	return createElement(root, {
		onClose = v7,
		preferCenterSheet = true,
		snapPoints = v5
	}, children)
end
