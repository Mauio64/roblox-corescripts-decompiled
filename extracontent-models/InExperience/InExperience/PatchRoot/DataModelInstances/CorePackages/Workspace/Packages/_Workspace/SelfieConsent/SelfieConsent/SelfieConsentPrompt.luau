local React = require(script.Parent.Parent.React)
local Localization = require(script.Parent.Parent.Localization)
local Foundation = require(script.Parent.Parent.Foundation)
local LegallySensitiveContent = require(script.Parent.Parent.LegallySensitiveContent)

local Button = Foundation.Button
local Dialog = Foundation.Dialog
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local useLocalization = Localization.Hooks.useLocalization
local ConsentName = LegallySensitiveContent.ConsentName
local useLegallySensitiveContentAndActions = LegallySensitiveContent.useLegallySensitiveContentAndActions

local LinkingProtocol = require(script.Parent.Parent.LinkingProtocol)
local linkingProtocol = LinkingProtocol.LinkingProtocol

local AvatarCreationService = game:GetService("AvatarCreationService")
local BrowserService = game:GetService("BrowserService")
local UserInputService = game:GetService("UserInputService")

return function(p)
	local v = useLocalization({
		title = "AvatarGeneration.SelfieConsent.Title",
		bodyText = "AvatarGeneration.SelfieConsent.BodyTextLink",
		privacyLinkText = "AvatarGeneration.SelfieConsent.PrivacyLinkText",
		agreeButton = "AvatarGeneration.SelfieConsent.AgreeButton",
		cancelButton = "AvatarGeneration.SelfieConsent.CancelButton"
	})

	local _, v2 = useLegallySensitiveContentAndActions(
		ConsentName.PhotoToAvatar,
		"in-experience-photo-to-avatar-selfie-consent"
	)

	return React.createElement(Dialog.Root, { size = DialogSize.Large }, {
		DialogTitle = React.createElement(Dialog.Title, { text = v.title }),
		DialogContent = React.createElement(Dialog.Content, nil, {
			DialogView = React.createElement(View, {
				tag = "col fill auto-xy items-start gap-medium"
			}, {
				DialogContentText = React.createElement(Dialog.Text, { Text = v.bodyText }),
				DialogFooter = React.createElement(Button, {
					text = v.privacyLinkText,
					variant = ButtonVariant.Link,
					onActivated = function()
						if UserInputService:GetPlatform() == Enum.Platform.Android then
							BrowserService:OpenBrowserWindow("https://en.help.roblox.com/hc/en-us/articles/115004630823-Roblox-Privacy-and-Cookie-Policy")
						else
							linkingProtocol.default:openURL("https://en.help.roblox.com/hc/en-us/articles/115004630823-Roblox-Privacy-and-Cookie-Policy")
						end
					end
				})
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v.agreeButton,
					variant = ButtonVariant.Emphasis,
					onActivated = function()
						AvatarCreationService:HandleSelfieConsentResult(true)
						p.displaySelfieConsent(false)
						v2.grantOneTimeUserConsentWithAuditing(nil, {
							privacyPolicyLink = "https://en.help.roblox.com/hc/en-us/articles/115004630823-Roblox-Privacy-and-Cookie-Policy"
						})
					end
				},
				{
					text = v.cancelButton,
					variant = ButtonVariant.Standard,
					onActivated = function()
						AvatarCreationService:HandleSelfieConsentResult(false)
						p.displaySelfieConsent(false)
					end
				}
			}
		})
	})
end
