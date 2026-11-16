local parent = script:FindFirstAncestor("AvatarExperienceControlBar").Parent

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton

local assetTypesToKeep = FFlagAXResetAvatarButton and {
	Enum.AssetType.Head,
	Enum.AssetType.Face,
	Enum.AssetType.Torso,
	Enum.AssetType.RightArm,
	Enum.AssetType.LeftArm,
	Enum.AssetType.LeftLeg,
	Enum.AssetType.RightLeg,
	Enum.AssetType.HairAccessory,
	Enum.AssetType.ClimbAnimation,
	Enum.AssetType.FallAnimation,
	Enum.AssetType.IdleAnimation,
	Enum.AssetType.JumpAnimation,
	Enum.AssetType.RunAnimation,
	Enum.AssetType.SwimAnimation,
	Enum.AssetType.WalkAnimation,
	Enum.AssetType.EmoteAnimation,
	Enum.AssetType.EyebrowAccessory,
	Enum.AssetType.EyelashAccessory,
	Enum.AssetType.MoodAnimation,
	Enum.AssetType.DynamicHead
} or nil

local assetTypeStringsToKeep = {}

if FFlagAXResetAvatarButton then
	for _, v in assetTypesToKeep do
		table.insert(assetTypeStringsToKeep, (tostring(v.Value)))
	end
end

return { AssetTypesToKeep = assetTypesToKeep, AssetTypeStringsToKeep = assetTypeStringsToKeep }
