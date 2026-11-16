local parent = script:FindFirstAncestor("DsaIllegalContentReporting").Parent
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput

local ControlState = Foundation.Enums.ControlState
local Text = Foundation.Text
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

local _ = { OPEN_CUSTOM_WEBVIEW = 20 }

local function OSAReportLink()
	local v = useTokens()
	local state, setState = React.useState(nil)
	local v2 = usePreferredInput() == Responsive.Input.Directional
	local v3 = Responsive.useIsSpatial()
	local v4 = v2 or v3

	local v5 = useLocalization({
		HelpPageTitle = "Feature.ReportAbuse.DSAIllegal.ReportPageTitle",
		OSACopy1 = "Feature.ReportAbuse.Message.OSACopy1",
		OSACopy2 = "Feature.ReportAbuse.Message.OSACopy2",
		OSACopy3 = "Feature.ReportAbuse.Message.OSACopy3",
		OSACopy4 = "Feature.ReportAbuse.Message.OSACopy4",
		OSACopyReadOnly = "Feature.ReportAbuse.Message.OSACopyReadOnly"
	})

	local onActivated = React.useCallback(function()
		GuiService:BroadcastNotification(
			HttpService:JSONEncode({
				title = v5.HelpPageTitle,
				presentationStyle = nil,
				visible = true,
				url = "https://www.roblox.com/illegal-content-reporting"
			}),
			20
		)
	end, {})

	local onStateChanged = React.useCallback(function(p)
		if p == ControlState.Hover then
			setState(v.Color.State.Hover)
		elseif p == ControlState.Pressed then
			setState(v.Color.State.Press)
		else
			setState(nil)
		end
	end, {})

	local createElement = React.createElement

	local createElement2 = React.createElement
	local text

	if v4 then
		text = `<b>{v5.OSACopyReadOnly}</b>`
	else
		text = `<b>{v5.OSACopy4}</b>`
	end

	local v6 = {
		Text = text,
		RichText = true,
		backgroundStyle = state,
		fontStyle = v.Typography.BodySmall,
		textStyle = v.Color.Content.Emphasis,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		onActivated = 0,
		onStateChanged = 0,
		tag = "auto-xy radius-small padding-xsmall",
		LayoutOrder = 2
	}

	if v4 then
		onActivated = nil
	end

	v6.onActivated = onActivated

	if v4 then
		onStateChanged = nil
	end

	v6.onStateChanged = onStateChanged
	return createElement(View, { tag = "size-full col gap-small" }, {
		OSALink = createElement2(Text, v6)
	})
end

return React.memo(OSAReportLink)
