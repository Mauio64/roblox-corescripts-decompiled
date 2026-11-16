local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local Image = Foundation.Image
local Slider = Foundation.Slider
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize

local function formatTime(p: number) -- 1 equivalent call inferred from this helper
	local v = math.max(0, (math.floor(p)))
	return `{math.floor(v / 60)}:{string.format("%02d", v % 60)}`
end

local function formatRemaining(p: number) -- 1 equivalent call inferred from this helper
	local v = math.ceil(p - 0.001)

	if v <= 0 then
		return `{0}:{string.format("%02d", 0)}`
	end

	return `-{formatTime(v)}` -- inferred equivalent call
end

local function LibraryAudioPlayerContentView(props)
	local v = Foundation.Hooks.useTokens()
	local v2 = Foundation.Hooks.useScaledValue(168)
	local isCompact = props.isCompact == true
	local mapped = props.elapsed:map(function(p: number)
		if props.duration <= 0 then
			return 0
		end

		return (math.clamp(p / props.duration, 0, 1))
	end)

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.LayoutOrder,
		tag = {
			["col align-x-center size-full-0 auto-y"] = true,
			["gap-small"] = isCompact,
			["gap-xxlarge"] = not isCompact
		},
		testId = "Library.AudioPlayer"
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local size

	if isCompact then
		size = UDim2.fromOffset(v.Size.Size_1600, v.Size.Size_1600)
	else
		size = UDim2.fromOffset(v2, v2)
	end

	local media

	if props.thumbnail == nil or props.thumbnail == "" then
		media = React.createElement(Icon, {
			name = IconName.MusicNote,
			size = IconSize.XLarge,
			style = v.Color.Content.Emphasis
		})
	else
		media = React.createElement(Image, {
			Image = props.thumbnail,
			ScaleType = Enum.ScaleType.Fit,
			tag = "size-full"
		})
	end

	local children = {
		Song = createElement2(View, {
			LayoutOrder = 1,
			tag = {
				["gap-medium"] = true,
				["row align-y-center size-full-0 auto-y"] = isCompact,
				["col align-x-center auto-xy"] = not isCompact
			}
		}, {
			Artwork = createElement3(
				View,
				{
					LayoutOrder = 1,
					Size = size,
					testId = "Library.AudioPlayer.Artwork",
					tag = "align-x-center align-y-center radius-large clip bg-shift-200"
				},
				{ Media = media }
			),
			Info = React.createElement(View, {
				LayoutOrder = 2,
				tag = {
					["col auto-y"] = true,
					fill = isCompact,
					["align-x-center size-full-0"] = not isCompact
				}
			}, {
				Title = React.createElement(Text, {
					LayoutOrder = 1,
					Text = props.title,
					tag = {
						["size-full-0 auto-y text-heading-small content-emphasis"] = true,
						["text-align-x-left text-truncate-end"] = isCompact,
						["text-wrap text-align-x-center"] = not isCompact
					}
				}),
				Artist = React.createElement(Text, {
					LayoutOrder = 2,
					Text = props.artist,
					tag = {
						["size-full-0 auto-y text-body-large text-truncate-end content-default"] = true,
						["text-align-x-left"] = isCompact,
						["text-align-x-center"] = not isCompact
					}
				})
			})
		}),
		Controls = 0
	}

	local createElement4 = React.createElement

	local v4 = {
		Timeline = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "col gap-xsmall size-full-0 auto-y",
				testId = "Library.AudioPlayer.Timeline"
			},
			{
				Slider = React.createElement(Slider, {
					LayoutOrder = 1,
					value = mapped,
					onValueChanged = props.onSeek,
					onDragStarted = props.onSeekStarted,
					onDragEnded = props.onSeekEnded,
					isDisabled = props.onSeek == nil or props.duration <= 0,
					size = InputSize.XSmall,
					knobVisibility = Foundation.Enums.Visibility.Always,
					variant = Foundation.Enums.SliderVariant.Emphasis,
					testId = "Library.AudioPlayer.Timeline.Slider"
				}),
				Times = React.createElement(View, {
					LayoutOrder = 2,
					tag = "row size-full-0 auto-y"
				}, {
					Elapsed = React.createElement(Text, {
						LayoutOrder = 1,
						Text = props.elapsed:map(formatTime),
						tag = "fill auto-y text-caption-large text-align-x-left content-default"
					}),
					Remaining = React.createElement(Text, {
						LayoutOrder = 2,
						Text = props.elapsed:map(function(p: number)
							return formatRemaining(props.duration - p) -- inferred equivalent call
						end),
						tag = "auto-xy text-caption-large content-default"
					})
				})
			}
		),
		PlayerControls = 0
	}

	local createElement5 = React.createElement

	local createElement6 = React.createElement
	local icon

	if props.isPlaying then
		icon = IconName.PauseLarge
	else
		icon = IconName.PlayLarge
	end

	v4.PlayerControls = createElement5(View, {
		LayoutOrder = 2,
		tag = "row align-x-center align-y-center auto-xy"
	}, {
		Playback = createElement6(IconButton, {
			LayoutOrder = 1,
			icon = icon,
			isCircular = true,
			onActivated = props.onTogglePlayback,
			size = InputSize.Large,
			testId = "Library.AudioPlayer.Playback",
			variant = ButtonVariant.Emphasis
		})
	})
	children.Controls = createElement4(View, {
		LayoutOrder = 2,
		tag = {
			["col align-x-center size-full-0 auto-y"] = true,
			["gap-small"] = isCompact,
			["gap-medium"] = not isCompact
		}
	}, v4)
	return createElement(View, v3, children)
end

return LibraryAudioPlayerContentView
