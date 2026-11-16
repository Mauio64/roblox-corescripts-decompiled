local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local focusable = RoactGamepad.Focusable
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local module = require("@luauforge/bundled/dMx")
local module2 = require("@luauforge/deferred/gVg")
local module3 = require("@luauforge/bundled/fuD")

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle

local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.5, 1),
	NumberSequenceKeypoint.new(1, 0.1)
})

local extended = Roact.PureComponent:extend("PageButton")

extended.validateProps = t.strictInterface({
	Size = t.UDim2,
	backgroundImage = t.string,
	icon = t.union(t.string, t.table),
	text = t.string,
	transparencyModifier = t.number,
	onActivated = t.callback,
	getThumbnail = t.optional(t.callback),
	thumbnailImageYInsetScale = t.optional(t.number),
	thumbnailImage = t.optional(t.string),
	thumbnailSize = t.optional(t.integer),
	thumbnailScaleOffset = t.optional(t.Vector2),
	ignoreThumbnail = t.optional(t.boolean),
	thumbnailZoom = t.optional(t.number),
	extraThumbnails = t.optional(t.array(t.strictInterface({
		side = module2.isEnumValue,
		image = t.string,
		imageRectSize = t.optional(t.Vector2),
		imageRectOffset = t.optional(t.Vector2),
		paddingTopScale = t.optional(t.number),
		paddingBottomScale = t.optional(t.number),
		paddingSideScale = t.optional(t.number)
	}))),
	iconBeforeText = t.optional(t.boolean),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	[Roact.Children] = t.optional(t.table),
	forwardRef = t.optional(t.table),
	dropShadowTransparency = t.optional(t.number),
	dropShadowOffset = t.optional(t.Vector2),
	dropShadowColor = t.optional(t.Color3)
})

extended.defaultProps = {
	transparencyModifier = 0,
	thumbnailScaleOffset = Vector2.new(0, 0),
	thumbnailZoom = 1,
	dropShadowTransparency = 0.6,
	dropShadowOffset = Vector2.new(2, 2),
	dropShadowColor = Color3.new(0, 0, 0)
}

function extended:calculateShadowPosition(p3)
	return UDim2.new(self.props.dropShadowOffset.X / p3.X, 0, 1 + self.props.dropShadowOffset.Y / p3.Y, 0)
end

function extended:init()
	local binding, v6 = Roact.createBinding(Vector2.new(1, 1))
	self.buttonSize = binding
	self.updateButtonSize = v6
	self:setState({ imageButtonWidth = 0 })
end

function extended:renderSideThumbnail(p3)
	if not self.props.extraThumbnails then
		return nil
	end

	local v6 = nil

	for k, extraThumbnail in self.props.extraThumbnails do
		if extraThumbnail.side == p3 then
			v6 = extraThumbnail
			break
		end
	end

	if not v6 then
		return nil
	end

	local vector2, udim

	if p3 == module2.Left then
		vector2 = Vector2.new(0, 0)
		udim = UDim2.fromScale(v6.paddingSideScale, v6.paddingTopScale)
	else
		vector2 = Vector2.new(1, 0)
		udim = UDim2.fromScale(1 - v6.paddingSideScale, v6.paddingTopScale)
	end

	return Roact.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Image = v6.image,
		ImageRectSize = v6.imageRectSize,
		ImageRectOffset = v6.imageRectOffset,
		AnchorPoint = vector2,
		Position = udim,
		Size = self.buttonSize:map(function(p4)
			local v8 = p4.Y * (1 - v6.paddingTopScale - v6.paddingBottomScale)
			local v9 = v6.imageRectSize.X * v8 / v6.imageRectSize.Y
			return UDim2.fromOffset(v9, v8)
		end)
	})
end

function extended:calcNormalizedSize(p3, p4)
	if p3.X > p3.Y then
		return Vector2.new(p4 * p3.Y / p3.X, p4)
	end

	return Vector2.new(p4, p4 * p3.X / p3.Y)
end

function extended:shouldUseImageRectSizeAndOffset()
	return self.props.thumbnailZoom > 1 and self.props.thumbnailSize
end

function extended:renderThumbnail()
	if self.props.ignoreThumbnail then
		return nil
	end

	local thumbnailImage = self.props.thumbnailImage
	local getThumbnail = self.props.getThumbnail

	local transparencyModifier = self.props.transparencyModifier
	local thumbnailPosition = self:getThumbnailPosition()
	local thumbnailSize = self:getThumbnailSize()
	local thumbnailImageRectOffset = self:getThumbnailImageRectOffset()
	local thumbnailImageRectSize = self:getThumbnailImageRectSize()

	if getThumbnail then
		return getThumbnail(
			thumbnailPosition,
			thumbnailSize,
			thumbnailImageRectOffset,
			thumbnailImageRectSize,
			2,
			{
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, module.PageButtonCornerRadius)
				})
			}
		)
	end

	return Roact.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Image = thumbnailImage,
		ImageTransparency = transparencyModifier,
		Position = thumbnailPosition,
		Size = thumbnailSize,
		ImageRectOffset = thumbnailImageRectOffset,
		ImageRectSize = thumbnailImageRectSize
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, module.PageButtonCornerRadius)
		})
	})
end

function extended:getThumbnailPosition()
	if self:shouldUseImageRectSizeAndOffset() then
		return UDim2.fromScale(0, 0)
	end

	local thumbnailScaleOffset = self.props.thumbnailScaleOffset

	return self.buttonSize:map(function(p2)
		local v6 = thumbnailScaleOffset - self:calcNormalizedSize(p2, self.props.thumbnailZoom) * Vector2.new(0.5, 0.5) + Vector2.new(0.5, 0.5)
		local vector2 = Vector2.new(
			math.max(v6.X, thumbnailScaleOffset.X - 0.5),
			(math.max(v6.Y, thumbnailScaleOffset.Y))
		)

		return UDim2.fromScale(vector2.X, vector2.Y)
	end)
end

function extended:getThumbnailSize()
	if self:shouldUseImageRectSizeAndOffset() then
		return UDim2.fromScale(1, 1)
	end

	return self.buttonSize:map(function(p2)
		local calcNormalizedSize = self:calcNormalizedSize(p2, self.props.thumbnailZoom)
		return UDim2.fromScale(calcNormalizedSize.X, calcNormalizedSize.Y)
	end)
end

function extended:getThumbnailImageRectOffset()
	if self:shouldUseImageRectSizeAndOffset() then
		return self.buttonSize:map(function(p2)
			local calcNormalizedSize = self:calcNormalizedSize(p2, self.props.thumbnailZoom)

			local vector2 = Vector2.new(
				self.props.thumbnailSize / calcNormalizedSize.X,
				self.props.thumbnailSize / calcNormalizedSize.Y
			)

			local v6 = (self.props.thumbnailSize - vector2.X) * 0.5
			local v7

			if self.props.thumbnailImageYInsetScale then
				v7 = self.props.thumbnailSize * self.props.thumbnailImageYInsetScale
			else
				v7 = (self.props.thumbnailSize - vector2.Y) * 0.5
			end

			return (Vector2.new(v6, v7))
		end)
	end

	return nil
end

function extended:getThumbnailImageRectSize()
	if self:shouldUseImageRectSizeAndOffset() then
		return self.buttonSize:map(function(p2)
			local calcNormalizedSize = self:calcNormalizedSize(p2, self.props.thumbnailZoom)
			return Vector2.new(
				self.props.thumbnailSize / calcNormalizedSize.X,
				self.props.thumbnailSize / calcNormalizedSize.Y
			)
		end)
	end

	return nil
end

function extended:renderTextComponent(p3, p4, text, p5, textColor, textTransparency, p6, p7)
	local v6 = if p3 then p6 - 48 - 30 else p6 - 20

	if v6 <= 0 then
		return nil
	end

	local v7 = if foundationFontFaceMigration then p7.HeadingSmall else p4.Header1

	local largestPossibleOneLineTextSize, v8 = module3.getLargestPossibleOneLineTextSize(text, p5, v7, v6)

	if largestPossibleOneLineTextSize == nil then
		return nil
	end

	local udim = UDim2.fromOffset(largestPossibleOneLineTextSize.X, largestPossibleOneLineTextSize.Y)
	local createElement = Roact.createElement

	local v11 = if not foundationFontFaceMigration then p4.Header1.Font else nil
	local v12 = if foundationFontFaceMigration then normalizeFontFace(p7.HeadingSmall.Font) else nil
	return createElement("TextLabel", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = udim,
		Font = v11,
		FontFace = v12,
		Text = text,
		TextColor3 = textColor,
		TextSize = v8,
		TextTransparency = textTransparency
	})
end

function extended:renderWithSelectionCursor(callback)
	local size = self.props.Size

	local backgroundImage = self.props.backgroundImage

	local icon = self.props.icon
	local iconBeforeText = self.props.iconBeforeText
	local text = self.props.text
	local transparencyModifier = self.props.transparencyModifier
	local nextSelectionLeft = self.props.NextSelectionLeft
	local nextSelectionRight = self.props.NextSelectionRight
	local nextSelectionUp = self.props.NextSelectionUp
	local nextSelectionDown = self.props.NextSelectionDown
	local udim = UDim2.new(1, 0, 2 / 3, 0)

	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font
		local v6 = font.BaseSize * font.Header1.RelativeSize

		local forwardRef = self.props.forwardRef
		local dropShadowTransparency = self.props.dropShadowTransparency
		local dropShadowColor = self.props.dropShadowColor

		local createElement = Roact.createElement
		local imageButton = focusable.ImageButton
		local v7 = {
			BackgroundTransparency = 0.9,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = size,
			NextSelectionLeft = nextSelectionLeft,
			NextSelectionRight = nextSelectionRight,
			NextSelectionUp = nextSelectionUp,
			NextSelectionDown = nextSelectionDown,
			[Roact.Ref] = forwardRef,
			SelectionImageObject = callback(cursorKind.RoundedRectNoInset),
			[Roact.Event.Activated] = self.props.onActivated,
			[Roact.Change.AbsoluteSize] = function(p2)
				self:setState({ imageButtonWidth = p2.AbsoluteSize.X })

				self.updateButtonSize(p2.AbsoluteSize)
			end
		}
		local children = {
			BackgroundImage = Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = backgroundImage,
				ImageTransparency = transparencyModifier,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Crop,
				ZIndex = 0
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, module.PageButtonCornerRadius)
				})
			}),
			BackgroundImageOverlay = Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = backgroundImage,
				ImageColor3 = theme.BackgroundUIDefault.Color,
				ImageTransparency = 1 - (1 - transparencyModifier) * 0.5,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Crop,
				ZIndex = 1
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, module.PageButtonCornerRadius)
				})
			}),
			Thumbnail = self:renderThumbnail(),
			LeftThumbnail = self:renderSideThumbnail(module2.Left),
			RightThumbnail = self:renderSideThumbnail(module2.Right),
			Overlay = Roact.createElement("Frame", {
				BackgroundTransparency = transparencyModifier,
				BackgroundColor3 = theme.Overlay.Color,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 3
			}, {
				Gradient = Roact.createElement("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
						ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
					}),
					Transparency = numberSequence
				}),
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, module.PageButtonCornerRadius)
				})
			}),
			ForegroundShadow = 0,
			Foreground = 0,
			UICorner = 0
		}

		local createElement2 = Roact.createElement
		local v9 = {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Position = self.buttonSize:map(function(p2)
				return self:calculateShadowPosition(p2)
			end),
			Size = self.props.iconBeforeText and UDim2.fromScale(1, 1) or udim,
			ZIndex = 4
		}

		local v10 = if not self.props.iconBeforeText then Roact.createElement("UISizeConstraint", {
			MinSize = Vector2.new(0, module.PageButtonForegroundMinHeightPix)
		}) or nil else nil
		local children2 = {
			uiSizeConstraint = v10,
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = iconBeforeText and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			IconShadow = Roact.createElement(imageSetLabel, {
				BackgroundTransparency = 1,
				Image = icon,
				ImageColor3 = dropShadowColor,
				ImageTransparency = dropShadowTransparency,
				LayoutOrder = 1,
				Size = UDim2.new(0, 48, 0, 48)
			}),
			DropShadow = 0
		}

		local imageButtonWidth = self.state.imageButtonWidth
		local v14 = if foundationFontFaceMigration then props.Tokens.Typography else nil
		children2.DropShadow = self:renderTextComponent(
			iconBeforeText,
			font,
			text,
			v6,
			dropShadowColor,
			dropShadowTransparency,
			imageButtonWidth,
			v14
		)
		children.ForegroundShadow = createElement2("Frame", v9, children2)

		local createElement3 = Roact.createElement
		local v16 = {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 1, 0),
			Size = self.props.iconBeforeText and UDim2.fromScale(1, 1) or udim,
			ZIndex = 4
		}

		local v17 = if not self.props.iconBeforeText then Roact.createElement("UISizeConstraint", {
			MinSize = Vector2.new(0, module.PageButtonForegroundMinHeightPix)
		}) or nil else nil
		local children3 = {
			uiSizeConstraint = v17,
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = iconBeforeText and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			Icon = Roact.createElement(imageSetLabel, {
				BackgroundTransparency = 1,
				Image = icon,
				ImageTransparency = transparencyModifier,
				LayoutOrder = 1,
				Size = UDim2.new(0, 48, 0, 48)
			}),
			Text = 0
		}

		local color = Color3.new(1, 1, 1)

		local imageButtonWidth2 = self.state.imageButtonWidth
		local v22 = if foundationFontFaceMigration then props.Tokens.Typography else nil
		children3.Text = self:renderTextComponent(
			iconBeforeText,
			font,
			text,
			v6,
			color,
			transparencyModifier,
			imageButtonWidth2,
			v22
		)
		children.Foreground = createElement3("Frame", v16, children3)

		children.UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, module.PageButtonCornerRadius)
		})
		return createElement(imageButton, v7, children)
	end)
end

function extended:render()
	return withSelectionCursorProvider(function(p2)
		return self:renderWithSelectionCursor(p2)
	end)
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
