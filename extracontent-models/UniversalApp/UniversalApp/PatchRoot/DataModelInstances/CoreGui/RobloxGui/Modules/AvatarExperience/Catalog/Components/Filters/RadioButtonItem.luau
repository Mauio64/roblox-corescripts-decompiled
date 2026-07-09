local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Interactable = UIBlox.Core.Control.Interactable
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ControlState = UIBlox.Core.Control.Enum.ControlState
local FilterUtils = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterUtils)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local ExpandingFrame = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.Filters.ExpandingFrame
local v15 = Images["component_assets/circle_24_stroke_1"]
local v16 = Images["component_assets/circle_16"]
local t1 = {
	[ControlState.Default] = "BackgroundDefault",
	[ControlState.Hover] = "BackgroundOnHover",
	[ControlState.Pressed] = "BackgroundOnPress"
}
local t2 = {
	[ControlState.Default] = "IconDefault",
	[ControlState.Hover] = "IconEmphasis",
	[ControlState.Pressed] = "IconDefault"
}

local function getCellStyle(p1, p2, p3) -- line: 43
	-- upvalues: ControlState (copy)
	local v26 = p1[p2] or p1[ControlState.Default]
	local t3 = {
		Color = p3.Theme[v26].Color,
		Transparency = p3.Theme[v26].Transparency
	}

	if p2 == ControlState.Default or p2 == ControlState.Disabled then
		t3.Transparency = 1
	end

	return t3
end
local function getIconStyle(p4, p5, p6) -- line: 60
	-- upvalues: ControlState (copy)
	local v31 = p4[p5] or p4[ControlState.Default]
	local t4 = {
		Color = p6.Theme[v31].Color,
		Transparency = p6.Theme[v31].Transparency
	}

	if p5 == ControlState.Disabled or p5 == ControlState.Pressed then
		t4.Transparency = 0.5 * t4.Transparency + 0.5
	end

	return t4
end
local function getTextStyle(p7, p8) -- line: 76
	-- upvalues: ControlState (copy)
	local t5 = {
		Color = p7.Color,
		Transparency = p7.Transparency
	}

	if p8 == ControlState.Disabled or p8 == ControlState.Pressed then
		t5.Transparency = 0.5 * t5.Transparency + 0.5
	end

	return t5
end
local function RadioButtonItem(t6: {[any]: any}) -- line: 138
	-- upvalues: React (copy), ControlState (copy), useStyle (copy), getIconStyle (copy), t2 (copy), getCellStyle (copy), t1 (copy), FilterUtils (copy), Focusable (copy), Interactable (copy), StyledTextLabel (copy), ImageSetLabel (copy), v15 (copy), v16 (copy), ExpandingFrame (copy)
	local v37, v38 = React.useState(ControlState.Initialize)
	local v39 = React.useCallback(function(_, p10) -- line: 141
		-- upvalues: v38 (copy)
		v38(p10)
	end, {})
	local v40 = React.useCallback(function() -- line: 145
		-- upvalues: t6 (copy)
		if t6.onActivated then
			t6.onActivated(t6.id)
		end
	end, {
		t6.onActivated,
		t6.id
	})
	local v41 = useStyle()
	local Font = v41.Font
	local Theme = v41.Theme
	local v44 = t6.useDefaultControlState and ControlState.Default or v37
	local v45 = getIconStyle(t2, v44, v41)
	local v46 = getCellStyle(t1, v44, v41)
	local v47 = if not t6.isSelected then Theme.TextDefault else Theme.TextEmphasis
	local t7 = {
		Color = v47.Color,
		Transparency = v47.Transparency
	}

	if v44 == ControlState.Disabled or v44 == ControlState.Pressed then
		t7.Transparency = 0.5 * t7.Transparency + 0.5
	end

	local v49 = t6.itemHeight or 45
	local v50 = React.useRef(nil)
	local v51, v52 = React.useBinding(v49)

	React.useEffect(function() -- line: 181
		-- upvalues: v50 (copy), v49 (copy), t6 (copy), v52 (copy)
		local current = v50.current
		local v61 = v49

		if current then
			v61 += current.AbsoluteSize.Y
		end

		if not t6.hideDivider then
			v61 += 1
		end

		v52(v61)

		if t6.onHeightChanged then
			t6.onHeightChanged(v61)
		end
	end, {})

	local v53 = t6.expandedView and t6.isSelected == true

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = v51:map(FilterUtils.mapHeightToSize),
		LayoutOrder = t6.layoutOrder,
		ref = t6.frameRef,
		NextSelectionLeft = t6.NextSelectionLeft,
		NextSelectionRight = t6.NextSelectionRight,
		NextSelectionUp = t6.NextSelectionUp,
		NextSelectionDown = t6.NextSelectionDown
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		}),
		Interactable = React.createElement(Focusable[Interactable], {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v49),
			BackgroundColor3 = v46.Color,
			BackgroundTransparency = v46.Transparency,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			[React.Event.Activated] = not t6.isDisabled and v40,
			ref = t6.defaultChildRef,
			NextSelectionDown = if not v53 then nil else v50,
			SelectionImageObject = t6.SelectionImageObject,
			isDisabled = t6.isDisabled,
			onStateChanged = v39
		}, {
			Contents = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v49)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				CustomViewFrame = t6.customView and React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, -48, 1, 0)
				}, {
					CustomView = t6.customView
				}),
				CustomViewSpacer = t6.customView and React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(0, 24, 1, 0)
				}),
				TitleText = t6.text and (not t6.customView and React.createElement(StyledTextLabel, {
					layoutOrder = 1,
					size = UDim2.new(1, -24, 1, 0),
					colorStyle = t7,
					fontStyle = Font.Header2,
					text = t6.text,
					textXAlignment = Enum.TextXAlignment.Left
				})),
				RightContent = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					Size = UDim2.new(0, 24, 1, 0)
				}, {
					SelectionImage = React.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						Image = v15,
						Size = UDim2.new(0, 24, 0, 24),
						ImageColor3 = v45.Color,
						ImageTransparency = v45.Transparency,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0)
					}, {
						SelectedImage = t6.isSelected and React.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							Image = v16,
							Size = UDim2.new(0, 16, 0, 16),
							ImageColor3 = v45.Color,
							ImageTransparency = v45.Transparency,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0)
						})
					})
				})
			})
		}),
		ExpandingFrame = t6.expandedView and React.createElement(Focusable[ExpandingFrame], {
			LayoutOrder = 2,
			Size = UDim2.new(1, -24, 0, t6.expandedViewHeight or 0),
			isExpanded = t6.isSelected == true,
			onAbsoluteSizeChanged = function(p11) -- line: 167
				-- upvalues: v49 (copy), t6 (copy), v52 (copy)
				local v59 = v49

				if p11 then
					v59 += p11.AbsoluteSize.Y
				end

				if not t6.hideDivider then
					v59 += 1
				end

				v52(v59)

				if t6.onHeightChanged then
					t6.onHeightChanged(v59)
				end
			end,
			ref = v50,
			NextSelectionUp = t6.defaultChildRef
		}, {
			ExpandedView = t6.expandedView
		}),
		DividerFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 1)
		}, {
			Divider = not t6.hideDivider and React.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, -24, 0, 1),
				Position = UDim2.new(1, -12, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = Theme.Divider.Color,
				BackgroundTransparency = Theme.Divider.Transparency
			})
		})
	})
end

return React.forwardRef(function(p12, p13) -- line: 310
	-- upvalues: React (copy), RadioButtonItem (copy), Cryo (copy)
	return React.createElement(RadioButtonItem, Cryo.Dictionary.join(p12, {
		frameRef = p13
	}))
end)
