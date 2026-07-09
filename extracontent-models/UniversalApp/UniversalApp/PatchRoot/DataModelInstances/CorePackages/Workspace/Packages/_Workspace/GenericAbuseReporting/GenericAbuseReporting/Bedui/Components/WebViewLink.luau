local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local AppLinking = require(GenericAbuseReportingParent.RoactServiceTags).AppLinking
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local useAppPolicy = require(GenericAbuseReportingParent.UniversalAppPolicy).useAppPolicy
local useRoactService = require(GenericAbuseReportingParent.RobloxAppHooks).useRoactService
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ControlState = Foundation.Enums.ControlState
local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName
local FoundationText = Foundation.Text
local View = Foundation.View
local NotificationType = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes).NotificationType
local FFlagChangeWebViewReportButtonToText = require(GenericAbuseReportingParent.SharedFlags).FFlagChangeWebViewReportButtonToText
local v19 = game:DefineFastFlag("FixWebViewLinkCutOff", false)

return React.memo(function(t1: {[any]: any}) -- line: 34
	-- upvalues: FFlagChangeWebViewReportButtonToText (copy), useRoactService (copy), AppLinking (copy), useAppPolicy (copy), React (copy), HttpService (copy), GuiService (copy), NotificationType (copy), v19 (copy), getIconRichText (copy), IconName (copy), ControlState (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy)
	local u21 = nil
	local u22

	if FFlagChangeWebViewReportButtonToText then
		u21 = useRoactService(AppLinking)
		u22 = useAppPolicy(function(p1) -- line: 39
			return p1.getWebViewSupport()
		end)
	else
		u22 = true
	end

	local v23 = React.useCallback(function() -- line: 46
		-- upvalues: FFlagChangeWebViewReportButtonToText (copy), u22 (ref), u21 (ref), t1 (copy), HttpService (copy), GuiService (copy), NotificationType (copy)
		if FFlagChangeWebViewReportButtonToText and not u22 then
			u21:openURL(t1.component.link.url)

			return
		end

		local ok, result = pcall(function() -- line: 50
			-- upvalues: HttpService (copy), t1 (copy)
			return HttpService:JSONEncode({
				presentationStyle = nil,
				visible = true,
				title = t1.component.link.label,
				url = t1.component.link.url
			})
		end)

		if not ok then
			warn("Failed to encode notification data for bedui webview link")

			return
		end

		GuiService:BroadcastNotification(result, NotificationType.OpenCustomWebView)
	end, {
		t1.component.link.label,
		t1.component.link.url
	})
	local v24, v25 = React.useBinding(false)
	local v26 = if not v19 then nil else React.useMemo(function() -- line: 69
		-- upvalues: t1 (copy), getIconRichText (copy), IconName (copy)
		return t1.component.link.linkButtonLabel .. ` { getIconRichText(IconName.ArrowUpRightFromSquare) }`
	end, { t1.component.link.linkButtonLabel })
	local v27 = if not v19 then nil else React.useCallback(function(p2) -- line: 75
		-- upvalues: ControlState (copy), v25 (copy)
		if p2 == ControlState.Hover then
			v25(true)

			return
		end

		v25(false)
	end, {})

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder
	}, if not v19 then React.createElement(Button, {
		text = t1.component.link.linkButtonLabel,
		variant = ButtonVariant.Text,
		onActivated = v23
	}) else React.createElement(FoundationText, {
		RichText = true,
		tag = "auto-xy padding-xsmall text-body-small text-wrap text-align-x-left radius-medium",
		Text = v24:map(function(p3) -- line: 92
			-- upvalues: v26 (copy)
			if p3 then
				return `<u>{ v26 }</u>`
			end

			return v26
		end),
		onActivated = v23,
		onStateChanged = v27
	}))
end)
