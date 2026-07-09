local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Focusable = RoactGamepad.Focusable
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ThumbnailSide = require(Modules.AvatarExperience.Common.Components.Landing.ThumbnailSide)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local FFlagEnableCoreContentTheme = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableCoreContentTheme
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle
local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.5, 1),
	NumberSequenceKeypoint.new(1, 0.1)
})
local v18 = Roact.PureComponent:extend("PageButton")

v18.validateProps = t.strictInterface({
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
		side = ThumbnailSide.isEnumValue,
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
v18.defaultProps = {
	transparencyModifier = 0,
	thumbnailZoom = 1,
	dropShadowTransparency = 0.6,
	thumbnailScaleOffset = Vector2.new(0, 0),
	dropShadowOffset = Vector2.new(2, 2),
	dropShadowColor = Color3.new(0, 0, 0)
}

function v18.calculateShadowPosition(p1, p2) -- line: 86
	return UDim2.new(p1.props.dropShadowOffset.X / p2.X, 0, 1 + p1.props.dropShadowOffset.Y / p2.Y, 0)
end
function v18.init(p3) -- line: 95
	-- upvalues: Roact (copy)
	local v22, v23 = Roact.createBinding(Vector2.new(1, 1))

	p3.buttonSize = v22
	p3.updateButtonSize = v23
	p3:setState({
		imageButtonWidth = 0
	})
end
function v18.renderSideThumbnail(p4, p5) -- line: 102
	-- upvalues: ThumbnailSide (copy), Roact (copy)
	if not p4.props.extraThumbnails then
		return nil
	end

	local u26 = nil

	for _, v28 in p4.props.extraThumbnails do
		if p5 == v28.side then
			u26 = v28

			break
		end
	end

	if not u26 then
		return nil
	end

	local vector2, uDim2

	if p5 == ThumbnailSide.Left then
		vector2 = Vector2.new(0, 0)
		uDim2 = UDim2.fromScale(u26.paddingSideScale, u26.paddingTopScale)
	else
		vector2 = Vector2.new(1, 0)
		uDim2 = UDim2.fromScale(1 - u26.paddingSideScale, u26.paddingTopScale)
	end

	return Roact.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Image = u26.image,
		ImageRectSize = u26.imageRectSize,
		ImageRectOffset = u26.imageRectOffset,
		AnchorPoint = vector2,
		Position = uDim2,
		Size = p4.buttonSize:map(function(p6) -- line: 136
			-- upvalues: u26 (ref)
			local v77 = p6.Y * (1 - u26.paddingTopScale - u26.paddingBottomScale)
			local v78 = u26.imageRectSize.X * v77 / u26.imageRectSize.Y

			return UDim2.fromOffset(v78, v77)
		end)
	})
end
function v18.calcNormalizedSize(_, p8, p9) -- line: 144
	if p8.X > p8.Y then
		return Vector2.new(p9 * p8.Y / p8.X, p9)
	end

	return Vector2.new(p9, p9 * p8.X / p8.Y)
end
function v18.shouldUseImageRectSizeAndOffset(p10) -- line: 152
	return p10.props.thumbnailZoom > 1 and p10.props.thumbnailSize
end
function v18.renderThumbnail(p11) -- line: 156
	-- upvalues: Roact (copy), Constants (copy)
	if p11.props.ignoreThumbnail then
		return nil
	end

	local thumbnailImage = p11.props.thumbnailImage
	local getThumbnail = p11.props.getThumbnail
	local transparencyModifier = p11.props.transparencyModifier
	local v39 = p11:getThumbnailPosition()
	local v40 = p11:getThumbnailSize()
	local v41 = p11:getThumbnailImageRectOffset()
	local v42 = p11:getThumbnailImageRectSize()

	if getThumbnail then
		return getThumbnail(v39, v40, v41, v42, 2, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, Constants.PageButtonCornerRadius)
			})
		})
	end

	return Roact.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Image = thumbnailImage,
		ImageTransparency = transparencyModifier,
		Position = v39,
		Size = v40,
		ImageRectOffset = v41,
		ImageRectSize = v42
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, Constants.PageButtonCornerRadius)
		})
	})
end
function v18.getThumbnailPosition(p12) -- line: 201
	if p12:shouldUseImageRectSizeAndOffset() then
		return UDim2.fromScale(0, 0)
	end

	local thumbnailScaleOffset = p12.props.thumbnailScaleOffset

	return p12.buttonSize:map(function(p13) -- line: 208
		-- upvalues: p12 (copy), thumbnailScaleOffset (copy), thumbnailScaleOffset (copy)
		local v80 = p12:calcNormalizedSize(p13, p12.props.thumbnailZoom)
		local v81 = thumbnailScaleOffset - v80 * Vector2.new(0.5, 0.5) + Vector2.new(0.5, 0.5)
		local vector2 = Vector2.new(math.max(v81.X, thumbnailScaleOffset.X - 0.5), (math.max(v81.Y, thumbnailScaleOffset.Y)))

		return UDim2.fromScale(vector2.X, vector2.Y)
	end)
end
function v18.getThumbnailSize(p14) -- line: 220
	if p14:shouldUseImageRectSizeAndOffset() then
		return UDim2.fromScale(1, 1)
	end

	return p14.buttonSize:map(function(p15) -- line: 224
		-- upvalues: p14 (copy)
		local v84 = p14:calcNormalizedSize(p15, p14.props.thumbnailZoom)

		return UDim2.fromScale(v84.X, v84.Y)
	end)
end
function v18.getThumbnailImageRectOffset(p16) -- line: 231
	if p16:shouldUseImageRectSizeAndOffset() then
		return p16.buttonSize:map(function(p17) -- line: 233
			-- upvalues: p16 (copy)
			local v86 = p16:calcNormalizedSize(p17, p16.props.thumbnailZoom)
			local vector2 = Vector2.new(p16.props.thumbnailSize / v86.X, p16.props.thumbnailSize / v86.Y)
			local v88 = (p16.props.thumbnailSize - vector2.X) * 0.5
			local v89 = if not p16.props.thumbnailImageYInsetScale then (p16.props.thumbnailSize - vector2.Y) * 0.5 else p16.props.thumbnailSize * p16.props.thumbnailImageYInsetScale

			return (Vector2.new(v88, v89))
		end)
	end

	return nil
end
function v18.getThumbnailImageRectSize(p18) -- line: 259
	if p18:shouldUseImageRectSizeAndOffset() then
		return p18.buttonSize:map(function(p19) -- line: 261
			-- upvalues: p18 (copy)
			local v91 = p18:calcNormalizedSize(p19, p18.props.thumbnailZoom)

			return Vector2.new(p18.props.thumbnailSize / v91.X, p18.props.thumbnailSize / v91.Y)
		end)
	end

	return nil
end
function v18.renderTextComponent(_, p21, p22, p23, p24, p25, p26, p27) -- line: 270
	-- upvalues: Utils (copy), Roact (copy)
	local v56 = if not p21 then p27 - 20 else p27 - 48 - 30

	if v56 <= 0 then
		return nil
	end

	local v57, v58 = Utils.getLargestPossibleOneLineTextSize(p23, p24, p22.Header1, v56)

	if v57 == nil then
		return nil
	end

	local uDim2 = UDim2.fromOffset(v57.X, v57.Y)

	return Roact.createElement("TextLabel", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = uDim2,
		Font = p22.Header1.Font,
		Text = p23,
		TextColor3 = p25,
		TextSize = v58,
		TextTransparency = p26
	})
end
function v18.renderWithSelectionCursor(p28, p29) -- line: 311
	-- upvalues: withStyle (copy), Roact (copy), Focusable (copy), CursorKind (copy), FFlagEnableCoreContentTheme (copy), Constants (copy), ThumbnailSide (copy), numberSequence (copy), ImageSetLabel (copy)
	local propsSize = p28.props.Size
	local backgroundImage = p28.props.backgroundImage
	local icon = p28.props.icon
	local iconBeforeText = p28.props.iconBeforeText
	local text = p28.props.text
	local transparencyModifier = p28.props.transparencyModifier
	local NextSelectionLeft = p28.props.NextSelectionLeft
	local NextSelectionRight = p28.props.NextSelectionRight
	local NextSelectionUp = p28.props.NextSelectionUp
	local NextSelectionDown = p28.props.NextSelectionDown
	local uDim2 = UDim2.new(1, 0, 0.6666666666666666, 0)

	return withStyle(function(p30) -- line: 326
		-- upvalues: p28 (copy), Roact (copy), Focusable (copy), propsSize (copy), NextSelectionLeft (copy), NextSelectionRight (copy), NextSelectionUp (copy), NextSelectionDown (copy), p29 (copy), CursorKind (copy), backgroundImage (copy), transparencyModifier (copy), FFlagEnableCoreContentTheme (copy), Constants (copy), ThumbnailSide (copy), numberSequence (copy), uDim2 (copy), iconBeforeText (copy), ImageSetLabel (copy), icon (copy), text (copy)
		local Theme = p30.Theme
		local p30Font = p30.Font
		local v95 = p30Font.BaseSize * p30Font.Header1.RelativeSize
		local forwardRef = p28.props.forwardRef
		local dropShadowTransparency = p28.props.dropShadowTransparency
		local dropShadowColor = p28.props.dropShadowColor

		return Roact.createElement(Focusable.ImageButton, {
			BackgroundTransparency = 0.9,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = propsSize,
			NextSelectionLeft = NextSelectionLeft,
			NextSelectionRight = NextSelectionRight,
			NextSelectionUp = NextSelectionUp,
			NextSelectionDown = NextSelectionDown,
			[Roact.Ref] = forwardRef,
			SelectionImageObject = p29(CursorKind.RoundedRectNoInset),
			[Roact.Event.Activated] = p28.props.onActivated,
			[Roact.Change.AbsoluteSize] = function(p31) -- line: 349
				-- upvalues: p28 (copy)
				p28:setState({
					imageButtonWidth = p31.AbsoluteSize.X
				})
				p28.updateButtonSize(p31.AbsoluteSize)
			end
		}, {
			BackgroundImage = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = backgroundImage,
				ImageTransparency = transparencyModifier,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Crop,
				ZIndex = not FFlagEnableCoreContentTheme and 1 or 0
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, Constants.PageButtonCornerRadius)
				})
			}),
			BackgroundImageOverlay = if not FFlagEnableCoreContentTheme then nil else Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				ZIndex = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = backgroundImage,
				ImageColor3 = Theme.BackgroundUIDefault.Color,
				ImageTransparency = 1 - (1 - transparencyModifier) * 0.5,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Crop
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, Constants.PageButtonCornerRadius)
				})
			}),
			Thumbnail = p28:renderThumbnail(),
			LeftThumbnail = p28:renderSideThumbnail(ThumbnailSide.Left),
			RightThumbnail = p28:renderSideThumbnail(ThumbnailSide.Right),
			Overlay = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 3,
				BackgroundTransparency = transparencyModifier,
				BackgroundColor3 = Theme.Overlay.Color,
				Size = UDim2.fromScale(1, 1)
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
					CornerRadius = UDim.new(0, Constants.PageButtonCornerRadius)
				})
			}),
			ForegroundShadow = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 4,
				AnchorPoint = Vector2.new(0, 1),
				Position = p28.buttonSize:map(function(p32) -- line: 417
					-- upvalues: p28 (copy)
					return p28:calculateShadowPosition(p32)
				end),
				Size = p28.props.iconBeforeText and UDim2.fromScale(1, 1) or uDim2
			}, {
				uiSizeConstraint = not p28.props.iconBeforeText and Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, Constants.PageButtonForegroundMinHeightPix)
				}) or nil,
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = iconBeforeText and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 10)
				}),
				IconShadow = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Image = icon,
					ImageColor3 = dropShadowColor,
					ImageTransparency = dropShadowTransparency,
					Size = UDim2.new(0, 48, 0, 48)
				}),
				DropShadow = p28:renderTextComponent(iconBeforeText, p30Font, text, v95, dropShadowColor, dropShadowTransparency, p28.state.imageButtonWidth)
			}),
			Foreground = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 4,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = p28.props.iconBeforeText and UDim2.fromScale(1, 1) or uDim2
			}, {
				uiSizeConstraint = not p28.props.iconBeforeText and Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, Constants.PageButtonForegroundMinHeightPix)
				}) or nil,
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = iconBeforeText and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 10)
				}),
				Icon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Image = icon,
					ImageTransparency = transparencyModifier,
					Size = UDim2.new(0, 48, 0, 48)
				}),
				Text = p28:renderTextComponent(iconBeforeText, p30Font, text, v95, Color3.new(1, 1, 1), transparencyModifier, p28.state.imageButtonWidth)
			}),
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, Constants.PageButtonCornerRadius)
			})
		})
	end)
end
function v18.render(p33) -- line: 498
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p34) -- line: 499
		-- upvalues: p33 (copy)
		return p33:renderWithSelectionCursor(p34)
	end)
end

return Roact.forwardRef(function(p35, p36) -- line: 504
	-- upvalues: Roact (copy), v18 (copy), Cryo (copy)
	return Roact.createElement(v18, Cryo.Dictionary.join(p35, {
		forwardRef = p36
	}))
end)
