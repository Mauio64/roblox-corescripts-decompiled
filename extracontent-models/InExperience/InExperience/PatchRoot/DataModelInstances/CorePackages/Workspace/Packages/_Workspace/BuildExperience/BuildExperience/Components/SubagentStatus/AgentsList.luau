local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local LoadingIndicator = require(script.Parent.LoadingIndicator)

local Icon = Foundation.Icon
local ScrollView = Foundation.ScrollView
local Text = Foundation.Text
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens

local SubagentTaskCategory = CreatorAgentChat.SubagentTaskCategory
local v = {
	SubagentTaskCategory.Gameplay,
	SubagentTaskCategory.Art,
	SubagentTaskCategory.Audio,
	SubagentTaskCategory.Marketing
}

local v2 = {
	Art = IconName.TwoMakeupBrushes,
	Audio = IconName.FiveVerticalLinesWave,
	Gameplay = IconName.Controller,
	Marketing = IconName.Wallet
}

local function getDisplayGroups(groups)
	local v3 = {}

	for _, item in groups do
		v3[item.name] = item
	end

	local displayGroups = {}

	for _, name in v do
		table.insert(displayGroups, v3[name] or {
			name = name,
			tasks = {},
			isComplete = false,
			isLoading = false
		})

		v3[name] = nil
	end

	for _, item in groups do
		if v3[item.name] == nil then
			continue
		end

		table.insert(displayGroups, item)
		v3[item.name] = nil
	end

	return displayGroups
end

local function AgentTaskList(props)
	local v3, v4 = React.useBinding(0)
	local mapped = v3:map(function(p)
		return UDim2.new(1, 0, 0, p)
	end)

	local onAbsoluteCanvasSizeChanged = React.useCallback(function(p)
		v4(p.AbsoluteCanvasSize.Y)
	end, { v4 })

	return React.createElement(ScrollView, {
		LayoutOrder = props.LayoutOrder,
		Size = mapped,
		onAbsoluteCanvasSizeChanged = onAbsoluteCanvasSizeChanged,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			scrollBarVisibility = ScrollBarVisibility.None,
			ScrollingDirection = Enum.ScrollingDirection.Y
		},
		tag = "shrink",
		testId = props.testId
	}, {
		Content = React.createElement(View, {
			onActivated = props.onActivated,
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, props.taskGap)
			},
			stateLayer = { affordance = StateLayerAffordance.None },
			tag = "col size-full-0 auto-y",
			testId = `{props.testId}-content`
		}, props.children)
	})
end

local function AgentCard(props)
	local group = props.group
	local v3 = useLocalization({
		building = LocalizationStrings.SUBAGENT_STATUS_BUILDING,
		completedTasks = {
			LocalizationStrings.SUBAGENT_STATUS_COMPLETED_TASKS,
			COUNT = #group.tasks
		},
		notStarted = LocalizationStrings.SUBAGENT_STATUS_NOT_STARTED
	})
	local text

	if #group.tasks == 0 then
		text = v3.notStarted
	elseif group.isComplete then
		text = v3.completedTasks
	else
		text = v3.building
	end

	local name = v2[group.name]
	local onActivated = React.useCallback(function()
		props.onAgentActivated(group)
	end, { props.onAgentActivated, group })
	local children = {}

	for k, task in group.tasks do
		children[`Task{k}`] = React.createElement(
			View,
			{
				LayoutOrder = k,
				tag = "row align-y-center gap-small size-full-0 auto-y",
				testId = `{props.testId}-card-{props.index}-task-{k}`
			},
			{
				Label = React.createElement(Text, {
					LayoutOrder = 1,
					Text = task.text,
					tag = "fill auto-y text-body-small text-align-x-left text-truncate-end content-emphasis"
				}),
				Status = React.createElement(LoadingIndicator, {
					layoutOrder = 2,
					status = task.status,
					testId = `{props.testId}-card-{props.index}-task-{k}`
				})
			}
		)
	end

	local createElement = React.createElement
	local v4 = {
		LayoutOrder = props.index,
		onActivated = 0,
		sizeConstraint = 0,
		tag = "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-emphasis radius-large",
		testId = 0
	}
	local onActivated2

	if #group.tasks > 0 then
		onActivated2 = onActivated
	end

	v4.onActivated = onActivated2
	v4.sizeConstraint = {
		MaxSize = Vector2.new(1e999, props.maxHeight)
	}

	v4.testId = `{props.testId}-card-{props.index}-container`

	local createElement2 = React.createElement
	local v5 = {
		LayoutOrder = 1,
		tag = "row align-y-center gap-small size-full-0 auto-y",
		testId = `{props.testId}-card-{props.index}`
	}
	local icon

	if name ~= nil then
		icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = name,
			size = IconSize.Small,
			tag = "auto-xy content-emphasis",
			testId = `{props.testId}-card-{props.index}-category-icon`
		})
	end

	local v6 = {
		Header = createElement2(View, v5, {
			Icon = icon,
			Title = React.createElement(Text, {
				LayoutOrder = 2,
				Text = group.name,
				tag = "fill auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
			}),
			Status = React.createElement(Text, {
				LayoutOrder = 3,
				Text = text,
				tag = "auto-xy padding-left-large text-body-small text-align-x-right content-emphasis"
			})
		}),
		Tasks = 0
	}
	local tasks

	if #group.tasks > 0 then
		tasks = React.createElement(
			AgentTaskList,
			{
				LayoutOrder = 2,
				onActivated = onActivated,
				taskGap = props.taskGap,
				testId = `{props.testId}-card-{props.index}-tasks`
			},
			children
		)
	end

	v6.Tasks = tasks
	return createElement(View, v4, v6)
end

local function AgentsList(props)
	local v3 = useTokens()
	local maxHeight = useScaledValue(156)
	local testId = props.testId or "build-agent-list"
	local children = {}

	for k, group in getDisplayGroups(props.groups) do
		children[`Card{k}`] = React.createElement(AgentCard, {
			group = group,
			index = k,
			maxHeight = maxHeight,
			onAgentActivated = props.onAgentActivated,
			taskGap = v3.Gap.Small,
			testId = testId
		})
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "col gap-medium size-full-0 auto-y padding-y-medium",
			testId = testId
		},
		children
	)
end

return React.memo(AgentsList)
