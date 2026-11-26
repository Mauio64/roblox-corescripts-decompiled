local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local fFlagBuildExperienceAdvancedPreviewSpecs = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceAdvancedPreviewSpecs
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
	local v6 = fFlagBuildExperienceAdvancedPreviewSpecs and props.specName ~= nil
	local state2, setState2

	if fFlagBuildExperienceAdvancedPreviewSpecs then
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
	local v7 = if state3 == nil then computed else state3.status
	local v8 = useSignalState(v7)
	local useSignalState2 = SignalsReact.useSignalState
	local v9 = if state3 == nil then computed2 else state3.data
	local v10 = useSignalState2(v9)

	local v11 = React.useMemo(function()
		return getRows(v10)
	end, { v10 })

	local state4, setState4 = React.useState(nil)
	local v12 = React.useCallback(function(p2)
		for k, v13 in v11 do
			if v13.value == p2 then
				setState(v13.override)
				setState4(p2)
				break
			end
		end
	end, { v11 })
	local v13

	if v6 and state2 == "build-on-mobile-advanced" then
		v13 = React.createElement(text, {
			Text = "Enter the published build-on-mobile-advanced preview hash below.",
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default"
		})
	elseif v8 == "Ready" then
		local v14 = math.ceil(v5.Typography.TitleMedium.FontSize * v5.Typography.TitleMedium.LineHeight)
		local children = {}

		for k, v15 in v11 do
			local value = v15.value
			local createElement = React.createElement

			local createElement2 = React.createElement
			local v19 = {
				LayoutOrder = 1,
				onActivated = function()
					v12(v15.value)
				end,
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-y-small"
			}

			local createElement3 = React.createElement

			local createElement4 = React.createElement

			local v24 = {
				Title = React.createElement(text, {
					LayoutOrder = 2,
					Text = v15.title,
					tag = "auto-xy text-title-medium text-wrap text-align-x-left content-emphasis"
				}),
				Pin = 0
			}

			local v25 = if v15.isPinned then React.createElement(
				view,
				{
					LayoutOrder = 1,
					Size = UDim2.fromOffset(0, v14),
					tag = "row align-y-center auto-x"
				},
				{
					Icon = React.createElement(icon, {
						name = iconName.Pin,
						size = iconSize.XSmall
					})
				}
			) else nil
			v24.Pin = v25
			local children4 = {
				TitleRow = createElement4(
					view,
					{
						LayoutOrder = 1,
						tag = "row align-y-top gap-xsmall size-full-0 auto-y"
					},
					v24
				),
				Description = 0
			}

			local v26 = if v15.description then React.createElement(text, {
				LayoutOrder = 2,
				Text = v15.description,
				tag = "auto-xy text-body-medium text-wrap text-align-x-left"
			}) else nil
			children4.Description = v26
			local children2 = {
				Row = createElement2(view, v19, {
					Text = createElement3(
						view,
						{ LayoutOrder = 1, tag = "col fill gap-xsmall auto-y" },
						children4
					),
					Radio = React.createElement(radioGroup.Item, {
						LayoutOrder = 2,
						label = "",
						size = inputSize.Medium,
						value = v15.value
					})
				}),
				Divider = 0
			}

			local v27 = if k < #v11 then React.createElement(divider, {
				LayoutOrder = 2
			}) else nil
			children2.Divider = v27
			children[value] = createElement(
				view,
				{ LayoutOrder = k, tag = "col size-full-0 auto-y" },
				children2
			)
		end

		v13 = React.createElement(
			radioGroup.Root,
			{
				onValueChanged = v12,
				Selectable = false,
				tag = "size-full-0 auto-y",
				value = getSelectedValue(v11, state, state4)
			},
			{
				Rows = React.createElement(view, { tag = "col size-full-0 auto-y" }, children)
			}
		)
	elseif v8 == "Failed" then
		v13 = React.createElement(text, {
			Text = "Preview list unavailable",
			tag = "size-full-0 auto-y text-body-small text-align-x-left content-muted"
		})
	else
		v13 = React.createElement(view, {
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

	local createElement = React.createElement
	local root = sheet.Root
	local v14 = {
		isOpen = true,
		preferCenterSheet = true,
		onClose = props.onClose,
		ref = props.focusRootRef,
		testId = props.testId
	}
	local v15 = {
		Header = React.createElement(sheet.Header, {
			hasCloseAffordance = props.hasCloseAffordance ~= false
		}, {
			Title = React.createElement(text, {
				Text = "Agent Spec",
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}),
		Content = React.createElement(sheet.Content, nil, { List = v13 }),
		Actions = 0
	}

	local createElement2 = React.createElement
	local actions = sheet.Actions
	local createElement3 = React.createElement
	local v20

	if v6 then
		v20 = React.createElement(radioGroup.Root, {
			LayoutOrder = 0,
			value = state2,
			testId = "AgentSpecDebug.SpecName",
			onValueChanged = function(p2)
				if p2 == "build-on-mobile" or p2 == "build-on-mobile-advanced" then
					setState2(p2)
					setState("")
					setState4(nil)
				end
			end,
			tag = "size-full-0 auto-y"
		}, {
			Default = React.createElement(radioGroup.Item, {
				LayoutOrder = 1,
				label = "Default spec",
				value = "build-on-mobile",
				testId = "AgentSpecDebug.SpecName.default"
			}),
			Advanced = React.createElement(radioGroup.Item, {
				LayoutOrder = 2,
				label = "Advanced spec",
				value = "build-on-mobile-advanced",
				testId = "AgentSpecDebug.SpecName.advanced"
			})
		})
	end

	v15.Actions = createElement2(actions, nil, {
		Form = createElement3(view, { tag = "col gap-small size-full-0 auto-y" }, {
			SpecName = v20,
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
					local onSave = props.onSave

					local v22 = if v6 and state2 == "build-on-mobile-advanced" then state2 else nil
					onSave(state, v22)

					props.onClose()
				end
			})
		})
	})
	return createElement(root, v14, v15)
end

return AgentSpecDebugSheet
