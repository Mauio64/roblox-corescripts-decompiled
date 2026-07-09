local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useTokens = Foundation.Hooks.useTokens
local tutils = require(CorePackages.Packages.tutils)
local useBodyDataCallbacksContext = require(Modules.AvatarExperience.Common.Context.useBodyDataCallbacksContext)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SetAvatarScales = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarScales)
local TwoAxisSlider = require(Modules.AvatarExperience.AvatarEditor.Components.TwoAxisSlider)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local vector2 = Vector2.new(224, 224)
local v19 = Images["component_assets/circle_17"]

local function mapPositionToScales(vector2_2: Vector2, t1: {[any]: any}, t2: {[any]: any}) -- line: 52
	local v27 = t1.max - t1.min
	local v28 = math.clamp(vector2_2.X * v27 + t1.min, t1.min, t1.max)
	local v29 = t2.max - t2.min

	return v28, (math.clamp((1 - vector2_2.Y) * v29 + t2.min, t2.min, t2.max))
end
local function mapScalesToPosition(n1: number, n2: number, t3: {[any]: any}, t4: {[any]: any}) -- line: 65
	local v34 = t3.max - t3.min
	local v35 = (n1 - t3.min) / v34
	local v36 = t4.max - t4.min
	local v37 = (n2 - t4.min) / v36

	return Vector2.new(v35, 1 - v37)
end
local function selectScalesState(p1) -- line: 75
	-- upvalues: Constants (copy)
	local AvatarScales = p1.AvatarExperience.AvatarEditor.Character.AvatarScales
	local v40 = p1.AvatarExperience.AvatarEditor.AvatarSettings[Constants.AvatarSettings.scalesRules]

	return {
		width = AvatarScales.width,
		height = AvatarScales.height,
		widthRules = v40.width,
		heightRules = v40.height
	}
end
local function BodySizeSlider(t5: {[any]: any}, p2) -- line: 88
	-- upvalues: useTokens (copy), useDispatch (copy), useBodyDataCallbacksContext (copy), useSelector (copy), selectScalesState (copy), tutils (copy), React (copy), mapPositionToScales (copy), mapScalesToPosition (copy), SetAvatarScales (copy), ImageSetLabel (copy), v19 (copy), vector2 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), TwoAxisSlider (copy)
	local v43 = useTokens()
	local v44 = useDispatch()
	local v45 = useBodyDataCallbacksContext()
	local v46 = useSelector(selectScalesState, tutils.deepEqual)
	local width = v46.width
	local height = v46.height
	local widthRules = v46.widthRules
	local heightRules = v46.heightRules
	local v51, v52 = React.useState({
		width = width,
		height = height
	})
	local v53 = React.useCallback(function(vector2_3: Vector2) -- line: 102
		-- upvalues: mapPositionToScales (copy), widthRules (copy), heightRules (copy)
		return mapPositionToScales(vector2_3, widthRules, heightRules)
	end, {
		widthRules,
		heightRules
	})
	local v54 = React.useCallback(function(n3: number, n4: number) -- line: 106
		-- upvalues: mapScalesToPosition (copy), widthRules (copy), heightRules (copy)
		return mapScalesToPosition(n3, n4, widthRules, heightRules)
	end, {
		widthRules,
		heightRules
	})
	local v55 = React.useCallback(function(n5: number, n6: number) -- line: 110
		-- upvalues: v45 (copy), v52 (copy)
		v45.setAvatarScales({
			width = n5,
			height = n6
		})
		v52({
			width = n5,
			height = n6
		})
	end, { v45 })
	local v56 = React.useCallback(function() -- line: 117
		-- upvalues: p2 (copy)
		if p2 and p2.current then
			return p2.current.AbsolutePosition
		end

		return nil
	end, {})
	local v57 = React.useCallback(function() -- line: 124
		-- upvalues: p2 (copy)
		if p2 and p2.current then
			return p2.current.AbsoluteSize
		end

		return nil
	end, {})
	local v58 = React.useCallback(function() -- line: 131
		-- upvalues: t5 (copy)
		if t5.lockNavigationCallback then
			t5.lockNavigationCallback()
		end
	end, { t5.lockNavigationCallback })
	local v59 = React.useCallback(function() -- line: 137
		-- upvalues: t5 (copy), v45 (copy), v44 (copy), SetAvatarScales (copy), v51 (copy)
		if t5.unlockNavigationCallback then
			t5.unlockNavigationCallback()
		end

		v45.setAvatarScales(nil)
		v44(SetAvatarScales({
			width = v51.width,
			height = v51.height
		}))
	end, {
		t5.unlockNavigationCallback,
		v51,
		v45,
		v44
	})

	return React.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Image = v19,
		Size = UDim2.new(0, vector2.X, 0, vector2.Y),
		ImageColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v43.Semantic.Color.BackgroundUi.Default else v43.Color.Surface.Surface_300)).Color3,
		ImageTransparency = if not t5.isDisabled then ((if not FFlagRenameDeprecatedUIBloxTokens then v43.Semantic.Color.BackgroundUi.Default else v43.Color.Surface.Surface_300)).Transparency else 0.5,
		LayoutOrder = t5.LayoutOrder,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(9, 9, 9, 9),
		ref = p2
	}, {
		TwoAxisSlider = React.createElement(TwoAxisSlider, {
			mapPositionToScales = v53,
			mapScalesToPosition = v54,
			setScales = v55,
			xScaleRules = widthRules,
			yScaleRules = heightRules,
			xScale = v51.width,
			yScale = v51.height,
			getBackgroundAbsolutePosition = v56,
			getBackgroundAbsoluteSize = v57,
			isDisabled = t5.isDisabled,
			onDragStart = v58,
			onDragEnd = v59
		})
	})
end

return React.memo(React.forwardRef(BodySizeSlider))
