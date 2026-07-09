local AvatarExperienceSearch = script:FindFirstAncestor("AvatarExperienceSearch")
local AvatarExperienceSearchParent = AvatarExperienceSearch.Parent
local React = require(AvatarExperienceSearchParent.React)
local UIBlox = require(AvatarExperienceSearchParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(AvatarExperienceSearchParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useDesignTokens = require(AvatarExperienceSearchParent.Style).useDesignTokens
local FlexLayout = require(AvatarExperienceSearch.Components.FlexLayout)
local SuggestedItemTypeEnum = require(AvatarExperienceSearch.Enums.SuggestedItemTypeEnum)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind

local function mapTokens(p1) -- line: 22
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return {
		barBackgroundColor = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Background.Default else p1.Color.Surface.Surface_0)).Color3,
		barBackgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Background.Default else p1.Color.Surface.Surface_0)).Transparency,
		barHeight = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_700 else p1.Size.Size_1400,
		iconAndTextInputMargin = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_200 else p1.Size.Size_400,
		iconOffsetX = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_50 else p1.Size.Size_100,
		iconContainerSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_400 else p1.Size.Size_800,
		textColorGroup = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Text.Emphasis else p1.Color.Content.Emphasis,
		textFontGroup = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Typography.Body else p1.Typography.BodyLarge,
		textIconColor = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Text.Emphasis else p1.Color.Content.Emphasis)).Color3,
		textIconTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Text.Emphasis else p1.Color.Content.Emphasis)).Transparency,
		textSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Typography.Body.FontSize else p1.Typography.BodyLarge.FontSize,
		trailingIconSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_200 else p1.Size.Size_400,
		autocompleteIconSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_300 else p1.Size.Size_600,
		recentIconSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_400 else p1.Size.Size_800
	}
end
local function getIconMap(p2) -- line: 61
	-- upvalues: Images (copy)
	return {
		recent = {
			icon = Images["icons/menu/recent"],
			size = p2.recentIconSize
		},
		autocomplete = {
			icon = Images["icons/common/search"],
			size = p2.autocompleteIconSize
		}
	}
end
local function getDisplayProps(p3, p4) -- line: 74
	-- upvalues: getIconMap (copy), SuggestedItemTypeEnum (copy)
	local v23 = getIconMap(p4)
	local icon = nil
	local size = nil

	if p3 == SuggestedItemTypeEnum.Recent then
		return v23.recent.icon, v23.recent.size, true
	end

	if p3 == SuggestedItemTypeEnum.Autocomplete then
		icon = v23.autocomplete.icon
		size = v23.autocomplete.size
	end

	return icon, size, false
end
local function SuggestedItem(p5, p6) -- line: 104
	-- upvalues: useDesignTokens (copy), mapTokens (copy), getIconMap (copy), SuggestedItemTypeEnum (copy), useSelectionCursor (copy), CursorKind (copy), React (copy), FlexLayout (copy), ImageSetLabel (copy), StyledTextLabel (copy), ImageSetButton (copy), Images (copy)
	local v28 = useDesignTokens(mapTokens)
	local v29 = p5.height or v28.barHeight
	local text = p5.text
	local type = p5.type
	local v32 = getIconMap(v28)
	local icon = nil
	local size = nil
	local v35 = false

	if type == SuggestedItemTypeEnum.Recent then
		icon = v32.recent.icon
		size = v32.recent.size
		v35 = true
	elseif type == SuggestedItemTypeEnum.Autocomplete then
		icon = v32.autocomplete.icon
		size = v32.autocomplete.size
	end

	local v36 = useSelectionCursor(CursorKind.RoundedRect)
	local v37 = useSelectionCursor(CursorKind.RoundedRectNoInset)
	local FontSize = v28.textFontGroup.FontSize

	local function onActivate() -- line: 117
		-- upvalues: p5 (copy)
		p5.onActivate()
	end
	local function onTrailingButtonActivate() -- line: 121
		-- upvalues: p5 (copy)
		if p5.onTrailingButtonActivate then
			p5.onTrailingButtonActivate()
		end
	end

	return React.createElement(FlexLayout, {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, v29),
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = v28.barBackgroundColor,
		BackgroundTransparency = v28.barBackgroundTransparency,
		LayoutOrder = p5.layoutOrder,
		margin = v28.iconOffsetX,
		flexSlot = React.createElement("ImageButton", {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			[React.Event.Activated] = onActivate,
			[React.Tag] = "data-testid=AvatarExperienceSearch_SuggestedItem_ImageButton",
			SelectionImageObject = v37,
			ref = p6
		}, {
			ButtonChildren = React.createElement(FlexLayout, {
				reverse = true,
				margin = v28.iconOffsetX,
				rigidSlot = React.createElement("Frame", {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.fromOffset(v28.iconContainerSize, v28.iconContainerSize),
					Position = UDim2.new(0, 0, 0.5, 0)
				}, {
					SuggestedItemLeadingIcon = React.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Image = icon,
						ImageColor3 = v28.textIconColor,
						ImageTransparency = v28.textIconTransparency,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.fromOffset(size, size)
					})
				}),
				flexSlot = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v29)
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					TextLabel = React.createElement(StyledTextLabel, {
						textWrapped = false,
						fontStyle = v28.textFontGroup,
						colorStyle = v28.textColorGroup,
						text = text or "",
						textTruncate = Enum.TextTruncate.AtEnd,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Top,
						automaticSize = Enum.AutomaticSize.X,
						size = UDim2.new(1, 0, 0, FontSize)
					})
				})
			})
		}),
		rigidSlot = if not v35 then nil else React.createElement(ImageSetButton, {
			AnchorPoint = Vector2.new(0, 0.5),
			Image = Images["icons/navigation/close_small"],
			ImageColor3 = v28.textIconColor,
			ImageTransparency = v28.textIconTransparency,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.fromOffset(v28.trailingIconSize, v28.trailingIconSize),
			[React.Event.Activated] = onTrailingButtonActivate,
			[React.Tag] = "data-testid=AvatarExperienceSearch_SuggestedItem_TrailingButton",
			SelectionImageObject = v36
		})
	})
end

return React.forwardRef(SuggestedItem)
