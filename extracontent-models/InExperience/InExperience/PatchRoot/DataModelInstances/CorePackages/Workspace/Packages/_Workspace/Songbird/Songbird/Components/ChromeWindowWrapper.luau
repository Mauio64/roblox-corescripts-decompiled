local Songbird = script:FindFirstAncestor("Songbird")

local React = require(Songbird.Parent.React)

local ChromeWindow = require(Songbird.Components.ChromeWindow)
local useCurrentSong = require(Songbird.Hooks.useCurrentSong)

local getFFlagSongbirdMusicIconThumbnail = require(Songbird.Flags.getFFlagSongbirdMusicIconThumbnail)
local useSongAlbumArt = require(Songbird.Hooks.useSongAlbumArt)

local useCallback = React.useCallback
local useMemo = React.useMemo

local function ChromeWindowWrapper(props)
	local v = useCurrentSong()

	local v2 = useMemo(function()
		if v then
			return (tonumber(v.metadata.AssetId))
		end

		return nil
	end, { v })

	local meetsCriteria = getFFlagSongbirdMusicIconThumbnail() and v and v.meetsCriteria

	if not meetsCriteria then
		v2 = nil
	end

	local v3 = useSongAlbumArt(v2)
	local thumbnailUrl

	if meetsCriteria then
		thumbnailUrl = v3.value
	end

	local onToggleLike = useCallback(function()
		if v then
			v.toggleFavorite()
		end
	end, { v })

	return React.createElement(ChromeWindow, {
		song = v and {
			title = v.metadata.Title,
			artists = { v.metadata.Artist },
			isLiked = v.isFavorited,
			meetsCriteria = v.meetsCriteria,
			thumbnailUrl = thumbnailUrl
		} or nil,
		isFocused = props.isFocused,
		maxSize = props.maxSize,
		onToggleLike = onToggleLike,
		onClose = props.onClose,
		onUnfocus = props.onUnfocus
	})
end

return ChromeWindowWrapper
