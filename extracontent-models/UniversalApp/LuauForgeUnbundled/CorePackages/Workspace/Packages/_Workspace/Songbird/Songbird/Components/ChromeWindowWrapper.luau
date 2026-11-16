local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")

local ChromeWindow = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/ChromeWindow")
local useCurrentSong = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Hooks/useCurrentSong")

local getFFlagSongbirdMusicIconThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Flags/getFFlagSongbirdMusicIconThumbnail")
local useSongAlbumArt = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Hooks/useSongAlbumArt")

local useCallback = React.useCallback
local useMemo = React.useMemo

local function ChromeWindowWrapper(props)
	local v5 = useCurrentSong()

	local v6 = useMemo(function()
		if v5 then
			return (tonumber(v5.metadata.AssetId))
		end

		return nil
	end, { v5 })

	local meetsCriteria = getFFlagSongbirdMusicIconThumbnail() and v5 and v5.meetsCriteria

	if not meetsCriteria then
		v6 = nil
	end

	local v8 = useSongAlbumArt(v6)
	local value = if meetsCriteria then v8.value else nil

	local v9 = useCallback(function()
		if v5 then
			v5.toggleFavorite()
		end
	end, { v5 })

	return React.createElement(ChromeWindow, {
		song = v5 and {
			title = v5.metadata.Title,
			artists = { v5.metadata.Artist },
			isLiked = v5.isFavorited,
			meetsCriteria = v5.meetsCriteria,
			thumbnailUrl = value
		} or nil,
		isFocused = props.isFocused,
		maxSize = props.maxSize,
		onToggleLike = v9,
		onClose = props.onClose,
		onUnfocus = props.onUnfocus
	})
end

return ChromeWindowWrapper
