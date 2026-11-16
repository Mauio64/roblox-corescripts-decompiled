local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
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

local defineFastInt = game:DefineFastInt("BuildAgentDetailsStatusMenuWidth", 172)

local function getStatusFilterText(items, state) -- 1 equivalent call inferred from this helper
	for _, item in items do
		if item.status == state then
			return item.text
		end
	end

	return state or "All"
end

local function taskMatchesSearch(p, searchQuery: string) -- 2 equivalent calls inferred from this helper
	return matchesSearchQuery(p.text, searchQuery) or matchesSearchQuery(p.description, searchQuery)
end

local function taskMatchesStatus(p, p2): boolean
	return p2 == nil or p.status == p2
end

local function shouldIncludeTask(p, p2)
	local v = taskMatchesSearch(p, p2.searchQuery) -- inferred equivalent call

	if not v then
		return v
	end

	local status = p2.status
	return status == nil or p.status == status
end

local function AgentDetailsList(props)
	local state, setState = React.useState("")
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(false)
	local v = useScaledValue(defineFastInt)
	local v2 = useLocalization({
		all = LocalizationStrings.SUBAGENT_STATUS_ALL,
		deleted = LocalizationStrings.SUBAGENT_STATUS_DELETED,
		done = LocalizationStrings.SUBAGENT_STATUS_DONE,
		error = LocalizationStrings.SUBAGENT_STATUS_ERROR,
		inProgress = LocalizationStrings.SUBAGENT_STATUS_IN_PROGRESS,
		pending = LocalizationStrings.SUBAGENT_STATUS_PENDING,
		searchTasks = LocalizationStrings.SUBAGENT_STATUS_SEARCH_TASKS,
		version = LocalizationStrings.SUBAGENT_STATUS_VERSION
	})

	local searchTasks = v2.searchTasks
	local _version = v2.version
	local v3 = {
		{ id = "All", status = nil, text = v2.all },
		{
			id = SubagentTaskStatus.InProgress,
			status = SubagentTaskStatus.InProgress,
			text = v2.inProgress
		},
		{ id = SubagentTaskStatus.Done, status = SubagentTaskStatus.Done, text = v2.done },
		{ id = SubagentTaskStatus.Pending, status = SubagentTaskStatus.Pending, text = v2.pending },
		{ id = SubagentTaskStatus.Error, status = SubagentTaskStatus.Error, text = v2.error },
		{ id = SubagentTaskStatus.Deleted, status = SubagentTaskStatus.Deleted, text = v2.deleted }
	}

	local v4 = { searchQuery = state, status = state2 }

	local items = {}

	for k, task in props.group.tasks do
		local v5 = taskMatchesSearch(task, v4.searchQuery) -- inferred equivalent call

		if v5 then
			local status = v4.status
			v5 = status == nil or task.status == status
		end

		if v5 then
			table.insert(items, {
				title = task.text,
				description = task.description,
				status = task.status,
				testId = `{props.testId or "build-agent-details-list"}-item-{k}`
			})
		end
	end

	local function buildStatusMenuItems()
		local statusMenuItems = {}

		for _, v5 in v3 do
			table.insert(statusMenuItems, {
				id = v5.id,
				text = v5.text,
				isChecked = state2 == v5.status,
				isDisabled = false
			})
		end

		return statusMenuItems
	end

	local statusMenuItems = buildStatusMenuItems()

	local onActivated = React.useCallback(function()
		setState3(function(p): boolean
			return not p
		end)
	end, {})

	local onPressedOutside = React.useCallback(function()
		setState3(false)
	end, {})

	local onActivated2 = React.useCallback(function(p)
		if p == "All" then
			p = nil
		end

		setState2(p)
		setState3(false)
	end, {})

	return React.createElement(View, {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-xxlarge size-full-0 auto-y padding-y-small",
		testId = props.testId or "build-agent-details-list"
	}, {
		Filters = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-small size-full-0 auto-y"
		}, {
			Search = React.createElement(SearchInput, {
				LayoutOrder = 1,
				text = state,
				placeholder = searchTasks,
				onChanged = setState,
				width = UDim.new(1, 0),
				testId = `{props.testId or "build-agent-details-list"}-search-input`
			}),
			Chips = React.createElement(
				View,
				{ LayoutOrder = 2, tag = "row align-y-center gap-small size-full-0 auto-y" },
				{
					VersionChip = nil,
					StatusMenu = React.createElement(Menu, {
						LayoutOrder = 2,
						align = PopoverAlign.Start,
						isOpen = state3,
						items = statusMenuItems,
						onActivated = onActivated2,
						onPressedOutside = onPressedOutside,
						side = PopoverSide.Bottom,
						size = InputSize.Medium,
						width = UDim.new(0, v)
					}, {
						StatusChip = React.createElement(Chip, {
							LayoutOrder = 1,
							text = getStatusFilterText(v3, state2), -- inferred equivalent call
							trailing = IconName.ChevronLargeDown,
							variant = ChipVariant.Standard,
							size = ChipSize.Medium,
							onActivated = onActivated,
							testId = `{props.testId or "build-agent-details-list"}-status-filter-chip`
						})
					})
				}
			)
		}),
		List = React.createElement(TodoList, { layoutOrder = 2, items = items })
	})
end

return React.memo(AgentDetailsList)
