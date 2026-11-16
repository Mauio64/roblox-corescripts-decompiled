local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local InExperienceDetailsPrompt = script:FindFirstAncestor("InExperienceDetailsPrompt")
local parent = InExperienceDetailsPrompt.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local InExperienceLocales = require(parent.InExperienceLocales)
local localization = InExperienceLocales.Localization
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local ReactRoblox = require(parent.ReactRoblox)

local InExperienceDetailsPromptApp = require(InExperienceDetailsPrompt.InExperienceDetailsPromptApp)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppIedpOverlayAndNavigationFix = SharedFlags.FFlagLuaAppIedpOverlayAndNavigationFix

local defineFastInt = game:DefineFastInt("InExperienceDetailsPromptDisplayOrder", -1)

local function createFocusNavigationService() -- 1 equivalent call inferred from this helper
	return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
end

local function renderInExperienceDetailsPrompt()
	local parent2 = Instance.new("Folder")
	parent2.Name = FFlagLuaAppIedpOverlayAndNavigationFix and "InExperienceDetailsPromptApp"
		or "InExperienceDetailsPrompt"

	parent2.Parent = CoreGui
	local inExperienceDetailsPromptOverlay

	if FFlagLuaAppIedpOverlayAndNavigationFix then
		inExperienceDetailsPromptOverlay = Instance.new("ScreenGui")
		inExperienceDetailsPromptOverlay.Parent = parent2
		inExperienceDetailsPromptOverlay.Name = "InExperienceDetailsPromptOverlay"
		inExperienceDetailsPromptOverlay.DisplayOrder = defineFastInt
		inExperienceDetailsPromptOverlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		inExperienceDetailsPromptOverlay.Enabled = true
		inExperienceDetailsPromptOverlay.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
		inExperienceDetailsPromptOverlay.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
		inExperienceDetailsPromptOverlay.ClipToDeviceSafeArea = false
	end

	local focusNavigationService = createFocusNavigationService() -- inferred equivalent call
	local createElement = React.createElement
	local v = {
		localization = localization.new(LocalizationService.RobloxLocaleId)
	}

	local createElement2 = React.createElement
	local v2 = { colorMode = Foundation.Enums.ColorMode.Dark, overlayGui = 0 }
	local overlayGui

	if FFlagLuaAppIedpOverlayAndNavigationFix then
		overlayGui = inExperienceDetailsPromptOverlay
	end

	v2.overlayGui = overlayGui
	local element = createElement(LocalizationProvider, v, {
		FoundationProvider = createElement2(FoundationProvider, v2, {
			FocusNavigationProvider = React.createElement(
				ReactFocusNavigation.FocusNavigationContext.Provider,
				{ value = focusNavigationService },
				{
					FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
						InExperienceDetailsPromptApp = React.createElement(InExperienceDetailsPromptApp)
					})
				}
			)
		})
	})

	local createRoot = ReactRoblox.createRoot

	if FFlagLuaAppIedpOverlayAndNavigationFix then
		parent2 = inExperienceDetailsPromptOverlay
	end

	local root = createRoot(parent2)
	root:render(element)
	return root
end

return renderInExperienceDetailsPrompt
