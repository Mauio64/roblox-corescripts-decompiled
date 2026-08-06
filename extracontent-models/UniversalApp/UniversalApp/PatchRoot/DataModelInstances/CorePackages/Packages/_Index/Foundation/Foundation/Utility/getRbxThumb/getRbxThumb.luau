local Foundation = script:FindFirstAncestor("Foundation")
local ThumbnailType = require(Foundation.Enums.ThumbnailType)
local ThumbnailSize = require(Foundation.Enums.ThumbnailSize)
local getAssetIdAsNumeric = require(Foundation.Utility.getAssetIdAsNumeric)
local t1 = {
	[ThumbnailType.Asset] = {
		[ThumbnailSize.Medium] = Vector2.new(150, 150),
		[ThumbnailSize.Large] = Vector2.new(420, 420)
	},
	[ThumbnailType.Avatar] = {
		[ThumbnailSize.Small] = Vector2.new(48, 48),
		[ThumbnailSize.Medium] = Vector2.new(150, 150),
		[ThumbnailSize.Large] = Vector2.new(420, 420),
		[ThumbnailSize.XLarge] = Vector2.new(720, 720)
	},
	[ThumbnailType.AvatarBust] = {
		[ThumbnailSize.Small] = Vector2.new(50, 50),
		[ThumbnailSize.Medium] = Vector2.new(150, 150),
		[ThumbnailSize.Large] = Vector2.new(420, 420)
	},
	[ThumbnailType.AvatarHeadShot] = {
		[ThumbnailSize.Small] = Vector2.new(48, 48),
		[ThumbnailSize.Medium] = Vector2.new(150, 150),
		[ThumbnailSize.Large] = Vector2.new(420, 420)
	},
	[ThumbnailType.BadgeIcon] = {
		[ThumbnailSize.Medium] = Vector2.new(150, 150)
	},
	[ThumbnailType.BundleThumbnail] = {
		[ThumbnailSize.Medium] = Vector2.new(150, 150),
		[ThumbnailSize.Large] = Vector2.new(420, 420)
	},
	[ThumbnailType.FontFamily] = {
		[ThumbnailSize.Medium] = Vector2.new(1200, 80)
	},
	[ThumbnailType.GameIcon] = {
		[ThumbnailSize.Small] = Vector2.new(50, 50),
		[ThumbnailSize.Medium] = Vector2.new(150, 150)
	},
	[ThumbnailType.GamePass] = {
		[ThumbnailSize.Medium] = Vector2.new(150, 150)
	},
	[ThumbnailType.GameThumbnail] = {
		[ThumbnailSize.Small] = Vector2.new(256, 144),
		[ThumbnailSize.Medium] = Vector2.new(384, 216),
		[ThumbnailSize.Large] = Vector2.new(480, 270),
		[ThumbnailSize.XLarge] = Vector2.new(768, 432)
	},
	[ThumbnailType.GroupIcon] = {
		[ThumbnailSize.Medium] = Vector2.new(150, 150),
		[ThumbnailSize.Large] = Vector2.new(420, 420)
	},
	[ThumbnailType.Outfit] = {
		[ThumbnailSize.Medium] = Vector2.new(150, 150),
		[ThumbnailSize.Large] = Vector2.new(420, 420)
	}
}

return function(p1, p2, p3, t2: {[any]: any}?) -- line: 197
	-- upvalues: t1 (copy), ThumbnailSize (copy), getAssetIdAsNumeric (copy), ThumbnailType (copy)
	local v10 = t1[p1][p3 or ThumbnailSize.Medium]
	local v11 = getAssetIdAsNumeric(p2)

	if not v10 then
		warn(`Unsupported size { p3 } for media type: { p1 }, defaulting to { ThumbnailSize.Medium }`)
		v10 = t1[p1][ThumbnailSize.Medium]
	end

	local v12 = `rbxthumb://type={ p1 }&id={ v11 }&w={ v10.X }&h={ v10.Y }`

	if p1 == ThumbnailType.AvatarHeadShot and t2 and t2.includeProfileFrame then
		v12 ..= "&includeprofileframe=true"
	end

	return v12
end
