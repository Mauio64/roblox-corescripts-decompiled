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
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local LocalizationProvider = Localization.LocalizationProvider
local Localization2 = RobloxAppLocales.Localization
local BuildExperienceCompositionStyleSheet = require(BuildExperience.Components.BuildExperienceCompositionStyleSheet)
local BuildControls = require(BuildExperience.Components.BuildControls.BuildControls)

local function ConnectedBuildControls() -- line: 22
	-- upvalues: React (copy), Localization2 (copy), LocalizationService (copy), LocalizationProvider (copy), Foundation (copy), BuildExperienceCompositionStyleSheet (copy), View (copy), BuildControls (copy), IconName (copy)
	local v20 = React.useMemo(function() -- line: 23
		-- upvalues: Localization2 (copy), LocalizationService (copy)
		return Localization2.new(LocalizationService.RobloxLocaleId)
	end, {})

	return React.createElement(LocalizationProvider, {
		localization = v20
	}, {
		FoundationProvider = React.createElement(Foundation.FoundationProvider, {
			theme = Foundation.Enums.Theme.Light
		}, {
			CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
			Anchor = React.createElement(View, {
				tag = "auto-xy",
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0)
			}, {
				BuildControls = React.createElement(BuildControls, {
					overflowIcon = IconName.ThreeDotsHorizontal
				})
			})
		})
	})
end

local v18 = RoactUtils.Components.createLazyComponent(function() -- line: 47
	-- upvalues: ConnectedBuildControls (copy)
	return ConnectedBuildControls
end)

local function mountBuildControls() -- line: 51
	-- upvalues: CoreGui (copy), ReactRoblox (copy), React (copy), v18 (copy)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "BuildExperienceBuildControls"
	ScreenGui.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = CoreGui

	local v22 = ReactRoblox.createRoot(ScreenGui)

	v22:render(React.createElement(v18))

	return v22
end

return mountBuildControls
