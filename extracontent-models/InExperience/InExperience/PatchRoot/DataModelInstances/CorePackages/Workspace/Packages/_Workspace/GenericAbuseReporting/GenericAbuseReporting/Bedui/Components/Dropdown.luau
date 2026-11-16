local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Text = Foundation.Text
local View = Foundation.View

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local ComponentSubtext = require(GenericAbuseReporting.Bedui.Components.ComponentSubtext)
local DropdownWithPopover = require(GenericAbuseReporting.Common.DropdownWithPopover)
local useFormData = require(GenericAbuseReporting.Bedui.Provider.useFormData)

local function Dropdown(props)
	local updateForm = useFormData().updateForm

	local cellDatas = React.useMemo(function()
		return Cryo.List.map(props.component.dropdown.items, function(p)
			return {
				text = p.label or "",
				value = p.formDataValue
			}
		end)
	end, { props.component.dropdown.items })

	local onChange = React.useCallback(function(p: string)
		updateForm(props.component.formDataKey, p)
	end, { props.component.formDataKey })

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = props.layoutOrder
	}, {
		Prompt = React.createElement(Text, {
			Text = props.component.dropdown.prompt,
			tag = "auto-xy",
			LayoutOrder = 0
		}),
		DropdownMenuContainer = React.createElement(
			View,
			{ tag = "size-full-0 auto-y col gap-small", LayoutOrder = 1, ZIndex = 3 },
			{
				DropdownWithPopover = React.createElement(DropdownWithPopover, {
					placeholder = props.component.dropdown.placeholder,
					onChange = onChange,
					cellDatas = cellDatas,
					errorState = props.isErrorState,
					layoutOrder = 1
				}),
				ComponentSubtext = React.createElement(ComponentSubtext, {
					isErrorState = props.isErrorState,
					isOptional = props.component.isOptional,
					requirementMessage = props.component.requirementMessage,
					layoutOrder = 2
				})
			}
		)
	})
end

return React.memo(Dropdown)
