local Songbird = script:FindFirstAncestor("Songbird")
local React = require(Songbird.Parent.React)
local ChromeWindow = require(Songbird.Components.ChromeWindow)
local useCurrentSong = require(Songbird.Hooks.useCurrentSong)
local AnalyticActions = require(Songbird.Analytics.AnalyticActions)
local sendChromeWindowAnalytics = require(Songbird.Analytics.sendChromeWindowAnalytics)
local getFFlagSongbirdMusicIconThumbnail = require(Songbird.Flags.getFFlagSongbirdMusicIconThumbnail)
local useSongAlbumArt = require(Songbird.Hooks.useSongAlbumArt)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local ReportAudioPopupContext = require(Songbird.Components.ReportAudioPopupContext)

local function ChromeWindowWrapper(t1: {[any]: any}) -- line: 28
	-- upvalues: useCurrentSong (copy), ReportAudioPopupContext (copy), useMemo (copy), getFFlagSongbirdMusicIconThumbnail (copy), useSongAlbumArt (copy), useEffect (copy), useCallback (copy), sendChromeWindowAnalytics (copy), AnalyticActions (copy), React (copy), ChromeWindow (copy)
	local v15 = useCurrentSong()
	local v16 = ReportAudioPopupContext.use()
	local v17 = useMemo(function() -- line: 32
		-- upvalues: v15 (copy)
		if v15 then
			return (tonumber(v15.metadata.AssetId))
		end

		return nil
	end, { v15 })
	local v18 = getFFlagSongbirdMusicIconThumbnail() and (v15 and v15.meetsCriteria)
	local v19 = useSongAlbumArt(if not v18 then nil else v17)
	local v20 = if not v18 then nil else v19.value

	useEffect(function() -- line: 40
		-- upvalues: v16 (copy), v17 (copy)
		v16.setAssetId(v17)

		return function() -- line: 43
			-- upvalues: v16 (copy)
			v16.setAssetId(nil)
		end
	end, {
		v17,
		v16.setAssetId
	})
	useEffect(function() -- line: 48
		-- upvalues: v16 (copy), v20 (copy)
		v16.setHasThumbnail(v20 ~= nil)

		return function() -- line: 51
			-- upvalues: v16 (copy)
			v16.setHasThumbnail(false)
		end
	end, {
		v20,
		v16.setHasThumbnail
	})

	local v21 = useCallback(function() -- line: 56
		-- upvalues: v16 (copy), sendChromeWindowAnalytics (copy), v17 (copy), AnalyticActions (copy), t1 (copy)
		v16.setVisibility(true)
		sendChromeWindowAnalytics({
			assetId = v17,
			action = AnalyticActions.OpenReport
		})

		if t1.onReport then
			t1.onReport()
		end
	end, {
		t1.onReport,
		v17,
		v16.setVisibility
	})
	local v22 = useCallback(function() -- line: 65
		-- upvalues: v15 (copy)
		if v15 then
			v15.toggleFavorite()
		end
	end, { v15 })

	return React.createElement(ChromeWindow, {
		song = if not v15 then nil else {
			title = v15.metadata.Title,
			artists = { v15.metadata.Artist },
			isLiked = v15.isFavorited,
			meetsCriteria = v15.meetsCriteria,
			thumbnailUrl = v20
		},
		isFocused = t1.isFocused,
		maxSize = t1.maxSize,
		onToggleLike = v22,
		onReport = v21,
		onClose = t1.onClose,
		onUnfocus = t1.onUnfocus
	})
end

return ChromeWindowWrapper
