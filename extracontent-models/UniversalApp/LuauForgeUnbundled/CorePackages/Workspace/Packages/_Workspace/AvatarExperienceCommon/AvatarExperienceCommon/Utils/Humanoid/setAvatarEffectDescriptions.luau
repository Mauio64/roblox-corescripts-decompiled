local SPAWN_EFFECT_ASSET_TYPE_ID_STRING = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants").SPAWN_EFFECT_ASSET_TYPE_ID_STRING

local function setAvatarEffectDescriptions(parent, p2)
	for i, avatarEffectDescription in parent:GetChildren() do
		if avatarEffectDescription:IsA("AvatarEffectDescription") then
			avatarEffectDescription:Destroy()
		end
	end

	for k in p2[SPAWN_EFFECT_ASSET_TYPE_ID_STRING] or {} do
		local avatarEffectDescription = Instance.new("AvatarEffectDescription")
		avatarEffectDescription.AssetId = tonumber(k)

		avatarEffectDescription.EffectType = Enum.AvatarEffectType.Spawn
		avatarEffectDescription.Parent = parent
	end
end

return setAvatarEffectDescriptions
