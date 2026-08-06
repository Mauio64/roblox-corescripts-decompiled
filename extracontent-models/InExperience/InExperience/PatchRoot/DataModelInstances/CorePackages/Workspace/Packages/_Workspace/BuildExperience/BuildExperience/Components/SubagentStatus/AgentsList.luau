local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local LoadingIndicator = require(script.Parent.LoadingIndicator)
local Icon = Foundation.Icon
local ScrollView = Foundation.ScrollView
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local SubagentTaskCategory = CreatorAgentChat.SubagentTaskCategory
local t1 = {
	SubagentTaskCategory.Gameplay,
	SubagentTaskCategory.Art,
	SubagentTaskCategory.Audio,
	SubagentTaskCategory.Marketing
}
local t2 = {
	Art = IconName.TwoMakeupBrushes,
	Audio = IconName.FiveVerticalLinesWave,
	Gameplay = IconName.Controller,
	Marketing = IconName.Wallet
}

local function getDisplayGroups(t3: {[any]: any}) -- line: 49
	-- upvalues: t1 (copy)
	local t4 = {}

	for _, v29 in t3 do
		t4[v29.name] = v29
	end

	local t5 = {}

	for _, v32 in t1 do
		table.insert(t5, t4[v32] or {
			isComplete = false,
			isLoading = false,
			name = v32,
			tasks = {}
		})
		t4[v32] = nil
	end

	for _, v34 in t3 do
		if t4[v34.name] ~= nil then
			table.insert(t5, v34)
			t4[v34.name] = nil
		end
	end

	return t5
end
local function getStatusText(p1) -- line: 77
	-- upvalues: LocalizationStrings (copy)
	if #p1.tasks == 0 then
		return LocalizationStrings.SUBAGENT_STATUS_NOT_STARTED
	end

	if p1.isComplete then
		return LocalizationStrings.formatSubagentStatusCompletedTasks(#p1.tasks)
	end

	return LocalizationStrings.SUBAGENT_STATUS_BUILDING
end
local function AgentTaskList(t6: {[any]: any}) -- line: 95
	-- upvalues: React (copy), ScrollView (copy), ScrollBarVisibility (copy), View (copy), StateLayerAffordance (copy)
	local v37, v38 = React.useBinding(0)
	local v39 = v37:map(function(p2) -- line: 97
		return UDim2.new(1, 0, 0, p2)
	end)
	local v40 = React.useCallback(function(p3) -- line: 100
		-- upvalues: v38 (copy)
		v38(p3.AbsoluteCanvasSize.Y)
	end, { v38 })

	return React.createElement(ScrollView, {
		tag = "shrink",
		LayoutOrder = t6.LayoutOrder,
		Size = v39,
		onAbsoluteCanvasSizeChanged = v40,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			scrollBarVisibility = ScrollBarVisibility.None,
			ScrollingDirection = Enum.ScrollingDirection.Y
		},
		testId = t6.testId
	}, {
		Content = React.createElement(View, {
			tag = "col size-full-0 auto-y",
			onActivated = t6.onActivated,
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, t6.taskGap)
			},
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			testId = `{ t6.testId }-content`
		}, t6.children)
	})
end
local function AgentCard(t7: {[any]: any}) -- line: 141
	-- upvalues: t2 (copy), React (copy), View (copy), FoundationText (copy), LoadingIndicator (copy), Icon (copy), IconSize (copy), LocalizationStrings (copy), AgentTaskList (copy)
	local group = t7.group
	local v43 = t2[group.name]
	local v44 = React.useCallback(function() -- line: 144
		-- upvalues: t7 (copy), group (copy)
		t7.onAgentActivated(group)
	end, {
		t7.onAgentActivated,
		group
	})
	local t8 = {}

	for v46, v47 in group.tasks do
		t8[`Task{ v46 }`] = React.createElement(View, {
			tag = "row align-y-center gap-small size-full-0 auto-y",
			LayoutOrder = v46,
			testId = `{ t7.testId }-card-{ t7.index }-task-{ v46 }`
		}, {
			Label = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "fill auto-y text-body-small text-align-x-left text-truncate-end content-emphasis",
				Text = v47.text
			}),
			Status = React.createElement(LoadingIndicator, {
				layoutOrder = 2,
				status = v47.status,
				testId = `{ t7.testId }-card-{ t7.index }-task-{ v46 }`
			})
		})
	end

	return React.createElement(View, {
		tag = "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-emphasis radius-large",
		LayoutOrder = t7.index,
		onActivated = if not (#group.tasks > 0) then nil else v44,
		sizeConstraint = {
			MaxSize = Vector2.new(1e999, t7.maxHeight)
		},
		testId = `{ t7.testId }-card-{ t7.index }-container`
	}, {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-y-center gap-small size-full-0 auto-y",
			testId = `{ t7.testId }-card-{ t7.index }`
		}, {
			Icon = if v43 == nil then nil else React.createElement(Icon, {
				LayoutOrder = 1,
				tag = "auto-xy content-emphasis",
				name = v43,
				size = IconSize.Small,
				testId = `{ t7.testId }-card-{ t7.index }-category-icon`
			}),
			Title = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "fill auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
				Text = group.name
			}),
			Status = React.createElement(FoundationText, {
				LayoutOrder = 3,
				tag = "auto-xy padding-left-large text-body-small text-align-x-right content-emphasis",
				Text = if #group.tasks ~= 0 then if not group.isComplete then LocalizationStrings.SUBAGENT_STATUS_BUILDING else LocalizationStrings.formatSubagentStatusCompletedTasks(#group.tasks) else LocalizationStrings.SUBAGENT_STATUS_NOT_STARTED
			})
		}),
		Tasks = if not (#group.tasks > 0) then nil else React.createElement(AgentTaskList, {
			LayoutOrder = 2,
			onActivated = v44,
			taskGap = t7.taskGap,
			testId = `{ t7.testId }-card-{ t7.index }-tasks`
		}, t8)
	})
end
local function AgentsList(t9: {[any]: any}) -- line: 213
	-- upvalues: useTokens (copy), useScaledValue (copy), getDisplayGroups (copy), React (copy), AgentCard (copy), View (copy)
	local v49 = useTokens()
	local v50 = useScaledValue(156)
	local v51 = t9.testId or "build-agent-list"
	local t10 = {}

	for v53, v54 in getDisplayGroups(t9.groups) do
		t10[`Card{ v53 }`] = React.createElement(AgentCard, {
			group = v54,
			index = v53,
			maxHeight = v50,
			onAgentActivated = t9.onAgentActivated,
			taskGap = v49.Gap.Small,
			testId = v51
		})
	end

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-y-medium",
		LayoutOrder = t9.LayoutOrder,
		testId = v51
	}, t10)
end

return React.memo(AgentsList)
