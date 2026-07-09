local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SetAvatarScales = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarScales)
local TwoAxisSlider = require(Modules.AvatarExperience.AvatarEditor.Components.TwoAxisSlider)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local withStyle = UIBlox.Style.withStyle
local vector2 = Vector2.new(224, 195)
local v13 = Roact.PureComponent:extend("BodyTypeSlider")

function v13.init(p1) -- line: 30
	local forwardRef = p1.props.forwardRef

	function p1.mapPositionToScales(p2) -- line: 34
		-- upvalues: p1 (copy)
		local bodyTypeScaleRules = p1.props.bodyTypeScaleRules
		local v37 = bodyTypeScaleRules.max - bodyTypeScaleRules.min
		local v38 = math.clamp((1 - p2.Y) * v37 + bodyTypeScaleRules.min, bodyTypeScaleRules.min, bodyTypeScaleRules.max)
		local proportionScaleRules = p1.props.proportionScaleRules
		local v40 = proportionScaleRules.max - proportionScaleRules.min

		return math.clamp((1 - (if v38 ~= 0 then (p2.X - 0.5 * p2.Y) / v38 else 0.5)) * v40 + proportionScaleRules.min, proportionScaleRules.min, proportionScaleRules.max), v38
	end
	function p1.mapScalesToPosition(p3, p4) -- line: 59
		-- upvalues: p1 (copy)
		local bodyTypeScaleRules = p1.props.bodyTypeScaleRules
		local v44 = bodyTypeScaleRules.max - bodyTypeScaleRules.min
		local v45 = (p4 - bodyTypeScaleRules.min) / v44
		local proportionScaleRules = p1.props.proportionScaleRules
		local v47 = proportionScaleRules.max - proportionScaleRules.min
		local v48 = (p3 - proportionScaleRules.min) / v47

		return Vector2.new((1 - v48) * v45 + 0.5 * (1 - v45), 1 - v45)
	end
	function p1.setScales(p5, p6) -- line: 74
		-- upvalues: p1 (copy)
		p1.props.setScales({
			proportion = p5,
			bodyType = p6
		})
	end
	function p1.getBackgroundAbsolutePosition() -- line: 81
		-- upvalues: forwardRef (copy)
		local v51 = forwardRef:getValue()

		if v51 then
			return v51.AbsolutePosition
		end

		return nil
	end
	function p1.getBackgroundAbsoluteSize() -- line: 88
		-- upvalues: forwardRef (copy)
		local v52 = forwardRef:getValue()

		if v52 then
			return v52.AbsoluteSize
		end

		return nil
	end
end
function v13.render(p7) -- line: 97
	-- upvalues: withStyle (copy), vector2 (copy), Roact (copy), TwoAxisSlider (copy)
	local proportion = p7.props.proportion
	local bodyType = p7.props.bodyType
	local proportionScaleRules = p7.props.proportionScaleRules
	local bodyTypeScaleRules = p7.props.bodyTypeScaleRules
	local propsLayoutOrder = p7.props.LayoutOrder
	local lockNavigationCallback = p7.props.lockNavigationCallback
	local unlockNavigationCallback = p7.props.unlockNavigationCallback
	local forwardRef = p7.props.forwardRef

	return withStyle(function(p8) -- line: 108
		-- upvalues: vector2 (copy), p7 (copy), Roact (copy), propsLayoutOrder (copy), forwardRef (copy), TwoAxisSlider (copy), proportionScaleRules (copy), bodyTypeScaleRules (copy), proportion (copy), bodyType (copy), lockNavigationCallback (copy), unlockNavigationCallback (copy)
		local Theme = p8.Theme
		local v55 = vector2.X / vector2.Y
		local v56 = vector2.X / v55
		local isDisabled = p7.props.isDisabled

		return Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			Image = "rbxasset://textures/AvatarEditorImages/Sliders/body-type-slider-background.png",
			LayoutOrder = propsLayoutOrder,
			Size = UDim2.new(0, vector2.X, 0, v56),
			BackgroundTransparency = 1,
			ImageColor3 = Theme.BackgroundUIDefault.Color,
			ImageTransparency = if not isDisabled then Theme.BackgroundUIDefault.Transparency else 0.5,
			[Roact.Ref] = forwardRef
		}, {
			TwoAxisSlider = Roact.createElement(TwoAxisSlider, {
				invertDPadX = true,
				mapPositionToScales = p7.mapPositionToScales,
				mapScalesToPosition = p7.mapScalesToPosition,
				setScales = p7.setScales,
				xScaleRules = proportionScaleRules,
				yScaleRules = bodyTypeScaleRules,
				xScale = proportion,
				yScale = bodyType,
				getBackgroundAbsolutePosition = p7.getBackgroundAbsolutePosition,
				getBackgroundAbsoluteSize = p7.getBackgroundAbsoluteSize,
				isDisabled = isDisabled,
				onDragStart = lockNavigationCallback,
				onDragEnd = unlockNavigationCallback
			})
		})
	end)
end

local function mapStateToProps(p9, _) -- line: 151
	-- upvalues: Constants (copy)
	local AvatarScales = p9.AvatarExperience.AvatarEditor.Character.AvatarScales
	local v31 = p9.AvatarExperience.AvatarEditor.AvatarSettings[Constants.AvatarSettings.scalesRules]

	return {
		avatarType = p9.AvatarExperience.AvatarEditor.Character.AvatarType,
		bodyType = AvatarScales.bodyType,
		proportion = AvatarScales.proportion,
		bodyTypeScaleRules = v31.bodyType,
		proportionScaleRules = v31.proportion
	}
end
local function mapDispatchToProps(p11) -- line: 165
	-- upvalues: SetAvatarScales (copy)
	return {
		setScales = function(p12) -- line: 167
			-- upvalues: p11 (copy), SetAvatarScales (copy)
			p11(SetAvatarScales(p12))
		end
	}
end

local u16 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v13)

return Roact.forwardRef(function(p13, p14) -- line: 175
	-- upvalues: Roact (copy), u16 (ref), Cryo (copy)
	return Roact.createElement(u16, Cryo.Dictionary.join(p13, {
		forwardRef = p14
	}))
end)
