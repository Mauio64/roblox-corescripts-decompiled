local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local Localization = require(BuildExperienceParent.Localization)
local React = require(BuildExperienceParent.React)
local ReactRoblox = require(BuildExperienceParent.ReactRoblox)
local RobloxAppLocales = require(BuildExperienceParent.RobloxAppLocales)
local RoactUtils = require(BuildExperienceParent.RoactUtils)
local BuildExperienceCompositionStyleSheet = require(BuildExperience.Components.BuildExperienceCompositionStyleSheet)
local PublishGameSheet = require(BuildExperience.Components.PublishGameSheet.PublishGameSheet)
local GetPublishGameSheetStore = require(BuildExperience.Stores.GetPublishGameSheetStore)
local LocalizationProvider = Localization.LocalizationProvider
local Localization2 = RobloxAppLocales.Localization

local function ConnectedPublishGameSheet() -- line: 21
	-- upvalues: GetPublishGameSheetStore (copy), React (copy), Localization2 (copy), LocalizationService (copy), LocalizationProvider (copy), Foundation (copy), BuildExperienceCompositionStyleSheet (copy), PublishGameSheet (copy)
	local v19 = GetPublishGameSheetStore()
	local v20 = v19.useIsOpen()
	local v21 = React.useMemo(function() -- line: 24
		-- upvalues: Localization2 (copy), LocalizationService (copy)
		return Localization2.new(LocalizationService.RobloxLocaleId)
	end, {})
	local v22 = React.useCallback(function() -- line: 28
		-- upvalues: v19 (copy)
		v19.setIsOpen(false)
	end, { v19 })

	return React.createElement(LocalizationProvider, {
		localization = v21
	}, {
		FoundationProvider = React.createElement(Foundation.FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
			PublishGameSheet = React.createElement(PublishGameSheet, {
				isOpen = v20,
				onClose = v22
			})
		})
	})
end

local v17 = RoactUtils.Components.createLazyComponent(function() -- line: 47
	-- upvalues: ConnectedPublishGameSheet (copy)
	return ConnectedPublishGameSheet
end)

local function mountPublishGameSheet() -- line: 51
	-- upvalues: CoreGui (copy), ReactRoblox (copy), React (copy), v17 (copy)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "BuildExperiencePublishGameSheet"
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = CoreGui

	local v24 = ReactRoblox.createRoot(ScreenGui)

	v24:render(React.createElement(v17))

	return v24
end

return mountPublishGameSheet
