local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local React = require(GroupsParent.React)
local Foundation = require(GroupsParent.Foundation)
local useLocalization = require(GroupsParent.Localization).Hooks.useLocalization
local ScrollView = Foundation.ScrollView
local View = Foundation.View
local FoundationText = Foundation.Text
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local TextKeys = require(Groups.Common.TextKeys)

require(Groups.Common.Types)

local GroupsListToolbar = require(script.Parent.GroupsListToolbar)
local GroupsListSection = require(script.Parent.GroupsListSection)
local GroupsListHeader = require(script.Parent.GroupsListHeader)
local GroupListItemSkeleton = require(script.Parent.GroupListItemSkeleton)
local v15 = table.freeze({})

local function renderSkeletons() -- line: 33
	-- upvalues: React (copy), GroupListItemSkeleton (copy)
	local t1 = {}

	for i = 1, 3 do
		t1[`Skeleton_{ i }`] = React.createElement(GroupListItemSkeleton, {
			layoutOrder = i
		})
	end

	return t1
end
local function GroupsList(t2: {[any]: any}) -- line: 43
	-- upvalues: useLocalization (copy), TextKeys (copy), v15 (copy), React (copy), View (copy), renderSkeletons (copy), ScrollView (copy), ScrollBarVisibility (copy), GroupsListSection (copy), GroupsListHeader (copy), GroupsListToolbar (copy), FoundationText (copy)
	local v21 = useLocalization({
		primaryHeading = TextKeys.HeadingPrimary,
		myGroupsHeading = TextKeys.HeadingMyGroups,
		loadFailure = TextKeys.MessageLoadGroupListError,
		notInGroups = TextKeys.MessageNotInAnyGroups,
		noResults = TextKeys.MessageNoGroupsFound
	})
	local v22 = t2.groupsList or v15
	local v23, v24 = React.useState("")
	local v25 = React.useRef(nil)
	local v26 = React.useMemo(function() -- line: 56
		-- upvalues: v22 (copy)
		for _, v in ipairs(v22) do
			if v.isPrimary then
				return v
			end
		end

		return nil
	end, { v22 })
	local v27 = React.useMemo(function() -- line: 65
		-- upvalues: v26 (copy), v22 (copy)
		if not v26 then
			return v22
		end

		local t3 = {}

		for _, v in ipairs(v22) do
			if v ~= v26 then
				table.insert(t3, v)
			end
		end

		return t3
	end, {
		v22,
		v26
	})
	local v28 = React.useMemo(function() -- line: 79
		-- upvalues: v26 (copy)
		if v26 then
			return { v26 }
		end

		return {}
	end, { v26 })

	React.useEffect(function() -- line: 86
		-- upvalues: v23 (copy), v25 (copy)
		if v23 ~= "" and v25.current then
			v25.current.CanvasPosition = Vector2.new(0, 0)
		end
	end, { v23 })

	local v29 = v23 ~= ""
	local v30 = React.useMemo(function() -- line: 94
		-- upvalues: v29 (copy), v23 (copy), v22 (copy)
		if not v29 then
			return nil
		end

		local v41 = string.lower(v23)
		local t4 = {}

		for _, v in ipairs(v22) do
			local v45 = string.lower(v.name or "")

			if string.find(v45, v41, 1, true) then
				t4[v.id] = true
			end
		end

		return t4
	end, {
		v22,
		v23
	})
	local v31 = v29 and (v30 ~= nil and next(v30) == nil)
	local v32 = React.useMemo(function() -- line: 111
		-- upvalues: t2 (copy), v21 (copy), v22 (copy), v31 (copy)
		if t2.isLoading or not t2.groupsList then
			return nil
		end

		if t2.loadFailure then
			return v21.loadFailure
		end

		if #v22 == 0 then
			return v21.notInGroups
		end

		if v31 then
			return v21.noResults
		end

		return nil
	end, {
		t2.isLoading,
		t2.groupsList,
		t2.loadFailure,
		v21,
		v22,
		v31
	})
	local v33 = t2.isLoading and #v22 == 0
	local v34 = #v28 > 0 or #v27 > 0
	local v35 = if not v33 then if not v34 then nil else React.createElement(ScrollView, {
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = ScrollBarVisibility.Auto,
			VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
		},
		scrollingFrameRef = v25,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		ListWrapper = React.createElement(View, {
			tag = "col gap-xlarge",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			PrimarySection = React.createElement(GroupsListSection, {
				layoutOrder = 1,
				showRank = true,
				showMemberCount = true,
				heading = v21.primaryHeading,
				groups = v28,
				visibleIds = if not v29 then nil else v30
			}),
			OtherGroupsSection = React.createElement(GroupsListSection, {
				layoutOrder = 2,
				showRank = true,
				showMemberCount = true,
				heading = if not (#v28 > 0) then nil else v21.myGroupsHeading,
				groups = v27,
				visibleIds = if not v29 then nil else v30
			})
		})
	}) else React.createElement(View, {
		tag = "col padding-small gap-small",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, (renderSkeletons()))

	return React.createElement(View, {
		tag = "col gap-xlarge",
		LayoutOrder = t2.layoutOrder,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Header = React.createElement(GroupsListHeader, {
			layoutOrder = 1
		}),
		Toolbar = React.createElement(GroupsListToolbar, {
			layoutOrder = 2,
			canCreateGroup = t2.canCreateGroup,
			onSearchTextChanged = v24
		}),
		Disclaimer = v32 and React.createElement(FoundationText, {
			LayoutOrder = 3,
			tag = "content-muted text-align-x-left text-body-medium",
			Text = v32
		}) or nil,
		List = v35 and React.createElement(View, {
			LayoutOrder = 4,
			tag = "fill",
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			ListContent = v35
		}) or nil
	})
end

return GroupsList
