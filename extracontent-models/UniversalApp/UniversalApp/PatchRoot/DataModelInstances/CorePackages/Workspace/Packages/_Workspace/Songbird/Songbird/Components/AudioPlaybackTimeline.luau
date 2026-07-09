local Songbird = script:FindFirstAncestor("Songbird")
local React = require(Songbird.Parent.React)
local Foundation = require(Songbird.Parent.Foundation)
local ReactUtils = require(Songbird.Parent.ReactUtils)
local ProgressCountdown = require(Songbird.Components.ProgressCountdown)
local createNextOrder = ReactUtils.createNextOrder

local function AudioPlaybackTimeline(t1: {[any]: any}) -- line: 22
	-- upvalues: createNextOrder (copy), React (copy), Foundation (copy), ProgressCountdown (copy)
	local v9 = createNextOrder()

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y row flex-between align-y-center gap-large",
		LayoutOrder = t1.LayoutOrder
	}, {
		TimeElapsed = React.createElement(ProgressCountdown, {
			counterType = "Elapsed",
			timeLength = t1.duration,
			timePosition = t1.elapsed,
			LayoutOrder = v9()
		}),
		ProgressBar = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y shrink padding-top-xxsmall",
			LayoutOrder = v9()
		}, {
			Slider = React.createElement(Foundation.Slider, {
				value = t1.elapsed:map(function(n1: number) -- line: 41
					-- upvalues: t1 (copy)
					if t1.duration > 0 then
						return n1 / t1.duration
					end

					return 0
				end),
				onValueChanged = t1.onDragTimeline,
				onDragStarted = t1.onDragTimelineStart,
				onDragEnded = t1.onDragTimelineEnd,
				size = Foundation.Enums.InputSize.Medium,
				knobVisibility = Foundation.Enums.ScrollBarVisibility.Auto,
				variant = Foundation.Enums.SliderVariant.Standard
			})
		}),
		TimeRemaining = React.createElement(ProgressCountdown, {
			timeLength = t1.duration,
			timePosition = t1.elapsed,
			LayoutOrder = v9()
		})
	})
end

return AudioPlaybackTimeline
