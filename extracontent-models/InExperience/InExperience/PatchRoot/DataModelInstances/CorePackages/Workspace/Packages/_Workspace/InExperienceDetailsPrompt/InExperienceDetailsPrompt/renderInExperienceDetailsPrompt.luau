local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local InExperienceDetailsPrompt = script:FindFirstAncestor("InExperienceDetailsPrompt")
local InExperienceDetailsPromptParent = InExperienceDetailsPrompt.Parent
local Provider = require(InExperienceDetailsPromptParent.FocusNavigationUtils).FocusNavigableSurfaceRegistry.Provider
local Foundation = require(InExperienceDetailsPromptParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local LocalizationProvider = require(InExperienceDetailsPromptParent.Localization).LocalizationProvider
local Localization = require(InExperienceDetailsPromptParent.InExperienceLocales).Localization
local React = require(InExperienceDetailsPromptParent.React)
local ReactFocusNavigation = require(InExperienceDetailsPromptParent.ReactFocusNavigation)
local ReactRoblox = require(InExperienceDetailsPromptParent.ReactRoblox)
local InExperienceDetailsPromptApp = require(InExperienceDetailsPrompt.InExperienceDetailsPromptApp)
local FFlagLuaAppIedpOverlayAndNavigationFix = require(InExperienceDetailsPromptParent.SharedFlags).FFlagLuaAppIedpOverlayAndNavigationFix
local v15 = game:DefineFastInt("InExperienceDetailsPromptDisplayOrder", -1)

local function createFocusNavigationService() -- line: 23
	-- upvalues: ReactFocusNavigation (copy)
	return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
end
local function renderInExperienceDetailsPrompt() -- line: 27
	-- upvalues: FFlagLuaAppIedpOverlayAndNavigationFix (copy), CoreGui (copy), v15 (copy), ReactFocusNavigation (copy), React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), FoundationProvider (copy), Foundation (copy), Provider (copy), InExperienceDetailsPromptApp (copy), ReactRoblox (copy)
	local Folder = Instance.new("Folder")

	Folder.Name = not FFlagLuaAppIedpOverlayAndNavigationFix and "InExperienceDetailsPrompt" or "InExperienceDetailsPromptApp"
	Folder.Parent = CoreGui

	local ScreenGui = nil

	if FFlagLuaAppIedpOverlayAndNavigationFix then
		ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Parent = Folder
		ScreenGui.Name = "InExperienceDetailsPromptOverlay"
		ScreenGui.DisplayOrder = v15
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		ScreenGui.Enabled = true
		ScreenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
		ScreenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
		ScreenGui.ClipToDeviceSafeArea = false
	end

	local v20 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	local v21 = React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		FoundationProvider = React.createElement(FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark,
			overlayGui = if not FFlagLuaAppIedpOverlayAndNavigationFix then nil else ScreenGui
		}, {
			FocusNavigationProvider = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
				value = v20
			}, {
				FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
					InExperienceDetailsPromptApp = React.createElement(InExperienceDetailsPromptApp)
				})
			})
		})
	})
	local v22 = ReactRoblox.createRoot(if not FFlagLuaAppIedpOverlayAndNavigationFix then Folder else ScreenGui)

	v22:render(v21)

	return v22
end

return renderInExperienceDetailsPrompt
