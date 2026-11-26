local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")
local SingleStepInnerContentRenderer = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/SingleStepInnerContentRenderer")

local function SingleStepContainer(props)
	local v5 = useTokens()

	local contentConfig = props.contentConfig or props.node.innerContentConfig

	local createElement = React.createElement

	local v8 = {
		Title = React.createElement(text, {
			Text = props.node.title,
			fontStyle = v5.Typography.HeadingLarge,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			tag = "auto-xy padding-bottom-medium",
			LayoutOrder = 0
		}),
		Subtitle = 0,
		InnerContent = 0
	}

	local v9 = if props.node.subtitle and #props.node.subtitle > 0 then React.createElement(text, {
		Text = props.node.subtitle,
		fontStyle = v5.Typography.LabelLarge,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		tag = "auto-xy padding-bottom-medium",
		LayoutOrder = 1
	}) else nil
	v8.Subtitle = v9

	v8.InnerContent = React.createElement(view, {
		tag = "size-full-0 auto-y",
		LayoutOrder = 2
	}, {
		InnerContentRenderer = React.createElement(SingleStepInnerContentRenderer, {
			contentConfig = contentConfig,
			formDataKeysWithError = props.formDataKeysWithError
		})
	})
	return createElement(view, { tag = "size-full-0 auto-y col gap-medium" }, v8)
end

return React.memo(SingleStepContainer)
