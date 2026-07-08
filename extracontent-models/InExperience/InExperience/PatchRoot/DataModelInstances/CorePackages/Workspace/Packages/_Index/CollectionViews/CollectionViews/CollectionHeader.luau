local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)
local Cryo = require(CollectionViewsParent.Cryo)
local UIBlox = require(CollectionViewsParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local useDesignTokens = require(CollectionViewsParent.Style).useDesignTokens
local IconWithTooltip = require(CollectionViewsParent.AppBlox).IconWithTooltip
local Responsive = require(CollectionViewsParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local checkAndFormatPossibleLink = require(CollectionViews.checkAndFormatPossibleLink)

require(CollectionViews.SeeAllButtonType_Legacy)

local SharedFlags = require(CollectionViewsParent.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagLuaAppHideCarouselSubtitleChevron = SharedFlags.FFlagLuaAppHideCarouselSubtitleChevron
local FFlagLuaAppSortHeaderAnchorTag = SharedFlags.FFlagLuaAppSortHeaderAnchorTag
local v18 = Images["icons/actions/truncationCollapse_small"]
local v19 = Images["icons/actions/cycleRight"]
local t1 = {
	tooltipSupportsVR = true,
	tooltipSupportsTenFootUi = true,
	AutomaticSize = Enum.AutomaticSize.Y,
	Size = UDim2.new(1, 0, 0, 0)
}

local function HeaderButton(t2: {[any]: any}) -- line: 89
	-- upvalues: useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), React (copy), ImageSetLabel (copy)
	local v24 = useDesignTokens()
	local v25 = if not FFlagRenameDeprecatedUIBloxTokens then v24.Global.Size_200 else v24.Size.Size_400
	local v26 = if not FFlagRenameDeprecatedUIBloxTokens then v24.Semantic.Color.Text.Emphasis else v24.Color.Content.Emphasis
	local image = t2.image

	return React.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Size = t2.Size or UDim2.new(0, v25, 0, v25),
		Image = image,
		ImageColor3 = v26.Color3,
		ImageTransparency = v26.Transparency,
		LayoutOrder = t2.LayoutOrder,
		Rotation = t2.Rotation,
		AnchorPoint = t2.AnchorPoint,
		Position = t2.Position
	})
end
local function CollectionHeader(t3: {[any]: any}) -- line: 121
	-- upvalues: Cryo (copy), t1 (copy), React (copy), usePreferredInput (copy), useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Responsive (copy), checkAndFormatPossibleLink (copy), FFlagLuaAppHideCarouselSubtitleChevron (copy), FFlagLuaAppSortHeaderAnchorTag (copy), HeaderButton (copy), v19 (copy), v18 (copy), IconWithTooltip (copy), TooltipOrientation (copy)
	local v29 = Cryo.Dictionary.join(t1, t3)
	local v30, v31 = React.useBinding(0)
	local v32 = React.useCallback(function(p1) -- line: 125
		-- upvalues: v31 (copy)
		v31(p1.AbsoluteSize.X)
	end, {})
	local v33 = usePreferredInput()
	local v34 = useDesignTokens()
	local v35 = v29.titleTypography or if not FFlagRenameDeprecatedUIBloxTokens then v34.Semantic.Typography.Header else v34.Typography.HeadingSmall
	local v36 = v29.titleColor or if not FFlagRenameDeprecatedUIBloxTokens then v34.Semantic.Color.Text.Emphasis else v34.Color.Content.Emphasis
	local v37 = v29.subtitleTypography or if not FFlagRenameDeprecatedUIBloxTokens then v34.Semantic.Typography.CaptionBody else v34.Typography.BodySmall
	local v38 = v29.subtitleTypography and v29.subtitleTypography.FontSize or 17.64 * if not FFlagRenameDeprecatedUIBloxTokens then v34.Global.Stroke_100 else v34.Stroke.Standard
	local v39 = v29.subtitleColor or if not FFlagRenameDeprecatedUIBloxTokens then v34.Semantic.Color.Text.Default else v34.Color.Content.Default
	local v40 = if not FFlagRenameDeprecatedUIBloxTokens then v34.Global.Space_25 else v34.Size.Size_50
	local v41 = if not FFlagRenameDeprecatedUIBloxTokens then v34.Global.Space_150 else v34.Size.Size_300
	local v42 = not not (not v29.hideButton and v33 ~= Responsive.Input.Directional) and not not v29.onActivate
	local v43 = if not FFlagRenameDeprecatedUIBloxTokens then v34.Global.Size_350 else v34.Size.Size_700
	local v44 = if not FFlagRenameDeprecatedUIBloxTokens then v34.Global.Space_50 else v34.Size.Size_100
	local v45 = if not FFlagRenameDeprecatedUIBloxTokens then v34.Global.Size_250 else v34.Size.Size_500
	local v46 = v29.tooltipInfoText ~= nil
	local v47 = not v42 and 0 or v45
	local v48 = not v46 and 0 or v43 + v41
	local v49 = not v46 and 0 or v48
	local v50 = v29.subtitle ~= nil and v29.subtitle ~= ""
	local v51, v52 = checkAndFormatPossibleLink(v29.subtitle)
	local v53 = if not v29.onActivateSubtitle then v29.onActivate else v29.onActivateSubtitle

	if v29.onActivateSubtitle then
		v51 = true
	end

	local v54 = if not FFlagLuaAppHideCarouselSubtitleChevron then nil else v51 and (not v29.hideSubtitleChevron and not v42)
	local v55 = if not FFlagRenameDeprecatedUIBloxTokens then v34.Global.Size_125 else v34.Size.Size_250
	local v56 = not (if not FFlagLuaAppHideCarouselSubtitleChevron then v51 else v54) and 0 or v55
	local v57 = v51 and v53 ~= nil

	return React.createElement("Frame", {
		Position = v29.Position,
		AutomaticSize = v29.AutomaticSize,
		Size = v29.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = v29.LayoutOrder,
		ZIndex = v29.ZIndex,
		[React.Tag] = if not FFlagLuaAppSortHeaderAnchorTag then nil else v29.headerTag,
		[React.Change.AbsoluteSize] = v32
	}, {
		LeftContentFrame = React.createElement(not v42 and "Frame" or "TextButton", {
			Text = if not v42 then nil else "",
			Size = UDim2.new(1, -v49, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			AnchorPoint = v29.AnchorPoint,
			BorderSizePixel = 0,
			AutoButtonColor = not v42 and nil,
			[React.Event.Activated] = if not v42 then nil else v29.onActivate,
			Active = v42,
			Selectable = v42
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v40),
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			TitleContainer = React.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, v44),
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				Title = if typeof(v29.title) ~= "string" then if typeof(v29.title) ~= "function" then nil else v29.title() else React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextWrapped = false,
					LayoutOrder = 1,
					Text = v29.title,
					AutomaticSize = Enum.AutomaticSize.XY,
					Size = UDim2.new(0, 0, 0, 0),
					Font = v35.Font,
					TextSize = v35.FontSize,
					TextTransparency = v36.Transparency,
					TextColor3 = v36.Color3,
					TextTruncate = Enum.TextTruncate.SplitWord,
					TextXAlignment = Enum.TextXAlignment.Left
				}, {
					UISizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = v30:map(function(n1: number) -- line: 283
							-- upvalues: v47 (copy), v48 (copy)
							local v60 = n1 - v47 - v48

							if v60 > 0 then
								return Vector2.new(v60, 1e999)
							end

							return nil
						end)
					})
				}),
				SeeAllButton = v42 and React.createElement(HeaderButton, {
					LayoutOrder = 2,
					Size = UDim2.fromOffset(v45, v45),
					image = v19
				}) or nil
			}),
			SubtitleFrame = v50 and React.createElement(not v57 and "Frame" or "TextButton", {
				LayoutOrder = 2,
				Text = if not v57 then nil else "",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutoButtonColor = not v57 and nil,
				[React.Event.Activated] = if not v57 then nil else v53,
				Active = v57,
				Selectable = v57
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v34.Global.Size_25 else v34.Size.Size_50),
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				Subtitle = React.createElement("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					TextWrapped = false,
					Text = v52,
					AutomaticSize = Enum.AutomaticSize.XY,
					Size = UDim2.new(0, 0, 0, 0),
					Font = v37.Font,
					TextSize = v38,
					TextTransparency = v36.Transparency,
					TextColor3 = v39.Color3,
					TextTruncate = Enum.TextTruncate.SplitWord,
					TextXAlignment = Enum.TextXAlignment.Left,
					RichText = v51
				}, {
					UISizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = v30:map(function(n2: number) -- line: 342
							-- upvalues: v56 (copy)
							local v62 = n2 - v56

							if v62 > 0 then
								return Vector2.new(v62, 1e999)
							end

							return nil
						end)
					})
				}),
				SubtitleLinkArrow = ((if not FFlagLuaAppHideCarouselSubtitleChevron then v51 and not v42 else v54)) and React.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Size = UDim2.fromOffset(v56, v56)
				}, {
					Icon = React.createElement(HeaderButton, {
						Rotation = 90,
						image = v18,
						Size = UDim2.new(1, if not FFlagRenameDeprecatedUIBloxTokens then v34.Global.Size_25 else v34.Size.Size_50, 1, if not FFlagRenameDeprecatedUIBloxTokens then v34.Global.Size_25 else v34.Size.Size_50),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				}) or nil
			}) or nil
		}),
		IconWithTooltip = v46 and React.createElement(IconWithTooltip, {
			triggerPointName = "IconWithTooltip",
			tooltipOrientation = TooltipOrientation.Bottom,
			hoverText = v29.tooltipInfoText,
			onActivateTooltip = v29.onActivateInfoIcon,
			supportVR = v29.tooltipSupportsVR,
			supportTenFootUi = v29.tooltipSupportsTenFootUi,
			size = UDim2.new(0, v43, 0, v43),
			position = if not v50 then UDim2.new(1, 0, 0.5, 0) else UDim2.new(1, 0, 0, 0),
			anchorPoint = if not v50 then Vector2.new(1, 0.5) else Vector2.new(1, 0)
		}) or nil
	})
end

return React.memo(CollectionHeader)
