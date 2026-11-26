local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/React")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/Localization")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/Responsive")
local usePreferredInput = Responsive.usePreferredInput

local controlState = Foundation.Enums.ControlState
local text = Foundation.Text
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View

local v5 = { OPEN_CUSTOM_WEBVIEW = 20 }

local function OSAReportLink()
	local v6 = useTokens()
	local state, setState = React.useState(nil)
	local v7 = usePreferredInput() == Responsive.Input.Directional
	local v8 = Responsive.useIsSpatial()
	local v9 = v7 or v8

	local v10 = useLocalization({
		HelpPageTitle = "Feature.ReportAbuse.DSAIllegal.ReportPageTitle",
		OSACopy1 = "Feature.ReportAbuse.Message.OSACopy1",
		OSACopy2 = "Feature.ReportAbuse.Message.OSACopy2",
		OSACopy3 = "Feature.ReportAbuse.Message.OSACopy3",
		OSACopy4 = "Feature.ReportAbuse.Message.OSACopy4",
		OSACopyReadOnly = "Feature.ReportAbuse.Message.OSACopyReadOnly"
	})

	local v11 = React.useCallback(function()
		GuiService:BroadcastNotification(
			HttpService:JSONEncode({
				title = v10.HelpPageTitle,
				presentationStyle = nil,
				visible = true,
				url = "https://www.roblox.com/illegal-content-reporting"
			}),
			20
		)
	end, {})

	local v12 = React.useCallback(function(p2)
		if p2 == controlState.Hover then
			setState(v6.Color.State.Hover)
		elseif p2 == controlState.Pressed then
			setState(v6.Color.State.Press)
		else
			setState(nil)
		end
	end, {})

	local createElement = React.createElement

	local createElement2 = React.createElement

	local v18 = if v9 then `<b>{v10.OSACopyReadOnly}</b>` else `<b>{v10.OSACopy4}</b>`
	local v17 = {
		Text = v18,
		RichText = true,
		backgroundStyle = state,
		fontStyle = v6.Typography.BodySmall,
		textStyle = v6.Color.Content.Emphasis,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		onActivated = 0,
		onStateChanged = 0,
		tag = "auto-xy radius-small padding-xsmall",
		LayoutOrder = 2
	}

	if v9 then
		v11 = nil
	end

	v17.onActivated = v11

	if v9 then
		v12 = nil
	end

	v17.onStateChanged = v12
	return createElement(view, { tag = "size-full col gap-small" }, {
		OSALink = createElement2(text, v17)
	})
end

return React.memo(OSAReportLink)
