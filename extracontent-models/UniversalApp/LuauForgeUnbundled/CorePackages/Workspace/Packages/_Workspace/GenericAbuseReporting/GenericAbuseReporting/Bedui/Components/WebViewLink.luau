local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local appLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RoactServiceTags").AppLinking
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/UniversalAppPolicy").useAppPolicy
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppHooks").useRoactService

local controlState = Foundation.Enums.ControlState
local getIconRichText = Foundation.Utility.getIconRichText
local iconName = Foundation.Enums.IconName
local text = Foundation.Text
local view = Foundation.View

local notificationType = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes").NotificationType

return React.memo(function(p2)
	local v5 = useRoactService(appLinking)
	local v6 = useAppPolicy(function(p3)
		return p3.getWebViewSupport()
	end)

	local v7 = React.useCallback(function()
		if not v6 then
			v5:openURL(p2.component.link.url)
			return
		end

		local success, result = pcall(function()
			return HttpService:JSONEncode({
				title = p2.component.link.label,
				presentationStyle = nil,
				visible = true,
				url = p2.component.link.url
			})
		end)

		if success then
			GuiService:BroadcastNotification(result, notificationType.OpenCustomWebView)
		else
			warn("Failed to encode notification data for bedui webview link")
		end
	end, { p2.component.link.label, p2.component.link.url })

	local v8, v9 = React.useBinding(false)

	local v10 = React.useMemo(function()
		return p2.component.link.linkButtonLabel .. ` {getIconRichText(iconName.ArrowUpRightFromSquare)}`
	end, { p2.component.link.linkButtonLabel })

	local v11 = React.useCallback(function(p3)
		if p3 == controlState.Hover then
			v9(true)
		else
			v9(false)
		end
	end, {})

	return React.createElement(
		view,
		{ tag = "size-full-0 auto-y", LayoutOrder = p2.layoutOrder },
		React.createElement(text, {
			Text = v8:map(function(p3)
				if p3 then
					return `<u>{v10}</u>`
				end

				return v10
			end),
			RichText = true,
			onActivated = v7,
			onStateChanged = v11,
			tag = "auto-xy padding-xsmall text-body-small text-wrap text-align-x-left radius-medium"
		})
	)
end)
