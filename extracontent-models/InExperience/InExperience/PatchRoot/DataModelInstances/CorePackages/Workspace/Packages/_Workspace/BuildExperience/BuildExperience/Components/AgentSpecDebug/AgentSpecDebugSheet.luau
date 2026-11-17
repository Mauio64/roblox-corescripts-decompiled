local parent = script:FindFirstAncestor("BuildExperience").Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceAdvancedPreviewSpecs = SharedFlags.FFlagBuildExperienceAdvancedPreviewSpecs
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
	local v2 = FFlagBuildExperienceAdvancedPreviewSpecs and props.specName ~= nil
	local state2, setState2

	if FFlagBuildExperienceAdvancedPreviewSpecs then
		state2, setState2 = React.useState(props.specName or "build-on-mobile")
	else
		state2 = nil
		setState2 = nil
	end

	local state3, setState3 = React.useState(nil)

	React.useEffect(function()
		setState3(CreatorAgentChat.PreviewSpecs.getPreviewSpecsStore(false).refreshPreviewSpecs())
	end, {})
	local useSignalState = SignalsReact.useSignalState
	local v3 = if state3 == nil then computed else state3.status
	local v4 = useSignalState(v3)
	local useSignalState2 = SignalsReact.useSignalState
	local v5 = if state3 == nil then computed2 else state3.data
	local v6 = useSignalState2(v5)

	local v7 = React.useMemo(function()
		return getRows(v6)
	end, { v6 })

	local state4, setState4 = React.useState(nil)
	local onValueChanged = React.useCallback(function(p: string)
		for _, v8 in v7 do
			if v8.value == p then
				setState(v8.override)
				setState4(p)
				break
			end
		end
	end, { v7 })
	local list

	if v2 and state2 == "build-on-mobile-advanced" then
		list = React.createElement(Text, {
			Text = "Enter the published build-on-mobile-advanced preview hash below.",
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default"
		})
	elseif v4 == "Ready" then
		local v8 = math.ceil(v.Typography.TitleMedium.FontSize * v.Typography.TitleMedium.LineHeight)
		local children = {}

		for k, v9 in v7 do
			local value = v9.value
			local createElement = React.createElement

			local createElement2 = React.createElement
			local v10 = {
				LayoutOrder = 1,
				onActivated = function()
					onValueChanged(v9.value)
				end,
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-y-small"
			}

			local createElement3 = React.createElement

			local createElement4 = React.createElement

			local v11 = {
				Title = React.createElement(Text, {
					LayoutOrder = 2,
					Text = v9.title,
					tag = "auto-xy text-title-medium text-wrap text-align-x-left content-emphasis"
				}),
				Pin = 0
			}
			local pin

			if v9.isPinned then
				pin = React.createElement(
					View,
					{
						LayoutOrder = 1,
						Size = UDim2.fromOffset(0, v8),
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

			v11.Pin = pin
			local children3 = {
				TitleRow = createElement4(
					View,
					{ LayoutOrder = 1, tag = "row align-y-top gap-xsmall size-full-0 auto-y" },
					v11
				),
				Description = 0
			}
			local description

			if v9.description then
				description = React.createElement(Text, {
					LayoutOrder = 2,
					Text = v9.description,
					tag = "auto-xy text-body-medium text-wrap text-align-x-left"
				})
			end

			children3.Description = description
			local children2 = {
				Row = createElement2(View, v10, {
					Text = createElement3(View, {
						LayoutOrder = 1,
						tag = "col fill gap-xsmall auto-y"
					}, children3),
					Radio = React.createElement(RadioGroup.Item, {
						LayoutOrder = 2,
						label = "",
						size = InputSize.Medium,
						value = v9.value
					})
				}),
				Divider = 0
			}
			local divider

			if k < #v7 then
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
				value = getSelectedValue(v7, state, state4)
			},
			{
				Rows = React.createElement(View, { tag = "col size-full-0 auto-y" }, children)
			}
		)
	elseif v4 == "Failed" then
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

	local createElement = React.createElement
	local root = Sheet.Root
	local v8 = {
		isOpen = true,
		preferCenterSheet = true,
		onClose = props.onClose,
		ref = props.focusRootRef,
		testId = props.testId
	}
	local v9 = {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = props.hasCloseAffordance ~= false
		}, {
			Title = React.createElement(Text, {
				Text = "Agent Spec",
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}),
		Content = React.createElement(Sheet.Content, nil, { List = list }),
		Actions = 0
	}

	local createElement2 = React.createElement
	local actions = Sheet.Actions
	local createElement3 = React.createElement
	local specName

	if v2 then
		specName = React.createElement(RadioGroup.Root, {
			LayoutOrder = 0,
			value = state2,
			testId = "AgentSpecDebug.SpecName",
			onValueChanged = function(p: string)
				if p == "build-on-mobile" or p == "build-on-mobile-advanced" then
					setState2(p)
					setState("")
					setState4(nil)
				end
			end,
			tag = "size-full-0 auto-y"
		}, {
			Default = React.createElement(RadioGroup.Item, {
				LayoutOrder = 1,
				label = "Default spec",
				value = "build-on-mobile",
				testId = "AgentSpecDebug.SpecName.default"
			}),
			Advanced = React.createElement(RadioGroup.Item, {
				LayoutOrder = 2,
				label = "Advanced spec",
				value = "build-on-mobile-advanced",
				testId = "AgentSpecDebug.SpecName.advanced"
			})
		})
	end

	v9.Actions = createElement2(actions, nil, {
		Form = createElement3(View, { tag = "col gap-small size-full-0 auto-y" }, {
			SpecName = specName,
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
					local onSave = props.onSave
					local v10

					if v2 and state2 == "build-on-mobile-advanced" then
						v10 = state2
					end

					onSave(state, v10)

					props.onClose()
				end
			})
		})
	})
	return createElement(root, v8, v9)
end

return AgentSpecDebugSheet
