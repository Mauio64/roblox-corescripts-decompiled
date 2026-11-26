local CorePackages = game:GetService("CorePackages")

require("@luauforge/bundled/dKT")

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local React = require(CorePackages.Packages.React)
local selectTryOnBodyIds = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.selectTryOnBodyIds

local module = require("@luauforge/bundled/gKW")
local defaultTryOnBodyColorsToggled = require("@luauforge/bundled/dKU").Actions.DefaultTryOnBodyColorsToggled

require("@luauforge/deferred/hiY")

local function selectColorPickerAvailable(p2): boolean
	local v5 = selectTryOnBodyIds(p2)

	if #v5 == 0 then
		return true
	end

	for k, v6 in v5 do
		local bundleInfo = p2.AvatarExperience.Common.BundleInfos[v6]

		if bundleInfo and bundleInfo.isRecolorable then
			return true
		end
	end

	return false
end

local function selectDefaultColorCheckboxAvailable(p2): boolean
	local v5 = selectTryOnBodyIds(p2)

	for k, v6 in v5 do
		local bundleInfo = p2.AvatarExperience.Common.BundleInfos[v6]

		if bundleInfo and bundleInfo.isRecolorable then
			return true
		end
	end

	return false
end

local function useColorAdjustmentPageProps()
	local v5 = useNavigation()
	local v6 = React.useCallback(function()
		v5.pop()
	end, { v5 })

	local v7 = useSelector(selectColorPickerAvailable)
	local v8 = useSelector(module)
	local v9 = useSelector(selectDefaultColorCheckboxAvailable)

	local v10 = useDispatch()
	return {
		onBackButtonPressed = v6,
		colorPickerAvailable = v7,
		defaultColorCheckboxAvailable = v9,
		defaultColorChecked = v8,
		onDefaultColorCheckboxActivated = React.useCallback(function()
			v10(defaultTryOnBodyColorsToggled(not v8))
		end, { v10, v8 })
	}
end

return useColorAdjustmentPageProps
