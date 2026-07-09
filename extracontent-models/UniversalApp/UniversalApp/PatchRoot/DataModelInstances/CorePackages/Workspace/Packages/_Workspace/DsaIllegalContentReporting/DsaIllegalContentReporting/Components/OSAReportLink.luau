local Parent = script:FindFirstAncestor("DsaIllegalContentReporting").Parent
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Localization = require(Parent.Localization)
local Responsive = require(Parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local ControlState = Foundation.Enums.ControlState
local FoundationText = Foundation.Text
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local _ = {
	OPEN_CUSTOM_WEBVIEW = 20
}

local function OSAReportLink() -- line: 24
	-- upvalues: useTokens (copy), React (copy), usePreferredInput (copy), Responsive (copy), useLocalization (copy), HttpService (copy), GuiService (copy), ControlState (copy), View (copy), FoundationText (copy)
	local v16 = useTokens()
	local v17, v18 = React.useState(nil)
	local v19 = usePreferredInput() == Responsive.Input.Directional
	local v20 = Responsive.useIsSpatial()
	local v21 = v19 or v20
	local v22 = useLocalization({
		HelpPageTitle = "Feature.ReportAbuse.DSAIllegal.ReportPageTitle",
		OSACopy1 = "Feature.ReportAbuse.Message.OSACopy1",
		OSACopy2 = "Feature.ReportAbuse.Message.OSACopy2",
		OSACopy3 = "Feature.ReportAbuse.Message.OSACopy3",
		OSACopy4 = "Feature.ReportAbuse.Message.OSACopy4",
		OSACopyReadOnly = "Feature.ReportAbuse.Message.OSACopyReadOnly"
	})
	local v23 = React.useCallback(function() -- line: 40
		-- upvalues: HttpService (copy), v22 (copy), GuiService (copy)
		local json = HttpService:JSONEncode({
			presentationStyle = nil,
			visible = true,
			url = "https://www.roblox.com/illegal-content-reporting",
			title = v22.HelpPageTitle
		})

		GuiService:BroadcastNotification(json, 20)
	end, {})
	local v24 = React.useCallback(function(p1) -- line: 50
		-- upvalues: ControlState (copy), v18 (copy), v16 (copy)
		if p1 == ControlState.Hover then
			v18(v16.Color.State.Hover)

			return
		end

		if p1 == ControlState.Pressed then
			v18(v16.Color.State.Press)

			return
		end

		v18(nil)
	end, {})

	return React.createElement(View, {
		tag = "size-full col gap-small"
	}, {
		OSALink = React.createElement(FoundationText, {
			RichText = true,
			TextWrapped = true,
			tag = "auto-xy radius-small padding-xsmall",
			LayoutOrder = 2,
			Text = if not v21 then `<b>{ v22.OSACopy4 }</b>` else `<b>{ v22.OSACopyReadOnly }</b>`,
			backgroundStyle = v17,
			fontStyle = v16.Typography.BodySmall,
			textStyle = v16.Color.Content.Emphasis,
			TextXAlignment = Enum.TextXAlignment.Left,
			onActivated = if not v21 then v23 else nil,
			onStateChanged = if not v21 then v24 else nil
		})
	})
end

return React.memo(OSAReportLink)
