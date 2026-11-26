local module = require("@luauforge/deferred/eko")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local module3 = require("@luauforge/deferred/fcB")

local focusNavigableSurfaceIdentifierEnum = module3.FocusNavigableSurfaceIdentifierEnum
local useFocusNavigableSurfaceRegistryConnection = module3.useFocusNavigableSurfaceRegistryConnection

local chip = Foundation.Chip
local sheet = Foundation.Sheet
local radioGroup = Foundation.RadioGroup
local text = Foundation.Text
local button = Foundation.Button
local view = Foundation.View

local chipSize = Foundation.Enums.ChipSize
local inputSize = Foundation.Enums.InputSize
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local iconName = Foundation.Enums.IconName

local function FilterChip(props)
	local state, setState = module.useState(false)
	local state2, setState2 = module.useState(props.value)

	local v5, v6 = module.useMemo(function()
		local v7 = not (props.value == nil) and props.value ~= props.defaultValue

		if v7 then
			for k, option in props.options do
				if option.id == props.value then
					return option.text, true
				end
			end
		end

		return props.label, false
	end, { props.options, props.value, props.label, props.defaultValue })

	local v7 = module.useCallback(function()
		setState2(props.value)
		setState(true)
	end, { props.value })

	local v8 = module.useCallback(function()
		setState(false)
	end, {})

	local state3, setState3 = module.useState(nil)
	useFocusNavigableSurfaceRegistryConnection(
		state3,
		focusNavigableSurfaceIdentifierEnum.CentralOverlay,
		state
	)

	local v9 = module.useMemo(function(): boolean
		return state2 == props.value
	end, { state2, props.value })

	local v10 = module.useCallback(function()
		setState(false)

		if state2 ~= nil then
			props.onChanged(state2)
		end
	end, { state2, props.onChanged })

	local v11 = module.useMemo(function()
		local children = {}

		for k, option in props.options do
			children[`item_{option.id}`] = module.createElement(radioGroup.Item, {
				value = option.id,
				label = option.label or option.text,
				LayoutOrder = k
			})
		end

		return children
	end, { props.options })

	return module.createElement(module.Fragment, nil, {
		Chip = module.createElement(chip, {
			text = v5,
			trailing = iconName.ChevronLargeDown,
			isChecked = v6,
			size = chipSize.Medium,
			onActivated = v7,
			LayoutOrder = props.layoutOrder
		}),
		PickerSheet = module.createElement(
			sheet.Root,
			{ isOpen = state, onClose = v8, preferCenterSheet = true, ref = setState3 },
			{
				Header = module.createElement(sheet.Header, {
					hasCloseAffordance = true
				}, {
					Title = module.createElement(text, {
						Text = props.sheetTitle,
						tag = "fill auto-y text-heading-small text-align-x-left content-emphasis"
					})
				}),
				Content = module.createElement(sheet.Content, { Selectable = false }, {
					Options = module.createElement(view, {
						tag = "col size-full-0 auto-y"
					}, {
						Group = module.createElement(
							radioGroup.Root,
							{ value = state2, onValueChanged = setState2 },
							v11
						)
					})
				}),
				Actions = module.createElement(sheet.Actions, nil, {
					Apply = module.createElement(button, {
						text = props.applyText,
						size = inputSize.Large,
						variant = buttonVariant.Emphasis,
						fillBehavior = fillBehavior.Fill,
						isDisabled = v9,
						onActivated = v10,
						LayoutOrder = 1
					})
				})
			}
		)
	})
end

return FilterChip
