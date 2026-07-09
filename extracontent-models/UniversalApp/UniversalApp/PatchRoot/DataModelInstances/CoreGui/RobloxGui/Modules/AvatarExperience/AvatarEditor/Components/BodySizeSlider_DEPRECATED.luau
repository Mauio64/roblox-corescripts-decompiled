local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SetAvatarScales = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarScales)
local TwoAxisSlider = require(Modules.AvatarExperience.AvatarEditor.Components.TwoAxisSlider)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local vector2 = Vector2.new(224, 224)
local v15 = Images["component_assets/circle_17"]
local v16 = Roact.PureComponent:extend("BodySizeSlider")

function v16.init(p1) -- line: 30
	local forwardRef = p1.props.forwardRef

	function p1.mapPositionToScales(p2) -- line: 34
		-- upvalues: p1 (copy)
		local widthRules = p1.props.widthRules
		local v41 = widthRules.max - widthRules.min
		local v42 = math.clamp(p2.X * v41 + widthRules.min, widthRules.min, widthRules.max)
		local heightRules = p1.props.heightRules
		local v44 = heightRules.max - heightRules.min

		return v42, (math.clamp((1 - p2.Y) * v44 + heightRules.min, heightRules.min, heightRules.max))
	end
	function p1.mapScalesToPosition(p3, p4) -- line: 49
		-- upvalues: p1 (copy)
		local widthRules = p1.props.widthRules
		local v48 = widthRules.max - widthRules.min
		local v49 = (p3 - widthRules.min) / v48
		local heightRules = p1.props.heightRules
		local v51 = heightRules.max - heightRules.min
		local v52 = (p4 - heightRules.min) / v51

		return Vector2.new(v49, 1 - v52)
	end
	function p1.setScales(p5, p6) -- line: 61
		-- upvalues: p1 (copy)
		p1.props.setScales({
			width = p5,
			height = p6
		})
	end
	function p1.getBackgroundAbsolutePosition() -- line: 68
		-- upvalues: forwardRef (copy)
		local v55 = forwardRef:getValue()

		if v55 then
			return v55.AbsolutePosition
		end

		return nil
	end
	function p1.getBackgroundAbsoluteSize() -- line: 75
		-- upvalues: forwardRef (copy)
		local v56 = forwardRef:getValue()

		if v56 then
			return v56.AbsoluteSize
		end

		return nil
	end
end
function v16.render(p7) -- line: 84
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy), v15 (copy), vector2 (copy), TwoAxisSlider (copy)
	local width = p7.props.width
	local height = p7.props.height
	local widthRules = p7.props.widthRules
	local heightRules = p7.props.heightRules
	local propsLayoutOrder = p7.props.LayoutOrder
	local lockNavigationCallback = p7.props.lockNavigationCallback
	local unlockNavigationCallback = p7.props.unlockNavigationCallback
	local isDisabled = p7.props.isDisabled
	local forwardRef = p7.props.forwardRef

	return withStyle(function(p8) -- line: 95
		-- upvalues: Roact (copy), ImageSetLabel (copy), v15 (copy), vector2 (copy), isDisabled (copy), propsLayoutOrder (copy), forwardRef (copy), TwoAxisSlider (copy), p7 (copy), widthRules (copy), heightRules (copy), width (copy), height (copy), lockNavigationCallback (copy), unlockNavigationCallback (copy)
		local Theme = p8.Theme

		return Roact.createElement(ImageSetLabel, {
			Image = v15,
			Size = UDim2.new(0, vector2.X, 0, vector2.Y),
			BackgroundTransparency = 1,
			ImageColor3 = Theme.BackgroundUIDefault.Color,
			ImageTransparency = if not isDisabled then Theme.BackgroundUIDefault.Transparency else 0.5,
			LayoutOrder = propsLayoutOrder,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(9, 9, 9, 9),
			ZIndex = 2,
			[Roact.Ref] = forwardRef
		}, {
			TwoAxisSlider = Roact.createElement(TwoAxisSlider, {
				mapPositionToScales = p7.mapPositionToScales,
				mapScalesToPosition = p7.mapScalesToPosition,
				setScales = p7.setScales,
				xScaleRules = widthRules,
				yScaleRules = heightRules,
				xScale = width,
				yScale = height,
				getBackgroundAbsolutePosition = p7.getBackgroundAbsolutePosition,
				getBackgroundAbsoluteSize = p7.getBackgroundAbsoluteSize,
				isDisabled = isDisabled,
				onDragStart = lockNavigationCallback,
				onDragEnd = unlockNavigationCallback
			})
		})
	end)
end

local function mapStateToProps(p9, _) -- line: 132
	-- upvalues: Constants (copy)
	local AvatarScales = p9.AvatarExperience.AvatarEditor.Character.AvatarScales
	local v35 = p9.AvatarExperience.AvatarEditor.AvatarSettings[Constants.AvatarSettings.scalesRules]

	return {
		height = AvatarScales.height,
		width = AvatarScales.width,
		heightRules = v35.height,
		widthRules = v35.width,
		avatarType = p9.AvatarExperience.AvatarEditor.Character.AvatarType
	}
end
local function mapDispatchToProps(p11) -- line: 146
	-- upvalues: SetAvatarScales (copy)
	return {
		setScales = function(p12) -- line: 148
			-- upvalues: p11 (copy), SetAvatarScales (copy)
			p11(SetAvatarScales(p12))
		end
	}
end

local u19 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v16)

return Roact.forwardRef(function(p13, p14) -- line: 156
	-- upvalues: Roact (copy), u19 (ref), Cryo (copy)
	return Roact.createElement(u19, Cryo.Dictionary.join(p13, {
		forwardRef = p14
	}))
end)
