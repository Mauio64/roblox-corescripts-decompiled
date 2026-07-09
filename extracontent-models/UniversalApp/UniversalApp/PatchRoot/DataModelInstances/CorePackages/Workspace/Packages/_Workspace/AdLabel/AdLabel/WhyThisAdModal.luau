local WebViewService = game:GetService("WebViewService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local React = require(scriptParentParent.React)
local Foundation = require(scriptParentParent.Foundation)
local Localization = require(scriptParentParent.Localization)
local Dialog = Foundation.Dialog
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local AdDisclosureTelemetry = require(scriptParent.AdDisclosureTelemetry)
local FStringLuaAppAdPreferencesUrl = require(scriptParentParent.SharedFlags).FStringLuaAppAdPreferencesUrl
local GetFFlagEnableUnifiedWebViews = require(scriptParentParent.SharedFlags).GetFFlagEnableUnifiedWebViews
local useLocalization = Localization.Hooks.useLocalization

local function WhyThisAdModal(t1: {[any]: any}) -- line: 26
	-- upvalues: useLocalization (copy), useTokens (copy), React (copy), Dialog (copy), View (copy), FoundationText (copy), AdDisclosureTelemetry (copy), GetFFlagEnableUnifiedWebViews (copy), WebViewService (copy), FStringLuaAppAdPreferencesUrl (copy), HttpService (copy), BrowserService (copy)
	local v19 = useLocalization({
		whyThisAd = "Feature.GameDetails.Label.WhyThisAd",
		adPreferences = "Feature.GameDetails.Message.AdPreferences"
	})
	local v20 = useTokens()

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		disablePortal = false,
		onClose = t1.onClose
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v19.whyThisAd
		}),
		DialogContent = React.createElement(Dialog.Content, {}, {
			ContentView = React.createElement(View, {
				tag = "col auto-xy gap-small"
			}, {
				DialogText = React.createElement(Dialog.Text, {
					LayoutOrder = 1,
					Text = t1.adDisclosureBody
				}),
				AdPreferences = if not t1.showAdPreferencesUrl then nil else React.createElement(FoundationText, {
					tag = "auto-xy",
					LayoutOrder = 2,
					Text = v19.adPreferences,
					textStyle = v20.Color.Content.Link,
					fontStyle = v20.Typography.BodyMedium,
					onActivated = function() -- line: 57
						-- upvalues: AdDisclosureTelemetry (copy), GetFFlagEnableUnifiedWebViews (copy), WebViewService (copy), FStringLuaAppAdPreferencesUrl (copy), v19 (copy), HttpService (copy), BrowserService (copy)
						AdDisclosureTelemetry.logAdPreferencesLinkClicked()

						if GetFFlagEnableUnifiedWebViews() then
							local u21 = nil

							u21 = WebViewService.OnWindowClosed:Connect(function() -- line: 62
								-- upvalues: WebViewService (copy), u21 (ref)
								WebViewService:CloseWindow()

								if u21 then
									u21:Disconnect()
									u21 = nil
								end
							end)
							WebViewService:OpenWindow(FStringLuaAppAdPreferencesUrl, v19.adPreferences, true)

							return
						end

						local json = HttpService:JSONEncode({
							command = "open",
							visible = true,
							isGenericWebview = true,
							url = FStringLuaAppAdPreferencesUrl,
							title = v19.adPreferences
						})

						BrowserService:SendCommand(json)
					end
				})
			})
		})
	})
end

return React.memo(WhyThisAdModal)
