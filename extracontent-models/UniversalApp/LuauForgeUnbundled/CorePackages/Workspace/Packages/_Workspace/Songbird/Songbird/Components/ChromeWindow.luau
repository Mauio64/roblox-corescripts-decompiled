local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/constants")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/ReactUtils")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Localization")

local ChromeWindowFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/ChromeWindowFrame")
local MarqueeScroller = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/MarqueeScroller")
local MusicIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/MusicIcon")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/LikeButton")
local TrackingAudioIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/TrackingAudioIcon")

local useLocalization = Localization.Hooks.useLocalization
local createNextOrder = ReactUtils.createNextOrder
local useCallback = React.useCallback
local useMemo = React.useMemo

local v5 = {
	Loading = "Loading",
	Unverified = "Unverified",
	MeetsCriteria = "MeetsCriteria"
}

local v6 = { isLoading = false, maxSize = Vector2.new(300, 1e999) }

local function ChromeWindow(p2)
	local joined = Cryo.Dictionary.join(v6, p2)
	local nextOrder = createNextOrder()

	local v7 = useMemo(function(): string
		if joined.isLoading or not joined.song then
			return "Loading"
		end

		if joined.song.meetsCriteria then
			return "MeetsCriteria"
		end

		return "Unverified"
	end, { joined.isLoading, joined.song })
	local v8 = v7 ~= "MeetsCriteria"
	local v9 = useLocalization({
		windowTitle = "CoreScripts.TopBar.Music",
		musicLoading = "CoreScripts.TopBar.MusicLoading",
		musicUnverified = "CoreScripts.TopBar.MusicNotVerified"
	})

	local v10 = useCallback(function()
		if joined.onToggleLike then
			joined.onToggleLike()
		end
	end, { joined.onToggleLike })

	local v11 = useMemo(function()
		if joined.song then
			return table.concat(joined.song.artists, ", ")
		end

		return nil
	end, { joined.song })
	local v12

	if v8 then
		v12 = {}
	else
		v12 = { LikeButtonWrapper = 0 }
		local createElement = React.createElement
		local view = Foundation.View

		local createElement2 = React.createElement
		local v17 = if joined.song then joined.song.isLiked else false
		v12.LikeButtonWrapper = createElement(view, {
			tag = "auto-xy padding-right-xsmall"
		}, {
			LikeButton = createElement2(module10, {
				isFavorited = v17,
				onFavorite = v10
			})
		})
	end

	local createElement = React.createElement
	local v14 = {
		title = v9.windowTitle,
		maxSize = joined.maxSize,
		actions = v12,
		isFocused = joined.isFocused,
		onClose = joined.onClose,
		onUnfocus = joined.onUnfocus
	}

	local createElement2 = React.createElement
	local view = Foundation.View
	local v16 = {
		Size = UDim2.new(1, 0, 0, constants.WINDOW_HEIGHT),
		tag = "col auto-x align-y-center"
	}
	local v18

	if v7 ~= "MeetsCriteria" then
		local createElement3 = React.createElement
		local view2 = Foundation.View

		local v20 = {
			Icon = React.createElement(TrackingAudioIcon, {
				isMoving = v7 == "Unverified"
			}),
			Alert = 0
		}

		local createElement4 = React.createElement
		local text = Foundation.Text

		local v22 = if v7 == "Unverified" then v9.musicUnverified else v9.musicLoading
		v20.Alert = createElement4(text, {
			tag = "auto-xy text-body-medium content-emphasis shrink text-wrap text-align-x-left text-align-y-center",
			Text = v22,
			LayoutOrder = nextOrder()
		})
		v18 = createElement3(view2, {
			tag = "auto-x size-0-full gap-medium row align-y-center"
		}, v20)
	end

	local v19

	if v7 == "MeetsCriteria" then
		local createElement3 = React.createElement
		local view2 = Foundation.View

		local createElement4 = React.createElement
		local v22 = { layoutOrder = nextOrder(), thumbnailUrl = 0 }
		local v23 = if joined.song then joined.song.thumbnailUrl else nil
		v22.thumbnailUrl = v23
		v19 = createElement3(view2, {
			tag = "auto-xy row gap-medium flex-between align-y-center"
		}, {
			Icon = createElement4(MusicIcon, v22),
			SongInfo = React.createElement(
				Foundation.View,
				{
					tag = "auto-xy col gap-xsmall shrink clip",
					LayoutOrder = nextOrder()
				},
				{
					Title = React.createElement(MarqueeScroller, {
						speed = v8 and 0 or nil,
						LayoutOrder = nextOrder()
					}, {
						Label = React.createElement(Foundation.Text, {
							tag = "auto-xy shrink text-title-medium content-emphasis",
							Text = not joined.song and "" or joined.song.title
						})
					}),
					Artists = React.createElement(Foundation.Text, {
						tag = "auto-xy shrink text-body-small content-default",
						Text = v11,
						TextTruncate = Enum.TextTruncate.AtEnd,
						LayoutOrder = nextOrder()
					})
				}
			)
		})
	else
		v19 = false
	end

	return createElement(ChromeWindowFrame, v14, {
		Body = createElement2(view, v16, { InvalidAudio = v18, NowPlaying = v19 })
	})
end

return ChromeWindow
