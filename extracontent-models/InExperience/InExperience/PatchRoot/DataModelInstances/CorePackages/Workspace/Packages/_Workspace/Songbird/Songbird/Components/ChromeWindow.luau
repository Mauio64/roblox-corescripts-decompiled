local Songbird = script:FindFirstAncestor("Songbird")

local constants = require(Songbird.constants)
local Cryo = require(Songbird.Parent.Cryo)
local Foundation = require(Songbird.Parent.Foundation)
local React = require(Songbird.Parent.React)
local ReactUtils = require(Songbird.Parent.ReactUtils)
local Localization = require(Songbird.Parent.Localization)

local ChromeWindowFrame = require(Songbird.Components.ChromeWindowFrame)
local MarqueeScroller = require(Songbird.Components.MarqueeScroller)
local MusicIcon = require(Songbird.Components.MusicIcon)
local LikeButton = require(Songbird.Components.LikeButton)
local TrackingAudioIcon = require(Songbird.Components.TrackingAudioIcon)

local useLocalization = Localization.Hooks.useLocalization
local createNextOrder = ReactUtils.createNextOrder
local useCallback = React.useCallback
local useMemo = React.useMemo

local _ = { Loading = "Loading", Unverified = "Unverified", MeetsCriteria = "MeetsCriteria" }

local v = { isLoading = false, maxSize = Vector2.new(300, 1e999) }

local function ChromeWindow(p)
	local joined = Cryo.Dictionary.join(v, p)
	local nextOrder = createNextOrder()

	local v2 = useMemo(function(): string
		if joined.isLoading or not joined.song then
			return "Loading"
		end

		if joined.song.meetsCriteria then
			return "MeetsCriteria"
		end

		return "Unverified"
	end, { joined.isLoading, joined.song })
	local v3 = v2 ~= "MeetsCriteria"
	local v4 = useLocalization({
		windowTitle = "CoreScripts.TopBar.Music",
		musicLoading = "CoreScripts.TopBar.MusicLoading",
		musicUnverified = "CoreScripts.TopBar.MusicNotVerified"
	})

	local onFavorite = useCallback(function()
		if joined.onToggleLike then
			joined.onToggleLike()
		end
	end, { joined.onToggleLike })

	local text2 = useMemo(function()
		if joined.song then
			return table.concat(joined.song.artists, ", ")
		end

		return nil
	end, { joined.song })
	local actions

	if v3 then
		actions = {}
	else
		actions = { LikeButtonWrapper = 0 }
		local createElement = React.createElement
		local view = Foundation.View

		local createElement2 = React.createElement
		local isFavorited

		if joined.song then
			isFavorited = joined.song.isLiked
		else
			isFavorited = false
		end

		actions.LikeButtonWrapper = createElement(view, { tag = "auto-xy padding-right-xsmall" }, {
			LikeButton = createElement2(LikeButton, {
				isFavorited = isFavorited,
				onFavorite = onFavorite
			})
		})
	end

	local createElement = React.createElement
	local v5 = {
		title = v4.windowTitle,
		maxSize = joined.maxSize,
		actions = actions,
		isFocused = joined.isFocused,
		onClose = joined.onClose,
		onUnfocus = joined.onUnfocus
	}

	local createElement2 = React.createElement
	local view = Foundation.View
	local v6 = {
		Size = UDim2.new(1, 0, 0, constants.WINDOW_HEIGHT),
		tag = "col auto-x align-y-center"
	}
	local invalidAudio

	if v2 ~= "MeetsCriteria" then
		local createElement3 = React.createElement
		local view2 = Foundation.View

		local v7 = {
			Icon = React.createElement(TrackingAudioIcon, {
				isMoving = v2 == "Unverified"
			}),
			Alert = 0
		}

		local createElement4 = React.createElement
		local text = Foundation.Text
		local text3

		if v2 == "Unverified" then
			text3 = v4.musicUnverified
		else
			text3 = v4.musicLoading
		end

		v7.Alert = createElement4(text, {
			tag = "auto-xy text-body-medium content-emphasis shrink text-wrap text-align-x-left text-align-y-center",
			Text = text3,
			LayoutOrder = nextOrder()
		})
		invalidAudio = createElement3(view2, {
			tag = "auto-x size-0-full gap-medium row align-y-center"
		}, v7)
	end

	local nowPlaying

	if v2 == "MeetsCriteria" then
		local createElement3 = React.createElement
		local view2 = Foundation.View

		local createElement4 = React.createElement
		local v7 = { layoutOrder = nextOrder(), thumbnailUrl = 0 }
		local thumbnailUrl

		if joined.song then
			thumbnailUrl = joined.song.thumbnailUrl
		end

		v7.thumbnailUrl = thumbnailUrl
		nowPlaying = createElement3(view2, {
			tag = "auto-xy row gap-medium flex-between align-y-center"
		}, {
			Icon = createElement4(MusicIcon, v7),
			SongInfo = React.createElement(
				Foundation.View,
				{ tag = "auto-xy col gap-xsmall shrink clip", LayoutOrder = nextOrder() },
				{
					Title = React.createElement(MarqueeScroller, {
						speed = v3 and 0 or nil,
						LayoutOrder = nextOrder()
					}, {
						Label = React.createElement(Foundation.Text, {
							tag = "auto-xy shrink text-title-medium content-emphasis",
							Text = not joined.song and "" or joined.song.title
						})
					}),
					Artists = React.createElement(Foundation.Text, {
						tag = "auto-xy shrink text-body-small content-default",
						Text = text2,
						TextTruncate = Enum.TextTruncate.AtEnd,
						LayoutOrder = nextOrder()
					})
				}
			)
		})
	else
		nowPlaying = false
	end

	return createElement(ChromeWindowFrame, v5, {
		Body = createElement2(view, v6, { InvalidAudio = invalidAudio, NowPlaying = nowPlaying })
	})
end

return ChromeWindow
