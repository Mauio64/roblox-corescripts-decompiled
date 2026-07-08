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
local LinkingProtocol = require(script.Parent.Parent.LinkingProtocol).LinkingProtocol
local AvatarCreationService = game:GetService("AvatarCreationService")
local BrowserService = game:GetService("BrowserService")
local UserInputService = game:GetService("UserInputService")

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: useLocalization (copy), useLegallySensitiveContentAndActions (copy), ConsentName (copy), React (copy), Dialog (copy), DialogSize (copy), View (copy), Button (copy), ButtonVariant (copy), UserInputService (copy), BrowserService (copy), LinkingProtocol (copy), AvatarCreationService (copy)
	local v18 = useLocalization({
		title = "AvatarGeneration.SelfieConsent.Title",
		bodyText = "AvatarGeneration.SelfieConsent.BodyTextLink",
		privacyLinkText = "AvatarGeneration.SelfieConsent.PrivacyLinkText",
		agreeButton = "AvatarGeneration.SelfieConsent.AgreeButton",
		cancelButton = "AvatarGeneration.SelfieConsent.CancelButton"
	})
	local _, v20 = useLegallySensitiveContentAndActions(ConsentName.PhotoToAvatar, "in-experience-photo-to-avatar-selfie-consent")

	return React.createElement(Dialog.Root, {
		size = DialogSize.Large
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v18.title
		}),
		DialogContent = React.createElement(Dialog.Content, nil, {
			DialogView = React.createElement(View, {
				tag = "col fill auto-xy items-start gap-medium"
			}, {
				DialogContentText = React.createElement(Dialog.Text, {
					Text = v18.bodyText
				}),
				DialogFooter = React.createElement(Button, {
					text = v18.privacyLinkText,
					variant = ButtonVariant.Link,
					onActivated = function() -- line: 55
						-- upvalues: UserInputService (copy), BrowserService (copy), LinkingProtocol (copy)
						if UserInputService:GetPlatform() == Enum.Platform.Android then
							BrowserService:OpenBrowserWindow("https://en.help.roblox.com/hc/en-us/articles/115004630823-Roblox-Privacy-and-Cookie-Policy")

							return
						end

						LinkingProtocol.default:openURL("https://en.help.roblox.com/hc/en-us/articles/115004630823-Roblox-Privacy-and-Cookie-Policy")
					end
				})
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v18.agreeButton,
					variant = ButtonVariant.Emphasis,
					onActivated = function() -- line: 72
						-- upvalues: AvatarCreationService (copy), t1 (copy), v20 (copy)
						AvatarCreationService:HandleSelfieConsentResult(true)
						t1.displaySelfieConsent(false)
						v20.grantOneTimeUserConsentWithAuditing(nil, {
							privacyPolicyLink = "https://en.help.roblox.com/hc/en-us/articles/115004630823-Roblox-Privacy-and-Cookie-Policy"
						})
					end
				},
				{
					text = v18.cancelButton,
					variant = ButtonVariant.Standard,
					onActivated = function() -- line: 81
						-- upvalues: AvatarCreationService (copy), t1 (copy)
						AvatarCreationService:HandleSelfieConsentResult(false)
						t1.displaySelfieConsent(false)
					end
				}
			}
		})
	})
end
