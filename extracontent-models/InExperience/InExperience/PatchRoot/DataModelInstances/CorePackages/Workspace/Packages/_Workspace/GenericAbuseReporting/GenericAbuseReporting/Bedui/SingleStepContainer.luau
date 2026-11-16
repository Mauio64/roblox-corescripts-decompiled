local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local SingleStepInnerContentRenderer = require(GenericAbuseReporting.Bedui.SingleStepInnerContentRenderer)

local function SingleStepContainer(props)
	local v = useTokens()

	local contentConfig = props.contentConfig or props.node.innerContentConfig

	local createElement = React.createElement

	local v2 = {
		Title = React.createElement(Text, {
			Text = props.node.title,
			fontStyle = v.Typography.HeadingLarge,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			tag = "auto-xy padding-bottom-medium",
			LayoutOrder = 0
		}),
		Subtitle = 0,
		InnerContent = 0
	}
	local subtitle

	if props.node.subtitle and #props.node.subtitle > 0 then
		subtitle = React.createElement(Text, {
			Text = props.node.subtitle,
			fontStyle = v.Typography.LabelLarge,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			tag = "auto-xy padding-bottom-medium",
			LayoutOrder = 1
		})
	end

	v2.Subtitle = subtitle

	v2.InnerContent = React.createElement(View, { tag = "size-full-0 auto-y", LayoutOrder = 2 }, {
		InnerContentRenderer = React.createElement(SingleStepInnerContentRenderer, {
			contentConfig = contentConfig,
			formDataKeysWithError = props.formDataKeysWithError
		})
	})
	return createElement(View, { tag = "size-full-0 auto-y col gap-medium" }, v2)
end

return React.memo(SingleStepContainer)
