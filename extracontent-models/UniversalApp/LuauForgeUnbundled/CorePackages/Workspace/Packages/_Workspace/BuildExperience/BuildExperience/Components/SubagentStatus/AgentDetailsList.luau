local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local TodoList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SubagentStatus/TodoList")
local matchesSearchQuery = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/matchesSearchQuery")

local chip = Foundation.Chip
local menu = Foundation.Menu
local searchInput = Foundation.SearchInput
local view = Foundation.View
local useScaledValue = Foundation.Hooks.useScaledValue
local chipSize = Foundation.Enums.ChipSize
local chipVariant = Foundation.Enums.ChipVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide

local subagentTaskStatus = CreatorAgentChat.SubagentTaskStatus

local defineFastInt = game:DefineFastInt("BuildAgentDetailsStatusMenuWidth", 172)

local function getStatusFilterText(items, value)
	for k, item in items do
		if item.status == value then
			return item.text
		end
	end

	return value or "All"
end

local function taskMatchesSearch(p2, p3)
	return matchesSearchQuery(p2.text, p3) or matchesSearchQuery(p2.description, p3)
end

local function taskMatchesStatus(p2, p3): boolean
	if p3 == nil then
		return true
	end

	return p2.status == p3
end

local function shouldIncludeTask(data, p2)
	local searchQuery = p2.searchQuery
	local v5 = matchesSearchQuery(data.text, searchQuery) or matchesSearchQuery(data.description, searchQuery)

	if not v5 then
		return v5
	end

	local status = p2.status

	if status == nil then
		return true
	end

	v5 = data.status == status
	return v5
end

local function AgentDetailsList(props)
	local state, setState = React.useState("")
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(false)
	local v5 = useScaledValue(defineFastInt)
	local v6 = useLocalization({
		all = LocalizationStrings.SUBAGENT_STATUS_ALL,
		deleted = LocalizationStrings.SUBAGENT_STATUS_DELETED,
		done = LocalizationStrings.SUBAGENT_STATUS_DONE,
		error = LocalizationStrings.SUBAGENT_STATUS_ERROR,
		inProgress = LocalizationStrings.SUBAGENT_STATUS_IN_PROGRESS,
		pending = LocalizationStrings.SUBAGENT_STATUS_PENDING,
		searchTasks = LocalizationStrings.SUBAGENT_STATUS_SEARCH_TASKS,
		version = LocalizationStrings.SUBAGENT_STATUS_VERSION
	})

	local searchTasks = v6.searchTasks
	local version = v6.version
	local v7 = {
		{ id = "All", status = nil, text = v6.all },
		{
			id = subagentTaskStatus.InProgress,
			status = subagentTaskStatus.InProgress,
			text = v6.inProgress
		},
		{
			id = subagentTaskStatus.Done,
			status = subagentTaskStatus.Done,
			text = v6.done
		},
		{
			id = subagentTaskStatus.Pending,
			status = subagentTaskStatus.Pending,
			text = v6.pending
		},
		{
			id = subagentTaskStatus.Error,
			status = subagentTaskStatus.Error,
			text = v6.error
		},
		{
			id = subagentTaskStatus.Deleted,
			status = subagentTaskStatus.Deleted,
			text = v6.deleted
		}
	}

	local v8 = { searchQuery = state, status = state2 }

	local v9 = {}

	for k, task2 in props.group.tasks do
		local searchQuery = v8.searchQuery
		local v10 = matchesSearchQuery(task2.text, searchQuery) or matchesSearchQuery(task2.description, searchQuery)

		if v10 then
			local status = v8.status
			v10 = status == nil or task2.status == status
		end

		if v10 then
			table.insert(v9, {
				title = task2.text,
				description = task2.description,
				status = task2.status,
				testId = `{props.testId or "build-agent-details-list"}-item-{k}`
			})
		end
	end

	local function buildStatusMenuItems()
		local statusMenuItems = {}

		for k, v10 in v7 do
			table.insert(statusMenuItems, {
				id = v10.id,
				text = v10.text,
				isChecked = state2 == v10.status,
				isDisabled = false
			})
		end

		return statusMenuItems
	end

	local statusMenuItems = buildStatusMenuItems()

	local v10 = React.useCallback(function()
		setState3(function(p2): boolean
			return not p2
		end)
	end, {})

	local v11 = React.useCallback(function()
		setState3(false)
	end, {})

	local v12 = React.useCallback(function(p2)
		if p2 == "All" then
			p2 = nil
		end

		setState2(p2)
		setState3(false)
	end, {})

	local createElement = React.createElement
	local v14 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-xxlarge size-full-0 auto-y padding-y-small",
		testId = props.testId or "build-agent-details-list"
	}

	local createElement2 = React.createElement

	local v16 = {
		Search = React.createElement(searchInput, {
			LayoutOrder = 1,
			text = state,
			placeholder = searchTasks,
			onChanged = setState,
			width = UDim.new(1, 0),
			testId = `{props.testId or "build-agent-details-list"}-search-input`
		}),
		Chips = 0
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local v19 = {
		LayoutOrder = 2,
		align = popoverAlign.Start,
		isOpen = state3,
		items = statusMenuItems,
		onActivated = v12,
		onPressedOutside = v11,
		side = popoverSide.Bottom,
		size = inputSize.Medium,
		width = UDim.new(0, v5)
	}

	local createElement5 = React.createElement
	local v21 = {
		LayoutOrder = 1,
		text = 0,
		trailing = 0,
		variant = 0,
		size = 0,
		onActivated = 0,
		testId = 0
	}
	local v22 = { StatusChip = 0 }
	local v23 = { VersionChip = nil, StatusMenu = 0 }
	local children = { Filters = 0, List = 0 }
	local flag = true
	local v26

	for k, v27 in v7 do
		if v27.status == state2 then
			v26 = v27.text
			flag = false
			break
		end
	end

	if flag then
		v26 = state2 or "All"
	end

	v21.text = v26
	v21.trailing = iconName.ChevronLargeDown
	v21.variant = chipVariant.Standard
	v21.size = chipSize.Medium
	v21.onActivated = v10
	v21.testId = `{props.testId or "build-agent-details-list"}-status-filter-chip`
	v22.StatusChip = createElement5(chip, v21)
	v23.StatusMenu = createElement4(menu, v19, v22)
	v16.Chips = createElement3(
		view,
		{ LayoutOrder = 2, tag = "row align-y-center gap-small size-full-0 auto-y" },
		v23
	)
	children.Filters = createElement2(
		view,
		{ LayoutOrder = 1, tag = "col gap-small size-full-0 auto-y" },
		v16
	)

	children.List = React.createElement(TodoList, { layoutOrder = 2, items = v9 })
	return createElement(view, v14, children)
end

return React.memo(AgentDetailsList)
