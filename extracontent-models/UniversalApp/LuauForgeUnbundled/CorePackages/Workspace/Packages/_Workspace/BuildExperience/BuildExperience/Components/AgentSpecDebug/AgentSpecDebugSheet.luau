local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local sheet = Foundation.Sheet
local button = Foundation.Button
local divider = Foundation.Divider
local icon = Foundation.Icon
local loading = Foundation.Loading
local radioGroup = Foundation.RadioGroup
local text = Foundation.Text
local textInput = Foundation.TextInput
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize

local computed = Signals.createComputed(function(): string
	return "NotReady"
end)

local computed2 = Signals.createComputed(function(): nil
	return nil
end)

local function getRows(p2)
	local rows = {
		{
			value = "default",
			title = "Default (latest)",
			description = nil,
			override = "",
			isPinned = false
		}
	}

	if p2 == nil then
		return rows
	end

	local set = {}
	local v5 = {}
	local v6 = {}

	for k, item in p2.items do
		local v7

		if item.pinned == CreatorAgentChat.PreviewSpecs.PreviewSpecPinned.Hash then
			v7 = `pr-{item.prNumber}-hash`
		else
			v7 = `pr-{item.prNumber}`
		end

		if set[v7] then
			continue
		end

		set[v7] = true
		local v8 = if item.pinned == nil then v5 else v6

		local v10 = if item.title == "" then `PR #{item.prNumber}` else item.title
		local v9 = {
			value = v7,
			title = v10,
			description = `#{item.prNumber} · {item.override}`,
			override = item.override,
			isPinned = item.pinned ~= nil
		}
		table.insert(v8, v9)
	end

	for k, v7 in v6 do
		table.insert(rows, v7)
	end

	for k, v8 in v5 do
		if k > 25 then
			break
		end

		table.insert(rows, v8)
	end

	return rows
end

local function getSelectedValue(items, state, state2)
	if CreatorAgentChat.experimentOverride.normalize(state) == "" then
		return "default"
	end

	local v5 = ""

	for k, item in items do
		if item.value ~= "default" and item.override == state and (v5 == "" or item.value == state2) then
			v5 = item.value
		end
	end

	return v5
end

local function AgentSpecDebugSheet(props)
	local v5 = Foundation.Hooks.useTokens()
	local state, setState = React.useState(props.specVersion or "")

	local state2, setState2 = React.useState(nil)

	React.useEffect(function()
		setState2(CreatorAgentChat.PreviewSpecs.getPreviewSpecsStore(false).refreshPreviewSpecs())
	end, {})
	local useSignalState = SignalsReact.useSignalState
	local v6 = if state2 == nil then computed else state2.status
	local v7 = useSignalState(v6)
	local useSignalState2 = SignalsReact.useSignalState
	local v8 = if state2 == nil then computed2 else state2.data
	local v9 = useSignalState2(v8)

	local v10 = React.useMemo(function()
		return getRows(v9)
	end, { v9 })

	local state3, setState3 = React.useState(nil)
	local v11 = React.useCallback(function(p2)
		for k, v12 in v10 do
			if v12.value == p2 then
				setState(v12.override)
				setState3(p2)
				break
			end
		end
	end, { v10 })
	local v12

	if v7 == "Ready" then
		local v13 = math.ceil(v5.Typography.TitleMedium.FontSize * v5.Typography.TitleMedium.LineHeight)
		local children = {}

		for k, v14 in v10 do
			local value = v14.value
			local createElement = React.createElement

			local createElement2 = React.createElement
			local v18 = {
				LayoutOrder = 1,
				onActivated = function()
					v11(v14.value)
				end,
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-y-small"
			}

			local createElement3 = React.createElement

			local createElement4 = React.createElement

			local v23 = {
				Title = React.createElement(text, {
					LayoutOrder = 2,
					Text = v14.title,
					tag = "auto-xy text-title-medium text-wrap text-align-x-left content-emphasis"
				}),
				Pin = 0
			}

			local v24 = if v14.isPinned then React.createElement(
				view,
				{
					LayoutOrder = 1,
					Size = UDim2.fromOffset(0, v13),
					tag = "row align-y-center auto-x"
				},
				{
					Icon = React.createElement(icon, {
						name = iconName.Pin,
						size = iconSize.XSmall
					})
				}
			) else nil
			v23.Pin = v24
			local children4 = {
				TitleRow = createElement4(
					view,
					{
						LayoutOrder = 1,
						tag = "row align-y-top gap-xsmall size-full-0 auto-y"
					},
					v23
				),
				Description = 0
			}

			local v25 = if v14.description then React.createElement(text, {
				LayoutOrder = 2,
				Text = v14.description,
				tag = "auto-xy text-body-medium text-wrap text-align-x-left"
			}) else nil
			children4.Description = v25
			local children2 = {
				Row = createElement2(view, v18, {
					Text = createElement3(
						view,
						{ LayoutOrder = 1, tag = "col fill gap-xsmall auto-y" },
						children4
					),
					Radio = React.createElement(radioGroup.Item, {
						LayoutOrder = 2,
						label = "",
						size = inputSize.Medium,
						value = v14.value
					})
				}),
				Divider = 0
			}

			local v26 = if k < #v10 then React.createElement(divider, {
				LayoutOrder = 2
			}) else nil
			children2.Divider = v26
			children[value] = createElement(
				view,
				{ LayoutOrder = k, tag = "col size-full-0 auto-y" },
				children2
			)
		end

		v12 = React.createElement(
			radioGroup.Root,
			{
				onValueChanged = v11,
				Selectable = false,
				tag = "size-full-0 auto-y",
				value = getSelectedValue(v10, state, state3)
			},
			{
				Rows = React.createElement(view, { tag = "col size-full-0 auto-y" }, children)
			}
		)
	elseif v7 == "Failed" then
		v12 = React.createElement(text, {
			Text = "Preview list unavailable",
			tag = "size-full-0 auto-y text-body-small text-align-x-left content-muted"
		})
	else
		v12 = React.createElement(view, {
			tag = "row align-y-center gap-small size-full-0 auto-y"
		}, {
			Spinner = React.createElement(loading, {
				LayoutOrder = 1,
				size = iconSize.Small
			}),
			Label = React.createElement(text, {
				LayoutOrder = 2,
				Text = "Loading previews",
				tag = "auto-xy text-body-medium"
			})
		})
	end

	return React.createElement(sheet.Root, {
		isOpen = true,
		preferCenterSheet = true,
		onClose = props.onClose,
		ref = props.focusRootRef,
		testId = props.testId
	}, {
		Header = React.createElement(sheet.Header, {
			hasCloseAffordance = props.hasCloseAffordance ~= false
		}, {
			Title = React.createElement(text, {
				Text = "Agent Spec",
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}),
		Content = React.createElement(sheet.Content, nil, { List = v12 }),
		Actions = React.createElement(sheet.Actions, nil, {
			Form = React.createElement(view, {
				tag = "col gap-small size-full-0 auto-y"
			}, {
				Input = React.createElement(textInput, {
					LayoutOrder = 1,
					label = "specVersion",
					placeholder = "Leave empty for latest",
					text = state,
					width = UDim.new(1, 0),
					onChanged = setState
				}),
				Save = React.createElement(button, {
					LayoutOrder = 2,
					text = "Save",
					size = inputSize.Large,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					width = UDim.new(1, 0),
					onActivated = function()
						props.onSave(state)
						props.onClose()
					end
				})
			})
		})
	})
end

return AgentSpecDebugSheet
