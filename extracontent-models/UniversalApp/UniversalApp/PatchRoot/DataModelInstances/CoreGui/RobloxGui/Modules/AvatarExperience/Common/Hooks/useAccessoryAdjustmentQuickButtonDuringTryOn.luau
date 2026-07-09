local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local selectAdjustableLastTryOnItem = AvatarExperienceCommon.State.Selectors.selectAdjustableLastTryOnItem
local useAccessoryAdjustmentQuickButtonFtux = require(Modules.AvatarExperience.AccessoryAdjustment.Hooks.useAccessoryAdjustmentQuickButtonFtux)
local AXEnableAccessoryAdjustmentDuringTryOnIXP = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments).AXEnableAccessoryAdjustmentDuringTryOnIXP

return function() -- line: 18
	-- upvalues: IxpUtils (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), useAccessoryAdjustmentQuickButtonFtux (copy), useSelector (copy), selectAdjustableLastTryOnItem (copy), React (copy)
	local v10 = IxpUtils.readTestVariable(AXEnableAccessoryAdjustmentDuringTryOnIXP.EnabledForUser)
	local v11 = useAccessoryAdjustmentQuickButtonFtux()
	local v12 = useSelector(selectAdjustableLastTryOnItem)

	React.useEffect(function() -- line: 26
		-- upvalues: v10 (copy), v11 (copy)
		if v10 and (v11 and v11.shouldShowFirstTimeGlow()) then
			task.delay(10, function() -- line: 32
				-- upvalues: v11 (copy)
				v11.completeFirstTimeGlow()
			end)
		end
	end, {
		v10,
		v11
	})

	return {
		shouldEnableAccessoryAdjustmentDuringTryOn = v10,
		adjustableLastTryOnItemId = v12,
		accessoryAdjustmentQuickButtonFtux = v11
	}
end
