local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local ComponentSubtext = require(GenericAbuseReporting.Bedui.Components.ComponentSubtext)
local CommentTextField = require(GenericAbuseReporting.Common.CommentTextField)
local useFormData = require(GenericAbuseReporting.Bedui.Provider.useFormData)

local function FreeComment(props)
	local v = useTokens()
	local state, setState = React.useState("")
	local updateForm = useFormData().updateForm

	local onUpdate = React.useCallback(function(p: string)
		setState(p)
		updateForm(props.component.formDataKey, p)
	end, { updateForm, props.component.formDataKey })

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = props.layoutOrder
	}, {
		Prompt = React.createElement(Text, {
			Text = props.component.freeComment.prompt,
			tag = "auto-xy",
			LayoutOrder = 0
		}),
		FreeCommentContainer = React.createElement(
			View,
			{
				tag = "size-full-0 auto-y col align-x-left stroke-thick stroke-default radius-medium",
				LayoutOrder = 1
			},
			{
				FreeComment = React.createElement(CommentTextField, {
					text = state,
					placeholderText = props.component.freeComment.placeholder,
					backgroundColor3 = v.Color.Shift.Shift_100.Color3,
					backgroundTransparency = v.Color.Shift.Shift_100.Transparency,
					onUpdate = onUpdate,
					layoutOrder = 1
				})
			}
		),
		ComponentSubtext = React.createElement(ComponentSubtext, {
			isErrorState = props.isErrorState,
			isOptional = props.component.isOptional,
			requirementMessage = props.component.requirementMessage,
			layoutOrder = 2
		})
	})
end

return React.memo(FreeComment)
