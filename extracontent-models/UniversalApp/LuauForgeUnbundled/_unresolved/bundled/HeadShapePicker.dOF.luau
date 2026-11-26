local module = require("@luauforge/bundled/dOu")
require("@luauforge/bundled/dOx")
local module2 = require("@luauforge/bundled/dOv")
local module3 = require("@luauforge/bundled/dOB")
local module4 = require("@luauforge/bundled/dOy")

local fFlagHeadRefinementFacialAnimationToggle = require("@luauforge/bundled/dLg").FFlagHeadRefinementFacialAnimationToggle

local styledTextLabel = module2.App.Text.StyledTextLabel

local module5 = require("@luauforge/bundled/dOw")
local toggle = module4.Toggle
local divider = module4.Divider
local view = module4.View
local inputSize = module4.Enums.InputSize
local loading = module4.Loading
local iconSize = module4.Enums.IconSize

require("@luauforge/bundled/dOz")

local module6 = require("@luauforge/bundled/dOG")
local useDesignTokens = module3.useDesignTokens
local useLocalization = require("@luauforge/bundled/dOH").Hooks.useLocalization

local function HeadShapePicker(props)
	local v5 = useDesignTokens()
	local v6 = useLocalization({
		headingText = "Feature.Avatar.Label.HeadRefinement.Title",
		unsupportedText = "Feature.Avatar.Label.HeadRefinement.Description.Unsupported",
		facialAnimationLabel = fFlagHeadRefinementFacialAnimationToggle and "Feature.Avatar.Label.HeadRefinement.FacialAnimation" or nil
	})

	local v7 = module.useMemo(function()
		return module6(props.items or {}, function(p2)
			return p2.headShapeName
		end)
	end, { props.items })

	local createElement = module.createElement
	local v9 = {
		Size = props.size or UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = v5.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v5.Color.Surface.Surface_0.Transparency,
		AutomaticSize = Enum.AutomaticSize.XY,
		[module.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapePickerContainer",
		ref = props.containerRef,
		NextSelectionUp = props.NextSelectionUp
	}
	local v10 = {
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		UIPadding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.Size.Size_400),
			PaddingBottom = UDim.new(0, v5.Size.Size_500)
		}),
		UICorner = module.createElement("UICorner", {
			CornerRadius = UDim.new(0, v5.Radius.Medium)
		}),
		Heading = module.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = 1,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			[module.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapePickerHeadingText"
		}, {
			UIPadding = module.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v5.Size.Size_500),
				PaddingRight = UDim.new(0, v5.Size.Size_500),
				PaddingBottom = UDim.new(0, v5.Size.Size_300)
			}),
			StyledTextLabel = module.createElement(styledTextLabel, {
				automaticSize = Enum.AutomaticSize.XY,
				size = UDim2.new(0, 0, 0, 0),
				text = v6.headingText,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				fontStyle = v5.Typography.HeadingSmall,
				colorStyle = v5.Color.Content.Emphasis
			})
		}),
		HeadShapePickerLoading = 0,
		Subheading = 0,
		HeadShapeList = 0,
		FacialAnimationDivider = 0,
		FacialAnimationToggle = 0
	}
	local v12

	if props.isLoading then
		local createElement3 = module.createElement
		local v14 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local v15 = {
			Padding = module.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v5.Size.Size_300),
				PaddingBottom = UDim.new(0, v5.Size.Size_300)
			}),
			Spinner = 0
		}

		if fFlagHeadRefinementFacialAnimationToggle then
		end

		v15.Spinner = module.createElement(loading, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, v5.Size.Size_500, 0.5, 0),
			size = iconSize.Medium
		})
		v12 = createElement3("Frame", v14, v15)
	end

	v10.HeadShapePickerLoading = v12
	local v13

	if not (props.isLoading or not props.isUnsupported) then
		v13 = module.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = 2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			[module.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapePickerSubheadingText"
		}, {
			UIPadding = module.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v5.Size.Size_500),
				PaddingRight = UDim.new(0, v5.Size.Size_500)
			}),
			StyledTextLabel = module.createElement(styledTextLabel, {
				automaticSize = Enum.AutomaticSize.XY,
				size = UDim2.new(0, 0, 0, 0),
				text = v6.unsupportedText,
				textWrapped = true,
				textXAlignment = Enum.TextXAlignment.Left,
				fontStyle = v5.Typography.BodySmall,
				colorStyle = v5.Color.Content.Default
			})
		})
	end

	v10.Subheading = v13

	local v14 = if not (props.isUnsupported or props.isLoading) then module.createElement(module5, {
		orientation = props.orientation,
		tileSize = props.tileSize,
		items = v7,
		LayoutOrder = 3,
		NextSelectionUp = props.NextSelectionUp,
		maxHeight = props.headShapeListMaxHeight
	}) else nil
	v10.HeadShapeList = v14

	local v15 = if fFlagHeadRefinementFacialAnimationToggle and not props.isLoading and props.isFacialAnimationEnabled ~= nil and props.onFacialAnimationToggle ~= nil then module.createElement(
		view,
		{
			tag = "size-full-0 auto-y",
			LayoutOrder = 4,
			testId = "AvatarExperienceHeadRefinement_FacialAnimationDivider"
		},
		{
			UIPadding = module.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v5.Size.Size_500),
				PaddingRight = UDim.new(0, v5.Size.Size_500),
				PaddingTop = UDim.new(0, v5.Size.Size_300),
				PaddingBottom = UDim.new(0, v5.Size.Size_300)
			}),
			Divider = module.createElement(divider, {
				Orientation = Enum.FillDirection.Horizontal,
				Size = UDim2.new(1, 0, 0, 1)
			})
		}
	) else nil
	v10.FacialAnimationDivider = v15
	local v16

	if
		fFlagHeadRefinementFacialAnimationToggle
		and not props.isLoading
		and props.isFacialAnimationEnabled ~= nil
		and props.onFacialAnimationToggle ~= nil
	then
		v16 = module.createElement(
			view,
			{
				tag = "size-full-0 auto-y",
				LayoutOrder = 5,
				testId = "AvatarExperienceHeadRefinement_FacialAnimationToggle"
			},
			{
				UIPadding = module.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v5.Size.Size_500),
					PaddingRight = UDim.new(0, v5.Size.Size_500),
					PaddingTop = UDim.new(0, v5.Size.Size_300),
					PaddingBottom = UDim.new(0, v5.Size.Size_300)
				}),
				UIListLayout = module.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, v5.Size.Size_400)
				}),
				ToggleWrapper = module.createElement(view, {
					tag = "auto-xy",
					LayoutOrder = 1
				}, {
					Toggle = module.createElement(toggle, {
						isChecked = props.isFacialAnimationEnabled,
						onActivated = function(p2)
							if props.onFacialAnimationToggle then
								props.onFacialAnimationToggle(p2)
							end
						end,
						label = "",
						size = inputSize.Medium,
						testId = "AvatarExperienceHeadRefinement_FacialAnimationToggleButton"
					})
				}),
				Label = module.createElement(view, { tag = "auto-xy", LayoutOrder = 2 }, {
					StyledTextLabel = module.createElement(styledTextLabel, {
						automaticSize = Enum.AutomaticSize.XY,
						size = UDim2.new(0, 0, 0, 0),
						text = v6.facialAnimationLabel,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Center,
						fontStyle = v5.Typography.BodySmall,
						colorStyle = v5.Color.Content.Default
					})
				})
			}
		)
	end

	v10.FacialAnimationToggle = v16
	return createElement("Frame", v9, v10)
end

return HeadShapePicker
