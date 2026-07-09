local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local TodoList = require(script.Parent.TodoList)
local matchesSearchQuery = require(BuildExperience.utils.matchesSearchQuery)
local Chip = Foundation.Chip
local Menu = Foundation.Menu
local SearchInput = Foundation.SearchInput
local View = Foundation.View
local useScaledValue = Foundation.Hooks.useScaledValue
local ChipSize = Foundation.Enums.ChipSize
local ChipVariant = Foundation.Enums.ChipVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local SubagentTaskStatus = CreatorAgentChat.SubagentTaskStatus
local v20 = game:DefineFastInt("BuildAgentDetailsStatusMenuWidth", 172)
local t1 = {
	{
		id = "All",
		status = nil,
		text = "All"
	},
	{
		text = "In progress",
		id = SubagentTaskStatus.InProgress,
		status = SubagentTaskStatus.InProgress
	},
	{
		text = "Done",
		id = SubagentTaskStatus.Done,
		status = SubagentTaskStatus.Done
	},
	{
		text = "Pending",
		id = SubagentTaskStatus.Pending,
		status = SubagentTaskStatus.Pending
	},
	{
		text = "Error",
		id = SubagentTaskStatus.Error,
		status = SubagentTaskStatus.Error
	},
	{
		text = "Deleted",
		id = SubagentTaskStatus.Deleted,
		status = SubagentTaskStatus.Deleted
	}
}

local function getStatusFilterText(p1) -- line: 54
	-- upvalues: t1 (copy)
	for _, v29 in t1 do
		if p1 == v29.status then
			return v29.text
		end
	end

	return p1 or "All"
end
local function taskMatchesSearch(p2, s1: string) -- line: 63
	-- upvalues: matchesSearchQuery (copy)
	return matchesSearchQuery(p2.text, s1) or matchesSearchQuery(p2.description, s1)
end
local function taskMatchesStatus(p3, p4) -- line: 67
	if p4 == nil then
		return true
	end

	return p4 == p3.status
end
local function shouldIncludeTask(p5, t2: {[any]: any}) -- line: 74
	-- upvalues: matchesSearchQuery (copy)
	local searchQuery = t2.searchQuery
	local v37 = matchesSearchQuery(p5.text, searchQuery) or matchesSearchQuery(p5.description, searchQuery)

	if v37 then
		local status = t2.status

		if status == nil then
			return true
		end

		v37 = status == p5.status
	end

	return v37
end
local function AgentDetailsList(t3: {[any]: any}) -- line: 78
	-- upvalues: React (copy), useScaledValue (copy), v20 (copy), matchesSearchQuery (copy), t1 (copy), View (copy), SearchInput (copy), Menu (copy), PopoverAlign (copy), PopoverSide (copy), InputSize (copy), Chip (copy), IconName (copy), ChipVariant (copy), ChipSize (copy), TodoList (copy)
	local v40, v41 = React.useState("")
	local v42, v43 = React.useState(nil)
	local v44, v45 = React.useState(false)
	local v46 = useScaledValue(v20)
	local t4 = {
		searchQuery = v40,
		status = v42
	}
	local t5 = {}
	local g80 = nil
	local text = nil

	for v49, v50 in t3.group.tasks do
		local searchQuery = t4.searchQuery
		local v52 = matchesSearchQuery(v50.text, searchQuery) or matchesSearchQuery(v50.description, searchQuery)

		if v52 then
			local status = t4.status

			v52 = status == nil or status == v50.status
		end

		if v52 then
			table.insert(t5, {
				title = v50.text,
				description = v50.description,
				status = v50.status,
				testId = `{ t3.testId or "build-agent-details-list" }-item-{ v49 }`
			})
		end
	end

	local v54 = React.useMemo(function() -- line: 101
		-- upvalues: t1 (copy), v42 (copy)
		local t6 = {}

		for _, v83 in t1 do
			table.insert(t6, {
				isDisabled = false,
				id = v83.id,
				text = v83.text,
				isChecked = v42 == v83.status
			})
		end

		return t6
	end, { v42 })
	local v55 = React.useCallback(function() -- line: 114
		-- upvalues: v45 (copy)
		v45(function(p6) -- line: 115
			return not p6
		end)
	end, {})
	local v56 = React.useCallback(function() -- line: 120
		-- upvalues: v45 (copy)
		v45(false)
	end, {})
	local v57 = React.useCallback(function(p7) -- line: 124
		-- upvalues: v43 (copy), v45 (copy)
		v43(if p7 ~= "All" then p7 else nil)
		v45(false)
	end, {})
	local createElement = React.createElement
	local v59 = View
	local t7 = {
		tag = "col gap-xxlarge size-full-0 auto-y padding-y-small",
		LayoutOrder = t3.LayoutOrder,
		testId = t3.testId or "build-agent-details-list"
	}
	local t8 = {}
	local createElement2 = React.createElement
	local v63 = View
	local t9 = {
		LayoutOrder = 1,
		tag = "col gap-small size-full-0 auto-y"
	}
	local t10 = {
		Search = React.createElement(SearchInput, {
			LayoutOrder = 1,
			placeholder = "Search tasks",
			text = v40,
			onChanged = v41,
			width = UDim.new(1, 0),
			testId = `{ t3.testId or "build-agent-details-list" }-search-input`
		})
	}
	local createElement3 = React.createElement
	local v67 = View
	local t11 = {
		LayoutOrder = 2,
		tag = "row align-y-center gap-small size-full-0 auto-y"
	}
	local t12 = {
		VersionChip = nil
	}
	local createElement4 = React.createElement
	local v71 = Menu
	local t13 = {
		LayoutOrder = 2,
		align = PopoverAlign.Start,
		isOpen = v44,
		items = v54,
		onActivated = v57,
		onPressedOutside = v56,
		side = PopoverSide.Bottom,
		size = InputSize.Medium,
		width = UDim.new(0, v46)
	}
	local t14 = {}
	local createElement5 = React.createElement
	local v75 = Chip
	local t15 = {
		LayoutOrder = 1
	}

	for _, v78 in t1 do
		if v42 == v78.status then
			text = v78.text
			g80 = true
		end

		if g80 then
			break
		end
	end

	if not g80 then
		text = v42 or "All"
	end

	g80 = false
	t15.text = text
	t15.trailing = IconName.ChevronLargeDown
	t15.variant = ChipVariant.Standard
	t15.size = ChipSize.Medium
	t15.onActivated = v55
	t15.testId = `{ t3.testId or "build-agent-details-list" }-status-filter-chip`
	t14.StatusChip = createElement5(v75, t15)
	t12.StatusMenu = createElement4(v71, t13, t14)
	t10.Chips = createElement3(v67, t11, t12)
	t8.Filters = createElement2(v63, t9, t10)
	t8.List = React.createElement(TodoList, {
		layoutOrder = 2,
		items = t5
	})

	return createElement(v59, t7, t8)
end

return React.memo(AgentDetailsList)
