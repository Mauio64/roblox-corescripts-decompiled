local AdService = game:GetService("AdService")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local React = require(scriptParentParent.React)
local ReactRoblox = require(scriptParentParent.ReactRoblox)
local InExperienceLocales = require(scriptParentParent.InExperienceLocales)
local Localization = require(scriptParentParent.Localization)
local Foundation = require(scriptParentParent.Foundation)
local Roact = require(scriptParentParent.Roact)
local DisclosureButtonListenerComponent = require(scriptParent.DisclosureButtonListenerComponent)
local AdsInteractivityControls = require(scriptParent.AdsInteractivityControls)
local LocalizationProvider = Localization.LocalizationProvider
local FoundationProvider = Foundation.FoundationProvider
local v16 = game:DefineFastFlag("AdsInteractivityControlsFixStyleLink", false)

local function initializeImmersiveAds() -- line: 22
	-- upvalues: CoreGui (copy), AdService (copy), Roact (copy), AdsInteractivityControls (copy), v16 (copy)
	local Folder = Instance.new("Folder")

	Folder.Name = "AdGuiInteractivityControls"
	Folder.Parent = CoreGui

	local t1 = {}

	AdService.adGuiRegisterUI:Connect(function(p1) -- line: 30
		-- upvalues: t1 (copy), Roact (copy), AdsInteractivityControls (copy), v16 (copy), Folder (copy)
		if not p1:IsA("AdGui") then
			return
		end

		if t1[p1] then
			return
		end

		local v23 = Roact.createElement(AdsInteractivityControls, {
			adGui = p1
		})

		if v16 then
			v23 = Roact.createElement("Folder", nil, v23)
		end

		t1[p1] = Roact.mount(v23, Folder, "AdsInteractivityControls")
		p1.Destroying:Connect(function() -- line: 46
			-- upvalues: Roact (copy), t1 (copy), p1 (copy)
			Roact.unmount(t1[p1])
			t1[p1] = nil
		end)
	end)
	AdService:SetAdGuiInteractivityHandlerInitialized()
end
local function initializeImmersiveBrandedAds() -- line: 55
	-- upvalues: CoreGui (copy), ReactRoblox (copy), React (copy), LocalizationProvider (copy), InExperienceLocales (copy), LocalizationService (copy), FoundationProvider (copy), Foundation (copy), DisclosureButtonListenerComponent (copy)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "ImmersiveBrandedAds"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.Parent = CoreGui
	ReactRoblox.createRoot(ScreenGui):render({
		localizationProvider = React.createElement(LocalizationProvider, {
			localization = InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
		}, {
			foundationProvider = React.createElement(FoundationProvider, {
				theme = Foundation.Enums.Theme.Dark
			}, {
				disclosureButtonListener = React.createElement(DisclosureButtonListenerComponent)
			})
		})
	})
end

return function() -- line: 75
	-- upvalues: initializeImmersiveAds (copy), initializeImmersiveBrandedAds (copy)
	initializeImmersiveAds()
	initializeImmersiveBrandedAds()
end
