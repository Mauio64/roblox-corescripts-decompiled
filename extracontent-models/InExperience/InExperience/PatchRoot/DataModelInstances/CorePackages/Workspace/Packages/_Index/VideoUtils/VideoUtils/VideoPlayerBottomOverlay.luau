local Parent = script:FindFirstAncestor("VideoUtils").Parent
local React = require(Parent.React)
local BuilderIcons = require(Parent.BuilderIcons)
local Icon = BuilderIcons.Icon
local IconVariant = BuilderIcons.IconVariant
local maybeForceDarkTheme = require(Parent.CollectionViews).maybeForceDarkTheme
local Foundation = require(Parent.Foundation)
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local Responsive = require(Parent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local VideoProgressBar = require(script.Parent.VideoProgressBar)
local FFlagLuaAppEdpMediaGalleryFullScreen = require(Parent.SharedFlags).FFlagLuaAppEdpMediaGalleryFullScreen

local function VideoPlayerBottomOverlay(t1: {[any]: any}) -- line: 45
	-- upvalues: useTokens (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), useBreakpointXOrSmaller (copy), Responsive (copy), React (copy), IconButton (copy), Icon (copy), IconVariant (copy), IconSize (copy), VideoProgressBar (copy), maybeForceDarkTheme (copy)
	local v17 = useTokens()
	local v18 = t1.muteButtonConfig ~= nil or FFlagLuaAppEdpMediaGalleryFullScreen and (t1.playButtonConfig ~= nil or t1.progressBarConfig ~= nil)
	local v19 = useBreakpointXOrSmaller(Responsive.Keys.Small)
	local XXLarge = v17.Padding.XXLarge
	local v21 = if not v19 then v17.Padding.Medium else 0
	local Medium = v17.Padding.Medium
	local Size_1000 = v17.Size.Size_1000
	local Size_100 = v17.Size.Size_100
	local XSmall = v17.Padding.XSmall
	local v26 = if not t1.muteButtonConfig then nil else React.createElement(IconButton, {
		Selectable = false,
		icon = {
			name = if not t1.muteButtonConfig.muted then Icon.Speaker else Icon.SpeakerSlash,
			variant = IconVariant.Filled
		},
		iconSize = IconSize.Medium,
		onActivated = t1.muteButtonConfig.onMuteButtonActivated or nil,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.fromScale(1, 1)
	})
	local t2 = nil

	if FFlagLuaAppEdpMediaGalleryFullScreen then
		t2 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, XSmall),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, XXLarge),
				PaddingBottom = UDim.new(0, v21),
				PaddingLeft = UDim.new(0, Medium),
				PaddingRight = UDim.new(0, Medium)
			}),
			ProgressBar = if not t1.progressBarConfig then nil else React.createElement(VideoProgressBar, {
				LayoutOrder = 1,
				progressBinding = t1.progressBarConfig.progressBinding,
				Size = UDim2.new(1, 0, 0, Size_100)
			}),
			ButtonsContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, Size_1000)
			}, {
				PlayButton = if not t1.playButtonConfig then nil else React.createElement(IconButton, {
					Selectable = false,
					icon = {
						name = if not t1.playButtonConfig.isVideoPlaying then Icon.PlayLarge else Icon.PauseLarge,
						variant = IconVariant.Filled
					},
					iconSize = IconSize.Medium,
					onActivated = t1.playButtonConfig.onPlayButtonActivated,
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.fromScale(0, 1)
				}),
				MuteButton = if not t1.muteButtonConfig then nil else v26
			})
		}
	end

	local v28 = React.useMemo(function() -- line: 124
		-- upvalues: XXLarge (copy), v21 (copy), t1 (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), Size_1000 (copy), Size_100 (copy), XSmall (copy)
		local v29 = XXLarge + v21

		if t1.muteButtonConfig or FFlagLuaAppEdpMediaGalleryFullScreen and t1.playButtonConfig then
			v29 += Size_1000
		end

		if FFlagLuaAppEdpMediaGalleryFullScreen and t1.progressBarConfig then
			v29 += Size_100 + XSmall
		end

		return v29
	end, {
		t1.muteButtonConfig,
		if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t1.playButtonConfig,
		if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t1.progressBarConfig,
		XXLarge,
		v21,
		Size_1000,
		Size_100,
		XSmall
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, v28),
		ZIndex = t1.ZIndex
	}, {
		GradientOverlay = React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 1,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v17.Color.Extended.Black.Black_100.Color3
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0.2)
				})
			}),
			UICorner = if not t1.cornerRadius then nil else React.createElement("UICorner", {
				CornerRadius = UDim.new(0, t1.cornerRadius)
			})
		}),
		UserControls = if not t1.videoLoaded or not v18 then nil else maybeForceDarkTheme(React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 10,
			Size = UDim2.fromScale(1, 1)
		}, if not FFlagLuaAppEdpMediaGalleryFullScreen then {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, XXLarge),
				PaddingBottom = UDim.new(0, v21),
				PaddingLeft = UDim.new(0, Medium),
				PaddingRight = UDim.new(0, Medium)
			}),
			MuteButton = if not t1.muteButtonConfig then nil else v26
		} else t2), true)
	})
end

return VideoPlayerBottomOverlay
