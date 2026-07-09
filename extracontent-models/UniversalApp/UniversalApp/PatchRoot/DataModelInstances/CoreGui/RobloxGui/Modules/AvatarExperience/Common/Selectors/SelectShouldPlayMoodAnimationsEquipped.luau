local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize

require(Modules.AvatarExperience.Common.Types)

local v7 = memoize(function(p1) -- line: 17
	-- upvalues: Constants (copy), Cryo (copy)
	local v9 = p1 and p1[Constants.AssetTypeIdStrings.DynamicHead]

	if not v9 or Cryo.isEmpty(v9) then
		return false
	end

	local v10 = p1 and p1[Constants.AssetTypeIdStrings.MoodAnimation]

	if v10 and next(v10) then
		return true
	end

	return false
end)

return function(p2) -- line: 37
	-- upvalues: v7 (copy)
	local EquippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets

	return v7(EquippedAssets)
end
