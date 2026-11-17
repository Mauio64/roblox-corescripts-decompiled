local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceAdvancedPreviewSpecs = SharedFlags.FFlagBuildExperienceAdvancedPreviewSpecs
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local AgentSpecDebugSheet

if FFlagBuildExperienceModelPicker then
	AgentSpecDebugSheet = require(BuildExperience.Components.AgentSpecDebug.AgentSpecDebugSheet)
else
	AgentSpecDebugSheet = nil
end

require(script.Parent.ModelPickerTypes)

local Chip = Foundation.Chip
local IconButton = Foundation.IconButton
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View

local function Option(props)
	local createElement = React.createElement
	local v = {
		LayoutOrder = props.LayoutOrder,
		onActivated = props.onActivated,
		isDisabled = props.isDisabled,
		selection = {
			Selectable = not props.isDisabled
		},
		cursor = Foundation.Enums.CursorType.RoundedRectNoInset,
		GroupTransparency = props.isDisabled and 0.5 or 0,
		tag = {
			["col gap-xxsmall size-full-0 auto-y padding-medium stroke-standard radius-medium"] = true,
			["stroke-system-contrast"] = props.isSelected,
			["stroke-emphasis"] = not props.isSelected
		},
		testId = props.testId
	}
	local v2 = {
		Label = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.label,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		Description = 0
	}
	local description

	if props.description then
		description = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.description,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		})
	end

	v2.Description = description
	return createElement(View, v, v2)
end

local function ModelPickerView(props)
	local v = Foundation.Hooks.useTokens()
	local body = nil
	local internalTesting = props.internalTesting
	local isSelected

	if internalTesting == nil then
		isSelected = false
	else
		isSelected = internalTesting.isSelected
	end

	local text

	if internalTesting then
		text = internalTesting.previewHash
	end

	local contentemphasis

	if text == nil then
		contentemphasis = false
	else
		contentemphasis = text ~= ""
	end

	if props.isOpen then
		local children = {}

		for k, option in props.data.options do
			local id = option.id
			local createElement = React.createElement
			local v2 = {
				LayoutOrder = k,
				label = option.label,
				description = 0,
				isDisabled = 0,
				isSelected = 0,
				onActivated = 0,
				testId = 0
			}
			local description

			if option.isAvailable then
				description = option.description
			else
				description = props.unavailableText
			end

			v2.description = description
			v2.isDisabled = props.isDisabled or not option.isAvailable
			v2.isSelected = not isSelected and props.selectedId == option.id
			function v2.onActivated()
				props.onSelect(option.id)
			end
			v2.testId = `ModelPicker.Option.{option.id}`
			children[id] = createElement(Option, v2)
		end

		local createElement = React.createElement

		local v2 = {
			Options = React.createElement(React.Fragment, nil, children),
			Unavailable = 0,
			InternalTesting = 0,
			InternalSpec = 0
		}
		local unavailable

		if #props.data.options == 0 then
			unavailable = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.unavailableText,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left"
			})
		end

		v2.Unavailable = unavailable
		local internalTesting2

		if internalTesting then
			internalTesting2 = React.createElement(Option, {
				LayoutOrder = #props.data.options + 2,
				label = internalTesting.label,
				description = internalTesting.description,
				isDisabled = props.isDisabled,
				isSelected = isSelected,
				onActivated = internalTesting.onSelect,
				testId = "ModelPicker.InternalTesting"
			})
		end

		v2.InternalTesting = internalTesting2
		local internalSpec

		if internalTesting and isSelected then
			local createElement2 = React.createElement
			local v3 = {
				LayoutOrder = #props.data.options + 3,
				tag = "col gap-small size-full-0 auto-y"
			}

			local children2 = {
				Label = React.createElement(Text, {
					LayoutOrder = 1,
					Text = internalTesting.specLabel,
					fontStyle = v.Typography.TitleMedium,
					selection = { Selectable = false },
					stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
					tag = {
						["size-full-0 auto-y text-wrap text-align-x-left"] = true,
						["content-emphasis"] = not props.isDisabled,
						["content-muted"] = props.isDisabled
					},
					testId = "ModelPicker.InternalSpec--label"
				}),
				Button = 0,
				Hint = 0
			}

			local createElement3 = React.createElement

			local createElement4 = React.createElement
			local v4 = {
				ZIndex = 1,
				onActivated = internalTesting.onOpenSpec,
				isDisabled = props.isDisabled,
				selection = {
					Selectable = not props.isDisabled
				},
				cursor = Foundation.Enums.CursorType.RoundedRectNoInset,
				GroupTransparency = props.isDisabled and 0.5 or 0,
				padding = {
					left = UDim.new(0, v.Padding.Small),
					right = UDim.new(0, v.Padding.Small + v.Size.Size_800)
				},
				tag = "size-full radius-medium",
				testId = "ModelPicker.InternalSpec"
			}

			local createElement5 = React.createElement

			if text == nil or text == "" then
				text = internalTesting.placeholder
			end

			children2.Button = createElement3(
				View,
				{
					LayoutOrder = 2,
					tag = "size-full-1000 stroke-standard stroke-emphasis radius-medium clip",
					testId = "ModelPicker.InternalSpec--container"
				},
				{
					Open = createElement4(View, v4, {
						Value = createElement5(Text, {
							Text = text,
							tag = {
								["size-full text-body-medium text-align-x-left text-truncate-end"] = true,
								["content-emphasis"] = contentemphasis,
								["content-muted"] = not contentemphasis
							},
							testId = "ModelPicker.InternalSpec--value"
						})
					}),
					Clear = React.createElement(IconButton, {
						ZIndex = 2,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -v.Padding.Small, 0.5, 0),
						icon = Foundation.Enums.IconName.X,
						size = Foundation.Enums.InputSize.Small,
						variant = Foundation.Enums.ButtonVariant.Utility,
						isDisabled = props.isDisabled or not contentemphasis,
						onActivated = internalTesting.onClearSpec,
						testId = "ModelPicker.InternalSpec--clear"
					})
				}
			)

			children2.Hint = React.createElement(Text, {
				LayoutOrder = 3,
				Text = internalTesting.hint,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default"
			})
			internalSpec = createElement2(View, v3, children2)
		end

		v2.InternalSpec = internalSpec
		body = createElement(
			View,
			{
				tag = "col items-stretch gap-medium size-full-0 auto-y padding-y-xsmall",
				testId = "ModelPicker.Options"
			},
			v2
		)

		if #props.data.options == 0 and internalTesting == nil then
			body = React.createElement(Text, {
				Text = props.unavailableText,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left"
			})
		end
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v2 = {
		Chip = React.createElement(
			View,
			{
				LayoutOrder = props.LayoutOrder,
				tag = "auto-xy stroke-standard stroke-default radius-circle"
			},
			{
				Control = React.createElement(Chip, {
					text = props.label,
					trailing = Foundation.Enums.IconName.ChevronLargeDown,
					size = Foundation.Enums.ChipSize.Medium,
					variant = Foundation.Enums.ChipVariant.Utility,
					isDisabled = props.isDisabled,
					onActivated = props.onOpen,
					testId = "ModelPicker.Chip"
				})
			}
		),
		AgentSpecSheet = 0,
		Sheet = 0
	}
	local agentSpecSheet

	if props.isSpecOpen and internalTesting then
		agentSpecSheet = React.createElement(AgentSpecDebugSheet, {
			specVersion = internalTesting.previewHash,
			specName = FFlagBuildExperienceAdvancedPreviewSpecs and (internalTesting.previewSpecName or "build-on-mobile") or nil,
			onSave = internalTesting.onSaveSpec,
			onClose = props.onCloseSpec,
			focusRootRef = props.focusRootRef,
			hasCloseAffordance = props.hasCloseAffordance,
			testId = "ModelPicker.AgentSpecSheet"
		})
	end

	v2.AgentSpecSheet = agentSpecSheet
	local sheet

	if props.isOpen then
		local createElement2 = React.createElement
		local root = Sheet.Root
		local v3 = {
			isOpen = true,
			preferCenterSheet = true,
			onClose = props.onClose,
			ref = props.focusRootRef,
			testId = "ModelPicker.Sheet"
		}

		local createElement3 = React.createElement
		local header = Sheet.Header
		local hasCloseAffordance

		if not props.hasCloseAffordance then
			hasCloseAffordance = false
		end

		sheet = createElement2(root, v3, {
			Header = createElement3(header, { hasCloseAffordance = hasCloseAffordance }, {
				Title = React.createElement(Text, {
					Text = props.title,
					tag = "shrink auto-xy text-heading-small text-wrap text-align-x-left content-emphasis"
				})
			}),
			Content = React.createElement(Sheet.Content, nil, { Body = body })
		})
	end

	v2.Sheet = sheet
	return createElement(fragment, nil, v2)
end

return ModelPickerView
