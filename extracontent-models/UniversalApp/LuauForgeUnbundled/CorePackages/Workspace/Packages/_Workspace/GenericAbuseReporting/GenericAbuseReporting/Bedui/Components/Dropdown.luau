local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local text = Foundation.Text
local view = Foundation.View

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Components/ComponentSubtext")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/DropdownWithPopover")
local useFormData = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/useFormData")

local function Dropdown(props)
	local updateForm = useFormData().updateForm

	local v5 = React.useMemo(function()
		return Cryo.List.map(props.component.dropdown.items, function(p2)
			return {
				text = p2.label or "",
				value = p2.formDataValue
			}
		end)
	end, { props.component.dropdown.items })

	local v6 = React.useCallback(function(p2)
		updateForm(props.component.formDataKey, p2)
	end, { props.component.formDataKey })

	return React.createElement(
		view,
		{ tag = "size-full-0 auto-y col gap-small", LayoutOrder = props.layoutOrder },
		{
			Prompt = React.createElement(text, {
				Text = props.component.dropdown.prompt,
				tag = "auto-xy",
				LayoutOrder = 0
			}),
			DropdownMenuContainer = React.createElement(
				view,
				{
					tag = "size-full-0 auto-y col gap-small",
					LayoutOrder = 1,
					ZIndex = 3
				},
				{
					DropdownWithPopover = React.createElement(module5, {
						placeholder = props.component.dropdown.placeholder,
						onChange = v6,
						cellDatas = v5,
						errorState = props.isErrorState,
						layoutOrder = 1
					}),
					ComponentSubtext = React.createElement(module4, {
						isErrorState = props.isErrorState,
						isOptional = props.component.isOptional,
						requirementMessage = props.component.requirementMessage,
						layoutOrder = 2
					})
				}
			)
		}
	)
end

return React.memo(Dropdown)
