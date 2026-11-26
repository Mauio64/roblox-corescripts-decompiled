local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local fFlagBuildExperienceAdvancedPreviewSpecs = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceAdvancedPreviewSpecs
local v5 = if require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker") then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AgentSpecDebug/AgentSpecDebugSheet") else nil

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")

local chip = Foundation.Chip
local iconButton = Foundation.IconButton
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View

local function Option(props)
	local createElement = React.createElement
	local v7 = {
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
	local v8 = {
		Label = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.label,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		Description = 0
	}

	local v9 = if props.description then React.createElement(text, {
		LayoutOrder = 2,
		Text = props.description,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
	}) else nil
	v8.Description = v9
	return createElement(view, v7, v8)
end

local function ModelPickerView(props)
	local v6 = Foundation.Hooks.useTokens()
	local v7 = nil
	local internalTesting = props.internalTesting
	local v8 = not (internalTesting == nil) and internalTesting.isSelected
	local v9 = if internalTesting then internalTesting.previewHash else nil
	local v10 = not (v9 == nil) and v9 ~= ""

	if props.isOpen then
		local children = {}

		for k, option in props.data.options do
			local id = option.id
			local createElement = React.createElement
			local v12 = {
				LayoutOrder = k,
				label = option.label,
				description = 0,
				isDisabled = 0,
				isSelected = 0,
				onActivated = 0,
				testId = 0
			}
			local v13 = if option.isAvailable then option.description else props.unavailableText
			v12.description = v13
			v12.isDisabled = props.isDisabled or not option.isAvailable
			v12.isSelected = not v8 and props.selectedId == option.id
			function v12.onActivated()
				props.onSelect(option.id)
			end
			v12.testId = `ModelPicker.Option.{option.id}`
			children[id] = createElement(Option, v12)
		end

		local createElement = React.createElement

		local v13 = {
			Options = React.createElement(React.Fragment, nil, children),
			Unavailable = 0,
			InternalTesting = 0,
			InternalSpec = 0
		}
		local v14 = if #props.data.options == 0 then React.createElement(text, {
			LayoutOrder = 1,
			Text = props.unavailableText,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left"
		}) else nil
		v13.Unavailable = v14

		local v15 = if internalTesting then React.createElement(Option, {
			LayoutOrder = #props.data.options + 2,
			label = internalTesting.label,
			description = internalTesting.description,
			isDisabled = props.isDisabled,
			isSelected = v8,
			onActivated = internalTesting.onSelect,
			testId = "ModelPicker.InternalTesting"
		}) else nil
		v13.InternalTesting = v15
		local v16

		if internalTesting and v8 then
			local createElement2 = React.createElement
			local v18 = {
				LayoutOrder = #props.data.options + 3,
				tag = "col gap-small size-full-0 auto-y"
			}

			local children2 = {
				Label = React.createElement(text, {
					LayoutOrder = 1,
					Text = internalTesting.specLabel,
					fontStyle = v6.Typography.TitleMedium,
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
			local v22 = {
				ZIndex = 1,
				onActivated = internalTesting.onOpenSpec,
				isDisabled = props.isDisabled,
				selection = {
					Selectable = not props.isDisabled
				},
				cursor = Foundation.Enums.CursorType.RoundedRectNoInset,
				GroupTransparency = props.isDisabled and 0.5 or 0,
				padding = {
					left = UDim.new(0, v6.Padding.Small),
					right = UDim.new(0, v6.Padding.Small + v6.Size.Size_800)
				},
				tag = "size-full radius-medium",
				testId = "ModelPicker.InternalSpec"
			}

			local createElement5 = React.createElement

			if v9 == nil or v9 == "" then
				v9 = internalTesting.placeholder
			end

			children2.Button = createElement3(
				view,
				{
					LayoutOrder = 2,
					tag = "size-full-1000 stroke-standard stroke-emphasis radius-medium clip",
					testId = "ModelPicker.InternalSpec--container"
				},
				{
					Open = createElement4(view, v22, {
						Value = createElement5(text, {
							Text = v9,
							tag = {
								["size-full text-body-medium text-align-x-left text-truncate-end"] = true,
								["content-emphasis"] = v10,
								["content-muted"] = not v10
							},
							testId = "ModelPicker.InternalSpec--value"
						})
					}),
					Clear = React.createElement(iconButton, {
						ZIndex = 2,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -v6.Padding.Small, 0.5, 0),
						icon = Foundation.Enums.IconName.X,
						size = Foundation.Enums.InputSize.Small,
						variant = Foundation.Enums.ButtonVariant.Utility,
						isDisabled = props.isDisabled or not v10,
						onActivated = internalTesting.onClearSpec,
						testId = "ModelPicker.InternalSpec--clear"
					})
				}
			)

			children2.Hint = React.createElement(text, {
				LayoutOrder = 3,
				Text = internalTesting.hint,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default"
			})
			v16 = createElement2(view, v18, children2)
		end

		v13.InternalSpec = v16
		v7 = createElement(
			view,
			{
				tag = "col items-stretch gap-medium size-full-0 auto-y padding-y-xsmall",
				testId = "ModelPicker.Options"
			},
			v13
		)

		if #props.data.options == 0 and internalTesting == nil then
			v7 = React.createElement(text, {
				Text = props.unavailableText,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left"
			})
		end
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v12 = {
		Chip = React.createElement(
			view,
			{
				LayoutOrder = props.LayoutOrder,
				tag = "auto-xy stroke-standard stroke-default radius-circle"
			},
			{
				Control = React.createElement(chip, {
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

	local v13 = if props.isSpecOpen and internalTesting then React.createElement(v5, {
		specVersion = internalTesting.previewHash,
		specName = fFlagBuildExperienceAdvancedPreviewSpecs and (internalTesting.previewSpecName or "build-on-mobile") or nil,
		onSave = internalTesting.onSaveSpec,
		onClose = props.onCloseSpec,
		focusRootRef = props.focusRootRef,
		hasCloseAffordance = props.hasCloseAffordance,
		testId = "ModelPicker.AgentSpecSheet"
	}) else nil
	v12.AgentSpecSheet = v13
	local v14

	if props.isOpen then
		local createElement2 = React.createElement
		local root = sheet.Root
		local v15 = {
			isOpen = true,
			preferCenterSheet = true,
			onClose = props.onClose,
			ref = props.focusRootRef,
			testId = "ModelPicker.Sheet"
		}

		local createElement3 = React.createElement
		local header = sheet.Header

		local v17 = if not props.hasCloseAffordance then false else nil
		v14 = createElement2(root, v15, {
			Header = createElement3(header, { hasCloseAffordance = v17 }, {
				Title = React.createElement(text, {
					Text = props.title,
					tag = "shrink auto-xy text-heading-small text-wrap text-align-x-left content-emphasis"
				})
			}),
			Content = React.createElement(sheet.Content, nil, { Body = v7 })
		})
	end

	v12.Sheet = v14
	return createElement(fragment, nil, v12)
end

return ModelPickerView
