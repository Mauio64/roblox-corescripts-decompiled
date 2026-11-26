local LocalizationService = game:GetService("LocalizationService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/ReactRoblox")

local styleProviderWithDefaultTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Style").StyleProviderWithDefaultTheme
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RobloxAppLocales").Localization
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Localization").LocalizationProvider
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Localization").Hooks.useLocalization
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local images = UIBlox.App.ImageSet.Images
local toast = UIBlox.App.Dialog.Toast
local getFFlagNotificationModalSetMenuIsOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").GetFFlagNotificationModalSetMenuIsOpen

local openModal = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/NotificationModalsManager").OpenModal
local closeModal = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/NotificationModalsManager").CloseModal
local inExperienceProviderContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/InExperienceContainer").InExperienceProviderContainer
local InGameUpsellContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/InGame/InGameUpsellContainer")

local v5 = nil

local function fn(p2)
	local v6 = useLocalization({
		titleKey = "Feature.VerificationUpsell.Heading.PhoneNumberVerified"
	})

	local v7 = useStyle()
	return React.createElement(React.Fragment, {}, {
		PhoneToast = React.createElement(toast, {
			toastContent = {
				iconColorStyle = {
					Color = v7.Tokens.Color.System.Success.Color3,
					Transparency = 0
				},
				iconImage = images["icons/status/success_large"],
				toastTitle = v6.titleKey,
				onDismissed = p2.onDismissed
			},
			duration = 3
		})
	})
end

return {
	openPhoneUpsell = function(props)
		if v5 == nil then
			local phoneUpsellToasts = Instance.new("Folder")
			phoneUpsellToasts.Name = "PhoneUpsellToasts"
			phoneUpsellToasts.Parent = game:GetService("CoreGui")
			v5 = ReactRoblox.createRoot(phoneUpsellToasts)
		end

		openModal("PHONE_UPSELL_KEY", inExperienceProviderContainer, {
			Props = {
				children = React.createElement(InGameUpsellContainer, Cryo.Dictionary.join(props, {
					closeUpsell = function()
						closeModal("PHONE_UPSELL_KEY")

						if props.closeUpsell then
							props.closeUpsell()
						end
					end,
					onSuccess = function()
						closeModal("PHONE_UPSELL_KEY")

						if props.onSuccessBeforeToast then
							props.onSuccessBeforeToast()
						end

						v5:render(React.createElement("ScreenGui", {
							IgnoreGuiInset = true,
							ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
							ResetOnSpawn = false,
							DisplayOrder = 0,
							Enabled = true
						}, {
							ContainerFrame = React.createElement(
								"Frame",
								{
									BackgroundTransparency = 1,
									Size = UDim2.new(1, 0, 1, 0)
								},
								{
									LocalizationProvider = React.createElement(
										localizationProvider,
										{
											localization = localization.new(LocalizationService.RobloxLocaleId)
										},
										{
											StyleProvider = React.createElement(styleProviderWithDefaultTheme, {}, {
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

																v5:unmount()
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
			BlockNonCoreUserInput = getFFlagNotificationModalSetMenuIsOpen()
		})
	end
}
