local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useStyle = UIBlox.Core.Style.useStyle
local Modules = CoreGui.RobloxGui.Modules
local AdjustmentSlider = require(Modules.AvatarExperience.AccessoryAdjustment.Components.AdjustmentSlider)
local AdjustmentSliderType = require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AdjustmentSliderType)
local AdjustmentType = require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AdjustmentType)
local Focusable = RoactGamepad.Focusable
local FFlagAXMigrateSystemSliderToFoundationSlider = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateSystemSliderToFoundationSlider
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus

local function Slider(p1, p2, p3, p4, p5, p6, p7, p8) -- line: 40
	-- upvalues: React (copy), AdjustmentSlider (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
	return React.createElement(AdjustmentSlider, {
		sliderRef = p6,
		NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then p7 else nil,
		NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then p8 else nil,
		LayoutOrder = p3,
		adjustmentSliderType = p2,
		sliderValue = p1[p2],
		updateCharacterCallback = p4,
		setSliderValuesCallback = p5
	})
end
local function getSliders(p9, p10, p11, p12, t1: {[any]: any}, p13, p14) -- line: 63
	-- upvalues: AdjustmentType (copy), Slider (copy), AdjustmentSliderType (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy)
	local t2 = {}

	if p9 == AdjustmentType.Position then
		table.insert(t2, Slider(p10, AdjustmentSliderType.PositionX, 1, p11, p12, t1[1], if not FFlagAXMigrateAXToGlobalAutofocus then p13 else nil, if not FFlagAXMigrateAXToGlobalAutofocus then t1[2] else nil))
		table.insert(t2, Slider(p10, AdjustmentSliderType.PositionY, 2, p11, p12, t1[2], if not FFlagAXMigrateAXToGlobalAutofocus then t1[1] else nil, if not FFlagAXMigrateAXToGlobalAutofocus then t1[3] else nil))
		table.insert(t2, Slider(p10, AdjustmentSliderType.PositionZ, 3, p11, p12, t1[3], if not FFlagAXMigrateAXToGlobalAutofocus then t1[2] else nil, if not FFlagAXMigrateAXToGlobalAutofocus then p14 else nil))
	elseif p9 == AdjustmentType.Rotation then
		table.insert(t2, Slider(p10, AdjustmentSliderType.RotationX, 1, p11, p12, t1[1], if not FFlagAXMigrateAXToGlobalAutofocus then p13 else nil, if not FFlagAXMigrateAXToGlobalAutofocus then t1[2] else nil))
		table.insert(t2, Slider(p10, AdjustmentSliderType.RotationY, 2, p11, p12, t1[2], if not FFlagAXMigrateAXToGlobalAutofocus then t1[1] else nil, if not FFlagAXMigrateAXToGlobalAutofocus then t1[3] else nil))
		table.insert(t2, Slider(p10, AdjustmentSliderType.RotationZ, 3, p11, p12, t1[3], if not FFlagAXMigrateAXToGlobalAutofocus then t1[2] else nil, if not FFlagAXMigrateAXToGlobalAutofocus then p14 else nil))
	elseif p9 == AdjustmentType.Scale then
		table.insert(t2, Slider(p10, AdjustmentSliderType.Scale, 1, p11, p12, t1[1], if not FFlagAXMigrateAXToGlobalAutofocus then p13 else nil, if not FFlagAXMigrateAXToGlobalAutofocus then p14 else nil))
	end

	table.insert(t2, React.createElement("UIListLayout", {
		Padding = UDim.new(0, 24),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top
	}))
	table.insert(t2, React.createElement("UIPadding", {
		PaddingRight = UDim.new(0, 5)
	}))

	return t2
end

if FFlagAXMigrateSystemSliderToFoundationSlider then
	local function AdjustmentSliders(t3: {[any]: any}) -- line: 195
		-- upvalues: useStyle (copy), RoactGamepad (copy), React (copy), getSliders (copy), AdjustmentType (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
		local Theme = useStyle().Theme
		local v36 = RoactGamepad.useRefCache()
		local v37 = RoactGamepad.useRefCache()
		local v38 = RoactGamepad.useRefCache()
		local v39 = React.useRef(nil)
		local v40 = React.useRef(nil)
		local v41 = React.useRef(nil)
		local v42 = getSliders(AdjustmentType.Position, t3.sliderValues, t3.updateCharacterCallback, t3.setSliderValuesCallback, v36, if not FFlagAXMigrateAXToGlobalAutofocus then t3.NextSelectionUp else nil, if not FFlagAXMigrateAXToGlobalAutofocus then t3.NextSelectionDown else nil)
		local v43 = getSliders(AdjustmentType.Rotation, t3.sliderValues, t3.updateCharacterCallback, t3.setSliderValuesCallback, v37, if not FFlagAXMigrateAXToGlobalAutofocus then t3.NextSelectionUp else nil, if not FFlagAXMigrateAXToGlobalAutofocus then t3.NextSelectionDown else nil)
		local v44 = getSliders(AdjustmentType.Scale, t3.sliderValues, t3.updateCharacterCallback, t3.setSliderValuesCallback, v38, if not FFlagAXMigrateAXToGlobalAutofocus then t3.NextSelectionUp else nil, if not FFlagAXMigrateAXToGlobalAutofocus then t3.NextSelectionDown else nil)

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			ref = if not FFlagAXMigrateAXToGlobalAutofocus then t3.frameRef else nil,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			LayoutOrder = t3.LayoutOrder
		}, {
			PositionSlidersContainer = if t3.adjustmentTypeSelected ~= AdjustmentType.Position then nil else React.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 2,
				ref = v39,
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				BackgroundTransparency = Theme.BackgroundDefault.Transparency
			}, v42),
			RotationSlidersContainer = if t3.adjustmentTypeSelected ~= AdjustmentType.Rotation then nil else React.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 2,
				ref = v40,
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				BackgroundTransparency = Theme.BackgroundDefault.Transparency
			}, v43),
			ScaleSlidersContainer = if t3.adjustmentTypeSelected ~= AdjustmentType.Scale then nil else React.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 2,
				ref = v41,
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				BackgroundTransparency = Theme.BackgroundDefault.Transparency
			}, v44),
			BackPanel = React.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 1,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				BackgroundTransparency = Theme.BackgroundDefault.Transparency
			})
		})
	end

	return AdjustmentSliders
end

local function AdjustmentSliders(t4: {[any]: any}) -- line: 293
	-- upvalues: useStyle (copy), RoactGamepad (copy), React (copy), getSliders (copy), AdjustmentType (copy), Focusable (copy)
	local Theme = useStyle().Theme
	local v47 = RoactGamepad.useRefCache()
	local v48 = RoactGamepad.useRefCache()
	local v49 = RoactGamepad.useRefCache()
	local v50 = React.useRef(nil)
	local v51 = React.useRef(nil)
	local v52 = React.useRef(nil)
	local v53, v54 = React.useState(v47[1])
	local v55 = getSliders(AdjustmentType.Position, t4.sliderValues, t4.updateCharacterCallback, t4.setSliderValuesCallback, v47, t4.NextSelectionUp, t4.NextSelectionDown)
	local v56 = getSliders(AdjustmentType.Rotation, t4.sliderValues, t4.updateCharacterCallback, t4.setSliderValuesCallback, v48, t4.NextSelectionUp, t4.NextSelectionDown)
	local v57 = getSliders(AdjustmentType.Scale, t4.sliderValues, t4.updateCharacterCallback, t4.setSliderValuesCallback, v49, t4.NextSelectionUp, t4.NextSelectionDown)

	React.useEffect(function() -- line: 341
		-- upvalues: t4 (copy), AdjustmentType (copy), v54 (copy), v50 (copy), v51 (copy), v52 (copy)
		if t4.adjustmentTypeSelected == AdjustmentType.Position then
			v54(v50)

			return
		end

		if t4.adjustmentTypeSelected == AdjustmentType.Rotation then
			v54(v51)

			return
		end

		v54(v52)
	end, { t4.adjustmentTypeSelected })

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		ref = t4.frameRef,
		defaultChild = v53,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		LayoutOrder = t4.LayoutOrder
	}, {
		PositionSlidersContainer = React.createElement(Focusable.Frame, {
			restorePreviousChildFocus = true,
			BorderSizePixel = 0,
			ref = v50,
			defaultChild = v47[1],
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			ZIndex = t4.adjustmentTypeSelected ~= AdjustmentType.Position and 0 or 2
		}, v55),
		RotationSlidersContainer = React.createElement(Focusable.Frame, {
			restorePreviousChildFocus = true,
			BorderSizePixel = 0,
			ref = v51,
			defaultChild = v48[1],
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			ZIndex = t4.adjustmentTypeSelected ~= AdjustmentType.Rotation and 0 or 2
		}, v56),
		ScaleSlidersContainer = React.createElement(Focusable.Frame, {
			restorePreviousChildFocus = true,
			BorderSizePixel = 0,
			ref = v52,
			defaultChild = v49[1],
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			ZIndex = t4.adjustmentTypeSelected ~= AdjustmentType.Scale and 0 or 2
		}, v57),
		BackPanel = React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 1,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency
		})
	})
end

return AdjustmentSliders
