local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local LocalizationService = game:GetService("LocalizationService")
local Cryo = require(PhoneUpsellParent.Cryo)
local React = require(PhoneUpsellParent.React)
local ReactRoblox = require(PhoneUpsellParent.ReactRoblox)
local StyleProviderWithDefaultTheme = require(PhoneUpsellParent.Style).StyleProviderWithDefaultTheme
local Localization = require(PhoneUpsellParent.RobloxAppLocales).Localization
local LocalizationProvider = require(PhoneUpsellParent.Localization).LocalizationProvider
local useLocalization = require(PhoneUpsellParent.Localization).Hooks.useLocalization
local UIBlox = require(PhoneUpsellParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local Toast = UIBlox.App.Dialog.Toast
local GetFFlagNotificationModalSetMenuIsOpen = require(PhoneUpsellParent.SharedFlags).GetFFlagNotificationModalSetMenuIsOpen
local OpenModal = require(PhoneUpsellParent.NotificationModalsManager).OpenModal
local CloseModal = require(PhoneUpsellParent.NotificationModalsManager).CloseModal
local InExperienceProviderContainer = require(PhoneUpsellParent.InExperienceContainer).InExperienceProviderContainer
local InGameUpsellContainer = require(PhoneUpsell.Components.InGame.InGameUpsellContainer)
local u20 = nil

local function v21(p1) -- line: 29
	-- upvalues: useLocalization (copy), useStyle (copy), React (copy), Toast (copy), Images (copy)
	local v23 = useLocalization({
		titleKey = "Feature.VerificationUpsell.Heading.PhoneNumberVerified"
	})
	local v24 = useStyle()

	return React.createElement(React.Fragment, {}, {
		PhoneToast = React.createElement(Toast, {
			duration = 3,
			toastContent = {
				iconColorStyle = {
					Transparency = 0,
					Color = v24.Tokens.Color.System.Success.Color3
				},
				iconImage = Images["icons/status/success_large"],
				toastTitle = v23.titleKey,
				onDismissed = p1.onDismissed
			}
		})
	})
end

return {
	openPhoneUpsell = function(p2) -- line: 54
		-- upvalues: u20 (ref), ReactRoblox (copy), OpenModal (copy), InExperienceProviderContainer (copy), React (copy), InGameUpsellContainer (copy), Cryo (copy), CloseModal (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), StyleProviderWithDefaultTheme (copy), v21 (copy), GetFFlagNotificationModalSetMenuIsOpen (copy)
		if u20 == nil then
			local Folder = Instance.new("Folder")

			Folder.Name = "PhoneUpsellToasts"
			Folder.Parent = game:GetService("CoreGui")
			u20 = ReactRoblox.createRoot(Folder)
		end

		OpenModal("PHONE_UPSELL_KEY", InExperienceProviderContainer, {
			DisableBackgroundDismiss = true,
			Props = {
				children = React.createElement(InGameUpsellContainer, Cryo.Dictionary.join(p2, {
					closeUpsell = function() -- line: 66
						-- upvalues: CloseModal (copy), p2 (copy)
						CloseModal("PHONE_UPSELL_KEY")

						if p2.closeUpsell then
							p2.closeUpsell()
						end
					end,
					onSuccess = function() -- line: 72
						-- upvalues: CloseModal (copy), p2 (copy), u20 (ref), React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), StyleProviderWithDefaultTheme (copy), v21 (copy)
						CloseModal("PHONE_UPSELL_KEY")

						if p2.onSuccessBeforeToast then
							p2.onSuccessBeforeToast()
						end

						u20:render(React.createElement("ScreenGui", {
							IgnoreGuiInset = true,
							ResetOnSpawn = false,
							DisplayOrder = 0,
							Enabled = true,
							ZIndexBehavior = Enum.ZIndexBehavior.Sibling
						}, {
							ContainerFrame = React.createElement("Frame", {
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 1, 0)
							}, {
								LocalizationProvider = React.createElement(LocalizationProvider, {
									localization = Localization.new(LocalizationService.RobloxLocaleId)
								}, {
									StyleProvider = React.createElement(StyleProviderWithDefaultTheme, {}, {
										Frame = React.createElement("Frame", {
											BackgroundTransparency = 1,
											Size = UDim2.new(1, 0, 1, 0)
										}, {
											Toast = React.createElement(v21, {
												onDismissed = function() -- line: 97
													-- upvalues: p2 (copy), u20 (ref)
													if p2.onSuccess then
														p2.onSuccess()
													end

													u20:unmount()
												end
											}, {})
										})
									})
								})
							})
						}))
					end
				}))
			},
			BlockNonCoreUserInput = GetFFlagNotificationModalSetMenuIsOpen()
		})
	end
}
