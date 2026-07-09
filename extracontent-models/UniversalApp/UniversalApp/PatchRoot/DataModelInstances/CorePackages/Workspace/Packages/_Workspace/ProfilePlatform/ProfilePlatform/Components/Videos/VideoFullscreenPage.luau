local UserInputService = game:GetService("UserInputService")
local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local Interactable = UIBlox.Core.Control.Interactable
local FullscreenPageWithSafeArea = require(ProfilePlatformParent.AppBlox).FullscreenPageWithSafeArea
local Navigation = require(ProfilePlatformParent.Navigation)
local VideoPlayer = require(ProfilePlatform.Components.Videos.VideoPlayer)
local ProgressBar = require(ProfilePlatform.Components.Videos.ProgressBar)
local useNavigation = Navigation.useNavigation
local useStyle = UIBlox.Core.Style.useStyle
local IconButton = Foundation.IconButton
local View = Foundation.View
local ButtonSize = Foundation.Enums.ButtonSize
local useScreenSize = require(ProfilePlatformParent.RobloxAppHooks).useScreenSize
local v18 = game:DefineFastFlag("BrandVideosFixCloseFullscreen", false)

return function() -- line: 42
	-- upvalues: useNavigation (copy), useScreenSize (copy), useStyle (copy), React (copy), v18 (copy), UserInputService (copy), FullscreenPageWithSafeArea (copy), View (copy), IconButton (copy), ButtonSize (copy), VideoPlayer (copy), ProgressBar (copy), Interactable (copy)
	local v19 = useNavigation()
	local v20 = v19.getParam("extraProps")
	local v21 = useScreenSize()
	local Theme = useStyle().Theme
	local v23, v24 = React.useState(0)
	local v25, v26 = React.useState(0)
	local v27, v28 = React.useState(true)
	local v29, v30 = React.useState(not v20 or (v20.isMuted == nil or v20.isMuted))
	local v31 = React.useRef(nil)

	React.useEffect(function() -- line: 56
		-- upvalues: v20 (copy), v29 (copy)
		if v20 and v20.onMuteUpdate then
			v20.onMuteUpdate(v29)
		end
	end, {
		v29,
		v20
	})

	local v32 = React.useMemo(function() -- line: 62
		-- upvalues: v21 (copy)
		local X = v21.X
		local v39 = X / 1.7777777777777777

		if v39 > v21.Y then
			v39 = v21.Y
			X = v39 * 1.7777777777777777
		end

		return UDim2.new(0, X, 0, v39)
	end, {
		v21.X,
		v21.Y
	})
	local v33 = React.useCallback(function() -- line: 74
		-- upvalues: v18 (copy), v31 (copy), v27 (copy), v19 (copy)
		if v18 and (v31.current and v27) then
			v31.current.togglePlayPause()
		end

		v19.goBack()
	end, { v19.goBack })
	local v34 = React.useCallback(function(p1, p2, p3, p4) -- line: 83
		-- upvalues: v24 (copy), v26 (copy), v28 (copy), v30 (copy)
		v24(p1)
		v26(p2)
		v28(p3)
		v30(p4)
	end, {})
	local v35 = React.useCallback(function(p5) -- line: 90
		-- upvalues: v31 (copy), v25 (copy)
		if v31.current and v31.current.setTimePosition then
			v31.current.setTimePosition(v25 * p5)
		end
	end, { v25 })
	local v36 = React.useCallback(function() -- line: 96
		-- upvalues: v31 (copy)
		if v31.current and v31.current.togglePlayPause then
			v31.current.togglePlayPause()
		end
	end, {})
	local v37 = React.useCallback(function() -- line: 102
		-- upvalues: v31 (copy)
		if v31.current and v31.current.toggleMute then
			v31.current.toggleMute()
		end
	end, {})

	React.useEffect(function() -- line: 108
		-- upvalues: UserInputService (copy), v36 (copy), v33 (copy)
		local connection = UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 109
			-- upvalues: v36 (copy), v33 (copy)
			if gameProcessed then
				return
			end

			if input.KeyCode == Enum.KeyCode.Space then
				v36()
			end

			if input.KeyCode == Enum.KeyCode.Escape then
				v33()
			end
		end)

		return function() -- line: 123
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v36,
		v33
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency
	}, {
		CloseButtonContainer = React.createElement(View, {
			tag = "align-x-right align-y-top position-top-right anchor-top-right auto-xy padding-xlarge padding-medium",
			ZIndex = 100000
		}, {
			CloseButton = React.createElement(IconButton, {
				icon = "icons/navigation/close",
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				size = ButtonSize.Medium,
				onActivated = v33
			})
		}),
		VideoContainer = React.createElement(View, {
			tag = "position-center-center anchor-center-center",
			Size = v32
		}, {
			VideoPlayer = if not v20 or not v20.videoId then nil else React.createElement(VideoPlayer, {
				isFullscreen = true,
				looped = false,
				initialTimePosition = v20.initialTimePosition,
				isMuted = v29,
				videoId = v20.videoId,
				onProgressUpdate = v34,
				ref = v31
			})
		}),
		FixedProgressBar = if not (v25 > 0) then nil else React.createElement(View, {
			tag = "position-bottom-center anchor-bottom-center",
			ZIndex = 1000,
			Size = UDim2.new(1, 0, 0, 80)
		}, {
			ProgressBar = React.createElement(ProgressBar, {
				isFullScreen = true,
				isMuted = v29,
				isPlaying = v27,
				onMuteButtonActivated = v37,
				onPlayButtonActivated = v36,
				onProgressBarActivated = v35,
				timePosition = v23,
				timeLength = v25
			})
		}),
		InteractableWrapper = if not (v25 > 0) then nil else React.createElement(View, {
			ZIndex = 999,
			Size = UDim2.fromScale(1, 1)
		}, {
			Interactable = React.createElement(Interactable, {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Selectable = false,
				[React.Event.Activated] = v36
			})
		})
	})
end
