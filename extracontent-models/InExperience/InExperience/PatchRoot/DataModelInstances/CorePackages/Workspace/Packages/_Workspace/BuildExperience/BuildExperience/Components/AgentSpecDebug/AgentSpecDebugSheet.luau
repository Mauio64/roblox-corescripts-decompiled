local parent = script:FindFirstAncestor("BuildExperience").Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local Sheet = Foundation.Sheet
local Button = Foundation.Button
local Divider = Foundation.Divider
local Icon = Foundation.Icon
local Loading = Foundation.Loading
local RadioGroup = Foundation.RadioGroup
local Text = Foundation.Text
local TextInput = Foundation.TextInput
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize

local computed = Signals.createComputed(function(): string
	return "NotReady"
end)

local computed2 = Signals.createComputed(function(): nil
	return nil
end)

local function getRows(p)
	local rows = {
		{
			value = "default",
			title = "Default (latest)",
			description = nil,
			override = "",
			isPinned = false
		}
	}

	if p == nil then
		return rows
	end

	local set = {}
	local v = {}
	local v2 = {}

	for _, item in p.items do
		local v3

		if item.pinned == CreatorAgentChat.PreviewSpecs.PreviewSpecPinned.Hash then
			v3 = `pr-{item.prNumber}-hash`
		else
			v3 = `pr-{item.prNumber}`
		end

		if set[v3] then
			continue
		end

		set[v3] = true
		local v4 = if item.pinned == nil then v else v2
		local title

		if item.title == "" then
			title = `PR #{item.prNumber}`
		else
			title = item.title
		end

		local v5 = {
			value = v3,
			title = title,
			description = `#{item.prNumber} · {item.override}`,
			override = item.override,
			isPinned = item.pinned ~= nil
		}
		table.insert(v4, v5)
	end

	for _, v3 in v2 do
		table.insert(rows, v3)
	end

	for k, v3 in v do
		if k > 25 then
			break
		end

		table.insert(rows, v3)
	end

	return rows
end

local function getSelectedValue(items, state: string, state2: string?)
	if CreatorAgentChat.experimentOverride.normalize(state) == "" then
		return "default"
	end

	local v = ""

	for _, item in items do
		if item.value ~= "default" and item.override == state and (v == "" or item.value == state2) then
			v = item.value
		end
	end

	return v
end

local function AgentSpecDebugSheet(props)
	local v = Foundation.Hooks.useTokens()
	local state, setState = React.useState(props.specVersion or "")

	local state2, setState2 = React.useState(nil)

	React.useEffect(function()
		setState2(CreatorAgentChat.PreviewSpecs.getPreviewSpecsStore(false).refreshPreviewSpecs())
	end, {})
	local useSignalState = SignalsReact.useSignalState
	local v2 = if state2 == nil then computed else state2.status
	local v3 = useSignalState(v2)
	local useSignalState2 = SignalsReact.useSignalState
	local v4 = if state2 == nil then computed2 else state2.data
	local v5 = useSignalState2(v4)

	local v6 = React.useMemo(function()
		return getRows(v5)
	end, { v5 })

	local state3, setState3 = React.useState(nil)
	local onValueChanged = React.useCallback(function(p: string)
		for _, v7 in v6 do
			if v7.value == p then
				setState(v7.override)
				setState3(p)
				break
			end
		end
	end, { v6 })
	local list

	if v3 == "Ready" then
		local v7 = math.ceil(v.Typography.TitleMedium.FontSize * v.Typography.TitleMedium.LineHeight)
		local children = {}

		for k, v8 in v6 do
			local value = v8.value
			local createElement = React.createElement

			local createElement2 = React.createElement
			local v9 = {
				LayoutOrder = 1,
				onActivated = function()
					onValueChanged(v8.value)
				end,
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-y-small"
			}

			local createElement3 = React.createElement

			local createElement4 = React.createElement

			local v10 = {
				Title = React.createElement(Text, {
					LayoutOrder = 2,
					Text = v8.title,
					tag = "auto-xy text-title-medium text-wrap text-align-x-left content-emphasis"
				}),
				Pin = 0
			}
			local pin

			if v8.isPinned then
				pin = React.createElement(
					View,
					{
						LayoutOrder = 1,
						Size = UDim2.fromOffset(0, v7),
						tag = "row align-y-center auto-x"
					},
					{
						Icon = React.createElement(Icon, {
							name = IconName.Pin,
							size = IconSize.XSmall
						})
					}
				)
			end

			v10.Pin = pin
			local children3 = {
				TitleRow = createElement4(
					View,
					{ LayoutOrder = 1, tag = "row align-y-top gap-xsmall size-full-0 auto-y" },
					v10
				),
				Description = 0
			}
			local description

			if v8.description then
				description = React.createElement(Text, {
					LayoutOrder = 2,
					Text = v8.description,
					tag = "auto-xy text-body-medium text-wrap text-align-x-left"
				})
			end

			children3.Description = description
			local children2 = {
				Row = createElement2(View, v9, {
					Text = createElement3(View, {
						LayoutOrder = 1,
						tag = "col fill gap-xsmall auto-y"
					}, children3),
					Radio = React.createElement(RadioGroup.Item, {
						LayoutOrder = 2,
						label = "",
						size = InputSize.Medium,
						value = v8.value
					})
				}),
				Divider = 0
			}
			local divider

			if k < #v6 then
				divider = React.createElement(Divider, { LayoutOrder = 2 })
			end

			children2.Divider = divider
			children[value] = createElement(View, {
				LayoutOrder = k,
				tag = "col size-full-0 auto-y"
			}, children2)
		end

		list = React.createElement(
			RadioGroup.Root,
			{
				onValueChanged = onValueChanged,
				Selectable = false,
				tag = "size-full-0 auto-y",
				value = getSelectedValue(v6, state, state3)
			},
			{
				Rows = React.createElement(View, { tag = "col size-full-0 auto-y" }, children)
			}
		)
	elseif v3 == "Failed" then
		list = React.createElement(Text, {
			Text = "Preview list unavailable",
			tag = "size-full-0 auto-y text-body-small text-align-x-left content-muted"
		})
	else
		list = React.createElement(View, { tag = "row align-y-center gap-small size-full-0 auto-y" }, {
			Spinner = React.createElement(Loading, { LayoutOrder = 1, size = IconSize.Small }),
			Label = React.createElement(Text, {
				LayoutOrder = 2,
				Text = "Loading previews",
				tag = "auto-xy text-body-medium"
			})
		})
	end

	return React.createElement(Sheet.Root, {
		isOpen = true,
		preferCenterSheet = true,
		onClose = props.onClose,
		ref = props.focusRootRef,
		testId = props.testId
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = props.hasCloseAffordance ~= false
		}, {
			Title = React.createElement(Text, {
				Text = "Agent Spec",
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}),
		Content = React.createElement(Sheet.Content, nil, { List = list }),
		Actions = React.createElement(Sheet.Actions, nil, {
			Form = React.createElement(View, { tag = "col gap-small size-full-0 auto-y" }, {
				Input = React.createElement(TextInput, {
					LayoutOrder = 1,
					label = "specVersion",
					placeholder = "Leave empty for latest",
					text = state,
					width = UDim.new(1, 0),
					onChanged = setState
				}),
				Save = React.createElement(Button, {
					LayoutOrder = 2,
					text = "Save",
					size = InputSize.Large,
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
