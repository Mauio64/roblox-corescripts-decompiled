local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local Constants = require(AvatarExperienceCommon.Constants)
local SPAWN_EFFECT_ASSET_TYPE_ID_STRING = Constants.SPAWN_EFFECT_ASSET_TYPE_ID_STRING

local function setAvatarEffectDescriptions(parent, p)
	for _, avatarEffectDescription in parent:GetChildren() do
		if avatarEffectDescription:IsA("AvatarEffectDescription") then
			avatarEffectDescription:Destroy()
		end
	end

	for k in p[SPAWN_EFFECT_ASSET_TYPE_ID_STRING] or {} do
		local avatarEffectDescription = Instance.new("AvatarEffectDescription")
		avatarEffectDescription.AssetId = tonumber(k)

		avatarEffectDescription.EffectType = Enum.AvatarEffectType.Spawn
		avatarEffectDescription.Parent = parent
	end
end

return setAvatarEffectDescriptions
