local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local Cryo = InGameMenuDependencies.Cryo

local Style = require(CorePackages.Workspace.Packages.Style)
local GetTextSize = Style.GetTextSize
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local Images = UIBlox.App.ImageSet.Images

local Foundation = require(CorePackages.Packages.Foundation)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local v2

if FFlagCoreUiMigrateUIBloxToFoundation then
	v2 = Foundation.Enums.CursorType
else
	v2 = UIBlox.App.SelectionImage.CursorKind
end

local parent = script.Parent.Parent.Parent
local Assets = require(parent.Resources.Assets)

local FillCircle = require(script.Parent.FillCircle)
local ThemedTextLabel = require(parent.Components.ThemedTextLabel)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Image = Foundation.Image

local extended = Roact.PureComponent:extend("TextEntryField")

local component_assetscircle_17 = Images["component_assets/circle_17"]

extended.validateProps = t.strictInterface({
	enabled = t.boolean,
	text = t.string,
	textChanged = t.callback,
	maxTextLength = t.integer,
	autoFocusOnEnabled = t.boolean,
	PlaceholderText = t.string,
	LayoutOrder = t.optional(t.integer),
	Size = t.UDim2,
	Position = t.optional(t.UDim2),
	textBoxRef = t.optional(t.table)
})

function extended:init()
	self.textBoxRef = self.props.textBoxRef or Roact.createRef()

	self.state = {
		textBoxWidth = 100,
		scrollingFrameHeight = 100,
		canvasPosition = 0,
		cursorPosition = 0
	}
end

function extended:calculateNeedsRescroll(p, p2)
	self:setState(function(data, p3)
		if data.cursorPosition == -1 then
			return nil
		end

		local v3 = p3.text:sub(1, data.cursorPosition - 1)
		local v4 = p2.RelativeSize * p.Font.BaseSize
		local vector2 = Vector2.new(p3.textBoxWidth, 10000)
		local textSize = GetTextSize(v3, v4, p.Tokens.Typography.BodyLarge.Font, vector2, {
			addTemporaryPadding = false
		})

		if textSize.Y > data.scrollingFrameHeight + data.canvasPosition then
			return {
				canvasPosition = textSize.Y - data.scrollingFrameHeight
			}
		end

		if textSize.Y - v4 < data.canvasPosition then
			return {
				canvasPosition = textSize.Y - v4
			}
		end

		return nil
	end)
end

function extended:renderWithSelectionCursor(callback)
	return withFoundationOrUIBloxStyle(function(tokens)
		return {
			Tokens = tokens,
			Theme = {
				TextDefault = {
					Color = tokens.Color.Content.Default.Color3,
					Transparency = tokens.Color.Content.Default.Transparency
				},
				BackgroundMuted = {
					Color = tokens.Color.Surface.Surface_200.Color3,
					Transparency = tokens.Color.Surface.Surface_200.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				Body = {
					Font = tokens.Typography.BodyLarge.Font,
					RelativeSize = tokens.Typography.BodyLarge.FontSize
				}
			}
		}
	end, function(props)
		local textDefault = props.Theme.TextDefault
		local body = props.Font.Body

		local textSize = GetTextSize(
			self.props.text,
			body.RelativeSize * props.Font.BaseSize,
			props.Tokens.Typography.BodyLarge.Font,
			Vector2.new(self.state.textBoxWidth, 10000),
			{ addTemporaryPadding = false }
		)

		local imageRectSize = component_assetscircle_17.ImageRectSize
		local imageRectOffset = component_assetscircle_17.ImageRectOffset
		local x = imageRectSize.X
		local halfX = x / 2

		local children = {
			ScrollingFrame = Roact.createElement("ScrollingFrame", {
				Size = UDim2.new(1, -24, 1, -44),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 7),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(1, -24, 0, textSize.Y),
				ScrollBarThickness = 8,
				VerticalScrollBarInset = Enum.ScrollBarInset.Always,
				CanvasPosition = Vector2.new(0, self.state.canvasPosition),
				Selectable = false,
				[Roact.Change.CanvasPosition] = function(p)
					self:setState({ canvasPosition = p.CanvasPosition.Y })
				end,
				[Roact.Change.AbsoluteSize] = function(p)
					self:setState({ scrollingFrameHeight = p.AbsoluteSize.Y }, function()
						self:calculateNeedsRescroll(props, body)
					end)
				end
			}, {
				TextBox = Roact.createElement("TextBox", {
					Size = UDim2.new(1, -2, 1, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Text = self.props.text,
					ClearTextOnFocus = false,
					TextEditable = self.props.enabled,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextColor3 = textDefault.Color,
					TextTransparency = textDefault.Transparency,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
					TextSize = body.RelativeSize * props.Font.BaseSize,
					TextWrapped = true,
					SelectionImageObject = callback(v2.InputFields),
					[Roact.Ref] = self.textBoxRef,
					[Roact.Change.Text] = function(state)
						if utf8.len(utf8.nfcnormalize(state.Text)) > self.props.maxTextLength then
							local v3 = utf8.offset(state.Text, self.props.maxTextLength + 1) - 1
							state.Text = string.sub(state.Text, 1, v3)
						else
							self.props.textChanged(state.Text)
							self:setState({ cursorPosition = state.CursorPosition }, function()
								self:calculateNeedsRescroll(props, body)
							end)
						end
					end,
					[Roact.Change.AbsoluteSize] = function(p)
						self:setState({ textBoxWidth = p.AbsoluteSize.X }, function()
							self:calculateNeedsRescroll(props, body)
						end)
					end,
					[Roact.Change.CursorPosition] = function(p)
						self:setState({ cursorPosition = p.CursorPosition }, function()
							self:calculateNeedsRescroll(props, body)
						end)
					end
				}, {
					PlaceholderText = Roact.createElement(ThemedTextLabel, {
						themeKey = "TextDefault",
						fontKey = "Body",
						Text = self.props.PlaceholderText,
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0, 0, 0, 0),
						TextTransparency = 0.5,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						Visible = self.props.text == ""
					})
				})
			}),
			BottomBar = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = component_assetscircle_17.Image,
				ImageColor3 = props.Theme.BackgroundMuted.Color,
				ImageTransparency = 0,
				ScaleType = Enum.ScaleType.Slice,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 32),
				SliceCenter = Rect.new(halfX - 1, 0, halfX + 1, 1),
				SliceScale = 1 / Images.ImagesResolutionScale,
				ImageRectSize = Vector2.new(x, halfX),
				ImageRectOffset = imageRectOffset + Vector2.new(0, halfX)
			}, {
				TextAmmountIndicator = Roact.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						Position = UDim2.new(1, -10, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						Size = UDim2.new(0, 20, 0, 20)
					},
					{ Roact.createElement(FillCircle, {
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							fillFraction = utf8.len(utf8.nfcnormalize(self.props.text)) / (self.props.maxTextLength - 10),
							largerCircleFraction = (self.props.maxTextLength - 20) / self.props.maxTextLength,
							popCircleFraction = 1,
							shakeCircleFraction = self.props.maxTextLength / (self.props.maxTextLength - 10),
							BackgroundColor = props.Theme.BackgroundMuted.Color
						}) }
				)
			})
		}

		if FFlagCoreUiMigrateUIBloxToFoundation then
			return Roact.createElement(Image, {
				Image = Assets.Images.RoundedRectImageKey,
				imageStyle = {
					Color3 = props.Theme.BackgroundMuted.Color,
					Transparency = props.Theme.BackgroundMuted.Transparency
				},
				Position = self.props.Position,
				Size = self.props.Size,
				LayoutOrder = self.props.LayoutOrder,
				slice = { center = Rect.new(8, 8, 9, 9) }
			}, children)
		end

		return Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = Assets.Images.RoundedRect.Image,
			ImageColor3 = props.Theme.BackgroundMuted.Color,
			ImageTransparency = props.Theme.BackgroundMuted.Transparency,
			Position = self.props.Position,
			ScaleType = Assets.Images.RoundedRect.ScaleType,
			Size = self.props.Size,
			SliceCenter = Assets.Images.RoundedRect.SliceCenter,
			LayoutOrder = self.props.LayoutOrder
		}, children)
	end)
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

function extended.didUpdate(p, p2, _)
	if p.props.enabled or not p2.enabled then
		if p.props.enabled and not p2.enabled and p.props.autoFocusOnEnabled and p.textBoxRef.current then
			p.textBoxRef.current:CaptureFocus()
		end
	elseif p.textBoxRef.current and p.textBoxRef.current:IsFocused() then
		p.textBoxRef.current:ReleaseFocus()
	end
end

return Roact.forwardRef(function(p, textBoxRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { textBoxRef = textBoxRef }))
end)
