local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local module = require("@luauforge/bundled/ciE")

local module2 = require("@luauforge/deferred/gSS")

require("@luauforge/bundled/dPs")

local loadableImage = UIBlox.App.Loading.LoadableImage
local useStyle = UIBlox.Core.Style.useStyle

local module3 = require("@luauforge/deferred/gSX")

local getRbxthumbWithTypeSizeAndOptions = module.Utils.getRbxthumbWithTypeSizeAndOptions

local module4 = require("@luauforge/deferred/gSP")

local defineFastFlag = game:DefineFastFlag("AXLookDetailsThumbnailStretched", false)

local function LookImageFrame(props)
	local v5 = useStyle()
	local theme = v5.Theme

	local size_600 = v5.Tokens.Size.Size_600

	local v6 = if not module4() then props.width * 9 / 16 else nil

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(props.lookId, "Look", 420)

	local displayProperties = props.lookDetails and props.lookDetails.displayProperties
	local moderationStatus = if props.lookDetails then props.lookDetails.moderationStatus else nil
	local color

	if
		displayProperties
		and displayProperties.backgroundType == "Hex"
		and displayProperties.backgroundValue
	then
		color = Color3.fromHex(displayProperties.backgroundValue)
	else
		color = theme.PlaceHolder.Color
	end

	local createElement = React.createElement

	local v9 = if module4() then UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, 0, v6)
	local v10 = if module4() then Enum.SizeConstraint.RelativeXY else nil

	local v11 = if module4() then React.createElement("UIAspectRatioConstraint", {
		AspectRatio = 1.5
	}) else nil
	local children = {
		AspectRatio = v11,
		ItemBackground = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.new(1, module4() and 0 or size_600 * 2, 1, 0),
			ZIndex = 0,
			BackgroundColor3 = color,
			BackgroundTransparency = theme.PlaceHolder.Transparency,
			BorderSizePixel = 0
		}),
		LookViewport = props.renderViewport and React.createElement(module2, {
			lookDetails = props.lookDetails
		}),
		Image = 0,
		ImageFrame = 0,
		ModerationStatus = 0
	}
	local v12

	if not (module4() or props.renderViewport) then
		local createElement2 = Roact.createElement
		local v14 = {
			BackgroundTransparency = 1,
			Image = rbxthumbWithTypeSizeAndOptions,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromOffset(v6, v6),
			useShimmerAnimationWhileLoading = true,
			ScaleType = 0
		}

		local v15 = if defineFastFlag then Enum.ScaleType.Fit else nil
		v14.ScaleType = v15
		v12 = createElement2(loadableImage, v14)
	end

	children.Image = v12
	local v13

	if module4() and not props.renderViewport then
		local createElement2 = React.createElement
		local v15 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0)
		}
		local v16 = {
			AspectRatio = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1
			}),
			Image = 0
		}

		local createElement3 = Roact.createElement
		local v18 = {
			BackgroundTransparency = 1,
			Image = rbxthumbWithTypeSizeAndOptions,
			Size = UDim2.new(1, 0, 1, 0),
			useShimmerAnimationWhileLoading = true,
			ScaleType = 0
		}

		local v19 = if defineFastFlag then Enum.ScaleType.Fit else nil
		v18.ScaleType = v19
		v16.Image = createElement3(loadableImage, v18)
		v13 = createElement2("Frame", v15, v16)
	end

	children.ImageFrame = v13

	children.ModerationStatus = Roact.createElement(module3, {
		moderationStatus = moderationStatus
	})
	return createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v9,
		SizeConstraint = v10,
		LayoutOrder = 1,
		ZIndex = 0
	}, children)
end

return LookImageFrame
