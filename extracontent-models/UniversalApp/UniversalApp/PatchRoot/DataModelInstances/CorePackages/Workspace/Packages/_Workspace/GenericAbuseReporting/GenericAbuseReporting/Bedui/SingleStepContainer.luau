local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

local SingleStepInnerContentRenderer = require(GenericAbuseReporting.Bedui.SingleStepInnerContentRenderer)

local function SingleStepContainer(t1: {[any]: any}) -- line: 23
	-- upvalues: useTokens (copy), React (copy), View (copy), FoundationText (copy), SingleStepInnerContentRenderer (copy)
	local v11 = useTokens()
	local v12 = t1.contentConfig or t1.node.innerContentConfig

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-medium"
	}, {
		Title = React.createElement(FoundationText, {
			TextWrapped = true,
			tag = "auto-xy padding-bottom-medium",
			LayoutOrder = 0,
			Text = t1.node.title,
			fontStyle = v11.Typography.HeadingLarge,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		Subtitle = if not t1.node.subtitle or not (#t1.node.subtitle > 0) then nil else React.createElement(FoundationText, {
			TextWrapped = true,
			tag = "auto-xy padding-bottom-medium",
			LayoutOrder = 1,
			Text = t1.node.subtitle,
			fontStyle = v11.Typography.LabelLarge,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		InnerContent = React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			InnerContentRenderer = React.createElement(SingleStepInnerContentRenderer, {
				contentConfig = v12,
				formDataKeysWithError = t1.formDataKeysWithError
			})
		})
	})
end

return React.memo(SingleStepContainer)
