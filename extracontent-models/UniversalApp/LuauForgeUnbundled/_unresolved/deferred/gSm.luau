local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)

local module = require("@luauforge/bundled/dNQ")
local module2 = require("@luauforge/bundled/dNS")
local module3 = require("@luauforge/deferred/gSl")
require("@luauforge/bundled/dHK")

local withStyle = UIBlox.Style.withStyle

local vector2 = Vector2.new(224, 195)

local extended = Roact.PureComponent:extend("BodyTypeSlider")

function extended:init()
	local forwardRef = self.props.forwardRef

	function self.mapPositionToScales(p3)
		local bodyTypeScaleRules = self.props.bodyTypeScaleRules
		local v5 = bodyTypeScaleRules.max - bodyTypeScaleRules.min
		local v6 = math.clamp(
			(1 - p3.Y) * v5 + bodyTypeScaleRules.min,
			bodyTypeScaleRules.min,
			bodyTypeScaleRules.max
		)

		local proportionScaleRules = self.props.proportionScaleRules
		local v7 = proportionScaleRules.max - proportionScaleRules.min

		return
			math.clamp(
				(1 - (v6 == 0 and 0.5 or (p3.X - 0.5 * p3.Y) / v6)) * v7 + proportionScaleRules.min,
				proportionScaleRules.min,
				proportionScaleRules.max
			),
			v6
	end

	function self.mapScalesToPosition(p3, p4)
		local bodyTypeScaleRules = self.props.bodyTypeScaleRules
		local v5 = bodyTypeScaleRules.max - bodyTypeScaleRules.min
		local v6 = (p4 - bodyTypeScaleRules.min) / v5

		local proportionScaleRules = self.props.proportionScaleRules
		local v7 = proportionScaleRules.max - proportionScaleRules.min
		local v8 = (p3 - proportionScaleRules.min) / v7

		return Vector2.new((1 - v8) * v6 + 0.5 * (1 - v6), 1 - v6)
	end

	function self.setScales(p3, p4)
		self.props.setScales({ proportion = p3, bodyType = p4 })
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
	local proportion = data.props.proportion
	local bodyType = data.props.bodyType
	local proportionScaleRules = data.props.proportionScaleRules
	local bodyTypeScaleRules = data.props.bodyTypeScaleRules
	local layoutOrder = data.props.LayoutOrder
	local lockNavigationCallback = data.props.lockNavigationCallback
	local unlockNavigationCallback = data.props.unlockNavigationCallback

	local forwardRef = data.props.forwardRef

	return withStyle(function(p2)
		local theme = p2.Theme

		local v5 = vector2.X / vector2.Y
		local v6 = vector2.X / v5

		local isDisabled = data.props.isDisabled

		return Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			Image = "rbxasset://textures/AvatarEditorImages/Sliders/body-type-slider-background.png",
			LayoutOrder = layoutOrder,
			Size = UDim2.new(0, vector2.X, 0, v6),
			BackgroundTransparency = 1,
			ImageColor3 = theme.BackgroundUIDefault.Color,
			ImageTransparency = isDisabled and 0.5 or theme.BackgroundUIDefault.Transparency,
			[Roact.Ref] = forwardRef
		}, {
			TwoAxisSlider = Roact.createElement(module3, {
				mapPositionToScales = data.mapPositionToScales,
				mapScalesToPosition = data.mapScalesToPosition,
				setScales = data.setScales,
				xScaleRules = proportionScaleRules,
				yScaleRules = bodyTypeScaleRules,
				xScale = proportion,
				yScale = bodyType,
				getBackgroundAbsolutePosition = data.getBackgroundAbsolutePosition,
				getBackgroundAbsoluteSize = data.getBackgroundAbsoluteSize,
				invertDPadX = true,
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
		avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType,
		bodyType = avatarScales.bodyType,
		proportion = avatarScales.proportion,
		bodyTypeScaleRules = avatarSetting.bodyType,
		proportionScaleRules = avatarSetting.proportion
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
