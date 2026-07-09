local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

local ComponentSubtext = require(GenericAbuseReporting.Bedui.Components.ComponentSubtext)
local CommentTextField = require(GenericAbuseReporting.Common.CommentTextField)
local useFormData = require(GenericAbuseReporting.Bedui.Provider.useFormData)

local function FreeComment(t1: {[any]: any}) -- line: 24
	-- upvalues: useTokens (copy), React (copy), useFormData (copy), View (copy), FoundationText (copy), CommentTextField (copy), ComponentSubtext (copy)
	local v13 = useTokens()
	local v14, v15 = React.useState("")
	local updateForm = useFormData().updateForm
	local v17 = React.useCallback(function(s1: string) -- line: 29
		-- upvalues: v15 (copy), updateForm (copy), t1 (copy)
		v15(s1)
		updateForm(t1.component.formDataKey, s1)
	end, {
		updateForm,
		t1.component.formDataKey
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = t1.layoutOrder
	}, {
		Prompt = React.createElement(FoundationText, {
			tag = "auto-xy",
			LayoutOrder = 0,
			Text = t1.component.freeComment.prompt
		}),
		FreeCommentContainer = React.createElement(View, {
			tag = "size-full-0 auto-y col align-x-left stroke-thick stroke-default radius-medium",
			LayoutOrder = 1
		}, {
			FreeComment = React.createElement(CommentTextField, {
				layoutOrder = 1,
				text = v14,
				placeholderText = t1.component.freeComment.placeholder,
				backgroundColor3 = v13.Color.Shift.Shift_100.Color3,
				backgroundTransparency = v13.Color.Shift.Shift_100.Transparency,
				onUpdate = v17
			})
		}),
		ComponentSubtext = React.createElement(ComponentSubtext, {
			layoutOrder = 2,
			isErrorState = t1.isErrorState,
			isOptional = t1.component.isOptional,
			requirementMessage = t1.component.requirementMessage
		})
	})
end

return React.memo(FreeComment)
