local Foundation = script:FindFirstAncestor("Foundation")

local ThumbnailType = require(Foundation.Enums.ThumbnailType)

local ThumbnailSize = require(Foundation.Enums.ThumbnailSize)

local getAssetIdAsNumeric = require(Foundation.Utility.getAssetIdAsNumeric)

local v = {}
local Asset = ThumbnailType.Asset
local vector2s = {
	[ThumbnailSize.Medium] = Vector2.new(150, 150),
	[ThumbnailSize.Large] = Vector2.new(420, 420)
}
v[Asset] = vector2s

local Avatar = ThumbnailType.Avatar
local vector2s2 = {
	[ThumbnailSize.Small] = Vector2.new(48, 48),
	[ThumbnailSize.Medium] = Vector2.new(150, 150),
	[ThumbnailSize.Large] = Vector2.new(420, 420),
	[ThumbnailSize.XLarge] = Vector2.new(720, 720)
}
v[Avatar] = vector2s2

local AvatarBust = ThumbnailType.AvatarBust
local vector2s3 = {
	[ThumbnailSize.Small] = Vector2.new(50, 50),
	[ThumbnailSize.Medium] = Vector2.new(150, 150),
	[ThumbnailSize.Large] = Vector2.new(420, 420)
}
v[AvatarBust] = vector2s3

local AvatarHeadShot = ThumbnailType.AvatarHeadShot
local vector2s4 = {
	[ThumbnailSize.Small] = Vector2.new(48, 48),
	[ThumbnailSize.Medium] = Vector2.new(150, 150),
	[ThumbnailSize.Large] = Vector2.new(420, 420)
}
v[AvatarHeadShot] = vector2s4

local BadgeIcon = ThumbnailType.BadgeIcon
local vector2sByMedium = { [ThumbnailSize.Medium] = Vector2.new(150, 150) }
v[BadgeIcon] = vector2sByMedium

local BundleThumbnail = ThumbnailType.BundleThumbnail
local vector2s5 = {
	[ThumbnailSize.Medium] = Vector2.new(150, 150),
	[ThumbnailSize.Large] = Vector2.new(420, 420)
}
v[BundleThumbnail] = vector2s5

local FontFamily = ThumbnailType.FontFamily
local vector2sByMedium2 = { [ThumbnailSize.Medium] = Vector2.new(1200, 80) }
v[FontFamily] = vector2sByMedium2

local GameIcon = ThumbnailType.GameIcon
local vector2s6 = {
	[ThumbnailSize.Small] = Vector2.new(50, 50),
	[ThumbnailSize.Medium] = Vector2.new(150, 150)
}
v[GameIcon] = vector2s6

local GamePass = ThumbnailType.GamePass
local vector2sByMedium3 = { [ThumbnailSize.Medium] = Vector2.new(150, 150) }
v[GamePass] = vector2sByMedium3

local GameThumbnail = ThumbnailType.GameThumbnail
local vector2s7 = {
	[ThumbnailSize.Small] = Vector2.new(256, 144),
	[ThumbnailSize.Medium] = Vector2.new(384, 216),
	[ThumbnailSize.Large] = Vector2.new(480, 270),
	[ThumbnailSize.XLarge] = Vector2.new(768, 432)
}
v[GameThumbnail] = vector2s7

local GroupIcon = ThumbnailType.GroupIcon
local vector2s8 = {
	[ThumbnailSize.Medium] = Vector2.new(150, 150),
	[ThumbnailSize.Large] = Vector2.new(420, 420)
}
v[GroupIcon] = vector2s8

local Outfit = ThumbnailType.Outfit
local vector2s9 = {
	[ThumbnailSize.Medium] = Vector2.new(150, 150),
	[ThumbnailSize.Large] = Vector2.new(420, 420)
}
v[Outfit] = vector2s9

return function(p, p2, p3, p4)
	local v2 = v[p][p3 or ThumbnailSize.Medium]

	local assetIdAsNumeric = getAssetIdAsNumeric(p2)

	if not v2 then
		warn(`Unsupported size {p3} for media type: {p}, defaulting to {ThumbnailSize.Medium}`)
		v2 = v[p][ThumbnailSize.Medium]
	end

	local v3 = `rbxthumb://type={p}&id={assetIdAsNumeric}&w={v2.X}&h={v2.Y}`

	if p == ThumbnailType.AvatarHeadShot and p4 and p4.includeProfileFrame then
		return v3 .. "&includeprofileframe=true"
	end

	return v3
end
