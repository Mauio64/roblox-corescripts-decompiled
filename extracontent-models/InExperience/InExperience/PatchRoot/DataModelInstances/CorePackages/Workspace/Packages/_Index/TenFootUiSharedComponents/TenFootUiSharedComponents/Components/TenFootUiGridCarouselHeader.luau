local Parent = script:FindFirstAncestor("TenFootUiSharedComponents").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local Style = require(Parent.Style)
local useDesignTokens = Style.useDesignTokens
local mapTypographyVariantToFontEnum = Style.mapTypographyVariantToFontEnum
local GetTextSize = Style.GetTextSize
local TooltipOrientation = require(Parent.UIBlox).App.Dialog.Enum.TooltipOrientation
local IconWithTooltip = require(Parent.AppBlox).IconWithTooltip
local SharedFlags = require(Parent.SharedFlags)
local GetFFlagTenFootUiSupportSortHeaderTooltip = SharedFlags.GetFFlagTenFootUiSupportSortHeaderTooltip
local GetFFlagTenFootUiSupportSortSubtitle = SharedFlags.GetFFlagTenFootUiSupportSortSubtitle
local vector2 = Vector2.new(1e999, 1e999)

local function TenFootUiGridCarouselHeader(t1: {[any]: any}) -- line: 33
	-- upvalues: useDesignTokens (copy), mapTypographyVariantToFontEnum (copy), GetFFlagTenFootUiSupportSortSubtitle (copy), GetTextSize (copy), vector2 (copy), GetFFlagTenFootUiSupportSortHeaderTooltip (copy), React (copy), Cryo (copy), IconWithTooltip (copy), TooltipOrientation (copy)
	local v16 = useDesignTokens(function(p1) -- line: 34
		-- upvalues: mapTypographyVariantToFontEnum (copy), GetFFlagTenFootUiSupportSortSubtitle (copy)
		return {
			textStyles = {
				Font = mapTypographyVariantToFontEnum(p1.Typography.HeadingSmall),
				TextSize = p1.Typography.HeadingSmall.FontSize,
				LineHeight = p1.Typography.HeadingSmall.LineHeight,
				TextColor3 = p1.Color.Content.Emphasis.Color3,
				TextTransparency = p1.Color.Content.Emphasis.Transparency
			},
			subtitleTextStyles = if not GetFFlagTenFootUiSupportSortSubtitle() then nil else {
				Font = p1.Typography.BodyLarge.Font,
				TextSize = p1.Typography.BodyLarge.FontSize,
				LineHeight = p1.Typography.BodyLarge.LineHeight,
				TextColor3 = p1.Color.Content.Default.Color3
			},
			paddingAboveSubtitle = if not GetFFlagTenFootUiSupportSortSubtitle() then nil else p1.Size.Size_100,
			paddingBottom = p1.Size.Size_400
		}
	end)
	local v17 = t1.margin or 0
	local v18 = GetTextSize(t1.text, v16.textStyles.TextSize, v16.textStyles.Font, vector2)
	local t2 = nil

	if GetFFlagTenFootUiSupportSortHeaderTooltip() or GetFFlagTenFootUiSupportSortSubtitle() then
		t2 = {
			TitleAndTooltipPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v17),
				PaddingRight = UDim.new(0, v17),
				PaddingBottom = if not GetFFlagTenFootUiSupportSortSubtitle() then UDim.new(0, v16.paddingBottom) else nil
			}),
			TitleAndTooltipLayout = if not GetFFlagTenFootUiSupportSortHeaderTooltip() then nil else React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			SortTitleTextLabel = React.createElement("TextLabel", Cryo.Dictionary.join(v16.textStyles, {
				BackgroundTransparency = 1,
				Size = if not GetFFlagTenFootUiSupportSortHeaderTooltip() then UDim2.fromScale(1, 1) else UDim2.new(0, v18.X, 1, 0),
				Text = t1.text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				LayoutOrder = if not GetFFlagTenFootUiSupportSortHeaderTooltip() then nil else 1
			})),
			SortTooltip = if not GetFFlagTenFootUiSupportSortHeaderTooltip() or not t1.tooltipHoverText then nil else React.createElement(IconWithTooltip, {
				triggerPointName = "GameSortTooltip",
				supportTenFootUi = true,
				layoutOrder = 2,
				tooltipOrientation = TooltipOrientation.Right,
				hoverText = t1.tooltipHoverText
			})
		}
	end

	if GetFFlagTenFootUiSupportSortSubtitle() then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v18.Y + v16.paddingBottom + ((not t1.subtitleText or not t1.subtitleHeight) and 0 or t1.subtitleHeight) + (not t1.subtitleText and 0 or v16.paddingAboveSubtitle))
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v17),
				PaddingRight = UDim.new(0, v17),
				PaddingBottom = UDim.new(0, v16.paddingBottom)
			}),
			HeaderLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v16.paddingAboveSubtitle)
			}),
			TitleAndTooltipFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v18.Y)
			}, t2),
			SubtitleTextLabel = if not t1.subtitleText then nil else React.createElement("TextLabel", Cryo.Dictionary.join(v16.subtitleTextStyles, {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.fromScale(1, 1),
				Text = t1.subtitleText,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			}))
		})
	end

	if GetFFlagTenFootUiSupportSortHeaderTooltip() then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v18.Y + v16.paddingBottom)
		}, t2)
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v18.Y + v16.paddingBottom)
	}, React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, v17),
		PaddingRight = UDim.new(0, v17),
		PaddingBottom = UDim.new(0, v16.paddingBottom)
	}), React.createElement("TextLabel", Cryo.Dictionary.join(v16.textStyles, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Text = t1.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top
	})))
end

return TenFootUiGridCarouselHeader
