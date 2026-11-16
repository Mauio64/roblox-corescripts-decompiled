local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")

local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/BuilderIcons")
local icon = BuilderIcons.Icon
local iconVariant = BuilderIcons.IconVariant

local maybeForceDarkTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/CollectionViews").maybeForceDarkTheme

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Foundation")
local iconButton = Foundation.IconButton
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Responsive")
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller

local VideoProgressBar = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoProgressBar")

local fFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppEdpMediaGalleryFullScreen

local function VideoPlayerBottomOverlay(props)
	local v5 = useTokens()

	local v6 = props.muteButtonConfig ~= nil
		or fFlagLuaAppEdpMediaGalleryFullScreen
		and (props.playButtonConfig ~= nil or props.progressBarConfig ~= nil)

	local v7 = useBreakpointXOrSmaller(Responsive.Keys.Small)

	local xxLarge = v5.Padding.XXLarge
	local v8 = v7 and 0 or v5.Padding.Medium
	local medium = v5.Padding.Medium
	local size_1000 = v5.Size.Size_1000
	local size_100 = v5.Size.Size_100
	local xSmall = v5.Padding.XSmall
	local v9

	if props.muteButtonConfig then
		local createElement = React.createElement

		local v13 = if props.muteButtonConfig.muted then icon.SpeakerSlash else icon.Speaker
		v9 = createElement(iconButton, {
			icon = { name = v13, variant = iconVariant.Filled },
			iconSize = iconSize.Medium,
			onActivated = props.muteButtonConfig.onMuteButtonActivated or nil,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.fromScale(1, 1),
			Selectable = false
		})
	end

	local v10

	if fFlagLuaAppEdpMediaGalleryFullScreen then
		v10 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, xSmall),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, xxLarge),
				PaddingBottom = UDim.new(0, v8),
				PaddingLeft = UDim.new(0, medium),
				PaddingRight = UDim.new(0, medium)
			}),
			ProgressBar = 0,
			ButtonsContainer = 0
		}

		local v11 = if props.progressBarConfig then React.createElement(VideoProgressBar, {
			progressBinding = props.progressBarConfig.progressBinding,
			Size = UDim2.new(1, 0, 0, size_100),
			LayoutOrder = 1
		}) else nil
		v10.ProgressBar = v11

		local createElement = React.createElement
		local v13 = {
			Size = UDim2.new(1, 0, 0, size_1000),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2
		}
		local v15

		if props.playButtonConfig then
			local createElement2 = React.createElement

			local v19 = if props.playButtonConfig.isVideoPlaying then icon.PauseLarge else icon.PlayLarge
			v15 = createElement2(iconButton, {
				icon = { name = v19, variant = iconVariant.Filled },
				iconSize = iconSize.Medium,
				onActivated = props.playButtonConfig.onPlayButtonActivated,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Selectable = false
			})
		end

		local v16 = if props.muteButtonConfig then v9 else nil
		v10.ButtonsContainer = createElement("Frame", v13, {
			PlayButton = v15,
			MuteButton = v16
		})
	end

	local useMemo = React.useMemo
	local function fn()
		local v11 = xxLarge + v8

		if props.muteButtonConfig or fFlagLuaAppEdpMediaGalleryFullScreen and props.playButtonConfig then
			v11 += size_1000
		end

		if fFlagLuaAppEdpMediaGalleryFullScreen and props.progressBarConfig then
			v11 += size_100 + xSmall
		end

		return v11
	end

	local muteButtonConfig = props.muteButtonConfig
	local playButtonConfig = if fFlagLuaAppEdpMediaGalleryFullScreen then props.playButtonConfig else nil
	local v12 = if fFlagLuaAppEdpMediaGalleryFullScreen then props.progressBarConfig else nil
	local v13 = useMemo(fn, {
		muteButtonConfig,
		playButtonConfig,
		v12,
		xxLarge,
		v8,
		size_1000,
		size_100,
		xSmall
	})

	local createElement = React.createElement
	local v15 = {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, v13),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = props.ZIndex
	}

	local createElement2 = React.createElement
	local v18 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v5.Color.Extended.Black.Black_100.Color3,
		BorderSizePixel = 0,
		ZIndex = 1
	}

	local v19 = {
		Gradient = React.createElement("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(1, 0.2)
			})
		}),
		UICorner = 0
	}

	local v20 = if props.cornerRadius then React.createElement("UICorner", {
		CornerRadius = UDim.new(0, props.cornerRadius)
	}) else nil
	v19.UICorner = v20
	local v16 = {
		GradientOverlay = createElement2("Frame", v18, v19),
		UserControls = 0
	}
	local v21

	if props.videoLoaded and v6 then
		local createElement3 = React.createElement

		local v24 = {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 10
		}

		if not fFlagLuaAppEdpMediaGalleryFullScreen then
			v10 = {
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, xxLarge),
					PaddingBottom = UDim.new(0, v8),
					PaddingLeft = UDim.new(0, medium),
					PaddingRight = UDim.new(0, medium)
				}),
				MuteButton = 0
			}

			if not props.muteButtonConfig then
				v9 = nil
			end

			v10.MuteButton = v9
		end

		v21 = maybeForceDarkTheme(createElement3("Frame", v24, v10), true)
	end

	v16.UserControls = v21
	return createElement("Frame", v15, v16)
end

return VideoPlayerBottomOverlay
