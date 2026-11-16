local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local ScrollView = Foundation.ScrollView
local View = Foundation.View
local Text = Foundation.Text
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility

local TextKeys = require(Groups.Common.TextKeys)
require(Groups.Common.Types)
local GroupsListToolbar = require(script.Parent.GroupsListToolbar)
local GroupsListSection = require(script.Parent.GroupsListSection)
local GroupsListHeader = require(script.Parent.GroupsListHeader)
local GroupListItemSkeleton = require(script.Parent.GroupListItemSkeleton)

local frozen = table.freeze({})

local function renderSkeletons()
	local children = {}

	for i = 1, 3 do
		children[`Skeleton_{i}`] = React.createElement(GroupListItemSkeleton, { layoutOrder = i })
	end

	return children
end

local function GroupsList(props)
	local v = useLocalization({
		primaryHeading = TextKeys.HeadingPrimary,
		myGroupsHeading = TextKeys.HeadingMyGroups,
		loadFailure = TextKeys.MessageLoadGroupListError,
		notInGroups = TextKeys.MessageNotInAnyGroups,
		noResults = TextKeys.MessageNoGroupsFound
	})

	local groupsList = props.groupsList or frozen
	local state, setState = React.useState("")
	local ref = React.useRef(nil)

	local v2 = React.useMemo(function()
		for _, group in ipairs(groupsList) do
			if group.isPrimary then
				return group
			end
		end

		return nil
	end, { groupsList })

	local groups = React.useMemo(function()
		if not v2 then
			return groupsList
		end

		local groups = {}

		for _, group in ipairs(groupsList) do
			if group ~= v2 then
				table.insert(groups, group)
			end
		end

		return groups
	end, { groupsList, v2 })

	local groups2 = React.useMemo(function()
		if v2 then
			return { v2 }
		end

		return {}
	end, { v2 })

	React.useEffect(function()
		if state ~= "" and ref.current then
			ref.current.CanvasPosition = Vector2.new(0, 0)
		end
	end, { state })
	local v3 = state ~= ""
	local visibleIds = React.useMemo(function()
		if not v3 then
			return nil
		end

		local v4 = string.lower(state)
		local idSet = {}

		for _, group in ipairs(groupsList) do
			local name = string.lower(group.name or "")

			if string.find(name, v4, 1, true) then
				idSet[group.id] = true
			end
		end

		return idSet
	end, { groupsList, state })
	local v4

	if v3 then
		if visibleIds == nil then
			v4 = false
		else
			v4 = next(visibleIds) == nil
		end
	else
		v4 = v3
	end

	local text = React.useMemo(function()
		if props.isLoading or not props.groupsList then
			return nil
		end

		if props.loadFailure then
			return v.loadFailure
		end

		if #groupsList == 0 then
			return v.notInGroups
		end

		return if v4 then v.noResults else nil
	end, { props.isLoading, props.groupsList, props.loadFailure, v, groupsList, v4 })

	local v5 = props.isLoading and #groupsList == 0

	local v6 = #groups2 > 0 or #groups > 0
	local listContent

	if v5 then
		listContent = React.createElement(
			View,
			{
				tag = "col padding-small gap-small",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			renderSkeletons()
		)
	elseif v6 then
		local createElement = React.createElement
		local v7 = {
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				scrollBarVisibility = ScrollBarVisibility.Auto,
				VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
			},
			scrollingFrameRef = ref,
			Size = UDim2.new(1, 0, 1, 0)
		}

		local createElement2 = React.createElement
		local v8 = {
			tag = "col gap-xlarge",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}

		local createElement3 = React.createElement
		local v9 = {
			layoutOrder = 1,
			heading = v.primaryHeading,
			groups = groups2,
			showRank = true,
			showMemberCount = true,
			visibleIds = 0
		}
		local visibleIds2

		if v3 then
			visibleIds2 = visibleIds
		end

		v9.visibleIds = visibleIds2
		local children = {
			PrimarySection = createElement3(GroupsListSection, v9),
			OtherGroupsSection = 0
		}

		local createElement4 = React.createElement
		local heading

		if #groups2 > 0 then
			heading = v.myGroupsHeading
		end

		if not v3 then
			visibleIds = nil
		end

		children.OtherGroupsSection = createElement4(GroupsListSection, {
			layoutOrder = 2,
			heading = heading,
			groups = groups,
			showRank = true,
			showMemberCount = true,
			visibleIds = visibleIds
		})
		listContent = createElement(ScrollView, v7, {
			ListWrapper = createElement2(View, v8, children)
		})
	end

	return React.createElement(
		View,
		{ LayoutOrder = props.layoutOrder, tag = "col gap-xlarge", Size = UDim2.new(1, 0, 1, 0) },
		{
			Header = React.createElement(GroupsListHeader, { layoutOrder = 1 }),
			Toolbar = React.createElement(GroupsListToolbar, {
				layoutOrder = 2,
				canCreateGroup = props.canCreateGroup,
				onSearchTextChanged = setState
			}),
			Disclaimer = text and React.createElement(Text, {
				LayoutOrder = 3,
				Text = text,
				tag = "content-muted text-align-x-left text-body-medium"
			}) or nil,
			List = listContent and React.createElement(
				View,
				{ LayoutOrder = 4, tag = "fill", Size = UDim2.new(1, 0, 1, 0) },
				{ ListContent = listContent }
			) or nil
		}
	)
end

return GroupsList
