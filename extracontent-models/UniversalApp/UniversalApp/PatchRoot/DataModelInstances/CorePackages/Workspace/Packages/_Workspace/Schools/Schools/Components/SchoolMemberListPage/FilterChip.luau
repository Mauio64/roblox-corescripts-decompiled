local Parent = script:FindFirstAncestor("Schools").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local Chip = Foundation.Chip
local Sheet = Foundation.Sheet
local RadioGroup = Foundation.RadioGroup
local FoundationText = Foundation.Text
local Button = Foundation.Button
local View = Foundation.View
local ChipSize = Foundation.Enums.ChipSize
local InputSize = Foundation.Enums.InputSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconName = Foundation.Enums.IconName

local function FilterChip(t1: {[any]: any}) -- line: 45
	-- upvalues: React (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy), RadioGroup (copy), Chip (copy), IconName (copy), ChipSize (copy), Sheet (copy), FoundationText (copy), View (copy), Button (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy)
	local v20, v21 = React.useState(false)
	local v22, v23 = React.useState(t1.value)
	local v24, v25 = React.useMemo(function() -- line: 49
		-- upvalues: t1 (copy)
		if t1.value ~= nil and t1.value ~= t1.defaultValue then
			for _, v33 in t1.options do
				if v33.id == t1.value then
					return v33.text, true
				end
			end
		end

		return t1.label, false
	end, {
		t1.options,
		t1.value,
		t1.label,
		t1.defaultValue
	})
	local v26 = React.useCallback(function() -- line: 61
		-- upvalues: v23 (copy), t1 (copy), v21 (copy)
		v23(t1.value)
		v21(true)
	end, { t1.value })
	local v27 = React.useCallback(function() -- line: 66
		-- upvalues: v21 (copy)
		v21(false)
	end, {})
	local v28, v29 = React.useState(nil)

	useFocusNavigableSurfaceRegistryConnection(v28, FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v20)

	local v30 = React.useCallback(function() -- line: 77
		-- upvalues: v21 (copy), v22 (copy), t1 (copy)
		v21(false)

		if v22 ~= nil then
			t1.onChanged(v22)
		end
	end, {
		v22,
		t1.onChanged
	})
	local v31 = React.useMemo(function() -- line: 84
		-- upvalues: t1 (copy), React (copy), RadioGroup (copy)
		local t2 = {}

		for v35, v36 in t1.options do
			t2[`item_{ v36.id }`] = React.createElement(RadioGroup.Item, {
				value = v36.id,
				label = v36.label or v36.text,
				LayoutOrder = v35
			})
		end

		return t2
	end, { t1.options })

	return React.createElement(React.Fragment, nil, {
		Chip = React.createElement(Chip, {
			text = v24,
			trailing = IconName.ChevronLargeDown,
			isChecked = v25,
			size = ChipSize.Small,
			onActivated = v26,
			LayoutOrder = t1.layoutOrder
		}),
		PickerSheet = React.createElement(Sheet.Root, {
			preferCenterSheet = true,
			isOpen = v20,
			onClose = v27,
			ref = v29
		}, {
			Header = React.createElement(Sheet.Header, {
				hasCloseAffordance = true
			}, {
				Title = React.createElement(FoundationText, {
					tag = "fill auto-y text-title-large text-align-x-left content-emphasis",
					Text = t1.sheetTitle
				})
			}),
			Content = React.createElement(Sheet.Content, {
				Selectable = false
			}, {
				Options = React.createElement(View, {
					tag = "col size-full-0 auto-y"
				}, {
					Group = React.createElement(RadioGroup.Root, {
						value = v22,
						onValueChanged = v23
					}, v31)
				})
			}),
			Actions = React.createElement(Sheet.Actions, nil, {
				Apply = React.createElement(Button, {
					LayoutOrder = 1,
					text = t1.applyText,
					size = InputSize.Large,
					variant = ButtonVariant.Emphasis,
					fillBehavior = FillBehavior.Fill,
					onActivated = v30
				})
			})
		})
	})
end

return FilterChip
