local Songbird = script:FindFirstAncestor("Songbird")

local Foundation = require(Songbird.Parent.Foundation)
local React = require(Songbird.Parent.React)

local ReactUtils = require(Songbird.Parent.ReactUtils)
local createNextOrder = ReactUtils.createNextOrder

local getFFlagSongbirdMusicIconThumbnail = require(Songbird.Flags.getFFlagSongbirdMusicIconThumbnail)

local function MusicIcon(p)
	local nextOrder = createNextOrder()
	local v = Foundation.Hooks.useTokens()
	local size_900 = v.Size.Size_900

	local thumbnailUrl = getFFlagSongbirdMusicIconThumbnail() and p.thumbnailUrl

	local createElement = React.createElement
	local view = Foundation.View
	local v2 = {
		Size = UDim2.fromOffset(size_900, size_900),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ClipsDescendants = thumbnailUrl and true or nil,
		backgroundStyle = not thumbnailUrl and {
			Color3 = Color3.fromRGB(43, 45, 50),
			Transparency = 0
		} or nil,
		cornerRadius = UDim.new(0, v.Radius.Medium),
		LayoutOrder = 0,
		ZIndex = 0
	}
	local layoutOrder

	if getFFlagSongbirdMusicIconThumbnail() then
		layoutOrder = p.layoutOrder
	end

	v2.LayoutOrder = layoutOrder
	v2.ZIndex = nextOrder()
	local thumbnail

	if thumbnailUrl then
		thumbnail = React.createElement(Foundation.Image, {
			tag = "size-full",
			Image = p.thumbnailUrl,
			ZIndex = nextOrder()
		})
	end

	local icon

	if not thumbnailUrl then
		icon = React.createElement(Foundation.Icon, {
			name = "icons/common/music",
			size = Foundation.Enums.IconSize.Medium,
			Position = UDim2.new(0.5, -1, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ZIndex = nextOrder()
		})
	end

	return createElement(view, v2, { Thumbnail = thumbnail, Icon = icon })
end

return MusicIcon
