local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local ClearTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.ClearTryOns
local SetEmoteAssetId = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetEmoteAssetId)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local CloseAllItemDetails = require(Modules.AvatarExperience.Common.Thunks.CloseAllItemDetails)

return function(p1, p2) -- line: 11
	-- upvalues: ArgCheck (copy), Cryo (copy), ClearTryOns (copy), CloseAllItemDetails (copy), SetEmoteAssetId (copy)
	ArgCheck.isTypeOrNil(p1, "string", "SetEmoteAssetId thunk expects emoteAssetId to be a string or nil")

	return function(p3) -- line: 13
		-- upvalues: Cryo (copy), ClearTryOns (copy), CloseAllItemDetails (copy), p2 (copy), SetEmoteAssetId (copy), p1 (copy)
		local TryOnItems = p3:getState().AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

		if not Cryo.isEmpty(TryOnItems) then
			p3:dispatch(ClearTryOns())
			p3:dispatch(CloseAllItemDetails(p2))
		end

		p3:dispatch(SetEmoteAssetId(p1))
	end
end
