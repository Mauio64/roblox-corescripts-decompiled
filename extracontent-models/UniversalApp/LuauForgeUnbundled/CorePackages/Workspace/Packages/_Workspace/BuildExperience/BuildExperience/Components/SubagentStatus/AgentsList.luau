local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local LoadingIndicator = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SubagentStatus/LoadingIndicator")

local icon = Foundation.Icon
local scrollView = Foundation.ScrollView
local text = Foundation.Text
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens

local subagentTaskCategory = CreatorAgentChat.SubagentTaskCategory
local v5 = {
	subagentTaskCategory.Gameplay,
	subagentTaskCategory.Art,
	subagentTaskCategory.Audio,
	subagentTaskCategory.Marketing
}

local v6 = {
	Art = iconName.TwoMakeupBrushes,
	Audio = iconName.FiveVerticalLinesWave,
	Gameplay = iconName.Controller,
	Marketing = iconName.Wallet
}

local function getDisplayGroups(groups)
	local v7 = {}

	for k, item in groups do
		v7[item.name] = item
	end

	local displayGroups = {}

	for k, v8 in v5 do
		table.insert(
			displayGroups,
			v7[v8] or { name = v8, tasks = {}, isComplete = false, isLoading = false }
		)

		v7[v8] = nil
	end

	for k, item in groups do
		if v7[item.name] == nil then
			continue
		end

		table.insert(displayGroups, item)
		v7[item.name] = nil
	end

	return displayGroups
end

local function AgentTaskList(props)
	local v7, v8 = React.useBinding(0)
	local mapped = v7:map(function(p2)
		return UDim2.new(1, 0, 0, p2)
	end)

	local v9 = React.useCallback(function(p2)
		v8(p2.AbsoluteCanvasSize.Y)
	end, { v8 })

	return React.createElement(scrollView, {
		LayoutOrder = props.LayoutOrder,
		Size = mapped,
		onAbsoluteCanvasSizeChanged = v9,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			scrollBarVisibility = scrollBarVisibility.None,
			ScrollingDirection = Enum.ScrollingDirection.Y
		},
		tag = "shrink",
		testId = props.testId
	}, {
		Content = React.createElement(view, {
			onActivated = props.onActivated,
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, props.taskGap)
			},
			stateLayer = { affordance = stateLayerAffordance.None },
			tag = "col size-full-0 auto-y",
			testId = `{props.testId}-content`
		}, props.children)
	})
end

local function AgentCard(props)
	local group = props.group
	local v7 = useLocalization({
		building = LocalizationStrings.SUBAGENT_STATUS_BUILDING,
		completedTasks = {
			LocalizationStrings.SUBAGENT_STATUS_COMPLETED_TASKS,
			COUNT = #group.tasks
		},
		notStarted = LocalizationStrings.SUBAGENT_STATUS_NOT_STARTED
	})
	local v8

	if #group.tasks == 0 then
		v8 = v7.notStarted
	else
		v8 = if group.isComplete then v7.completedTasks else v7.building
	end

	local v9 = v6[group.name]
	local v10 = React.useCallback(function()
		props.onAgentActivated(group)
	end, { props.onAgentActivated, group })
	local children = {}

	for k, task2 in group.tasks do
		children[`Task{k}`] = React.createElement(
			view,
			{
				LayoutOrder = k,
				tag = "row align-y-center gap-small size-full-0 auto-y",
				testId = `{props.testId}-card-{props.index}-task-{k}`
			},
			{
				Label = React.createElement(text, {
					LayoutOrder = 1,
					Text = task2.text,
					tag = "fill auto-y text-body-small text-align-x-left text-truncate-end content-emphasis"
				}),
				Status = React.createElement(LoadingIndicator, {
					layoutOrder = 2,
					status = task2.status,
					testId = `{props.testId}-card-{props.index}-task-{k}`
				})
			}
		)
	end

	local createElement = React.createElement
	local v12 = {
		LayoutOrder = props.index,
		onActivated = 0,
		sizeConstraint = 0,
		tag = "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-emphasis radius-large",
		testId = 0
	}
	local v13 = if #group.tasks > 0 then v10 else nil
	v12.onActivated = v13
	v12.sizeConstraint = {
		MaxSize = Vector2.new(1e999, props.maxHeight)
	}

	v12.testId = `{props.testId}-card-{props.index}-container`

	local createElement2 = React.createElement
	local v16 = {
		LayoutOrder = 1,
		tag = "row align-y-center gap-small size-full-0 auto-y",
		testId = `{props.testId}-card-{props.index}`
	}

	local v17 = if v9 ~= nil then React.createElement(icon, {
		LayoutOrder = 1,
		name = v9,
		size = iconSize.Small,
		tag = "auto-xy content-emphasis",
		testId = `{props.testId}-card-{props.index}-category-icon`
	}) else nil
	local v14 = {
		Header = createElement2(view, v16, {
			Icon = v17,
			Title = React.createElement(text, {
				LayoutOrder = 2,
				Text = group.name,
				tag = "fill auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
			}),
			Status = React.createElement(text, {
				LayoutOrder = 3,
				Text = v8,
				tag = "auto-xy padding-left-large text-body-small text-align-x-right content-emphasis"
			})
		}),
		Tasks = 0
	}

	local v18 = if #group.tasks > 0 then React.createElement(
		AgentTaskList,
		{
			LayoutOrder = 2,
			onActivated = v10,
			taskGap = props.taskGap,
			testId = `{props.testId}-card-{props.index}-tasks`
		},
		children
	) else nil
	v14.Tasks = v18
	return createElement(view, v12, v14)
end

local function AgentsList(props)
	local v7 = useTokens()
	local v8 = useScaledValue(156)
	local testId = props.testId or "build-agent-list"
	local children = {}

	for k, v9 in getDisplayGroups(props.groups) do
		children[`Card{k}`] = React.createElement(AgentCard, {
			group = v9,
			index = k,
			maxHeight = v8,
			onAgentActivated = props.onAgentActivated,
			taskGap = v7.Gap.Small,
			testId = testId
		})
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "col gap-medium size-full-0 auto-y padding-y-medium",
			testId = testId
		},
		children
	)
end

return React.memo(AgentsList)
