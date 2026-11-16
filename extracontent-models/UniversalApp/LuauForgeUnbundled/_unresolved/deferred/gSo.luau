local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local UIBlox = require(CorePackages.Packages.UIBlox)

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useTokens = Foundation.Hooks.useTokens
local tutils = require(CorePackages.Packages.tutils)
local module = require("@luauforge/deferred/gOI")

local module2 = require("@luauforge/bundled/dNQ")
local module3 = require("@luauforge/bundled/dNS")
local module4 = require("@luauforge/deferred/gSl")
require("@luauforge/bundled/dHK")

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images

local vector2 = Vector2.new(224, 224)

local component_assetscircle_17 = images["component_assets/circle_17"]

local function mapPositionToScales(p2, widthRules, heightRules)
	local v5 = widthRules.max - widthRules.min
	local v6 = math.clamp(p2.X * v5 + widthRules.min, widthRules.min, widthRules.max)

	local v7 = heightRules.max - heightRules.min
	return v6, (math.clamp((1 - p2.Y) * v7 + heightRules.min, heightRules.min, heightRules.max))
end

local function mapScalesToPosition(p2, p3, widthRules, heightRules)
	local v5 = widthRules.max - widthRules.min
	local v6 = (p2 - widthRules.min) / v5

	local v7 = heightRules.max - heightRules.min
	local v8 = (p3 - heightRules.min) / v7

	return Vector2.new(v6, 1 - v8)
end

local function selectScalesState(p2)
	local avatarScales = p2.AvatarExperience.AvatarEditor.Character.AvatarScales
	local avatarSetting = p2.AvatarExperience.AvatarEditor.AvatarSettings[module2.AvatarSettings.scalesRules]

	return {
		width = avatarScales.width,
		height = avatarScales.height,
		widthRules = avatarSetting.width,
		heightRules = avatarSetting.height
	}
end

local function BodySizeSlider(props, p2)
	local v5 = useTokens()
	local v6 = useDispatch()
	local v7 = module()
	local v8 = useSelector(selectScalesState, tutils.deepEqual)

	local width = v8.width
	local height = v8.height
	local widthRules = v8.widthRules
	local heightRules = v8.heightRules

	local state, setState = React.useState({ width = width, height = height })

	local v9 = React.useCallback(function(p3)
		return mapPositionToScales(p3, widthRules, heightRules)
	end, { widthRules, heightRules })

	local v10 = React.useCallback(function(p3, p4)
		return mapScalesToPosition(p3, p4, widthRules, heightRules)
	end, { widthRules, heightRules })

	local v11 = React.useCallback(function(p3, p4)
		v7.setAvatarScales({ width = p3, height = p4 })

		setState({ width = p3, height = p4 })
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

		v6(module3({ width = state.width, height = state.height }))
	end, { props.unlockNavigationCallback, state, v7, v6 })

	return React.createElement(imageSetLabel, {
		Image = component_assetscircle_17,
		Size = UDim2.new(0, vector2.X, 0, vector2.Y),
		BackgroundTransparency = 1,
		ImageColor3 = v5.Color.Surface.Surface_300.Color3,
		ImageTransparency = props.isDisabled and 0.5 or v5.Color.Surface.Surface_300.Transparency,
		LayoutOrder = props.LayoutOrder,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(9, 9, 9, 9),
		ZIndex = 2,
		ref = p2
	}, {
		TwoAxisSlider = React.createElement(module4, {
			mapPositionToScales = v9,
			mapScalesToPosition = v10,
			setScales = v11,
			xScaleRules = widthRules,
			yScaleRules = heightRules,
			xScale = state.width,
			yScale = state.height,
			getBackgroundAbsolutePosition = v12,
			getBackgroundAbsoluteSize = v13,
			isDisabled = props.isDisabled,
			onDragStart = v14,
			onDragEnd = v15
		})
	})
end

return React.memo(React.forwardRef(BodySizeSlider))
