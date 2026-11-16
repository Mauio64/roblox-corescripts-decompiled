local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local tutils = require(CorePackages.Packages.tutils)

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useTokens = Foundation.Hooks.useTokens
local module = require("@luauforge/deferred/gOI")

local module2 = require("@luauforge/bundled/dNQ")
local module3 = require("@luauforge/bundled/dNS")
local module4 = require("@luauforge/deferred/gSl")
require("@luauforge/bundled/dHK")

local vector2 = Vector2.new(224, 195)

local function mapPositionToScales(p2, bodyTypeScaleRules, proportionScaleRules)
	local v5 = bodyTypeScaleRules.max - bodyTypeScaleRules.min
	local v6 = math.clamp(
		(1 - p2.Y) * v5 + bodyTypeScaleRules.min,
		bodyTypeScaleRules.min,
		bodyTypeScaleRules.max
	)

	local v7 = proportionScaleRules.max - proportionScaleRules.min

	return
		math.clamp(
			(1 - (v6 == 0 and 0.5 or (p2.X - 0.5 * p2.Y) / v6)) * v7 + proportionScaleRules.min,
			proportionScaleRules.min,
			proportionScaleRules.max
		),
		v6
end

local function mapScalesToPosition(p2, p3, bodyTypeScaleRules, proportionScaleRules)
	local v5 = bodyTypeScaleRules.max - bodyTypeScaleRules.min
	local v6 = (p3 - bodyTypeScaleRules.min) / v5

	local v7 = proportionScaleRules.max - proportionScaleRules.min
	local v8 = (p2 - proportionScaleRules.min) / v7

	return Vector2.new((1 - v8) * v6 + 0.5 * (1 - v6), 1 - v6)
end

local function selectScalesState(p2)
	local avatarScales = p2.AvatarExperience.AvatarEditor.Character.AvatarScales
	local avatarSetting = p2.AvatarExperience.AvatarEditor.AvatarSettings[module2.AvatarSettings.scalesRules]

	return {
		bodyType = avatarScales.bodyType,
		proportion = avatarScales.proportion,
		bodyTypeScaleRules = avatarSetting.bodyType,
		proportionScaleRules = avatarSetting.proportion
	}
end

local function BodyTypeSlider(props, p2)
	local v5 = useTokens()
	local v6 = useSelector(selectScalesState, tutils.deepEqual)
	local v7 = module()

	local v8 = useDispatch()

	local proportion = v6.proportion
	local bodyType = v6.bodyType
	local bodyTypeScaleRules = v6.bodyTypeScaleRules
	local proportionScaleRules = v6.proportionScaleRules

	local state, setState = React.useState({
		proportion = proportion,
		bodyType = bodyType
	})

	local v9 = React.useCallback(function(p3)
		return mapPositionToScales(p3, bodyTypeScaleRules, proportionScaleRules)
	end, { bodyTypeScaleRules, proportionScaleRules })

	local v10 = React.useCallback(function(p3, p4)
		return mapScalesToPosition(p3, p4, bodyTypeScaleRules, proportionScaleRules)
	end, { bodyTypeScaleRules, proportionScaleRules })

	local v11 = React.useCallback(function(p3, p4)
		v7.setAvatarScales({ proportion = p3, bodyType = p4 })
		setState({ proportion = p3, bodyType = p4 })
	end, { v7 })

	local v12 = React.useCallback(function()
		if p2 and p2.current then
			return p2.current.AbsolutePosition
		end

		return nil
	end, {})

	local v13 = React.useCallback(function()
		if p2 and p2.current then
			return p2.current.AbsoluteSize
		end

		return nil
	end, {})

	local v14 = React.useCallback(function()
		if props.lockNavigationCallback then
			props.lockNavigationCallback()
		end
	end, { props.lockNavigationCallback })

	local v15 = React.useCallback(function()
		if props.unlockNavigationCallback then
			props.unlockNavigationCallback()
		end

		v7.setAvatarScales(nil)

		v8(module3({ proportion = state.proportion, bodyType = state.bodyType }))
	end, { props.unlockNavigationCallback, state, v7, v8 })

	local v16 = vector2.X / vector2.Y
	local v17 = vector2.X / v16

	return React.createElement("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		Image = "rbxasset://textures/AvatarEditorImages/Sliders/body-type-slider-background.png",
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(0, vector2.X, 0, v17),
		BackgroundTransparency = 1,
		ImageColor3 = v5.Color.Surface.Surface_300.Color3,
		ImageTransparency = props.isDisabled and 0.5 or v5.Color.Surface.Surface_300.Transparency,
		ref = p2
	}, {
		TwoAxisSlider = React.createElement(module4, {
			mapPositionToScales = v9,
			mapScalesToPosition = v10,
			setScales = v11,
			xScaleRules = proportionScaleRules,
			yScaleRules = bodyTypeScaleRules,
			xScale = state.proportion,
			yScale = state.bodyType,
			getBackgroundAbsolutePosition = v12,
			getBackgroundAbsoluteSize = v13,
			invertDPadX = true,
			isDisabled = props.isDisabled,
			onDragStart = v14,
			onDragEnd = v15
		})
	})
end

return React.memo(React.forwardRef(BodyTypeSlider))
