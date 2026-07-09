local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local selectAssetTypeId = require(Modules.AvatarExperience.AccessoryAdjustment.Selectors.selectAssetTypeId)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXRemoveMemoizeFromAccessoryAdjustmentUtils = AvatarExperienceFlags.FFlagAXRemoveMemoizeFromAccessoryAdjustmentUtils
local FFlagAXProvideAccessoryAdjustmentDefaults = AvatarExperienceFlags.FFlagAXProvideAccessoryAdjustmentDefaults
local FFlagAXAccessoryAdjustmentReturnOnNil = AvatarExperienceFlags.FFlagAXAccessoryAdjustmentReturnOnNil
local t1 = {
	position = {
		xPosition = -0.25,
		yPosition = -0.25,
		zPosition = -0.25
	},
	rotation = {
		xRotation = -15,
		yRotation = -30,
		zRotation = -30
	},
	scale = {
		xScale = 0.8,
		yScale = 0.8,
		zScale = 0.8
	}
}
local v14 = memoize(function(p1, p2) -- line: 39
	return p2[string.lower((string.sub(p1, 1, 1))) .. string.sub(p1, 2)]
end)

return function(p3) -- line: 48
	-- upvalues: Constants (copy), selectAssetTypeId (copy), FFlagAXAccessoryAdjustmentReturnOnNil (copy), t1 (copy), Constants2 (copy), FFlagAXRemoveMemoizeFromAccessoryAdjustmentUtils (copy), FFlagAXProvideAccessoryAdjustmentDefaults (copy), mutedError (copy), v14 (copy)
	local v18 = p3.AvatarExperience.AvatarEditor.AvatarSettings[Constants.AvatarSettings.accessoryRefinementLowerBounds]
	local v19 = selectAssetTypeId(p3)

	if FFlagAXAccessoryAdjustmentReturnOnNil and not v19 then
		return t1
	end

	local v20 = Constants2.AssetTypeIdStringToName[v19]

	if FFlagAXRemoveMemoizeFromAccessoryAdjustmentUtils then
		if FFlagAXProvideAccessoryAdjustmentDefaults and not v20 then
			mutedError(`[selectLowerAdjustmentLimits] No accessory type name found for asset type id: { v19 }`)

			return t1
		end

		return v18[string.lower((string.sub(v20, 1, 1))) .. string.sub(v20, 2)]
	end

	return v14(v20, v18)
end
