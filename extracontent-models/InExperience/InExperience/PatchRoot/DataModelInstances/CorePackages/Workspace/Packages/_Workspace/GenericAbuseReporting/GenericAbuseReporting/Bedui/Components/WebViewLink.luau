local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local RoactServiceTags = require(parent.RoactServiceTags)
local AppLinking = RoactServiceTags.AppLinking
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local ControlState = Foundation.Enums.ControlState
local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName
local Text = Foundation.Text
local View = Foundation.View

local AbuseReportBeduiTypes = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local NotificationType = AbuseReportBeduiTypes.NotificationType

return React.memo(function(p)
	local v = useRoactService(AppLinking)
	local v2 = useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)

	local onActivated = React.useCallback(function()
		if not v2 then
			v:openURL(p.component.link.url)
			return
		end

		local success, result = pcall(function()
			return HttpService:JSONEncode({
				title = p.component.link.label,
				presentationStyle = nil,
				visible = true,
				url = p.component.link.url
			})
		end)

		if success then
			GuiService:BroadcastNotification(result, NotificationType.OpenCustomWebView)
		else
			warn("Failed to encode notification data for bedui webview link")
		end
	end, { p.component.link.label, p.component.link.url })

	local v3, v4 = React.useBinding(false)

	local v5 = React.useMemo(function()
		return p.component.link.linkButtonLabel .. ` {getIconRichText(IconName.ArrowUpRightFromSquare)}`
	end, { p.component.link.linkButtonLabel })

	local onStateChanged = React.useCallback(function(p2)
		if p2 == ControlState.Hover then
			v4(true)
		else
			v4(false)
		end
	end, {})

	return React.createElement(
		View,
		{ tag = "size-full-0 auto-y", LayoutOrder = p.layoutOrder },
		React.createElement(Text, {
			Text = v3:map(function(p2)
				if p2 then
					return `<u>{v5}</u>`
				end

				return v5
			end),
			RichText = true,
			onActivated = onActivated,
			onStateChanged = onStateChanged,
			tag = "auto-xy padding-xsmall text-body-small text-wrap text-align-x-left radius-medium"
		})
	)
end)
