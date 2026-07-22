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
local v18 = game:DefineFastFlag("FixWebViewLinkCutOff", false)

return React.memo(function(t1: {[any]: any}) -- line: 32
	-- upvalues: useRoactService (copy), AppLinking (copy), useAppPolicy (copy), React (copy), HttpService (copy), GuiService (copy), NotificationType (copy), v18 (copy), getIconRichText (copy), IconName (copy), ControlState (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy)
	local v20 = useRoactService(AppLinking)
	local v21 = useAppPolicy(function(p1) -- line: 34
		return p1.getWebViewSupport()
	end)
	local v22 = React.useCallback(function() -- line: 38
		-- upvalues: v21 (copy), v20 (copy), t1 (copy), HttpService (copy), GuiService (copy), NotificationType (copy)
		if not v21 then
			v20:openURL(t1.component.link.url)

			return
		end

		local ok, result = pcall(function() -- line: 42
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
	local v23, v24 = React.useBinding(false)
	local v25 = if not v18 then nil else React.useMemo(function() -- line: 61
		-- upvalues: t1 (copy), getIconRichText (copy), IconName (copy)
		return t1.component.link.linkButtonLabel .. ` { getIconRichText(IconName.ArrowUpRightFromSquare) }`
	end, { t1.component.link.linkButtonLabel })
	local v26 = if not v18 then nil else React.useCallback(function(p2) -- line: 67
		-- upvalues: ControlState (copy), v24 (copy)
		if p2 == ControlState.Hover then
			v24(true)

			return
		end

		v24(false)
	end, {})

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder
	}, if not v18 then React.createElement(Button, {
		text = t1.component.link.linkButtonLabel,
		variant = ButtonVariant.Text,
		onActivated = v22
	}) else React.createElement(FoundationText, {
		RichText = true,
		tag = "auto-xy padding-xsmall text-body-small text-wrap text-align-x-left radius-medium",
		Text = v23:map(function(p3) -- line: 84
			-- upvalues: v25 (copy)
			if p3 then
				return `<u>{ v25 }</u>`
			end

			return v25
		end),
		onActivated = v22,
		onStateChanged = v26
	}))
end)
