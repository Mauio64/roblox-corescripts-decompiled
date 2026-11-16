local WebViewService = game:GetService("WebViewService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")

local parent = script.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)
local Dialog = Foundation.Dialog
local View = Foundation.View
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local AdDisclosureTelemetry = require(parent.AdDisclosureTelemetry)

local SharedFlags = require(parent2.SharedFlags)
local FStringLuaAppAdPreferencesUrl = SharedFlags.FStringLuaAppAdPreferencesUrl
local SharedFlags2 = require(parent2.SharedFlags)
local GetFFlagEnableUnifiedWebViews = SharedFlags2.GetFFlagEnableUnifiedWebViews

local useLocalization = Localization.Hooks.useLocalization

local function WhyThisAdModal(props)
	local v = useLocalization({
		whyThisAd = "Feature.GameDetails.Label.WhyThisAd",
		adPreferences = "Feature.GameDetails.Message.AdPreferences"
	})

	local v2 = useTokens()

	local createElement = React.createElement
	local root = Dialog.Root
	local v3 = { onClose = props.onClose, hasBackdrop = true, disablePortal = false }

	local v4 = {
		DialogTitle = React.createElement(Dialog.Title, { text = v.whyThisAd }),
		DialogContent = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content
	local createElement3 = React.createElement

	local v5 = {
		DialogText = React.createElement(Dialog.Text, {
			Text = props.adDisclosureBody,
			LayoutOrder = 1
		}),
		AdPreferences = 0
	}
	local adPreferences

	if props.showAdPreferencesUrl then
		adPreferences = React.createElement(Text, {
			Text = v.adPreferences,
			textStyle = v2.Color.Content.Link,
			fontStyle = v2.Typography.BodyMedium,
			tag = "auto-xy",
			onActivated = function()
				AdDisclosureTelemetry.logAdPreferencesLinkClicked()

				if not GetFFlagEnableUnifiedWebViews() then
					BrowserService:SendCommand((HttpService:JSONEncode({
						command = "open",
						url = FStringLuaAppAdPreferencesUrl,
						title = v.adPreferences,
						visible = true,
						isGenericWebview = true
					})))

					return
				end

				local onWindowClosedConnection = nil
				onWindowClosedConnection = WebViewService.OnWindowClosed:Connect(function()
					WebViewService:CloseWindow()

					if onWindowClosedConnection then
						onWindowClosedConnection:Disconnect()
						onWindowClosedConnection = nil
					end
				end)

				WebViewService:OpenWindow(FStringLuaAppAdPreferencesUrl, v.adPreferences, true)
			end,
			LayoutOrder = 2
		})
	end

	v5.AdPreferences = adPreferences
	v4.DialogContent = createElement2(content, {}, {
		ContentView = createElement3(View, { tag = "col auto-xy gap-small" }, v5)
	})
	return createElement(root, v3, v4)
end

return React.memo(WhyThisAdModal)
