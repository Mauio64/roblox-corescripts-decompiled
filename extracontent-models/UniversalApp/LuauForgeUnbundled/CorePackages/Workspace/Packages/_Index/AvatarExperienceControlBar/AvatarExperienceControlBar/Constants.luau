local fFlagAXResetAvatarButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagAXResetAvatarButton

local v5 = fFlagAXResetAvatarButton and {
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

local v6 = {}

if fFlagAXResetAvatarButton then
	for k, v7 in v5 do
		table.insert(v6, (tostring(v7.Value)))
	end
end

return { AssetTypesToKeep = v5, AssetTypeStringsToKeep = v6 }
