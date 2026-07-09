local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local Cryo = require(CorePackages.Packages.Cryo)
local SetOwnedItemIdsBySubtype = require(Modules.AvatarExperience.AvatarEditor.Actions.SetOwnedItemIdsBySubtype)
local SetPageFinished = require(Modules.AvatarExperience.AvatarEditor.Actions.SetPageFinished)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local FFlagAEGetEditableOutfitsType = require(Modules.AvatarExperience.Flags.FFlagAEGetEditableOutfitsType)
local GetOutfits = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetOutfits)

return function() -- line: 20
	-- upvalues: Constants2 (copy), Cryo (copy), Utils (copy), SetOwnedItemIdsBySubtype (copy), SetPageFinished (copy), Promise (copy), GetOutfits (copy), FFlagAEGetEditableOutfitsType (copy), Constants (copy)
	return function(p1) -- line: 21
		-- upvalues: Constants2 (copy), Cryo (copy), Utils (copy), SetOwnedItemIdsBySubtype (copy), SetPageFinished (copy), Promise (copy), GetOutfits (copy), FFlagAEGetEditableOutfitsType (copy), Constants (copy)
		local v13 = p1:getState()

		if v13.AvatarExperience.AvatarEditor.PageFinished[Constants2.CharacterKey] then
			local OutfitInfos = v13.AvatarExperience.AvatarEditor.OutfitInfos
			local v15 = v13.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[Constants2.CharacterKey]
			local u16 = true
			local v17 = Cryo.List.filter(v15, function(p2) -- line: 35
				-- upvalues: OutfitInfos (copy), Utils (copy), u16 (ref)
				local v19 = OutfitInfos[tostring(p2)]

				if v19 then
					return not Utils.isPresetOutfit(v19)
				end

				u16 = false

				return false
			end)

			if u16 then
				p1:dispatch(SetOwnedItemIdsBySubtype(Constants2.EditableCharacterKey, v17))
				p1:dispatch(SetPageFinished(Constants2.EditableCharacterKey, true))

				return Promise.resolve()
			end
		end

		return p1:dispatch(GetOutfits(Constants2.EditableCharacterKey, true, nil, if not FFlagAEGetEditableOutfitsType then nil else Constants.OutfitTypes.Avatar))
	end
end
