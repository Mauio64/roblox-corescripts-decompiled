local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local RevokeAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.RevokeAsset)
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Thunks.ToggleEquipAsset)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)

require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)

return function(p1, p2, p3) -- line: 10
	-- upvalues: Utils (copy), ToggleEquipAsset (copy), RevokeAsset (copy)
	return function(p4) -- line: 11
		-- upvalues: p1 (ref), p2 (ref), Utils (copy), ToggleEquipAsset (copy), p3 (copy), RevokeAsset (copy)
		local EquippedAssets = p4:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets

		p1 = tostring(p1)
		p2 = tostring(p2)

		if Utils.isAssetEquipped(p2, p1, EquippedAssets) then
			p4:dispatch(ToggleEquipAsset(p1, p2, p3))
		end

		p4:dispatch(RevokeAsset(p1, p2))
	end
end
