local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Foundation2 = require(parent.Foundation)
local normalizeFontFace = Foundation2.Utility.normalizeFontFace
local AppBlox = require(parent.AppBlox)
local IconWithTooltip = AppBlox.IconWithTooltip
local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local checkAndFormatPossibleLink = require(CollectionViews.checkAndFormatPossibleLink)
require(CollectionViews.SeeAllButtonType_Legacy)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSortHeaderAnchorTag = SharedFlags.FFlagLuaAppSortHeaderAnchorTag
local FFlagSduiComponentsUseFoundationTokens = SharedFlags.FFlagSduiComponentsUseFoundationTokens

local iconsactionstruncationCollapse_small = Images["icons/actions/truncationCollapse_small"]
local iconsactionscycleRight = Images["icons/actions/cycleRight"]

local v = {
	AutomaticSize = Enum.AutomaticSize.Y,
	Size = UDim2.new(1, 0, 0, 0),
	tooltipSupportsVR = true,
	tooltipSupportsTenFootUi = true
}

local function HeaderButton(props)
	local v2

	if FFlagSduiComponentsUseFoundationTokens then
		v2 = useTokens()
	else
		v2 = useDesignTokens()
	end

	local size_400 = v2.Size.Size_400
	local emphasis = v2.Color.Content.Emphasis
	local image = props.image
	return React.createElement(ImageSetLabel, {
		Size = props.Size or UDim2.new(0, size_400, 0, size_400),
		BackgroundTransparency = 1,
		Image = image,
		ImageColor3 = emphasis.Color3,
		ImageTransparency = emphasis.Transparency,
		LayoutOrder = props.LayoutOrder,
		Rotation = props.Rotation,
		AnchorPoint = props.AnchorPoint,
		Position = props.Position
	})
end

local function CollectionHeader(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2, v3 = React.useBinding(0)
	local v4 = React.useCallback(function(p2)
		v3(p2.AbsoluteSize.X)
	end, {})

	local v5 = usePreferredInput()
	local v6

	if FFlagSduiComponentsUseFoundationTokens then
		v6 = useTokens()
	else
		v6 = useDesignTokens()
	end

	local titleTypography = joined.titleTypography or v6.Typography.HeadingSmall
	local titleColor = joined.titleColor or v6.Color.Content.Emphasis

	local subtitleTypography = joined.subtitleTypography or v6.Typography.BodySmall

	local fontSize = joined.subtitleTypography and joined.subtitleTypography.FontSize or 17.64 * v6.Stroke.Standard
	local subtitleColor = joined.subtitleColor or v6.Color.Content.Default

	local size_50 = v6.Size.Size_50

	local size_300 = v6.Size.Size_300

	local v7 = not joined.hideButton and v5 ~= Responsive.Input.Directional and joined.onActivate and true or false

	local size_700 = v6.Size.Size_700

	local size_100 = v6.Size.Size_100

	local size_500 = v6.Size.Size_500

	local v8 = joined.tooltipInfoText ~= nil
	local v9 = not v7 and 0 or size_500
	local v10 = not v8 and 0 or size_700 + size_300
	local v11

	if joined.subtitle == nil then
		v11 = false
	else
		v11 = joined.subtitle ~= ""
	end

	local v12, text = checkAndFormatPossibleLink(joined.subtitle)
	local v13

	if joined.onActivateSubtitle then
		v13 = joined.onActivateSubtitle
	else
		v13 = joined.onActivate
	end

	local richText = joined.onActivateSubtitle and true or v12

	local v14 = richText and not (joined.hideSubtitleChevron or v7)
	local size_250 = v6.Size.Size_250
	local v15 = not v14 and 0 or size_250
	local v16 = richText and v13 ~= nil
	local createElement = React.createElement
	local v17 = {
		["Position"] = nil,
		["Position"] = nil,
		Position = joined.Position,
		AutomaticSize = joined.AutomaticSize,
		Size = joined.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = joined.LayoutOrder,
		ZIndex = joined.ZIndex
	}
	local tag = React.Tag
	local v18

	if FFlagLuaAppSortHeaderAnchorTag then
		v18 = joined.headerTag
	end

	v17[tag] = v18
	v17[React.Change.AbsoluteSize] = v4

	local createElement2 = React.createElement
	local v19 = {}
	v19.Text = v7 and "" or nil
	v19.Size = UDim2.new(1, -(not v8 and 0 or v10), 0, 0)
	v19.AutomaticSize = Enum.AutomaticSize.Y
	v19.BackgroundTransparency = 1
	v19.AnchorPoint = joined.AnchorPoint
	v19.BorderSizePixel = 0
	v19.AutoButtonColor = not v7 and nil
	local activated = React.Event.Activated
	local v20

	if v7 then
		v20 = joined.onActivate
	end

	v19[activated] = v20
	v19.Active = v7
	v19.Selectable = v7
	local v21 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, size_50),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		TitleContainer = 0,
		SubtitleFrame = 0
	}

	local createElement3 = React.createElement
	local v22 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v24 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, size_100),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Title = 0,
		SeeAllButton = 0
	}
	local title

	if typeof(joined.title) == "string" then
		title = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = joined.title,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.new(0, 0, 0, 0),
			FontFace = normalizeFontFace(titleTypography.Font),
			TextSize = titleTypography.FontSize,
			TextTransparency = titleColor.Transparency,
			TextColor3 = titleColor.Color3,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 1
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = v2:map(function(p2: number)
					local v23 = p2 - v9 - v10

					if v23 > 0 then
						return Vector2.new(v23, 1e999)
					end

					return nil
				end)
			})
		})
	elseif typeof(joined.title) == "function" then
		title = joined.title()
	end

	v24.Title = title

	v24.SeeAllButton = v7
		and React.createElement(HeaderButton, {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(size_500, size_500),
			image = iconsactionscycleRight
		})
		or nil
	v21.TitleContainer = createElement3("Frame", v22, v24)
	local subtitleFrame

	if v11 then
		local createElement4 = React.createElement
		local v23 = {}
		v23.LayoutOrder = 2
		v23.Text = v16 and "" or nil
		v23.Size = UDim2.new(1, 0, 0, 0)
		v23.AutomaticSize = Enum.AutomaticSize.Y
		v23.BackgroundTransparency = 1
		v23.BorderSizePixel = 0
		v23.AutoButtonColor = not v16 and nil
		local activated2 = React.Event.Activated

		if not v16 then
			v13 = nil
		end

		v23[activated2] = v13
		v23.Active = v16
		v23.Selectable = v16
		subtitleFrame = createElement4(v16 and "TextButton" or "Frame", v23, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v6.Size.Size_50),
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Subtitle = React.createElement("TextLabel", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Text = text,
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.new(0, 0, 0, 0),
				FontFace = normalizeFontFace(subtitleTypography.Font),
				TextSize = fontSize,
				TextTransparency = titleColor.Transparency,
				TextColor3 = subtitleColor.Color3,
				TextWrapped = false,
				TextTruncate = Enum.TextTruncate.SplitWord,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = richText
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = v2:map(function(p2: number)
						local v25 = p2 - v15

						if v25 > 0 then
							return Vector2.new(v25, 1e999)
						end

						return nil
					end)
				})
			}),
			SubtitleLinkArrow = v14 and React.createElement(
				"Frame",
				{
					LayoutOrder = 2,
					Size = UDim2.fromOffset(v15, v15),
					BackgroundTransparency = 1,
					ClipsDescendants = true
				},
				{
					Icon = React.createElement(HeaderButton, {
						image = iconsactionstruncationCollapse_small,
						Size = UDim2.new(1, v6.Size.Size_50, 1, v6.Size.Size_50),
						Rotation = 90,
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				}
			) or nil
		}) or nil
	end

	v21.SubtitleFrame = subtitleFrame
	local v23 = {
		LeftContentFrame = createElement2(v7 and "TextButton" or "Frame", v19, v21),
		IconWithTooltip = 0
	}
	local iconWithTooltip

	if v8 then
		local createElement4 = React.createElement
		local v25 = {
			tooltipOrientation = TooltipOrientation.Bottom,
			hoverText = joined.tooltipInfoText,
			triggerPointName = "IconWithTooltip",
			onActivateTooltip = joined.onActivateInfoIcon,
			supportVR = joined.tooltipSupportsVR,
			supportTenFootUi = joined.tooltipSupportsTenFootUi,
			size = UDim2.new(0, size_700, 0, size_700),
			position = 0,
			anchorPoint = 0
		}
		local position

		if v11 then
			position = UDim2.new(1, 0, 0, 0)
		else
			position = UDim2.new(1, 0, 0.5, 0)
		end

		v25.position = position
		local anchorPoint

		if v11 then
			anchorPoint = Vector2.new(1, 0)
		else
			anchorPoint = Vector2.new(1, 0.5)
		end

		v25.anchorPoint = anchorPoint
		iconWithTooltip = createElement4(IconWithTooltip, v25) or nil
	end

	v23.IconWithTooltip = iconWithTooltip
	return createElement("Frame", v17, v23)
end

return React.memo(CollectionHeader)
