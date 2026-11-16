local AssetService = game:GetService("AssetService")

local parent = script:FindFirstAncestor("QRCodeDisplay").Parent

local React = require(parent.React)
local Dash = require(parent.Dash)

local drawImage = require(script.Parent.drawImage)

local v = {
	backgroundColor3 = Color3.fromRGB(255, 255, 255),
	backgroundTransparency = 0,
	pixelColor3 = Color3.fromRGB(0, 0, 0),
	pixelTransparency = 0,
	sideLength = 200
}

local function getQrCodeImageSize(sideLength: number, qrCodeRotation: number?) -- 1 equivalent call inferred from this helper
	if not qrCodeRotation then
		return sideLength
	end

	assert(type(qrCodeRotation) == "number", "rotation must be a number")

	if qrCodeRotation % 90 == 0 then
		return sideLength
	end

	local v2 = math.rad(qrCodeRotation)
	return (math.round(sideLength / (math.sin(v2) + math.cos(v2))))
end

return function(p)
	local joined = Dash.join(v, p)

	local state, setState = React.useState(nil)
	local ref = React.createRef()
	local qrCodeImageSize = getQrCodeImageSize(joined.sideLength, joined.qrCodeRotation) -- inferred equivalent call

	React.useEffect(function()
		if not ref.current or ref.current.Size.X ~= qrCodeImageSize then
			ref.current = AssetService:CreateEditableImage({
				Size = Vector2.new(qrCodeImageSize, qrCodeImageSize)
			})

			setState(Content.fromObject(ref.current))
		end

		drawImage(ref.current, qrCodeImageSize, joined.qrCodeMatrix, joined.pixelColor3, joined.pixelTransparency)
	end, { qrCodeImageSize, joined.qrCodeMatrix, joined.pixelColor3, joined.pixelTransparency })

	return React.createElement(
		"Frame",
		{
			BackgroundColor3 = joined.backgroundColor3,
			BackgroundTransparency = joined.backgroundTransparency,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(joined.sideLength, joined.sideLength)
		},
		{
			ImageLabel = React.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ImageContent = state,
				Position = UDim2.fromScale(0.5, 0.5),
				Rotation = joined.qrCodeRotation,
				Size = UDim2.fromOffset(qrCodeImageSize, qrCodeImageSize)
			})
		}
	)
end
