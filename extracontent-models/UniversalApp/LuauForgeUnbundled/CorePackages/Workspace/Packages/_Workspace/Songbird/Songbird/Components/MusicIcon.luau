local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")

local createNextOrder = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/ReactUtils").createNextOrder

local getFFlagSongbirdMusicIconThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Flags/getFFlagSongbirdMusicIconThumbnail")

local function MusicIcon(p2)
	local nextOrder = createNextOrder()
	local v5 = Foundation.Hooks.useTokens()
	local size_900 = v5.Size.Size_900

	local thumbnailUrl = getFFlagSongbirdMusicIconThumbnail() and p2.thumbnailUrl

	local createElement = React.createElement
	local view = Foundation.View
	local v6 = {
		Size = UDim2.fromOffset(size_900, size_900),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ClipsDescendants = thumbnailUrl and true or nil,
		backgroundStyle = not thumbnailUrl and {
			Color3 = Color3.fromRGB(43, 45, 50),
			Transparency = 0
		} or nil,
		cornerRadius = UDim.new(0, v5.Radius.Medium),
		LayoutOrder = 0,
		ZIndex = 0
	}
	local v7 = if getFFlagSongbirdMusicIconThumbnail() then p2.layoutOrder else nil
	v6.LayoutOrder = v7
	v6.ZIndex = nextOrder()

	local v9 = if thumbnailUrl then React.createElement(Foundation.Image, {
		tag = "size-full",
		Image = p2.thumbnailUrl,
		ZIndex = nextOrder()
	}) else nil

	local v10 = if not thumbnailUrl then React.createElement(Foundation.Icon, {
		name = "icons/common/music",
		size = Foundation.Enums.IconSize.Medium,
		Position = UDim2.new(0.5, -1, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ZIndex = nextOrder()
	}) else nil
	return createElement(view, v6, { Thumbnail = v9, Icon = v10 })
end

return MusicIcon
