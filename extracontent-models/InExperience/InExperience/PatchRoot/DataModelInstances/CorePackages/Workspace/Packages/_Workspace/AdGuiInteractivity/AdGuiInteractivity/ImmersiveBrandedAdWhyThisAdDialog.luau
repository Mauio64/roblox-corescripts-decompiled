local AdGuiInteractivity = script:FindFirstAncestor("AdGuiInteractivity")
local parent = AdGuiInteractivity.Parent
local React = require(parent.React)
local LinkingProtocol = require(parent.LinkingProtocol)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)

local AdsInteractivityTelemetry = require(AdGuiInteractivity.AdsInteractivityTelemetry)

local default = LinkingProtocol.LinkingProtocol.default
local Dialog = Foundation.Dialog
local View = Foundation.View
local Button = Foundation.Button
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useLocalization = Localization.Hooks.useLocalization

local defineFastString = game:DefineFastString("ImmersiveBrandedAdsLearnMoreUrl", "www.roblox.com")

return function(p)
	local advertiserName = p.advertiserName or ""

	local v = useLocalization({
		WhyThisAdText = "CoreScripts.Ads.Label.WhyThisAd",
		CloseButtonText = "CoreScripts.Ads.Action.Close",
		DynamicAdvertiserBodyText = {
			"CoreScripts.Ads.ImmersiveBrandedAds.WhyThisAd",
			AdvertiserName = advertiserName
		},
		StaticBodyText = "CoreScripts.Ads.Label.InExperienceDisclosureStatic",
		LearnMoreLinkText = "InGame.CommonUI.Badge.Popup.LearnMoreLink"
	})

	local text = v.StaticBodyText

	if advertiserName ~= "" then
		text = v.DynamicAdvertiserBodyText
	end

	local onActivated = React.useCallback(function()
		default:openURL(defineFastString):catch(function(_)
			AdsInteractivityTelemetry.logImmersiveBrandedAdLinkingFailedCounter("whyThisAd.learnMore")
			p.onDismiss()
		end)
	end, { p.onDismiss })

	local onClose = React.useCallback(function(_)
		p.onDismiss()
	end, { p.onDismiss })

	return React.createElement(React.Fragment, nil, {
		dialog = React.createElement(Dialog.Root, { size = DialogSize.Small, onClose = onClose }, {
			dialogTitle = React.createElement(Dialog.Title, { text = v.WhyThisAdText }),
			dialogContent = React.createElement(Dialog.Content, nil, {
				content = React.createElement(View, { tag = "col size-full-0 auto-y gap-small" }, {
					dialogText = React.createElement(Dialog.Text, { LayoutOrder = 1, Text = text }),
					link = React.createElement(Button, {
						LayoutOrder = 2,
						text = v.LearnMoreLinkText,
						variant = ButtonVariant.Link,
						onActivated = onActivated,
						icon = "icons/navigation/externallink",
						size = InputSize.Small
					})
				})
			}),
			dialogActions = React.createElement(Dialog.Actions, {
				actions = {
					{
						text = v.CloseButtonText,
						variant = ButtonVariant.Standard,
						onActivated = p.onDismiss
					}
				}
			})
		}),
		modal = React.createElement("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, 0),
			Modal = true
		})
	})
end
