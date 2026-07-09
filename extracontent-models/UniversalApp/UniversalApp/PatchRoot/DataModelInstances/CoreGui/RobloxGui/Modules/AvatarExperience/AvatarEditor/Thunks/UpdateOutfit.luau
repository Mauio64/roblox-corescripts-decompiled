local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UpdateOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.UpdateOutfit)
local GetOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetOutfit)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

require(Modules.AvatarExperience.Common.Types)

local FFlagAXFixMakeupLookGrantOutfitHoisting = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixMakeupLookGrantOutfitHoisting

return function(p1, p2) -- line: 12
	-- upvalues: ArgCheck (copy), FFlagAXFixMakeupLookGrantOutfitHoisting (copy), UpdateOutfit (copy), GetOutfit (copy)
	ArgCheck.isType(p1, "string", "UpdateOutfit thunk expects outfitId to be a string")

	return function(p3) -- line: 14
		-- upvalues: p1 (copy), FFlagAXFixMakeupLookGrantOutfitHoisting (copy), UpdateOutfit (copy), GetOutfit (copy), p2 (copy)
		local v10 = p3:getState().AvatarExperience.AvatarEditor.OutfitInfos[p1]
		local v11 = (v10 and v10.updateCounter or 0) + 1
		local v12 = v10 and v10.isEditable or nil
		local v13 = if not FFlagAXFixMakeupLookGrantOutfitHoisting then nil else v10 and v10.outfitType or nil

		p3:dispatch(UpdateOutfit(p1, v12, if not FFlagAXFixMakeupLookGrantOutfitHoisting then nil else v13))
		p3:dispatch(GetOutfit(p1, v11, nil, p2))
	end
end
