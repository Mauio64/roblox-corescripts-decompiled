local AssetService = game:GetService("AssetService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/QRCodeDisplay/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/QRCodeDisplay/Dash")

local drawImage = require("@game/CorePackages/Workspace/Packages/_Index/QRCodeDisplay/QRCodeDisplay/DisplayQRCodeFromMatrix/drawImage")

local v5 = {
	backgroundColor3 = Color3.fromRGB(255, 255, 255),
	backgroundTransparency = 0,
	pixelColor3 = Color3.fromRGB(0, 0, 0),
	pixelTransparency = 0,
	sideLength = 200
}

local function getQrCodeImageSize(p2, value)
	if not value then
		return p2
	end

	assert(type(value) == "number", "rotation must be a number")

	if value % 90 == 0 then
		return p2
	end

	local v6 = math.rad(value)
	return (math.round(p2 / (math.sin(v6) + math.cos(v6))))
end

return function(p2)
	local joined = Dash.join(v5, p2)

	local state, setState = React.useState(nil)
	local ref = React.createRef()
	local v6 = joined.sideLength
	local qrCodeRotation = joined.qrCodeRotation

	if qrCodeRotation then
		assert(type(qrCodeRotation) == "number", "rotation must be a number")

		if qrCodeRotation % 90 ~= 0 then
			local v7 = math.rad(qrCodeRotation)
			v6 = math.round(v6 / (math.sin(v7) + math.cos(v7)))
		end
	end

	React.useEffect(function()
		if not ref.current or ref.current.Size.X ~= v6 then
			ref.current = AssetService:CreateEditableImage({
				Size = Vector2.new(v6, v6)
			})

			setState(Content.fromObject(ref.current))
		end

		drawImage(ref.current, v6, joined.qrCodeMatrix, joined.pixelColor3, joined.pixelTransparency)
	end, { v6, joined.qrCodeMatrix, joined.pixelColor3, joined.pixelTransparency })

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
				Size = UDim2.fromOffset(v6, v6)
			})
		}
	)
end
