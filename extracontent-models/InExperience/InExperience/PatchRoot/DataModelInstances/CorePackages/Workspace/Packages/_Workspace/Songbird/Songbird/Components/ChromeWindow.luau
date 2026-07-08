local Songbird = script:FindFirstAncestor("Songbird")
local UserInputService = game:GetService("UserInputService")
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
local AnalyticActions = require(Songbird.Analytics.AnalyticActions)
local sendChromeWindowAnalytics = require(Songbird.Analytics.sendChromeWindowAnalytics)
local isInputInsideObject = require(Songbird.Internal.isInputInsideObject)
local getFFlagSongbirdPopoverSubmenu = require(Songbird.Flags.getFFlagSongbirdPopoverSubmenu)
local useLocalization = Localization.Hooks.useLocalization
local createNextOrder = ReactUtils.createNextOrder
local useEventConnection = ReactUtils.useEventConnection
local useCallback = React.useCallback
local useMemo = React.useMemo
local useRef = React.useRef
local useState = React.useState
local _ = {
	Loading = "Loading",
	Unverified = "Unverified",
	MeetsCriteria = "MeetsCriteria"
}
local t1 = {
	isLoading = false,
	maxSize = Vector2.new(300, 1e999)
}

local function ChromeWindow(t2: {[any]: any}) -- line: 64
	-- upvalues: Cryo (copy), t1 (copy), createNextOrder (copy), useMemo (copy), useLocalization (copy), useCallback (copy), useState (copy), sendChromeWindowAnalytics (copy), AnalyticActions (copy), getFFlagSongbirdPopoverSubmenu (copy), useRef (copy), useEventConnection (copy), UserInputService (copy), isInputInsideObject (copy), Foundation (copy), React (copy), LikeButton (copy), constants (copy), ChromeWindowFrame (copy), TrackingAudioIcon (copy), MusicIcon (copy), MarqueeScroller (copy)
	local v29 = Cryo.Dictionary.join(t1, t2)
	local v30 = createNextOrder()
	local v31 = useMemo(function() -- line: 68
		-- upvalues: v29 (copy)
		if v29.isLoading then
			return "Loading"
		end

		if v29.song then
			if v29.song.meetsCriteria then
				return "MeetsCriteria"
			end

			return "Unverified"
		end

		return "Loading"
	end, {
		v29.isLoading,
		v29.song
	})
	local v32 = v31 ~= "MeetsCriteria"
	local v33 = useLocalization({
		windowTitle = "CoreScripts.TopBar.Music",
		musicLoading = "CoreScripts.TopBar.MusicLoading",
		musicUnverified = "CoreScripts.TopBar.MusicNotVerified",
		report = "CoreScripts.TopBar.Label.Report"
	})
	local v34 = useCallback(function() -- line: 93
		-- upvalues: v29 (copy)
		if v29.onToggleLike then
			v29.onToggleLike()
		end
	end, { v29.onToggleLike })
	local v35 = useMemo(function() -- line: 99
		-- upvalues: v29 (copy)
		if v29.song then
			return table.concat(v29.song.artists, ", ")
		end

		return nil
	end, { v29.song })
	local v36, v37 = useState(false)
	local v38 = useCallback(function() -- line: 107
		-- upvalues: v37 (copy), sendChromeWindowAnalytics (copy), AnalyticActions (copy)
		v37(function(p1) -- line: 108
			return not p1
		end)
		sendChromeWindowAnalytics({
			action = AnalyticActions.SeeMore
		})
	end, {})
	local u39 = nil

	if not getFFlagSongbirdPopoverSubmenu() then
		u39 = useRef(nil)
		useEventConnection(UserInputService.InputBegan, function(p2) -- line: 117
			-- upvalues: v36 (copy), isInputInsideObject (copy), u39 (ref), v37 (copy)
			if v36 and not isInputInsideObject(p2.Position, u39.current) then
				v37(false)
			end
		end, { v36 })
	end

	local v40 = useCallback(function(p3) -- line: 126
		-- upvalues: Foundation (copy), v29 (copy), v38 (copy)
		if p3 == Foundation.Enums.ControlState.Pressed then
			if v29.onReport then
				v29.onReport()
			end

			v38()
		end
	end, { v29.onReport })
	local v41 = if v32 then {} else {
		LikeButton = React.createElement(LikeButton, {
			isFavorited = not not v29.song and v29.song.isLiked,
			onFavorite = v34
		})
	}
	local v42 = if not getFFlagSongbirdPopoverSubmenu() then {
		Menu = React.createElement(Foundation.View, {
			tag = "auto-y col gap-small",
			Size = UDim2.fromOffset(constants.SUBMENU_WIDTH, 0),
			sizeConstraint = {
				MaxSize = Vector2.new(constants.SUBMENU_WIDTH, 1e999)
			}
		}, {
			ReportButton = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y row gap-small align-y-center radius-medium",
				onStateChanged = v40
			}, {
				Icon = React.createElement(Foundation.Icon, {
					name = "icons/actions/feedback",
					LayoutOrder = v30()
				}),
				Label = React.createElement(Foundation.Text, {
					tag = "auto-xy text-title-medium content-emphasis",
					Text = v33.report,
					LayoutOrder = v30()
				})
			})
		})
	} else nil
	local v43 = if not getFFlagSongbirdPopoverSubmenu() then nil else {{
		id = "report",
		icon = "icons/actions/feedback",
		text = v33.report,
		onActivated = function() -- line: 180
			-- upvalues: v29 (copy), v37 (copy)
			if v29.onReport then
				v29.onReport()
			end

			v37(false)
		end
	}}

	return React.createElement(ChromeWindowFrame, {
		title = v33.windowTitle,
		maxSize = v29.maxSize,
		actions = v41,
		menuItems = if not getFFlagSongbirdPopoverSubmenu() then nil else if v31 ~= "MeetsCriteria" and v31 ~= "Unverified" then nil else v43,
		submenu = if not getFFlagSongbirdPopoverSubmenu() then if v31 ~= "MeetsCriteria" and v31 ~= "Unverified" then nil else v42 else nil,
		isSubMenuOpen = v36,
		isFocused = v29.isFocused,
		onToggleSubMenu = v38,
		onClose = v29.onClose,
		onUnfocus = v29.onUnfocus,
		overflowButtonRef = if not getFFlagSongbirdPopoverSubmenu() then u39 else nil
	}, {
		Body = React.createElement(Foundation.View, {
			tag = "col auto-x align-y-center",
			Size = UDim2.new(1, 0, 0, constants.WINDOW_HEIGHT)
		}, {
			InvalidAudio = if v31 == "MeetsCriteria" then nil else React.createElement(Foundation.View, {
				tag = "auto-x size-0-full gap-medium row align-y-center"
			}, {
				Icon = React.createElement(TrackingAudioIcon, {
					isMoving = v31 == "Unverified"
				}),
				Alert = React.createElement(Foundation.Text, {
					tag = "auto-xy text-body-medium content-emphasis shrink text-wrap text-align-x-left text-align-y-center",
					Text = if v31 ~= "Unverified" then v33.musicLoading else v33.musicUnverified,
					LayoutOrder = v30()
				})
			}),
			NowPlaying = v31 == "MeetsCriteria" and React.createElement(Foundation.View, {
				tag = "auto-xy row gap-medium flex-between align-y-center"
			}, {
				Icon = React.createElement(MusicIcon, {
					layoutOrder = v30(),
					thumbnailUrl = if not v29.song then nil else v29.song.thumbnailUrl
				}),
				SongInfo = React.createElement(Foundation.View, {
					tag = "auto-xy col gap-xsmall shrink clip",
					LayoutOrder = v30()
				}, {
					Title = React.createElement(MarqueeScroller, {
						speed = if not v32 then nil else 0,
						LayoutOrder = v30()
					}, {
						Label = React.createElement(Foundation.Text, {
							tag = "auto-xy shrink text-title-medium content-emphasis",
							Text = not v29.song and "" or v29.song.title
						})
					}),
					Artists = React.createElement(Foundation.Text, {
						tag = "auto-xy shrink text-body-small content-default",
						Text = v35,
						TextTruncate = Enum.TextTruncate.AtEnd,
						LayoutOrder = v30()
					})
				})
			})
		})
	})
end

return ChromeWindow
