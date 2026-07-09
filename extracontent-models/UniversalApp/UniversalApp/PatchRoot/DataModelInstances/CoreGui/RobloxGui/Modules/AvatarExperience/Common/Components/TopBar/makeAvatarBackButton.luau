local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local makeBackButton = require(Modules.LuaApp.Components.TopBar.Buttons.makeBackButton)
local React = require(CorePackages.Packages.React)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local TopBarConstants = require(Modules.LuaApp.Components.TopBar.TopBarConstants)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local useInitializedValue = ReactUtils.useInitializedValue
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local usePreferredInput = Responsive.usePreferredInput
local Cryo = require(CorePackages.Packages.Cryo)
local v18 = game:DefineFastFlag("AXRestoreBackButtonForTouch", false)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXCustomizeMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCustomizeMakeupSupport
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole

local function selectTabBarVisible(p1) -- line: 44
	return p1.TabBarVisible
end
local function makeAvatarBackButton(p2: ((...any) -> ...any), s1: string?) -- line: 48
	-- upvalues: useInitializedValue (copy), makeBackButton (copy), v18 (copy), useSelector (copy), selectTabBarVisible (copy), getUseSelectorDeepEquals (copy), DeviceOrientationMode (copy), useAvatarRoute (copy), AvatarScreen (copy), usePreferredInput (copy), Responsive (copy), FFlagEnableLeftNavOnConsole (copy), FFlagAXCustomizeMakeupSupport (copy), React (copy), TopBarConstants (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Cryo (copy)
	local function AvatarBackButton(p3) -- line: 49
		-- upvalues: useInitializedValue (copy), makeBackButton (copy), p2 (copy), v18 (copy), useSelector (copy), selectTabBarVisible (copy), getUseSelectorDeepEquals (copy), DeviceOrientationMode (copy), useAvatarRoute (copy), AvatarScreen (copy), usePreferredInput (copy), Responsive (copy), FFlagEnableLeftNavOnConsole (copy), FFlagAXCustomizeMakeupSupport (copy), React (copy), TopBarConstants (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), s1 (copy), Cryo (copy)
		local v29 = useInitializedValue(function() -- line: 51
			-- upvalues: makeBackButton (copy), p2 (copy)
			return makeBackButton(p2)
		end)
		local v30 = if not v18 then nil else useSelector(selectTabBarVisible, getUseSelectorDeepEquals())
		local v31 = useSelector(function(p4) -- line: 59
			-- upvalues: DeviceOrientationMode (copy)
			return p4.DeviceOrientation == DeviceOrientationMode.Portrait
		end, getUseSelectorDeepEquals())
		local v32 = useAvatarRoute()
		local v33 = v32.current.name == AvatarScreen.SortAndFilters
		local v34 = v31 and v33
		local v35 = usePreferredInput() ~= Responsive.Input.Directional or FFlagEnableLeftNavOnConsole

		if v18 then
			v35 = v35 and v30
		end

		if v35 then
			if FFlagAXCustomizeMakeupSupport then
				local v36 = not v31 and (v32.current.name ~= AvatarScreen.LayeredClothingSort and v32.current.name ~= AvatarScreen.LayeredMakeupSort)

				v34 = v34 or v36
			else
				local v37 = not v31 and v32.current.name ~= AvatarScreen.LayeredClothingSort

				v34 = v34 or v37
			end
		end

		if v34 then
			return React.createElement("TextButton", {
				Active = false,
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				Text = "",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(TopBarConstants.BACK_BUTTON_SIZE, TopBarConstants.BACK_BUTTON_SIZE),
				Selectable = not FFlagAXMigrateAXToGlobalAutofocus and nil
			})
		end

		if s1 then
			p3 = Cryo.Dictionary.join(p3, {
				customIcon = s1
			})
		end

		return React.createElement(v29, p3)
	end

	return AvatarBackButton
end

return makeAvatarBackButton
