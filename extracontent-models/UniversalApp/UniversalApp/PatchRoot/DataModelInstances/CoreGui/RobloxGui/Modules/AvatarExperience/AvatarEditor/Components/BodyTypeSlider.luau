local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local tutils = require(CorePackages.Packages.tutils)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useTokens = Foundation.Hooks.useTokens
local useBodyDataCallbacksContext = require(Modules.AvatarExperience.Common.Context.useBodyDataCallbacksContext)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SetAvatarScales = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarScales)
local TwoAxisSlider = require(Modules.AvatarExperience.AvatarEditor.Components.TwoAxisSlider)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local vector2 = Vector2.new(224, 195)

local function mapPositionToScales(vector2_2: Vector2, t1: {[any]: any}, t2: {[any]: any}) -- line: 50
	local v23 = t1.max - t1.min
	local v24 = math.clamp((1 - vector2_2.Y) * v23 + t1.min, t1.min, t1.max)
	local v25 = t2.max - t2.min

	return math.clamp((1 - (if v24 ~= 0 then (vector2_2.X - 0.5 * vector2_2.Y) / v24 else 0.5)) * v25 + t2.min, t2.min, t2.max), v24
end
local function mapScalesToPosition(n1: number, n2: number, t3: {[any]: any}, t4: {[any]: any}) -- line: 67
	local v30 = t3.max - t3.min
	local v31 = (n2 - t3.min) / v30
	local v32 = t4.max - t4.min
	local v33 = (n1 - t4.min) / v32

	return Vector2.new((1 - v33) * v31 + (1 - v31) * 0.5, 1 - v31)
end
local function selectScalesState(p1) -- line: 85
	-- upvalues: Constants (copy)
	local AvatarScales = p1.AvatarExperience.AvatarEditor.Character.AvatarScales
	local v36 = p1.AvatarExperience.AvatarEditor.AvatarSettings[Constants.AvatarSettings.scalesRules]

	return {
		bodyType = AvatarScales.bodyType,
		proportion = AvatarScales.proportion,
		bodyTypeScaleRules = v36.bodyType,
		proportionScaleRules = v36.proportion
	}
end
local function BodyTypeSlider(t5: {[any]: any}, p2) -- line: 98
	-- upvalues: useTokens (copy), useSelector (copy), selectScalesState (copy), tutils (copy), useBodyDataCallbacksContext (copy), useDispatch (copy), React (copy), mapPositionToScales (copy), mapScalesToPosition (copy), SetAvatarScales (copy), vector2 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), TwoAxisSlider (copy)
	local v39 = useTokens()
	local v40 = useSelector(selectScalesState, tutils.deepEqual)
	local v41 = useBodyDataCallbacksContext()
	local v42 = useDispatch()
	local proportion = v40.proportion
	local bodyType = v40.bodyType
	local bodyTypeScaleRules = v40.bodyTypeScaleRules
	local proportionScaleRules = v40.proportionScaleRules
	local v47, v48 = React.useState({
		proportion = proportion,
		bodyType = bodyType
	})
	local v49 = React.useCallback(function(vector2_3: Vector2) -- line: 116
		-- upvalues: mapPositionToScales (copy), bodyTypeScaleRules (copy), proportionScaleRules (copy)
		return mapPositionToScales(vector2_3, bodyTypeScaleRules, proportionScaleRules)
	end, {
		bodyTypeScaleRules,
		proportionScaleRules
	})
	local v50 = React.useCallback(function(n3: number, n4: number) -- line: 120
		-- upvalues: mapScalesToPosition (copy), bodyTypeScaleRules (copy), proportionScaleRules (copy)
		return mapScalesToPosition(n3, n4, bodyTypeScaleRules, proportionScaleRules)
	end, {
		bodyTypeScaleRules,
		proportionScaleRules
	})
	local v51 = React.useCallback(function(n5: number, n6: number) -- line: 124
		-- upvalues: v41 (copy), v48 (copy)
		v41.setAvatarScales({
			proportion = n5,
			bodyType = n6
		})
		v48({
			proportion = n5,
			bodyType = n6
		})
	end, { v41 })
	local v52 = React.useCallback(function() -- line: 129
		-- upvalues: p2 (copy)
		if p2 and p2.current then
			return p2.current.AbsolutePosition
		end

		return nil
	end, {})
	local v53 = React.useCallback(function() -- line: 136
		-- upvalues: p2 (copy)
		if p2 and p2.current then
			return p2.current.AbsoluteSize
		end

		return nil
	end, {})
	local v54 = React.useCallback(function() -- line: 143
		-- upvalues: t5 (copy)
		if t5.lockNavigationCallback then
			t5.lockNavigationCallback()
		end
	end, { t5.lockNavigationCallback })
	local v55 = React.useCallback(function() -- line: 149
		-- upvalues: t5 (copy), v41 (copy), v42 (copy), SetAvatarScales (copy), v47 (copy)
		if t5.unlockNavigationCallback then
			t5.unlockNavigationCallback()
		end

		v41.setAvatarScales(nil)
		v42(SetAvatarScales({
			proportion = v47.proportion,
			bodyType = v47.bodyType
		}))
	end, {
		t5.unlockNavigationCallback,
		v47,
		v41,
		v42
	})
	local v56 = vector2.X / vector2.Y
	local v57 = vector2.X / v56

	return React.createElement("ImageLabel", {
		Image = "rbxasset://textures/AvatarEditorImages/Sliders/body-type-slider-background.png",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		LayoutOrder = t5.LayoutOrder,
		Size = UDim2.new(0, vector2.X, 0, v57),
		ImageColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v39.Semantic.Color.BackgroundUi.Default else v39.Color.Surface.Surface_300)).Color3,
		ImageTransparency = if not t5.isDisabled then ((if not FFlagRenameDeprecatedUIBloxTokens then v39.Semantic.Color.BackgroundUi.Default else v39.Color.Surface.Surface_300)).Transparency else 0.5,
		ref = p2
	}, {
		TwoAxisSlider = React.createElement(TwoAxisSlider, {
			invertDPadX = true,
			mapPositionToScales = v49,
			mapScalesToPosition = v50,
			setScales = v51,
			xScaleRules = proportionScaleRules,
			yScaleRules = bodyTypeScaleRules,
			xScale = v47.proportion,
			yScale = v47.bodyType,
			getBackgroundAbsolutePosition = v52,
			getBackgroundAbsoluteSize = v53,
			isDisabled = t5.isDisabled,
			onDragStart = v54,
			onDragEnd = v55
		})
	})
end

return React.memo(React.forwardRef(BodyTypeSlider))
