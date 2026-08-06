local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
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
local v21 = game:DefineFastInt("BuildAgentDetailsStatusMenuWidth", 172)
local t1 = {
	{
		id = "All",
		status = nil,
		text = LocalizationStrings.SUBAGENT_STATUS_ALL
	},
	{
		id = SubagentTaskStatus.InProgress,
		status = SubagentTaskStatus.InProgress,
		text = LocalizationStrings.SUBAGENT_STATUS_IN_PROGRESS
	},
	{
		id = SubagentTaskStatus.Done,
		status = SubagentTaskStatus.Done,
		text = LocalizationStrings.SUBAGENT_STATUS_DONE
	},
	{
		id = SubagentTaskStatus.Pending,
		status = SubagentTaskStatus.Pending,
		text = LocalizationStrings.SUBAGENT_STATUS_PENDING
	},
	{
		id = SubagentTaskStatus.Error,
		status = SubagentTaskStatus.Error,
		text = LocalizationStrings.SUBAGENT_STATUS_ERROR
	},
	{
		id = SubagentTaskStatus.Deleted,
		status = SubagentTaskStatus.Deleted,
		text = LocalizationStrings.SUBAGENT_STATUS_DELETED
	}
}

local function getStatusFilterText(p1) -- line: 73
	-- upvalues: t1 (copy)
	for _, v30 in t1 do
		if p1 == v30.status then
			return v30.text
		end
	end

	return p1 or "All"
end
local function taskMatchesSearch(p2, s1: string) -- line: 82
	-- upvalues: matchesSearchQuery (copy)
	return matchesSearchQuery(p2.text, s1) or matchesSearchQuery(p2.description, s1)
end
local function taskMatchesStatus(p3, p4) -- line: 86
	if p4 == nil then
		return true
	end

	return p4 == p3.status
end
local function shouldIncludeTask(p5, t2: {[any]: any}) -- line: 93
	-- upvalues: matchesSearchQuery (copy)
	local searchQuery = t2.searchQuery
	local v38 = matchesSearchQuery(p5.text, searchQuery) or matchesSearchQuery(p5.description, searchQuery)

	if v38 then
		local status = t2.status

		if status == nil then
			return true
		end

		v38 = status == p5.status
	end

	return v38
end
local function AgentDetailsList(t3: {[any]: any}) -- line: 97
	-- upvalues: React (copy), useScaledValue (copy), v21 (copy), matchesSearchQuery (copy), t1 (copy), View (copy), SearchInput (copy), LocalizationStrings (copy), Menu (copy), PopoverAlign (copy), PopoverSide (copy), InputSize (copy), Chip (copy), IconName (copy), ChipVariant (copy), ChipSize (copy), TodoList (copy)
	local v41, v42 = React.useState("")
	local v43, v44 = React.useState(nil)
	local v45, v46 = React.useState(false)
	local v47 = useScaledValue(v21)
	local t4 = {
		searchQuery = v41,
		status = v43
	}
	local t5 = {}
	local g81 = nil
	local text = nil

	for v50, v51 in t3.group.tasks do
		local searchQuery = t4.searchQuery
		local v53 = matchesSearchQuery(v51.text, searchQuery) or matchesSearchQuery(v51.description, searchQuery)

		if v53 then
			local status = t4.status

			v53 = status == nil or status == v51.status
		end

		if v53 then
			table.insert(t5, {
				title = v51.text,
				description = v51.description,
				status = v51.status,
				testId = `{ t3.testId or "build-agent-details-list" }-item-{ v50 }`
			})
		end
	end

	local v55 = React.useMemo(function() -- line: 120
		-- upvalues: t1 (copy), v43 (copy)
		local t6 = {}

		for _, v84 in t1 do
			table.insert(t6, {
				isDisabled = false,
				id = v84.id,
				text = v84.text,
				isChecked = v43 == v84.status
			})
		end

		return t6
	end, { v43 })
	local v56 = React.useCallback(function() -- line: 133
		-- upvalues: v46 (copy)
		v46(function(p6) -- line: 134
			return not p6
		end)
	end, {})
	local v57 = React.useCallback(function() -- line: 139
		-- upvalues: v46 (copy)
		v46(false)
	end, {})
	local v58 = React.useCallback(function(p7) -- line: 143
		-- upvalues: v44 (copy), v46 (copy)
		v44(if p7 ~= "All" then p7 else nil)
		v46(false)
	end, {})
	local createElement = React.createElement
	local v60 = View
	local t7 = {
		tag = "col gap-xxlarge size-full-0 auto-y padding-y-small",
		LayoutOrder = t3.LayoutOrder,
		testId = t3.testId or "build-agent-details-list"
	}
	local t8 = {}
	local createElement2 = React.createElement
	local v64 = View
	local t9 = {
		LayoutOrder = 1,
		tag = "col gap-small size-full-0 auto-y"
	}
	local t10 = {
		Search = React.createElement(SearchInput, {
			LayoutOrder = 1,
			text = v41,
			placeholder = LocalizationStrings.SUBAGENT_STATUS_SEARCH_TASKS,
			onChanged = v42,
			width = UDim.new(1, 0),
			testId = `{ t3.testId or "build-agent-details-list" }-search-input`
		})
	}
	local createElement3 = React.createElement
	local v68 = View
	local t11 = {
		LayoutOrder = 2,
		tag = "row align-y-center gap-small size-full-0 auto-y"
	}
	local t12 = {
		VersionChip = nil
	}
	local createElement4 = React.createElement
	local v72 = Menu
	local t13 = {
		LayoutOrder = 2,
		align = PopoverAlign.Start,
		isOpen = v45,
		items = v55,
		onActivated = v58,
		onPressedOutside = v57,
		side = PopoverSide.Bottom,
		size = InputSize.Medium,
		width = UDim.new(0, v47)
	}
	local t14 = {}
	local createElement5 = React.createElement
	local v76 = Chip
	local t15 = {
		LayoutOrder = 1
	}

	for _, v79 in t1 do
		if v43 == v79.status then
			text = v79.text
			g81 = true
		end

		if g81 then
			break
		end
	end

	if not g81 then
		text = v43 or "All"
	end

	g81 = false
	t15.text = text
	t15.trailing = IconName.ChevronLargeDown
	t15.variant = ChipVariant.Standard
	t15.size = ChipSize.Medium
	t15.onActivated = v56
	t15.testId = `{ t3.testId or "build-agent-details-list" }-status-filter-chip`
	t14.StatusChip = createElement5(v76, t15)
	t12.StatusMenu = createElement4(v72, t13, t14)
	t10.Chips = createElement3(v68, t11, t12)
	t8.Filters = createElement2(v64, t9, t10)
	t8.List = React.createElement(TodoList, {
		layoutOrder = 2,
		items = t5
	})

	return createElement(v60, t7, t8)
end

return React.memo(AgentDetailsList)
