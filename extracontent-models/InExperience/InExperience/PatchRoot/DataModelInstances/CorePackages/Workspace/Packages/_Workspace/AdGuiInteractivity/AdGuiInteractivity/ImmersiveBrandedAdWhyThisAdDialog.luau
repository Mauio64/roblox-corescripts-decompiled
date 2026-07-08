local AdGuiInteractivity = script:FindFirstAncestor("AdGuiInteractivity")
local AdGuiInteractivityParent = AdGuiInteractivity.Parent
local React = require(AdGuiInteractivityParent.React)
local LinkingProtocol = require(AdGuiInteractivityParent.LinkingProtocol)
local Foundation = require(AdGuiInteractivityParent.Foundation)
local Localization = require(AdGuiInteractivityParent.Localization)
local AdsInteractivityTelemetry = require(AdGuiInteractivity.AdsInteractivityTelemetry)
local default = LinkingProtocol.LinkingProtocol.default
local Dialog = Foundation.Dialog
local View = Foundation.View
local Button = Foundation.Button
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useLocalization = Localization.Hooks.useLocalization
local v16 = game:DefineFastString("ImmersiveBrandedAdsLearnMoreUrl", "www.roblox.com")

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: useLocalization (copy), React (copy), default (copy), v16 (copy), AdsInteractivityTelemetry (copy), Dialog (copy), DialogSize (copy), View (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local v18 = t1.advertiserName or ""
	local v19 = useLocalization({
		WhyThisAdText = "CoreScripts.Ads.Label.WhyThisAd",
		CloseButtonText = "CoreScripts.Ads.Action.Close",
		StaticBodyText = "CoreScripts.Ads.Label.InExperienceDisclosureStatic",
		LearnMoreLinkText = "InGame.CommonUI.Badge.Popup.LearnMoreLink",
		DynamicAdvertiserBodyText = {
			"CoreScripts.Ads.ImmersiveBrandedAds.WhyThisAd",
			AdvertiserName = v18
		}
	})
	local StaticBodyText = v19.StaticBodyText

	if v18 ~= "" then
		StaticBodyText = v19.DynamicAdvertiserBodyText
	end

	local v21 = React.useCallback(function() -- line: 46
		-- upvalues: default (copy), v16 (copy), AdsInteractivityTelemetry (copy), t1 (copy)
		default:openURL(v16):catch(function(_) -- line: 47
			-- upvalues: AdsInteractivityTelemetry (copy), t1 (copy)
			AdsInteractivityTelemetry.logImmersiveBrandedAdLinkingFailedCounter("whyThisAd.learnMore")
			t1.onDismiss()
		end)
	end, { t1.onDismiss })
	local v22 = React.useCallback(function(_) -- line: 53
		-- upvalues: t1 (copy)
		t1.onDismiss()
	end, { t1.onDismiss })

	return React.createElement(React.Fragment, nil, {
		dialog = React.createElement(Dialog.Root, {
			size = DialogSize.Small,
			onClose = v22
		}, {
			dialogTitle = React.createElement(Dialog.Title, {
				text = v19.WhyThisAdText
			}),
			dialogContent = React.createElement(Dialog.Content, nil, {
				content = React.createElement(View, {
					tag = "col size-full-0 auto-y gap-small"
				}, {
					dialogText = React.createElement(Dialog.Text, {
						LayoutOrder = 1,
						Text = StaticBodyText
					}),
					link = React.createElement(Button, {
						LayoutOrder = 2,
						icon = "icons/navigation/externallink",
						text = v19.LearnMoreLinkText,
						variant = ButtonVariant.Link,
						onActivated = v21,
						size = InputSize.Small
					})
				})
			}),
			dialogActions = React.createElement(Dialog.Actions, {
				actions = {{
					text = v19.CloseButtonText,
					variant = ButtonVariant.Standard,
					onActivated = t1.onDismiss
				}}
			})
		}),
		modal = React.createElement("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Modal = true,
			Size = UDim2.new(0, 0, 0, 0)
		})
	})
end
