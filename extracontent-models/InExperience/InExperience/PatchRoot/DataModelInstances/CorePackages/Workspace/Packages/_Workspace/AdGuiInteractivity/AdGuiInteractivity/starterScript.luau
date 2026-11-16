local AdService = game:GetService("AdService")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local parent = script.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local ReactRoblox = require(parent2.ReactRoblox)
local InExperienceLocales = require(parent2.InExperienceLocales)
local Localization = require(parent2.Localization)
local Foundation = require(parent2.Foundation)
local Roact = require(parent2.Roact)

local DisclosureButtonListenerComponent = require(parent.DisclosureButtonListenerComponent)
local AdsInteractivityControls = require(parent.AdsInteractivityControls)

local LocalizationProvider = Localization.LocalizationProvider
local FoundationProvider = Foundation.FoundationProvider

local function initializeImmersiveAds()
	local adGuiInteractivityControls = Instance.new("Folder")
	adGuiInteractivityControls.Name = "AdGuiInteractivityControls"
	adGuiInteractivityControls.Parent = CoreGui

	local v = {}

	AdService.adGuiRegisterUI:Connect(function(adGui)
		if not adGui:IsA("AdGui") or v[adGui] then
			return
		end

		local element = Roact.createElement(AdsInteractivityControls, { adGui = adGui })
		local element2 = Roact.createElement("Folder", nil, element)

		v[adGui] = Roact.mount(element2, adGuiInteractivityControls, "AdsInteractivityControls")

		adGui.Destroying:Connect(function()
			Roact.unmount(v[adGui])
			v[adGui] = nil
		end)
	end)

	AdService:SetAdGuiInteractivityHandlerInitialized()
end

local function initializeImmersiveBrandedAds()
	local immersiveBrandedAds = Instance.new("ScreenGui")
	immersiveBrandedAds.Name = "ImmersiveBrandedAds"
	immersiveBrandedAds.ResetOnSpawn = false
	immersiveBrandedAds.IgnoreGuiInset = true
	immersiveBrandedAds.Parent = CoreGui

	ReactRoblox.createRoot(immersiveBrandedAds):render({
		localizationProvider = React.createElement(
			LocalizationProvider,
			{
				localization = InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
			},
			{
				foundationProvider = React.createElement(
					FoundationProvider,
					{ colorMode = Foundation.Enums.ColorMode.Dark },
					{
						disclosureButtonListener = React.createElement(DisclosureButtonListenerComponent)
					}
				)
			}
		)
	})
end

return function()
	initializeImmersiveAds()
	initializeImmersiveBrandedAds()
end
