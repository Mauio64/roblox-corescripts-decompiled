local AvatarExperienceHeadRefinement = script:FindFirstAncestor("AvatarExperienceHeadRefinement")
local AvatarExperienceHeadRefinementParent = AvatarExperienceHeadRefinement.Parent
local React = require(AvatarExperienceHeadRefinementParent.React)

require(AvatarExperienceHeadRefinementParent.RobloxAppEnums)

local UIBlox = require(AvatarExperienceHeadRefinementParent.UIBlox)
local AppCommonStyle = require(AvatarExperienceHeadRefinementParent.AppCommonStyle)
local Foundation = require(AvatarExperienceHeadRefinementParent.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(AvatarExperienceHeadRefinementParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local AvatarExperienceFlags = require(AvatarExperienceHeadRefinementParent.AvatarExperienceFlags)
local FFlagDHMHideHeadRefinementSubheading = AvatarExperienceFlags.FFlagDHMHideHeadRefinementSubheading
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local FFlagAXEnableResponsiveHeadRefinementMenu = AvatarExperienceFlags.FFlagAXEnableResponsiveHeadRefinementMenu
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local HeadShapeList = require(AvatarExperienceHeadRefinement.Components.HeadShapeList)
local Toggle = Foundation.Toggle
local Divider = Foundation.Divider
local View = Foundation.View
local InputSize = Foundation.Enums.InputSize
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize

require(AvatarExperienceHeadRefinement.Enums.HeadShapeTileSize)

local sortHeadShapes = require(AvatarExperienceHeadRefinement.Utils.sortHeadShapes)
local useDesignTokens = AppCommonStyle.useDesignTokens
local useLocalization = require(AvatarExperienceHeadRefinementParent.Localization).Hooks.useLocalization

local function HeadShapePicker(t1: {[any]: any}) -- line: 51
	-- upvalues: useDesignTokens (copy), useLocalization (copy), FFlagDHMHideHeadRefinementSubheading (copy), FFlagHeadRefinementFacialAnimationToggle (copy), React (copy), sortHeadShapes (copy), FFlagRenameDeprecatedUIBloxTokens (copy), StyledTextLabel (copy), Loading (copy), IconSize (copy), HeadShapeList (copy), FFlagAXEnableResponsiveHeadRefinementMenu (copy), View (copy), Divider (copy), Toggle (copy), InputSize (copy)
	local v25 = useDesignTokens()
	local v26 = useLocalization({
		headingText = "Feature.Avatar.Label.HeadRefinement.Title",
		unsupportedText = "Feature.Avatar.Label.HeadRefinement.Description.Unsupported",
		subheadingText = if FFlagDHMHideHeadRefinementSubheading then nil else "Feature.Avatar.Label.HeadRefinement.Description",
		facialAnimationLabel = if not FFlagHeadRefinementFacialAnimationToggle then nil else "Feature.Avatar.Label.HeadRefinement.FacialAnimation"
	})
	local v27 = React.useMemo(function() -- line: 64
		-- upvalues: sortHeadShapes (copy), t1 (copy)
		return sortHeadShapes(t1.items or {}, function(p1) -- line: 65
			return p1.headShapeName
		end)
	end, { t1.items })

	return React.createElement("Frame", {
		Size = t1.size or UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v25.Semantic.Color.Background.Default else v25.Color.Surface.Surface_0)).Color3,
		BackgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v25.Semantic.Color.Background.Default else v25.Color.Surface.Surface_0)).Transparency,
		AutomaticSize = Enum.AutomaticSize.XY,
		[React.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapePickerContainer",
		ref = t1.containerRef,
		NextSelectionUp = t1.NextSelectionUp
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_200 else v25.Size.Size_400),
			PaddingBottom = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_250 else v25.Size.Size_500)
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Semantic.Radius.Medium else v25.Radius.Medium)
		}),
		Heading = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = 1,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			[React.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapePickerHeadingText"
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_250 else v25.Size.Size_500),
				PaddingRight = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_250 else v25.Size.Size_500),
				PaddingBottom = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_150 else v25.Size.Size_300)
			}),
			StyledTextLabel = React.createElement(StyledTextLabel, {
				automaticSize = Enum.AutomaticSize.XY,
				size = UDim2.new(0, 0, 0, 0),
				text = v26.headingText,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				fontStyle = if not FFlagRenameDeprecatedUIBloxTokens then v25.Semantic.Typography.Header else v25.Typography.HeadingSmall,
				colorStyle = if not FFlagRenameDeprecatedUIBloxTokens then v25.Semantic.Color.Text.Emphasis else v25.Color.Content.Emphasis
			})
		}),
		HeadShapePickerLoading = if not t1.isLoading then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_150 else v25.Size.Size_300),
				PaddingBottom = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_150 else v25.Size.Size_300)
			}),
			Spinner = if not FFlagHeadRefinementFacialAnimationToggle then React.createElement(Loading, {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_250 else v25.Size.Size_500, 0.5, 0),
				size = IconSize.Medium
			}) else React.createElement(Loading, {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_250 else v25.Size.Size_500, 0.5, 0),
				size = IconSize.Medium
			})
		}),
		Subheading = if not t1.isLoading and (not FFlagDHMHideHeadRefinementSubheading or t1.isUnsupported) then React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = 2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			[React.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapePickerSubheadingText"
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_250 else v25.Size.Size_500),
				PaddingRight = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_250 else v25.Size.Size_500),
				PaddingBottom = if not t1.isUnsupported then UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_150 else v25.Size.Size_300) else nil
			}),
			StyledTextLabel = React.createElement(StyledTextLabel, {
				textWrapped = true,
				automaticSize = Enum.AutomaticSize.XY,
				size = UDim2.new(0, 0, 0, 0),
				text = if not t1.isUnsupported then v26.subheadingText else v26.unsupportedText,
				textXAlignment = Enum.TextXAlignment.Left,
				fontStyle = if not FFlagRenameDeprecatedUIBloxTokens then v25.Semantic.Typography.CaptionBody else v25.Typography.BodySmall,
				colorStyle = if not FFlagRenameDeprecatedUIBloxTokens then v25.Semantic.Color.Text.Default else v25.Color.Content.Default
			})
		}) else nil,
		HeadShapeList = if not t1.isUnsupported and not t1.isLoading then React.createElement(HeadShapeList, {
			LayoutOrder = 3,
			orientation = t1.orientation,
			tileSize = t1.tileSize,
			items = v27,
			NextSelectionUp = t1.NextSelectionUp,
			maxHeight = if not FFlagAXEnableResponsiveHeadRefinementMenu then nil else t1.headShapeListMaxHeight
		}) else nil,
		FacialAnimationDivider = if not FFlagHeadRefinementFacialAnimationToggle or (t1.isLoading or (t1.isFacialAnimationEnabled == nil or t1.onFacialAnimationToggle == nil)) then nil else React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 4,
			testId = "AvatarExperienceHeadRefinement_FacialAnimationDivider"
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_250 else v25.Size.Size_500),
				PaddingRight = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_250 else v25.Size.Size_500),
				PaddingTop = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_150 else v25.Size.Size_300),
				PaddingBottom = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_150 else v25.Size.Size_300)
			}),
			Divider = React.createElement(Divider, {
				Orientation = Enum.FillDirection.Horizontal,
				Size = UDim2.new(1, 0, 0, 1)
			})
		}),
		FacialAnimationToggle = if not FFlagHeadRefinementFacialAnimationToggle or (t1.isLoading or (t1.isFacialAnimationEnabled == nil or t1.onFacialAnimationToggle == nil)) then nil else React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 5,
			testId = "AvatarExperienceHeadRefinement_FacialAnimationToggle"
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_250 else v25.Size.Size_500),
				PaddingRight = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_250 else v25.Size.Size_500),
				PaddingTop = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_150 else v25.Size.Size_300),
				PaddingBottom = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_150 else v25.Size.Size_300)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v25.Global.Size_200 else v25.Size.Size_400)
			}),
			ToggleWrapper = React.createElement(View, {
				tag = "auto-xy",
				LayoutOrder = 1
			}, {
				Toggle = React.createElement(Toggle, {
					label = "",
					testId = "AvatarExperienceHeadRefinement_FacialAnimationToggleButton",
					isChecked = t1.isFacialAnimationEnabled,
					onActivated = function(b1: boolean) -- line: 387
						-- upvalues: t1 (copy)
						if t1.onFacialAnimationToggle then
							t1.onFacialAnimationToggle(b1)
						end
					end,
					size = InputSize.Medium
				})
			}),
			Label = React.createElement(View, {
				tag = "auto-xy",
				LayoutOrder = 2
			}, {
				StyledTextLabel = React.createElement(StyledTextLabel, {
					automaticSize = Enum.AutomaticSize.XY,
					size = UDim2.new(0, 0, 0, 0),
					text = v26.facialAnimationLabel,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center,
					fontStyle = if not FFlagRenameDeprecatedUIBloxTokens then v25.Semantic.Typography.CaptionBody else v25.Typography.BodySmall,
					colorStyle = if not FFlagRenameDeprecatedUIBloxTokens then v25.Semantic.Color.Text.Default else v25.Color.Content.Default
				})
			})
		})
	})
end

return HeadShapePicker
