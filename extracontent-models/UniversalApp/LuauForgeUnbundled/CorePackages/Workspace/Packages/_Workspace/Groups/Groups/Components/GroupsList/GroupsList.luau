local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Localization").Hooks.useLocalization

local scrollView = Foundation.ScrollView
local view = Foundation.View
local text = Foundation.Text
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/TextKeys")
require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/Types")
local GroupsListToolbar = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/GroupsList/GroupsListToolbar")
local GroupsListSection = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/GroupsList/GroupsListSection")
local GroupsListHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/GroupsList/GroupsListHeader")
local GroupListItemSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/GroupsList/GroupListItemSkeleton")

local frozen = table.freeze({})

local function renderSkeletons()
	local children = {}

	for i = 1, 3 do
		children[`Skeleton_{i}`] = React.createElement(GroupListItemSkeleton, { layoutOrder = i })
	end

	return children
end

local function GroupsList(props)
	local v5 = useLocalization({
		primaryHeading = TextKeys.HeadingPrimary,
		myGroupsHeading = TextKeys.HeadingMyGroups,
		loadFailure = TextKeys.MessageLoadGroupListError,
		notInGroups = TextKeys.MessageNotInAnyGroups,
		noResults = TextKeys.MessageNoGroupsFound
	})

	local groupsList = props.groupsList or frozen
	local state, setState = React.useState("")
	local ref = React.useRef(nil)

	local v6 = React.useMemo(function()
		for i, group in ipairs(groupsList) do
			if group.isPrimary then
				return group
			end
		end

		return nil
	end, { groupsList })

	local v7 = React.useMemo(function()
		if not v6 then
			return groupsList
		end

		local groups = {}

		for i, group in ipairs(groupsList) do
			if group ~= v6 then
				table.insert(groups, group)
			end
		end

		return groups
	end, { groupsList, v6 })

	local v8 = React.useMemo(function()
		if v6 then
			return { v6 }
		end

		return {}
	end, { v6 })

	React.useEffect(function()
		if state ~= "" and ref.current then
			ref.current.CanvasPosition = Vector2.new(0, 0)
		end
	end, { state })
	local v9 = state ~= ""
	local v10 = React.useMemo(function()
		if not v9 then
			return nil
		end

		local v11 = string.lower(state)
		local idSet = {}

		for i, group in ipairs(groupsList) do
			local name = string.lower(group.name or "")

			if string.find(name, v11, 1, true) then
				idSet[group.id] = true
			end
		end

		return idSet
	end, { groupsList, state })

	local v11 = if v9 then not (v10 == nil) and next(v10) == nil else v9

	local v12 = React.useMemo(function()
		if props.isLoading or not props.groupsList then
			return nil
		end

		if props.loadFailure then
			return v5.loadFailure
		end

		if #groupsList == 0 then
			return v5.notInGroups
		end

		if v11 then
			return v5.noResults
		end

		return nil
	end, { props.isLoading, props.groupsList, props.loadFailure, v5, groupsList, v11 })

	local v13 = props.isLoading and #groupsList == 0

	local v14 = #v8 > 0 or #v7 > 0
	local v15

	if v13 then
		v15 = React.createElement(
			view,
			{
				tag = "col padding-small gap-small",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			renderSkeletons()
		)
	elseif v14 then
		local createElement = React.createElement
		local v17 = {
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				scrollBarVisibility = scrollBarVisibility.Auto,
				VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
			},
			scrollingFrameRef = ref,
			Size = UDim2.new(1, 0, 1, 0)
		}

		local createElement2 = React.createElement
		local v20 = {
			tag = "col gap-xlarge",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local children = {
			PrimarySection = React.createElement(GroupsListSection, {
				layoutOrder = 1,
				heading = v5.primaryHeading,
				groups = v8,
				showRank = true,
				showMemberCount = true,
				visibleIds = if v9 then v10 else nil
			}),
			OtherGroupsSection = 0
		}

		local createElement4 = React.createElement

		local v26 = if #v8 > 0 then v5.myGroupsHeading else nil

		if not v9 then
			v10 = nil
		end

		children.OtherGroupsSection = createElement4(GroupsListSection, {
			layoutOrder = 2,
			heading = v26,
			groups = v7,
			showRank = true,
			showMemberCount = true,
			visibleIds = v10
		})
		v15 = createElement(scrollView, v17, {
			ListWrapper = createElement2(view, v20, children)
		})
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col gap-xlarge",
			Size = UDim2.new(1, 0, 1, 0)
		},
		{
			Header = React.createElement(GroupsListHeader, { layoutOrder = 1 }),
			Toolbar = React.createElement(GroupsListToolbar, {
				layoutOrder = 2,
				canCreateGroup = props.canCreateGroup,
				onSearchTextChanged = setState
			}),
			Disclaimer = v12 and React.createElement(text, {
				LayoutOrder = 3,
				Text = v12,
				tag = "content-muted text-align-x-left text-body-medium"
			}) or nil,
			List = v15 and React.createElement(
				view,
				{ LayoutOrder = 4, tag = "fill", Size = UDim2.new(1, 0, 1, 0) },
				{ ListContent = v15 }
			) or nil
		}
	)
end

return GroupsList
