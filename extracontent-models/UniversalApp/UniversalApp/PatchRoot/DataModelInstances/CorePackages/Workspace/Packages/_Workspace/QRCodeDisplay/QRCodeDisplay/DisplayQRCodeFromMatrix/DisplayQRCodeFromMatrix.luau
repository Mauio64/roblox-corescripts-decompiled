local AssetService = game:GetService("AssetService")
local Parent = script:FindFirstAncestor("QRCodeDisplay").Parent
local React = require(Parent.React)
local Dash = require(Parent.Dash)
local drawImage = require(script.Parent.drawImage)
local t1 = {
	backgroundTransparency = 0,
	pixelTransparency = 0,
	sideLength = 200,
	backgroundColor3 = Color3.fromRGB(255, 255, 255),
	pixelColor3 = Color3.fromRGB(0, 0, 0)
}

local function getQrCodeImageSize(n1: number, n2: number?) -- line: 36
	if not n2 then
		return n1
	end

	assert(type(n2) == "number", "rotation must be a number")

	if n2 % 90 == 0 then
		return n1
	end

	local v10 = math.rad(n2)

	return (math.round(n1 / (math.sin(v10) + math.cos(v10))))
end

return function(t2: {[any]: any}) -- line: 51
	-- upvalues: Dash (copy), t1 (copy), React (copy), AssetService (copy), drawImage (copy)
	local v12 = Dash.join(t1, t2)
	local v13, v14 = React.useState(nil)
	local v15 = React.createRef()
	local sideLength = v12.sideLength
	local qrCodeRotation = v12.qrCodeRotation

	if not qrCodeRotation then
	else
		assert(type(qrCodeRotation) == "number", "rotation must be a number")

		if qrCodeRotation % 90 == 0 then
		else
			local v18 = math.rad(qrCodeRotation)

			sideLength = math.round(sideLength / (math.sin(v18) + math.cos(v18)))
		end
	end

	local v19 = sideLength

	React.useEffect(function() -- line: 58
		-- upvalues: v15 (copy), v19 (copy), AssetService (copy), v14 (copy), drawImage (copy), v12 (copy)
		if not v15.current or v15.current.Size.X ~= v19 then
			v15.current = AssetService:CreateEditableImage({
				Size = Vector2.new(v19, v19)
			})
			v14(Content.fromObject(v15.current))
		end

		drawImage(v15.current, v19, v12.qrCodeMatrix, v12.pixelColor3, v12.pixelTransparency)
	end, {
		v19,
		v12.qrCodeMatrix,
		v12.pixelColor3,
		v12.pixelTransparency
	})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = v12.backgroundColor3,
		BackgroundTransparency = v12.backgroundTransparency,
		Size = UDim2.fromOffset(v12.sideLength, v12.sideLength)
	}, {
		ImageLabel = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageContent = v13,
			Position = UDim2.fromScale(0.5, 0.5),
			Rotation = v12.qrCodeRotation,
			Size = UDim2.fromOffset(v19, v19)
		})
	})
end
