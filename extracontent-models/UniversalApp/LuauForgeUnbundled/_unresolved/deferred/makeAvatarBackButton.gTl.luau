local CorePackages = game:GetService("CorePackages")

local ReactUtils = require(CorePackages.Packages.ReactUtils)

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local module2 = require("@luauforge/bundled/fsW")
local React = require(CorePackages.Packages.React)
require("@luauforge/bundled/dHK")

local module3 = require("@luauforge/bundled/fsX")
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local useInitializedValue = ReactUtils.useInitializedValue
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local Cryo = require(CorePackages.Packages.Cryo)

local defineFastFlag = game:DefineFastFlag("AXRestoreBackButtonForTouch", false)

local function selectTabBarVisible(p2)
	return p2.TabBarVisible
end

local function makeAvatarBackButton(p2, p3)
	local function AvatarBackButton(p4)
		local v5 = useInitializedValue(function()
			return module2(p2)
		end)
		local v6

		if defineFastFlag then
			v6 = useSelector(selectTabBarVisible, getUseSelectorDeepEquals())
		end

		local v7 = useSelector(function(p5): boolean
			return p5.DeviceOrientation == deviceOrientationMode.Portrait
		end, getUseSelectorDeepEquals())

		local v8 = useAvatarRoute()
		local v9 = v8.current.name == avatarScreen.SortAndFilters

		local v10 = v7 and v9

		if not defineFastFlag or v6 then
			local v11 = not v7

			if v11 then
				if v8.current.name == avatarScreen.LayeredClothingSort then
					v11 = false
				else
					v11 = v8.current.name ~= avatarScreen.LayeredMakeupSort
				end
			end

			v10 = v10 or v11
		end

		if v10 then
			return React.createElement("TextButton", {
				Active = false,
				AutoButtonColor = false,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(module3.BACK_BUTTON_SIZE, module3.BACK_BUTTON_SIZE),
				Text = "",
				Selectable = false
			})
		end

		if p3 then
			p4 = Cryo.Dictionary.join(p4, { customIcon = p3 })
		end

		return React.createElement(v5, p4)
	end

	return AvatarBackButton
end

return makeAvatarBackButton
