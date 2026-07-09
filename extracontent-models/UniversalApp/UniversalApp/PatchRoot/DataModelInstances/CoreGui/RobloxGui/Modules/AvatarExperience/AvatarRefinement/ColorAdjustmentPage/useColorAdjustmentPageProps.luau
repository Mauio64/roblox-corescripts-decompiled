local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local React = require(CorePackages.Packages.React)
local FFlagAXColorAdjustmentButtonShouldAccountForTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local v9 = if not FFlagAXColorAdjustmentButtonShouldAccountForTryOns then require(Modules.AvatarExperience.Common.Selectors.selectTryOnBodyIds) else AvatarExperienceCommon.State.Selectors.selectTryOnBodyIds
local selectDefaultTryOnBodyColorsToggled = require(Modules.AvatarExperience.Common.Selectors.selectDefaultTryOnBodyColorsToggled)
local DefaultTryOnBodyColorsToggled = require(Modules.AvatarExperience.Common.Actions.DefaultTryOnBodyColorsToggled)

require(script.Parent.ColorAdjustmentPage)

local function selectColorPickerAvailable(p1) -- line: 24
	-- upvalues: v9 (copy)
	local v16 = v9(p1)

	if #v16 == 0 then
		return true
	end

	for _, v18 in v16 do
		local v19 = p1.AvatarExperience.Common.BundleInfos[v18]

		if v19 and v19.isRecolorable then
			return true
		end
	end

	return false
end
local function selectDefaultColorCheckboxAvailable(p2) -- line: 38
	-- upvalues: v9 (copy)
	for _, v22 in (v9(p2)) do
		local v23 = p2.AvatarExperience.Common.BundleInfos[v22]

		if v23 and v23.isRecolorable then
			return true
		end
	end

	return false
end
local function useColorAdjustmentPageProps() -- line: 49
	-- upvalues: useNavigation (copy), React (copy), useSelector (copy), selectColorPickerAvailable (copy), selectDefaultTryOnBodyColorsToggled (copy), selectDefaultColorCheckboxAvailable (copy), useDispatch (copy), DefaultTryOnBodyColorsToggled (copy)
	local v24 = useNavigation()
	local v25 = React.useCallback(function() -- line: 51
		-- upvalues: v24 (copy)
		v24.pop()
	end, { v24 })
	local v26 = useSelector(selectColorPickerAvailable)
	local v27 = useSelector(selectDefaultTryOnBodyColorsToggled)
	local v28 = useSelector(selectDefaultColorCheckboxAvailable)
	local v29 = useDispatch()
	local v30 = React.useCallback(function() -- line: 60
		-- upvalues: v29 (copy), DefaultTryOnBodyColorsToggled (copy), v27 (copy)
		v29(DefaultTryOnBodyColorsToggled(not v27))
	end, {
		v29,
		v27
	})

	return {
		onBackButtonPressed = v25,
		colorPickerAvailable = v26,
		defaultColorCheckboxAvailable = v28,
		defaultColorChecked = v27,
		onDefaultColorCheckboxActivated = v30
	}
end

return useColorAdjustmentPageProps
