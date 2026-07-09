local ParentParent = script.Parent.Parent.Parent
local Foundation = require(ParentParent.Foundation)
local React = require(ParentParent.React)
local ButtonSize = Foundation.Enums.ButtonSize
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local View = Foundation.View

local function formatTime(n1: number) -- line: 29
	local v11 = math.floor(n1 / 60)
	local v12 = math.floor(n1 % 60)

	return string.format("%02d:%02d", v11, v12)
end
local function ProgressBar(t1: {[any]: any}) -- line: 35
	-- upvalues: React (copy), View (copy), IconButton (copy), ButtonSize (copy), FoundationText (copy)
	local v14 = t1.timePosition / t1.timeLength
	local timePosition = t1.timePosition
	local v16 = math.floor(timePosition / 60)
	local v17 = math.floor(timePosition % 60)
	local v18 = string.format("%02d:%02d", v16, v17)
	local timeLength = t1.timeLength
	local v20 = math.floor(timeLength / 60)
	local v21 = math.floor(timeLength % 60)
	local v22 = string.format("%02d:%02d", v20, v21)
	local v23 = React.useRef(nil)
	local v24, v25 = React.useState(0)

	React.useEffect(function() -- line: 42
		-- upvalues: v23 (copy), v25 (copy)
		if not v23 or not v23.current then
			return
		end

		local connection = v23.current.InputBegan:Connect(function(input) -- line: 49
			-- upvalues: v25 (copy)
			v25(input.Position.X)
		end)

		return function() -- line: 53
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	local v26 = React.useCallback(function() -- line: 58
		-- upvalues: v23 (copy), t1 (copy), v24 (copy)
		if not v23 or not v23.current then
			return
		end

		local AbsolutePositionX = v23.current.AbsolutePosition.X
		local AbsoluteSizeX = v23.current.AbsoluteSize.X

		t1.onProgressBarActivated((v24 - AbsolutePositionX) / AbsoluteSizeX)
	end, {
		v24,
		t1.onProgressBarActivated
	})

	return React.createElement(View, {
		tag = {
			["align-x-center align-y-center col size-full-1400"] = true,
			["padding-medium"] = t1.isFullScreen,
			["padding-x-medium"] = not t1.isFullScreen
		}
	}, {
		ProgressBarContainer = React.createElement(View, {
			LayoutOrder = 1,
			tag = "radius-small bg-over-media-0 size-full-200",
			onActivated = v26,
			ref = v23
		}, {
			Progress = React.createElement(View, {
				tag = "radius-small bg-system-neutral",
				Size = UDim2.fromScale(v14, 1)
			})
		}),
		CTAContainer = React.createElement(View, {
			LayoutOrder = 2,
			isDisabled = true,
			tag = "row flex-between align-x-center align-y-center size-full-1000"
		}, {
			PlayButton = React.createElement(IconButton, {
				isDisabled = false,
				LayoutOrder = 1,
				icon = not t1.isPlaying and "icons/controls/media-play-medium" or "icons/controls/media-pause-medium",
				onActivated = t1.onPlayButtonActivated,
				size = ButtonSize.Medium
			}),
			TimeText = if not t1.isTimeHidden then React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy text-body-large",
				Text = string.format("%s / %s", v18, v22)
			}) else nil,
			MuteButton = React.createElement(IconButton, {
				isDisabled = false,
				LayoutOrder = 3,
				icon = not t1.isMuted and "icons/controls/speaker" or "icons/controls/speakerMute",
				onActivated = t1.onMuteButtonActivated,
				size = ButtonSize.Medium
			})
		})
	})
end

return ProgressBar
