local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Components/ComponentSubtext")
local CommentTextField = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/CommentTextField")
local useFormData = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/useFormData")

local function FreeComment(props)
	local v5 = useTokens()
	local state, setState = React.useState("")
	local updateForm = useFormData().updateForm

	local v6 = React.useCallback(function(p2)
		setState(p2)
		updateForm(props.component.formDataKey, p2)
	end, { updateForm, props.component.formDataKey })

	return React.createElement(
		view,
		{ tag = "size-full-0 auto-y col gap-small", LayoutOrder = props.layoutOrder },
		{
			Prompt = React.createElement(text, {
				Text = props.component.freeComment.prompt,
				tag = "auto-xy",
				LayoutOrder = 0
			}),
			FreeCommentContainer = React.createElement(
				view,
				{
					tag = "size-full-0 auto-y col align-x-left stroke-thick stroke-default radius-medium",
					LayoutOrder = 1
				},
				{
					FreeComment = React.createElement(CommentTextField, {
						text = state,
						placeholderText = props.component.freeComment.placeholder,
						backgroundColor3 = v5.Color.Shift.Shift_100.Color3,
						backgroundTransparency = v5.Color.Shift.Shift_100.Transparency,
						onUpdate = v6,
						layoutOrder = 1
					})
				}
			),
			ComponentSubtext = React.createElement(module3, {
				isErrorState = props.isErrorState,
				isOptional = props.component.isOptional,
				requirementMessage = props.component.requirementMessage,
				layoutOrder = 2
			})
		}
	)
end

return React.memo(FreeComment)
