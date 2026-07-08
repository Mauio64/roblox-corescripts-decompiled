local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Cryo = require(GenericAbuseReportingParent.Cryo)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local FoundationText = Foundation.Text
local View = Foundation.View

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

local ComponentSubtext = require(GenericAbuseReporting.Bedui.Components.ComponentSubtext)
local DropdownWithPopover = require(GenericAbuseReporting.Common.DropdownWithPopover)
local useFormData = require(GenericAbuseReporting.Bedui.Provider.useFormData)

local function Dropdown(t1: {[any]: any}) -- line: 24
	-- upvalues: useFormData (copy), React (copy), Cryo (copy), View (copy), FoundationText (copy), DropdownWithPopover (copy), ComponentSubtext (copy)
	local updateForm = useFormData().updateForm
	local v14 = React.useMemo(function() -- line: 27
		-- upvalues: Cryo (copy), t1 (copy)
		return Cryo.List.map(t1.component.dropdown.items, function(p1) -- line: 28
			return {
				text = p1.label or "",
				value = p1.formDataValue
			}
		end)
	end, { t1.component.dropdown.items })
	local v15 = React.useCallback(function(s1: string) -- line: 36
		-- upvalues: updateForm (copy), t1 (copy)
		updateForm(t1.component.formDataKey, s1)
	end, { t1.component.formDataKey })

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = t1.layoutOrder
	}, {
		Prompt = React.createElement(FoundationText, {
			tag = "auto-xy",
			LayoutOrder = 0,
			Text = t1.component.dropdown.prompt
		}),
		DropdownMenuContainer = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-small",
			LayoutOrder = 1,
			ZIndex = 3
		}, {
			DropdownWithPopover = React.createElement(DropdownWithPopover, {
				layoutOrder = 1,
				placeholder = t1.component.dropdown.placeholder,
				onChange = v15,
				cellDatas = v14,
				errorState = t1.isErrorState
			}),
			ComponentSubtext = React.createElement(ComponentSubtext, {
				layoutOrder = 2,
				isErrorState = t1.isErrorState,
				isOptional = t1.component.isOptional,
				requirementMessage = t1.component.requirementMessage
			})
		})
	})
end

return React.memo(Dropdown)
