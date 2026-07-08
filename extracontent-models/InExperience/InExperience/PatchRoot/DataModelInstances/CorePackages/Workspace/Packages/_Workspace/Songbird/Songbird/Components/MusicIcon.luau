local Songbird = script:FindFirstAncestor("Songbird")
local Foundation = require(Songbird.Parent.Foundation)
local React = require(Songbird.Parent.React)
local createNextOrder = require(Songbird.Parent.ReactUtils).createNextOrder
local getFFlagSongbirdMusicIconThumbnail = require(Songbird.Flags.getFFlagSongbirdMusicIconThumbnail)

local function MusicIcon(t1: {[any]: any}) -- line: 17
	-- upvalues: createNextOrder (copy), Foundation (copy), getFFlagSongbirdMusicIconThumbnail (copy), React (copy)
	local v8 = createNextOrder()
	local v9 = Foundation.Hooks.useTokens()
	local Size_900 = v9.Size.Size_900
	local v11 = getFFlagSongbirdMusicIconThumbnail() and t1.thumbnailUrl

	return React.createElement(Foundation.View, {
		Size = UDim2.fromOffset(Size_900, Size_900),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ClipsDescendants = not not v11 or nil,
		backgroundStyle = if v11 then nil else {
			Transparency = 0,
			Color3 = Color3.fromRGB(43, 45, 50)
		},
		cornerRadius = UDim.new(0, v9.Radius.Medium),
		LayoutOrder = if not getFFlagSongbirdMusicIconThumbnail() then nil else t1.layoutOrder,
		ZIndex = v8()
	}, {
		Thumbnail = if not v11 then nil else React.createElement(Foundation.Image, {
			tag = "size-full",
			Image = t1.thumbnailUrl,
			ZIndex = v8()
		}),
		Icon = if v11 then nil else React.createElement(Foundation.Icon, {
			name = "icons/common/music",
			size = Foundation.Enums.IconSize.Medium,
			Position = UDim2.new(0.5, -1, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ZIndex = v8()
		})
	})
end

return MusicIcon
