local parent = script:FindFirstAncestor("VideoUtils").Parent

local React = require(parent.React)

local BuilderIcons = require(parent.BuilderIcons)
local Icon = BuilderIcons.Icon
local IconVariant = BuilderIcons.IconVariant

local CollectionViews = require(parent.CollectionViews)
local maybeForceDarkTheme = CollectionViews.maybeForceDarkTheme

local Foundation = require(parent.Foundation)
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local Responsive = require(parent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller

local VideoProgressBar = require(script.Parent.VideoProgressBar)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEdpMediaGalleryFullScreen = SharedFlags.FFlagLuaAppEdpMediaGalleryFullScreen

local function VideoPlayerBottomOverlay(props)
	local v = useTokens()

	local v2 = props.muteButtonConfig ~= nil
		or FFlagLuaAppEdpMediaGalleryFullScreen and (props.playButtonConfig ~= nil or props.progressBarConfig ~= nil)

	local v3 = useBreakpointXOrSmaller(Responsive.Keys.Small)

	local xxLarge = v.Padding.XXLarge
	local v4 = v3 and 0 or v.Padding.Medium
	local medium = v.Padding.Medium
	local size_1000 = v.Size.Size_1000
	local size_100 = v.Size.Size_100
	local xSmall = v.Padding.XSmall
	local muteButton

	if props.muteButtonConfig then
		local createElement = React.createElement
		local name

		if props.muteButtonConfig.muted then
			name = Icon.SpeakerSlash
		else
			name = Icon.Speaker
		end

		muteButton = createElement(IconButton, {
			icon = { name = name, variant = IconVariant.Filled },
			iconSize = IconSize.Medium,
			onActivated = props.muteButtonConfig.onMuteButtonActivated or nil,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.fromScale(1, 1),
			Selectable = false
		})
	end

	local v5

	if FFlagLuaAppEdpMediaGalleryFullScreen then
		v5 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, xSmall),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, xxLarge),
				PaddingBottom = UDim.new(0, v4),
				PaddingLeft = UDim.new(0, medium),
				PaddingRight = UDim.new(0, medium)
			}),
			ProgressBar = 0,
			ButtonsContainer = 0
		}
		local progressBar

		if props.progressBarConfig then
			progressBar = React.createElement(VideoProgressBar, {
				progressBinding = props.progressBarConfig.progressBinding,
				Size = UDim2.new(1, 0, 0, size_100),
				LayoutOrder = 1
			})
		end

		v5.ProgressBar = progressBar

		local createElement = React.createElement
		local v6 = {
			Size = UDim2.new(1, 0, 0, size_1000),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2
		}
		local playButton

		if props.playButtonConfig then
			local createElement2 = React.createElement
			local name

			if props.playButtonConfig.isVideoPlaying then
				name = Icon.PauseLarge
			else
				name = Icon.PlayLarge
			end

			playButton = createElement2(IconButton, {
				icon = { name = name, variant = IconVariant.Filled },
				iconSize = IconSize.Medium,
				onActivated = props.playButtonConfig.onPlayButtonActivated,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Selectable = false
			})
		end

		local muteButton2

		if props.muteButtonConfig then
			muteButton2 = muteButton
		end

		v5.ButtonsContainer = createElement("Frame", v6, {
			PlayButton = playButton,
			MuteButton = muteButton2
		})
	end

	local useMemo = React.useMemo
	local function fn()
		local v6 = xxLarge + v4

		if props.muteButtonConfig or FFlagLuaAppEdpMediaGalleryFullScreen and props.playButtonConfig then
			v6 += size_1000
		end

		if FFlagLuaAppEdpMediaGalleryFullScreen and props.progressBarConfig then
			return v6 + (size_100 + xSmall)
		end

		return v6
	end

	local muteButtonConfig = props.muteButtonConfig
	local playButtonConfig

	if FFlagLuaAppEdpMediaGalleryFullScreen then
		playButtonConfig = props.playButtonConfig
	end

	local v6

	if FFlagLuaAppEdpMediaGalleryFullScreen then
		v6 = props.progressBarConfig
	end

	local v7 = useMemo(fn, {
		muteButtonConfig,
		playButtonConfig,
		v6,
		xxLarge,
		v4,
		size_1000,
		size_100,
		xSmall
	})

	local createElement = React.createElement
	local v8 = {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, v7),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = props.ZIndex
	}

	local createElement2 = React.createElement
	local v9 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v.Color.Extended.Black.Black_100.Color3,
		BorderSizePixel = 0,
		ZIndex = 1
	}

	local v10 = {
		Gradient = React.createElement("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.2) })
		}),
		UICorner = 0
	}
	local uiCorner

	if props.cornerRadius then
		uiCorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.cornerRadius)
		})
	end

	v10.UICorner = uiCorner
	local v11 = {
		GradientOverlay = createElement2("Frame", v9, v10),
		UserControls = 0
	}
	local userControls

	if props.videoLoaded and v2 then
		local createElement3 = React.createElement

		local v12 = {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 10
		}

		if not FFlagLuaAppEdpMediaGalleryFullScreen then
			v5 = {
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, xxLarge),
					PaddingBottom = UDim.new(0, v4),
					PaddingLeft = UDim.new(0, medium),
					PaddingRight = UDim.new(0, medium)
				}),
				MuteButton = 0
			}

			if not props.muteButtonConfig then
				muteButton = nil
			end

			v5.MuteButton = muteButton
		end

		userControls = maybeForceDarkTheme(createElement3("Frame", v12, v5), true)
	end

	v11.UserControls = userControls
	return createElement("Frame", v8, v11)
end

return VideoPlayerBottomOverlay
