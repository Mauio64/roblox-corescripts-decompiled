local AppMusicPlayer = script:FindFirstAncestor("AppMusicPlayer")
local Cryo = require(AppMusicPlayer.Parent.Cryo)
local Foundation = require(AppMusicPlayer.Parent.Foundation)
local React = require(AppMusicPlayer.Parent.React)
local ReactUtils = require(AppMusicPlayer.Parent.ReactUtils)
local Songbird = require(AppMusicPlayer.Parent.Songbird)
local AudioPlayer = Songbird.AudioPlayer
local AudioPlayerActions = Songbird.AudioPlayerActions
local createNextOrder = ReactUtils.createNextOrder
local t1 = {
	disablePortal = false,
	hasBackdrop = true
}

local function SongDetailsSheet(t2: {[any]: any}) -- line: 38
	-- upvalues: Cryo (copy), t1 (copy), createNextOrder (copy), React (copy), Foundation (copy), AudioPlayer (copy), AudioPlayerActions (copy)
	local v13 = Cryo.Dictionary.join(t1, t2)
	local v14 = createNextOrder()
	local t3 = {
		title = v13.title,
		artist = v13.artist,
		assetId = tostring(v13.assetId),
		thumbnail = v13.albumArt,
		isLiked = v13.isLiked
	}

	if not v13.isOpen then
		return nil
	end

	return React.createElement(Foundation.Dialog.Root, {
		disablePortal = v13.disablePortal,
		hasBackdrop = v13.hasBackdrop,
		onClose = v13.onClose
	}, {
		Title = React.createElement(Foundation.Dialog.Title, {
			text = ""
		}),
		Content = React.createElement(Foundation.View, {
			tag = "auto-xy col gap-xxlarge align-x-center"
		}, {
			MusicPlayer = React.createElement(AudioPlayer, {
				audio = t3,
				LayoutOrder = v14()
			}),
			MusicPlayerActions = React.createElement(AudioPlayerActions, {
				audio = t3,
				onLike = v13.onLike,
				onUnlike = v13.onUnlike,
				onReport = v13.onReport,
				LayoutOrder = v14()
			})
		})
	})
end

return React.memo(SongDetailsSheet)
