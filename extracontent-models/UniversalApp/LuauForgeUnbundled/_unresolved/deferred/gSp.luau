local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dNQ")
local module2 = require("@luauforge/bundled/dNS")
local module3 = require("@luauforge/deferred/gSl")
require("@luauforge/bundled/dHK")

local withStyle = UIBlox.Style.withStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images

local vector2 = Vector2.new(224, 224)

local component_assetscircle_17 = images["component_assets/circle_17"]

local extended = Roact.PureComponent:extend("BodySizeSlider")

function extended:init()
	local forwardRef = self.props.forwardRef

	function self.mapPositionToScales(p3)
		local widthRules = self.props.widthRules
		local v5 = widthRules.max - widthRules.min
		local v6 = math.clamp(p3.X * v5 + widthRules.min, widthRules.min, widthRules.max)

		local heightRules = self.props.heightRules
		local v7 = heightRules.max - heightRules.min
		return v6, (math.clamp((1 - p3.Y) * v7 + heightRules.min, heightRules.min, heightRules.max))
	end

	function self.mapScalesToPosition(p3, p4)
		local widthRules = self.props.widthRules
		local v5 = widthRules.max - widthRules.min
		local v6 = (p3 - widthRules.min) / v5

		local heightRules = self.props.heightRules
		local v7 = heightRules.max - heightRules.min
		local v8 = (p4 - heightRules.min) / v7

		return Vector2.new(v6, 1 - v8)
	end

	function self.setScales(p3, p4)
		self.props.setScales({ width = p3, height = p4 })
	end

	function self.getBackgroundAbsolutePosition()
		local value = forwardRef:getValue()

		if value then
			return value.AbsolutePosition
		end

		return nil
	end

	function self.getBackgroundAbsoluteSize()
		local value = forwardRef:getValue()

		if value then
			return value.AbsoluteSize
		end

		return nil
	end
end

function extended.render(data)
	local width = data.props.width
	local height = data.props.height
	local widthRules = data.props.widthRules
	local heightRules = data.props.heightRules
	local layoutOrder = data.props.LayoutOrder
	local lockNavigationCallback = data.props.lockNavigationCallback
	local unlockNavigationCallback = data.props.unlockNavigationCallback
	local isDisabled = data.props.isDisabled
	local forwardRef = data.props.forwardRef

	return withStyle(function(p2)
		local theme = p2.Theme

		return Roact.createElement(imageSetLabel, {
			Image = component_assetscircle_17,
			Size = UDim2.new(0, vector2.X, 0, vector2.Y),
			BackgroundTransparency = 1,
			ImageColor3 = theme.BackgroundUIDefault.Color,
			ImageTransparency = isDisabled and 0.5 or theme.BackgroundUIDefault.Transparency,
			LayoutOrder = layoutOrder,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(9, 9, 9, 9),
			ZIndex = 2,
			[Roact.Ref] = forwardRef
		}, {
			TwoAxisSlider = Roact.createElement(module3, {
				mapPositionToScales = data.mapPositionToScales,
				mapScalesToPosition = data.mapScalesToPosition,
				setScales = data.setScales,
				xScaleRules = widthRules,
				yScaleRules = heightRules,
				xScale = width,
				yScale = height,
				getBackgroundAbsolutePosition = data.getBackgroundAbsolutePosition,
				getBackgroundAbsoluteSize = data.getBackgroundAbsoluteSize,
				isDisabled = isDisabled,
				onDragStart = lockNavigationCallback,
				onDragEnd = unlockNavigationCallback
			})
		})
	end)
end

local function mapStateToProps(p2, p3)
	local avatarScales = p2.AvatarExperience.AvatarEditor.Character.AvatarScales

	local avatarSetting = p2.AvatarExperience.AvatarEditor.AvatarSettings[module.AvatarSettings.scalesRules]

	return {
		height = avatarScales.height,
		width = avatarScales.width,
		heightRules = avatarSetting.height,
		widthRules = avatarSetting.width,
		avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType
	}
end

local function mapDispatchToProps(callback)
	return {
		setScales = function(p2)
			callback(module2(p2))
		end
	}
end

local v5 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v5, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
