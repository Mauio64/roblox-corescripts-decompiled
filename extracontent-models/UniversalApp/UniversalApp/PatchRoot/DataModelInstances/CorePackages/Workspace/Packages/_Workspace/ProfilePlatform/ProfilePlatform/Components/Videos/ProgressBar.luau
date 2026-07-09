local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local ButtonSize = Foundation.Enums.ButtonSize
local IconButton = Foundation.IconButton
local View = Foundation.View

local function ProgressBar(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), View (copy), IconButton (copy), ButtonSize (copy)
	local v9 = not (t1.timeLength > 0) and 0 or t1.timePosition / t1.timeLength
	local v10 = React.useRef(nil)
	local v11, v12 = React.useState(0)

	React.useEffect(function() -- line: 32
		-- upvalues: v10 (copy), v12 (copy)
		if not v10 or not v10.current then
			return
		end

		local connection = v10.current.InputBegan:Connect(function(input) -- line: 39
			-- upvalues: v12 (copy)
			v12(input.Position.X)
		end)

		return function() -- line: 43
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	local v13 = React.useCallback(function() -- line: 48
		-- upvalues: v10 (copy), t1 (copy), v11 (copy)
		if not v10 or not v10.current then
			return
		end

		local AbsolutePositionX = v10.current.AbsolutePosition.X
		local AbsoluteSizeX = v10.current.AbsoluteSize.X

		t1.onProgressBarActivated((v11 - AbsolutePositionX) / AbsoluteSizeX)
	end, {
		v11,
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
			tag = "radius-small size-full-200",
			backgroundStyle = {
				Transparency = 0.7,
				Color3 = Color3.fromHex("#D5D7DD")
			},
			onActivated = v13,
			ref = v10
		}, {
			Progress = React.createElement(View, {
				tag = "radius-small bg-action-sub-emphasis",
				Size = UDim2.fromScale(v9, 1)
			})
		}),
		CTAContainer = React.createElement(View, {
			isDisabled = true,
			LayoutOrder = 2,
			tag = "row flex-between align-x-center align-y-center size-full-1000"
		}, {
			PlayButton = React.createElement(IconButton, {
				isDisabled = false,
				LayoutOrder = 1,
				icon = not t1.isPlaying and "icons/controls/media-play-medium" or "icons/controls/media-pause-medium",
				onActivated = t1.onPlayButtonActivated,
				size = ButtonSize.Medium
			}),
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
