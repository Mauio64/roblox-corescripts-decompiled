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
local FFlagLuaAppHideCarouselSubtitleChevron = SharedFlags.FFlagLuaAppHideCarouselSubtitleChevron
local FFlagLuaAppSortHeaderAnchorTag = SharedFlags.FFlagLuaAppSortHeaderAnchorTag
local v17 = Images["icons/actions/truncationCollapse_small"]
local v18 = Images["icons/actions/cycleRight"]
local t1 = {
	tooltipSupportsVR = true,
	tooltipSupportsTenFootUi = true,
	AutomaticSize = Enum.AutomaticSize.Y,
	Size = UDim2.new(1, 0, 0, 0)
}

local function HeaderButton(t2: {[any]: any}) -- line: 88
	-- upvalues: useDesignTokens (copy), React (copy), ImageSetLabel (copy)
	local v23 = useDesignTokens()
	local Size_400 = v23.Size.Size_400
	local Emphasis = v23.Color.Content.Emphasis
	local image = t2.image

	return React.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Size = t2.Size or UDim2.new(0, Size_400, 0, Size_400),
		Image = image,
		ImageColor3 = Emphasis.Color3,
		ImageTransparency = Emphasis.Transparency,
		LayoutOrder = t2.LayoutOrder,
		Rotation = t2.Rotation,
		AnchorPoint = t2.AnchorPoint,
		Position = t2.Position
	})
end
local function CollectionHeader(t3: {[any]: any}) -- line: 115
	-- upvalues: Cryo (copy), t1 (copy), React (copy), usePreferredInput (copy), useDesignTokens (copy), Responsive (copy), checkAndFormatPossibleLink (copy), FFlagLuaAppHideCarouselSubtitleChevron (copy), FFlagLuaAppSortHeaderAnchorTag (copy), HeaderButton (copy), v18 (copy), v17 (copy), IconWithTooltip (copy), TooltipOrientation (copy)
	local v28 = Cryo.Dictionary.join(t1, t3)
	local v29, v30 = React.useBinding(0)
	local v31 = React.useCallback(function(p1) -- line: 119
		-- upvalues: v30 (copy)
		v30(p1.AbsoluteSize.X)
	end, {})
	local v32 = usePreferredInput()
	local v33 = useDesignTokens()
	local v34 = v28.titleTypography or v33.Typography.HeadingSmall
	local v35 = v28.titleColor or v33.Color.Content.Emphasis
	local v36 = v28.subtitleTypography or v33.Typography.BodySmall
	local v37 = v28.subtitleTypography and v28.subtitleTypography.FontSize or 17.64 * v33.Stroke.Standard
	local v38 = v28.subtitleColor or v33.Color.Content.Default
	local Size_50 = v33.Size.Size_50
	local Size_300 = v33.Size.Size_300
	local v41 = not not (not v28.hideButton and v32 ~= Responsive.Input.Directional) and not not v28.onActivate
	local Size_700 = v33.Size.Size_700
	local Size_100 = v33.Size.Size_100
	local Size_500 = v33.Size.Size_500
	local v45 = v28.tooltipInfoText ~= nil
	local v46 = not v41 and 0 or Size_500
	local v47 = not v45 and 0 or Size_700 + Size_300
	local v48 = not v45 and 0 or v47
	local v49 = v28.subtitle ~= nil and v28.subtitle ~= ""
	local v50, v51 = checkAndFormatPossibleLink(v28.subtitle)
	local v52 = if not v28.onActivateSubtitle then v28.onActivate else v28.onActivateSubtitle

	if v28.onActivateSubtitle then
		v50 = true
	end

	local v53 = if not FFlagLuaAppHideCarouselSubtitleChevron then nil else v50 and (not v28.hideSubtitleChevron and not v41)
	local Size_250 = v33.Size.Size_250
	local v55 = not (if not FFlagLuaAppHideCarouselSubtitleChevron then v50 else v53) and 0 or Size_250
	local v56 = v50 and v52 ~= nil

	return React.createElement("Frame", {
		Position = v28.Position,
		AutomaticSize = v28.AutomaticSize,
		Size = v28.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = v28.LayoutOrder,
		ZIndex = v28.ZIndex,
		[React.Tag] = if not FFlagLuaAppSortHeaderAnchorTag then nil else v28.headerTag,
		[React.Change.AbsoluteSize] = v31
	}, {
		LeftContentFrame = React.createElement(not v41 and "Frame" or "TextButton", {
			Text = if not v41 then nil else "",
			Size = UDim2.new(1, -v48, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			AnchorPoint = v28.AnchorPoint,
			BorderSizePixel = 0,
			AutoButtonColor = not v41 and nil,
			[React.Event.Activated] = if not v41 then nil else v28.onActivate,
			Active = v41,
			Selectable = v41
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, Size_50),
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
					Padding = UDim.new(0, Size_100),
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				Title = if typeof(v28.title) ~= "string" then if typeof(v28.title) ~= "function" then nil else v28.title() else React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextWrapped = false,
					LayoutOrder = 1,
					Text = v28.title,
					AutomaticSize = Enum.AutomaticSize.XY,
					Size = UDim2.new(0, 0, 0, 0),
					Font = v34.Font,
					TextSize = v34.FontSize,
					TextTransparency = v35.Transparency,
					TextColor3 = v35.Color3,
					TextTruncate = Enum.TextTruncate.SplitWord,
					TextXAlignment = Enum.TextXAlignment.Left
				}, {
					UISizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = v29:map(function(n1: number) -- line: 245
							-- upvalues: v46 (copy), v47 (copy)
							local v59 = n1 - v46 - v47

							if v59 > 0 then
								return Vector2.new(v59, 1e999)
							end

							return nil
						end)
					})
				}),
				SeeAllButton = v41 and React.createElement(HeaderButton, {
					LayoutOrder = 2,
					Size = UDim2.fromOffset(Size_500, Size_500),
					image = v18
				}) or nil
			}),
			SubtitleFrame = v49 and React.createElement(not v56 and "Frame" or "TextButton", {
				LayoutOrder = 2,
				Text = if not v56 then nil else "",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutoButtonColor = not v56 and nil,
				[React.Event.Activated] = if not v56 then nil else v52,
				Active = v56,
				Selectable = v56
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, v33.Size.Size_50),
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				Subtitle = React.createElement("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					TextWrapped = false,
					Text = v51,
					AutomaticSize = Enum.AutomaticSize.XY,
					Size = UDim2.new(0, 0, 0, 0),
					Font = v36.Font,
					TextSize = v37,
					TextTransparency = v35.Transparency,
					TextColor3 = v38.Color3,
					TextTruncate = Enum.TextTruncate.SplitWord,
					TextXAlignment = Enum.TextXAlignment.Left,
					RichText = v50
				}, {
					UISizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = v29:map(function(n2: number) -- line: 299
							-- upvalues: v55 (copy)
							local v61 = n2 - v55

							if v61 > 0 then
								return Vector2.new(v61, 1e999)
							end

							return nil
						end)
					})
				}),
				SubtitleLinkArrow = ((if not FFlagLuaAppHideCarouselSubtitleChevron then v50 and not v41 else v53)) and React.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Size = UDim2.fromOffset(v55, v55)
				}, {
					Icon = React.createElement(HeaderButton, {
						Rotation = 90,
						image = v17,
						Size = UDim2.new(1, v33.Size.Size_50, 1, v33.Size.Size_50),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				}) or nil
			}) or nil
		}),
		IconWithTooltip = v45 and React.createElement(IconWithTooltip, {
			triggerPointName = "IconWithTooltip",
			tooltipOrientation = TooltipOrientation.Bottom,
			hoverText = v28.tooltipInfoText,
			onActivateTooltip = v28.onActivateInfoIcon,
			supportVR = v28.tooltipSupportsVR,
			supportTenFootUi = v28.tooltipSupportsTenFootUi,
			size = UDim2.new(0, Size_700, 0, Size_700),
			position = if not v49 then UDim2.new(1, 0, 0.5, 0) else UDim2.new(1, 0, 0, 0),
			anchorPoint = if not v49 then Vector2.new(1, 0.5) else Vector2.new(1, 0)
		}) or nil
	})
end

return React.memo(CollectionHeader)
