local Songbird = script:FindFirstAncestor("Songbird")

local React = require(Songbird.Parent.React)
local Foundation = require(Songbird.Parent.Foundation)
local ReactUtils = require(Songbird.Parent.ReactUtils)

local ProgressCountdown = require(Songbird.Components.ProgressCountdown)

local createNextOrder = ReactUtils.createNextOrder

local function AudioPlaybackTimeline(props)
	local nextOrder = createNextOrder()

	return React.createElement(
		Foundation.View,
		{
			tag = "size-full-0 auto-y row flex-between align-y-center gap-large",
			LayoutOrder = props.LayoutOrder
		},
		{
			TimeElapsed = React.createElement(ProgressCountdown, {
				timeLength = props.duration,
				timePosition = props.elapsed,
				counterType = "Elapsed",
				LayoutOrder = nextOrder()
			}),
			ProgressBar = React.createElement(
				Foundation.View,
				{ tag = "size-full-0 auto-y shrink padding-top-xxsmall", LayoutOrder = nextOrder() },
				{
					Slider = React.createElement(Foundation.Slider, {
						value = props.elapsed:map(function(p: number)
							if props.duration > 0 then
								return p / props.duration
							end

							return 0
						end),
						onValueChanged = props.onDragTimeline,
						onDragStarted = props.onDragTimelineStart,
						onDragEnded = props.onDragTimelineEnd,
						size = Foundation.Enums.InputSize.Medium,
						knobVisibility = Foundation.Enums.ScrollBarVisibility.Auto,
						variant = Foundation.Enums.SliderVariant.Standard
					})
				}
			),
			TimeRemaining = React.createElement(ProgressCountdown, {
				timeLength = props.duration,
				timePosition = props.elapsed,
				LayoutOrder = nextOrder()
			})
		}
	)
end

return AudioPlaybackTimeline
