local Parent = script:FindFirstAncestor("AvatarExperienceControlBar").Parent
local FFlagAXResetAvatarButton = require(Parent.AvatarExperienceFlags).FFlagAXResetAvatarButton
local v3 = if not FFlagAXResetAvatarButton then nil else {
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
}
local t1 = {}

if FFlagAXResetAvatarButton then
	for _, v6 in v3 do
		table.insert(t1, (tostring(v6.Value)))
	end
end

return {
	AssetTypesToKeep = v3,
	AssetTypeStringsToKeep = t1
}
