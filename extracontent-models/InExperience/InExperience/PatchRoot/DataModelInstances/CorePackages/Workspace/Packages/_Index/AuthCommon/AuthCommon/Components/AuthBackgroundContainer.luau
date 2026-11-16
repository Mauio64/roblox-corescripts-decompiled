local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AuthBackgroundConstants = require(AuthCommon.Common.AuthBackgroundConstants)

local Background2026 = AuthBackgroundConstants.Background2026

local function renderScrim(SCRIM_TRANSPARENCY: number)
	return React.createElement("ImageLabel", {
		ZIndex = 2,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = SCRIM_TRANSPARENCY,
		BorderSizePixel = 0,
		Image = ""
	})
end

local function renderImage(image: string)
	return React.createElement(Foundation.Image, {
		Image = image,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Crop
	})
end

local function renderGradientFrame(backgroundColor: Color3, p: number, zIndex: number, transparency)
	return React.createElement(
		"Frame",
		{
			ZIndex = zIndex,
			Size = UDim2.fromScale(1, p),
			BackgroundColor3 = backgroundColor,
			BorderSizePixel = 0
		},
		{
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = transparency
			})
		}
	)
end

local function renderMobileFade(image: string, mobileFadeColor: Color3)
	return {
		Media = React.createElement(Foundation.Image, {
			Image = image,
			Size = UDim2.fromScale(1, 0.8870657276995305),
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Crop,
			imageStyle = { Color3 = Color3.new(1, 1, 1), Transparency = 0.2 },
			backgroundStyle = { Color3 = Color3.new(0, 0, 0), Transparency = 0 }
		}),
		BottomShadow = renderGradientFrame(
			mobileFadeColor,
			397 / 426,
			2,
			NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.2418, 1),
				NumberSequenceKeypoint.new(0.8588, 0),
				NumberSequenceKeypoint.new(1, 0)
			})
		),
		NavCover = renderGradientFrame(
			Color3.new(0, 0, 0),
			271 / 852,
			3,
			NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.3),
				NumberSequenceKeypoint.new(0.2447, 0.3),
				NumberSequenceKeypoint.new(1, 0.817)
			})
		)
	}
end

local function AuthBackgroundContainer(props)
	local v = Background2026.SCRIM_TRANSPARENCY < 1
	local v2 = props.showImage == nil or props.showImage
	local mobileFadeColor

	if v2 then
		mobileFadeColor = props.mobileFadeColor
	end

	local createElement = React.createElement

	local v3 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = v2 and not mobileFadeColor and 1 or 0,
		BackgroundColor3 = mobileFadeColor or props.fallbackBackgroundColor
	}
	local v4

	if mobileFadeColor then
		v4 = renderMobileFade(Background2026.IMAGE, mobileFadeColor)
	else
		v4 = { Background = 0, Scrim = 0 }
		local background

		if v2 then
			background = renderImage(Background2026.IMAGE)
		end

		v4.Background = background
		local scrim

		if v2 and v then
			scrim = renderScrim(Background2026.SCRIM_TRANSPARENCY)
		end

		v4.Scrim = scrim
	end

	return createElement("Frame", v3, v4)
end

return AuthBackgroundContainer
