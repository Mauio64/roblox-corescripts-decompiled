local CorePackages = game:GetService("CorePackages")

require("@luauforge/bundled/dHK")

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local React = require(CorePackages.Packages.React)
local fFlagAXColorAdjustmentButtonShouldAccountForTryOns = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local v5

if fFlagAXColorAdjustmentButtonShouldAccountForTryOns then
	v5 = AvatarExperienceCommon.State.Selectors.selectTryOnBodyIds
else
	v5 = require("@luauforge/bundled/gqj")
end

local module2 = require("@luauforge/bundled/ggq")
local defaultTryOnBodyColorsToggled = require("@luauforge/bundled/dHL").Actions.DefaultTryOnBodyColorsToggled

require("@luauforge/deferred/gWM")

local function selectColorPickerAvailable(p2): boolean
	local v6 = v5(p2)

	if #v6 == 0 then
		return true
	end

	for k, v7 in v6 do
		local bundleInfo = p2.AvatarExperience.Common.BundleInfos[v7]

		if bundleInfo and bundleInfo.isRecolorable then
			return true
		end
	end

	return false
end

local function selectDefaultColorCheckboxAvailable(p2): boolean
	local v6 = v5(p2)

	for k, v7 in v6 do
		local bundleInfo = p2.AvatarExperience.Common.BundleInfos[v7]

		if bundleInfo and bundleInfo.isRecolorable then
			return true
		end
	end

	return false
end

local function useColorAdjustmentPageProps()
	local v6 = useNavigation()
	local v7 = React.useCallback(function()
		v6.pop()
	end, { v6 })

	local v8 = useSelector(selectColorPickerAvailable)
	local v9 = useSelector(module2)
	local v10 = useSelector(selectDefaultColorCheckboxAvailable)

	local v11 = useDispatch()
	return {
		onBackButtonPressed = v7,
		colorPickerAvailable = v8,
		defaultColorCheckboxAvailable = v10,
		defaultColorChecked = v9,
		onDefaultColorCheckboxActivated = React.useCallback(function()
			v11(defaultTryOnBodyColorsToggled(not v9))
		end, { v11, v9 })
	}
end

return useColorAdjustmentPageProps
