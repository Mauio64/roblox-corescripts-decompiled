local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local mutedError = require(Modules.LuaApp.mutedError)
local useStyle = UIBlox.Core.Style.useStyle
local SystemSlider = UIBlox.App.Slider.SystemSlider
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local selectLowerAdjustmentLimits = require(Modules.AvatarExperience.AccessoryAdjustment.Selectors.selectLowerAdjustmentLimits)
local selectUpperAdjustmentLimits = require(Modules.AvatarExperience.AccessoryAdjustment.Selectors.selectUpperAdjustmentLimits)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local Constants = require(Modules.AvatarExperience.AccessoryAdjustment.Constants)
local AdjustmentSliderType = require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AdjustmentSliderType)
local AxisType = require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AxisType)
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local v21 = game:DefineFastInt("AXAdjustmentSnapThreshold", 5)
local v22 = game:DefineFastFlag("AXAddVRContainerRefToAASlider", false)
local FFlagAXMigrateSystemSliderToFoundationSlider = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateSystemSliderToFoundationSlider
local FFlagAXMakeSlidersSmoothWithGamepad = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMakeSlidersSmoothWithGamepad
local v25 = Images["component_assets/circle_21"]
local t1 = {
	[AdjustmentSliderType.PositionX] = {
		AdjustmentKey = "position",
		LimitKey = "xPosition",
		Invert = true,
		Text = AxisType.X,
		Color = Constants.XAxisColor
	},
	[AdjustmentSliderType.PositionY] = {
		AdjustmentKey = "position",
		LimitKey = "yPosition",
		Text = AxisType.Y,
		Color = Constants.YAxisColor
	},
	[AdjustmentSliderType.PositionZ] = {
		AdjustmentKey = "position",
		LimitKey = "zPosition",
		Invert = true,
		Text = AxisType.Z,
		Color = Constants.ZAxisColor
	},
	[AdjustmentSliderType.RotationX] = {
		AdjustmentKey = "rotation",
		LimitKey = "xRotation",
		Invert = true,
		Text = AxisType.X,
		Color = Constants.XAxisColor
	},
	[AdjustmentSliderType.RotationY] = {
		AdjustmentKey = "rotation",
		LimitKey = "yRotation",
		Text = AxisType.Y,
		Color = Constants.YAxisColor
	},
	[AdjustmentSliderType.RotationZ] = {
		AdjustmentKey = "rotation",
		LimitKey = "zRotation",
		Text = AxisType.Z,
		Color = Constants.ZAxisColor
	},
	[AdjustmentSliderType.Scale] = {
		Text = "",
		AdjustmentKey = "scale",
		LimitKey = "xScale",
		Color = Constants.ZAxisColor
	}
}

local function SliderImage(p1, p2, n1: number) -- line: 116
	-- upvalues: React (copy), ImageSetLabel (copy), v25 (copy), t1 (copy), Constants (copy)
	return React.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, n1, 0, n1),
		Image = v25,
		ImageColor3 = t1[p2].Color,
		ImageTransparency = p1.IconEmphasis.Transparency,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}, {
		Letter = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextScaled = true,
			ZIndex = 2,
			Size = UDim2.new(1, -3, 1, -3),
			Text = t1[p2].Text,
			FontFace = Constants.FontFace,
			TextColor3 = Color3.new(1, 1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
	})
end
local function valueToPercent(n2: number, n3: number, n4: number, n5: number, p3) -- line: 141
	local v48 = if not (n2 < n5) then math.abs((n2 - n5) / (n4 - n5)) else -math.abs((n2 - n5) / (n3 - n5))

	if p3 then
		v48 = -v48
	end

	return v48 * 100
end
local function percentToValue(n6: number, n7: number, n8: number, n9: number, p4) -- line: 154
	if p4 then
		n6 = -n6
	end

	if n6 < 0 then
		return n9 - math.abs(n6 / 100) * math.abs(n9 - n7)
	end

	return n9 + math.abs(n6 / 100) * math.abs(n8 - n9)
end
local function v30(p5) -- line: 164
	return p5.AvatarExperience.AccessoryAdjustment.AdjustmentTypeSelected
end

if FFlagAXMigrateSystemSliderToFoundationSlider then
	local function convertStoredValueToSliderValue(n10: number, _: number, n12: number, n13: number, p6) -- line: 169
		-- upvalues: mutedError (copy)
		if n12 <= n13 then
			mutedError("AdjustmentSlider.lua convertStoredValueToSliderValue argument error: max must be greater than defaultValue.")

			return 0.5
		end

		local v60 = if not (n10 < n13) then (n10 - n13) / (n12 - n13) / 2 + 0.5 else 0.5 - (n13 - n10) / (n12 - n13) / 2

		if p6 then
			return 1 - v60
		end

		return v60
	end
	local function convertSliderValueToStoredValue(n14: number, _: number, n16: number, n17: number, p7) -- line: 196
		if p7 then
			n14 = 1 - n14
		end

		if n14 < 0.5 then
			return n17 - (0.5 - n14) / 0.5 * (n16 - n17)
		end

		return n17 + (n14 - 0.5) / 0.5 * (n16 - n17)
	end
	local function AdjustmentSlider(t2: {[any]: any}) -- line: 217
		-- upvalues: useStyle (copy), v22 (copy), useIsSpatial (copy), React (copy), useSelector (copy), selectLowerAdjustmentLimits (copy), selectUpperAdjustmentLimits (copy), v30 (copy), Constants (copy), Responsive (copy), t1 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), useDesignTokens (copy), AdjustmentSliderType (copy), mutedError (copy), SliderImage (copy), Foundation (copy), FFlagAXMakeSlidersSmoothWithGamepad (copy)
		local Theme = useStyle().Theme
		local v68 = if not v22 then nil else useIsSpatial()
		local v69 = if not v22 or not v68 then nil else React.createRef()
		local v70 = useSelector(selectLowerAdjustmentLimits)
		local v71 = useSelector(selectUpperAdjustmentLimits)
		local v72 = useSelector(v30) ~= Constants.AdjustmentSliderTypeToAdjustmentType[t2.adjustmentSliderType]
		local v73 = React.useRef(false)
		local u74 = Responsive.useLastInput() == Responsive.Input.Directional
		local adjustmentSliderType = t2.adjustmentSliderType
		local AdjustmentKey = t1[adjustmentSliderType].AdjustmentKey
		local LimitKey = t1[adjustmentSliderType].LimitKey
		local v78 = v70[AdjustmentKey][LimitKey]
		local v79 = v71[AdjustmentKey][LimitKey]

		local function mapTokens(p8) -- line: 236
			-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
			return {
				smallIconSize = if not FFlagRenameDeprecatedUIBloxTokens then p8.Semantic.Icon.Size.Small else p8.Size.Size_400,
				padding = if not FFlagRenameDeprecatedUIBloxTokens then p8.Global.Size_200 else p8.Size.Size_400
			}
		end

		local v81 = useDesignTokens(mapTokens)
		local v82 = t2.adjustmentSliderType ~= AdjustmentSliderType.Scale and 0 or 1
		local Invert = t1[t2.adjustmentSliderType].Invert
		local useState = React.useState
		local sliderValue = t2.sliderValue
		local n18

		if v79 <= v82 then
			mutedError("AdjustmentSlider.lua convertStoredValueToSliderValue argument error: max must be greater than defaultValue.")
			n18 = 0.5
		else
			local v87 = if not (sliderValue < v82) then (sliderValue - v82) / (v79 - v82) / 2 + 0.5 else 0.5 - (v82 - sliderValue) / (v79 - v82) / 2

			n18 = if not Invert then v87 else 1 - v87
		end

		local v88, v89 = useState(n18)

		React.useEffect(function() -- line: 251
			-- upvalues: v89 (copy), t2 (copy), v78 (copy), v79 (copy), v82 (copy), Invert (copy), mutedError (copy)
			local v114 = v89
			local sliderValue2 = t2.sliderValue
			local _ = v78
			local v117 = v79
			local v118 = v82
			local v119 = Invert
			local n19

			if v117 <= v118 then
				mutedError("AdjustmentSlider.lua convertStoredValueToSliderValue argument error: max must be greater than defaultValue.")
				n19 = 0.5
			else
				local v121 = if not (sliderValue2 < v118) then (sliderValue2 - v118) / (v117 - v118) / 2 + 0.5 else 0.5 - (v118 - sliderValue2) / (v117 - v118) / 2

				n19 = if not v119 then v121 else 1 - v121
			end

			v114(n19)
		end, {
			t2.sliderValue,
			v78,
			v79,
			v82,
			Invert
		})

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			LayoutOrder = t2.LayoutOrder,
			ref = if not v22 or not v68 then nil else v69
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, v81.padding),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			SliderImage = SliderImage(Theme, t2.adjustmentSliderType, v81.smallIconSize),
			Slider = React.createElement(Foundation.Slider, {
				layoutOrder = 2,
				ref = t2.sliderRef,
				NextSelectionDown = t2.NextSelectionDown,
				NextSelectionUp = t2.NextSelectionUp,
				isDisabled = v72,
				range = NumberRange.new(0, 1),
				value = v88,
				onDragStarted = function() -- line: 280
					-- upvalues: v73 (copy)
					v73.current = true
				end,
				onValueChanged = function(n20: number) -- line: 283
					-- upvalues: u74 (ref), v88 (copy), v78 (copy), v79 (copy), v82 (copy), Invert (copy), t2 (copy), v89 (copy)
					if math.abs(0.5 - n20) < 0.025 then
						if u74 then
							if n20 < 0.5 and n20 > v88 or n20 > 0.5 and n20 < v88 then
								n20 = 0.5
							elseif v88 == 0.5 then
								n20 = not (n20 > 0.5) and 0.475 or 0.525
							end
						else
							n20 = 0.5
						end
					end

					local v123 = n20
					local _ = v78
					local v125 = v79
					local v126 = v82

					if Invert then
						v123 = 1 - v123
					end

					local v127 = if not (v123 < 0.5) then v126 + (v123 - 0.5) / 0.5 * (v125 - v126) else v126 - (0.5 - v123) / 0.5 * (v125 - v126)

					t2.updateCharacterCallback(v127, t2.adjustmentSliderType)
					v89(n20)
				end,
				onDragEnded = function() -- line: 305
					-- upvalues: v73 (copy), v88 (copy), v78 (copy), v79 (copy), v82 (copy), Invert (copy), t2 (copy)
					if not v73.current then
						return
					end

					local v128 = v88
					local _ = v78
					local v130 = v79
					local v131 = v82

					if Invert then
						v128 = 1 - v128
					end

					local v132 = if not (v128 < 0.5) then v131 + (v128 - 0.5) / 0.5 * (v130 - v131) else v131 - (0.5 - v128) / 0.5 * (v130 - v131)

					t2.setSliderValuesCallback(v132, t2.adjustmentSliderType)
					v73.current = false
				end,
				width = UDim.new(1, -v81.padding - v81.smallIconSize),
				step = if not FFlagAXMakeSlidersSmoothWithGamepad then nil else 0.01
			})
		})
	end

	return AdjustmentSlider
end

local function AdjustmentSlider(t3: {[any]: any}) -- line: 326
	-- upvalues: useStyle (copy), v22 (copy), useIsSpatial (copy), React (copy), useSelector (copy), selectLowerAdjustmentLimits (copy), selectUpperAdjustmentLimits (copy), v30 (copy), Constants (copy), Responsive (copy), t1 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), useDesignTokens (copy), AdjustmentSliderType (copy), SliderImage (copy), SystemSlider (copy), v21 (copy)
	local Theme = useStyle().Theme
	local v92 = if not v22 then nil else useIsSpatial()
	local v93 = if not v22 or not v92 then nil else React.createRef()
	local v94 = useSelector(selectLowerAdjustmentLimits)
	local v95 = useSelector(selectUpperAdjustmentLimits)
	local v96 = useSelector(v30) ~= Constants.AdjustmentSliderTypeToAdjustmentType[t3.adjustmentSliderType]
	local v97 = React.useRef(false)
	local v98 = Responsive.useLastInput() == Responsive.Input.Directional
	local adjustmentSliderType = t3.adjustmentSliderType
	local AdjustmentKey = t1[adjustmentSliderType].AdjustmentKey
	local LimitKey = t1[adjustmentSliderType].LimitKey
	local v102 = v94[AdjustmentKey][LimitKey]
	local v103 = v95[AdjustmentKey][LimitKey]

	local function mapTokens(p9) -- line: 343
		-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
		return {
			smallIconSize = if not FFlagRenameDeprecatedUIBloxTokens then p9.Semantic.Icon.Size.Small else p9.Size.Size_400,
			padding = if not FFlagRenameDeprecatedUIBloxTokens then p9.Global.Size_200 else p9.Size.Size_400
		}
	end

	local v105 = useDesignTokens(mapTokens)
	local v106 = t3.adjustmentSliderType ~= AdjustmentSliderType.Scale and 0 or 1
	local Invert = t1[t3.adjustmentSliderType].Invert
	local useState = React.useState
	local sliderValue = t3.sliderValue
	local v110 = if not (sliderValue < v106) then math.abs((sliderValue - v106) / (v103 - v106)) else -math.abs((sliderValue - v106) / (v102 - v106))

	if Invert then
		v110 = -v110
	end

	local v111, v112 = useState(v110 * 100)

	React.useEffect(function() -- line: 358
		-- upvalues: v112 (copy), t3 (copy), v102 (copy), v103 (copy), v106 (copy), Invert (copy)
		local v134 = v112
		local sliderValue3 = t3.sliderValue
		local v136 = v102
		local v137 = v103
		local v138 = v106
		local v139 = Invert
		local v140 = if not (sliderValue3 < v138) then math.abs((sliderValue3 - v138) / (v137 - v138)) else -math.abs((sliderValue3 - v138) / (v136 - v138))

		if v139 then
			v140 = -v140
		end

		v134(v140 * 100)
	end, {
		t3.sliderValue,
		v102,
		v103,
		v106,
		Invert
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		LayoutOrder = t3.LayoutOrder,
		ref = if not v22 or not v92 then nil else v93
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v105.padding),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		SliderImage = SliderImage(Theme, t3.adjustmentSliderType, v105.smallIconSize),
		Slider = React.createElement(SystemSlider, {
			min = -100,
			max = 100,
			stepInterval = 2,
			layoutOrder = 2,
			ref = t3.sliderRef,
			NextSelectionDown = t3.NextSelectionDown,
			NextSelectionUp = t3.NextSelectionUp,
			isDisabled = v96,
			value = v111,
			onDragStart = function() -- line: 390
				-- upvalues: v97 (copy)
				v97.current = true
			end,
			onValueChanged = function(n21: number) -- line: 393
				-- upvalues: v21 (copy), v98 (copy), v111 (copy), v102 (copy), v103 (copy), v106 (copy), Invert (copy), t3 (copy), v112 (copy)
				if math.abs(n21) < v21 then
					if v98 then
						if n21 < 0 and n21 > v111 or n21 > 0 and n21 < v111 then
							n21 = 0
						elseif v111 == 0 then
							n21 = (not (n21 < 0) and 1 or -1) * v21
						end
					else
						n21 = 0
					end
				end

				local v142 = n21
				local v143 = v102
				local v144 = v103
				local v145 = v106

				if Invert then
					v142 = -v142
				end

				local v146 = if not (v142 < 0) then v145 + math.abs(v142 / 100) * math.abs(v144 - v145) else v145 - math.abs(v142 / 100) * math.abs(v145 - v143)

				t3.updateCharacterCallback(v146, t3.adjustmentSliderType)
				v112(n21)
			end,
			onDragEnd = function() -- line: 413
				-- upvalues: v97 (copy), v111 (copy), v102 (copy), v103 (copy), v106 (copy), Invert (copy), t3 (copy)
				if not v97.current then
					return
				end

				local v147 = v111
				local v148 = v102
				local v149 = v103
				local v150 = v106

				if Invert then
					v147 = -v147
				end

				local v151 = if not (v147 < 0) then v150 + math.abs(v147 / 100) * math.abs(v149 - v150) else v150 - math.abs(v147 / 100) * math.abs(v150 - v148)

				t3.setSliderValuesCallback(v151, t3.adjustmentSliderType)
				v97.current = false
			end,
			width = UDim.new(1, -v105.padding - v105.smallIconSize),
			containerRef = if not v22 or not v92 then nil else v93
		})
	})
end

return AdjustmentSlider
