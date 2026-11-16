local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent

local LocalizationService = game:GetService("LocalizationService")

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local Localization3 = require(parent.Localization)
local useLocalization = Localization3.Hooks.useLocalization
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local Toast = UIBlox.App.Dialog.Toast
local SharedFlags = require(parent.SharedFlags)
local GetFFlagNotificationModalSetMenuIsOpen = SharedFlags.GetFFlagNotificationModalSetMenuIsOpen

local NotificationModalsManager = require(parent.NotificationModalsManager)
local OpenModal = NotificationModalsManager.OpenModal
local NotificationModalsManager2 = require(parent.NotificationModalsManager)
local CloseModal = NotificationModalsManager2.CloseModal
local InExperienceContainer = require(parent.InExperienceContainer)
local InExperienceProviderContainer = InExperienceContainer.InExperienceProviderContainer
local InGameUpsellContainer = require(PhoneUpsell.Components.InGame.InGameUpsellContainer)

local v = nil

local function fn(p)
	local v2 = useLocalization({
		titleKey = "Feature.VerificationUpsell.Heading.PhoneNumberVerified"
	})

	local v3 = useStyle()
	return React.createElement(React.Fragment, {}, {
		PhoneToast = React.createElement(Toast, {
			toastContent = {
				iconColorStyle = { Color = v3.Tokens.Color.System.Success.Color3, Transparency = 0 },
				iconImage = Images["icons/status/success_large"],
				toastTitle = v2.titleKey,
				onDismissed = p.onDismissed
			},
			duration = 3
		})
	})
end

return {
	openPhoneUpsell = function(props)
		if v == nil then
			local phoneUpsellToasts = Instance.new("Folder")
			phoneUpsellToasts.Name = "PhoneUpsellToasts"
			phoneUpsellToasts.Parent = game:GetService("CoreGui")
			v = ReactRoblox.createRoot(phoneUpsellToasts)
		end

		OpenModal("PHONE_UPSELL_KEY", InExperienceProviderContainer, {
			Props = {
				children = React.createElement(InGameUpsellContainer, Cryo.Dictionary.join(props, {
					closeUpsell = function()
						CloseModal("PHONE_UPSELL_KEY")

						if props.closeUpsell then
							props.closeUpsell()
						end
					end,
					onSuccess = function()
						CloseModal("PHONE_UPSELL_KEY")

						if props.onSuccessBeforeToast then
							props.onSuccessBeforeToast()
						end

						v:render(React.createElement("ScreenGui", {
							IgnoreGuiInset = true,
							ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
							ResetOnSpawn = false,
							DisplayOrder = 0,
							Enabled = true
						}, {
							ContainerFrame = React.createElement(
								"Frame",
								{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) },
								{
									LocalizationProvider = React.createElement(
										LocalizationProvider,
										{
											localization = Localization.new(LocalizationService.RobloxLocaleId)
										},
										{
											StyleProvider = React.createElement(StyleProviderWithDefaultTheme, {}, {
												Frame = React.createElement(
													"Frame",
													{
														BackgroundTransparency = 1,
														Size = UDim2.new(1, 0, 1, 0)
													},
													{
														Toast = React.createElement(fn, {
															onDismissed = function()
																if props.onSuccess then
																	props.onSuccess()
																end

																v:unmount()
															end
														}, {})
													}
												)
											})
										}
									)
								}
							)
						}))
					end
				}))
			},
			DisableBackgroundDismiss = true,
			BlockNonCoreUserInput = GetFFlagNotificationModalSetMenuIsOpen()
		})
	end
}
