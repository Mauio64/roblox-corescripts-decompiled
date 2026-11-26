local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")
local background2026 = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Common/AuthBackgroundConstants").Background2026

local function renderScrim(SCRIM_TRANSPARENCY)
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

local function renderImage(image)
	return React.createElement(Foundation.Image, {
		Image = image,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Crop
	})
end

local function renderGradientFrame(p2, p3, p4, numberSequence)
	return React.createElement(
		"Frame",
		{
			ZIndex = p4,
			Size = UDim2.fromScale(1, p3),
			BackgroundColor3 = p2,
			BorderSizePixel = 0
		},
		{
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = numberSequence
			})
		}
	)
end

local function renderMobileFade(image, mobileFadeColor)
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
	local v5 = background2026.SCRIM_TRANSPARENCY < 1
	local v6 = props.showImage == nil or props.showImage
	local mobileFadeColor = if v6 then props.mobileFadeColor else nil

	local createElement = React.createElement

	local v8 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = v6 and not mobileFadeColor and 1 or 0,
		BackgroundColor3 = mobileFadeColor or props.fallbackBackgroundColor
	}
	local v9

	if mobileFadeColor then
		v9 = renderMobileFade(background2026.IMAGE, mobileFadeColor)
	else
		v9 = { Background = 0, Scrim = 0 }
		local v10 = if v6 then renderImage(background2026.IMAGE) else nil
		v9.Background = v10
		local v11 = if v6 and v5 then renderScrim(background2026.SCRIM_TRANSPARENCY) else nil
		v9.Scrim = v11
	end

	return createElement("Frame", v8, v9)
end

return AuthBackgroundContainer
