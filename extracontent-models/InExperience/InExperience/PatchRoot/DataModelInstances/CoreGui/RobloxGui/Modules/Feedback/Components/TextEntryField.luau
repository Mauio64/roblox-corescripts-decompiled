local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local Style = require(CorePackages.Workspace.Packages.Style)
local GetTextSize = Style.GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local t = require(CorePackages.Packages.t)

local parent = script.Parent.Parent
local Assets = require(parent.Resources.Assets)
local ThemedTextLabel = require(parent.Components.PortedComponents.ThemedTextLabel)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider

local extended = Roact.PureComponent:extend("TextEntryField")

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

		local v = p3.text:sub(1, data.cursorPosition - 1)
		local v2 = p2.RelativeSize * p.Font.BaseSize
		local vector2 = Vector2.new(p3.textBoxWidth, 10000)
		local v3

		if FoundationFontFaceMigration then
			v3 = GetTextSize(v, v2, p.Tokens.Typography.BodyLarge.Font, vector2, {
				addTemporaryPadding = false
			})
		else
			v3 = TextService:GetTextSize(v, v2, p2.Font, vector2)
		end

		if v3.Y > data.scrollingFrameHeight + data.canvasPosition then
			return {
				canvasPosition = v3.Y - data.scrollingFrameHeight
			}
		end

		if v3.Y - v2 < data.canvasPosition then
			return {
				canvasPosition = v3.Y - v2
			}
		end

		return nil
	end)
end

function extended:renderWithSelectionCursor(callback)
	return withStyle(function(props)
		local textDefault = props.Theme.TextDefault
		local body = props.Font.Body

		local vector2 = Vector2.new(self.state.textBoxWidth, 10000)
		local v

		if FoundationFontFaceMigration then
			v = GetTextSize(
				self.props.text,
				body.RelativeSize * props.Font.BaseSize,
				props.Tokens.Typography.BodyLarge.Font,
				vector2,
				{ addTemporaryPadding = false }
			)
		else
			v = TextService:GetTextSize(self.props.text, body.RelativeSize * props.Font.BaseSize, body.Font, vector2)
		end

		local createElement = Roact.createElement
		local v2 = {
			BackgroundTransparency = 1,
			Image = Assets.Images.RoundedRect.Image,
			ImageColor3 = props.Theme.BackgroundMuted.Color,
			ImageTransparency = props.Theme.BackgroundMuted.Transparency,
			Position = self.props.Position,
			ScaleType = Assets.Images.RoundedRect.ScaleType,
			Size = self.props.Size,
			SliceCenter = Assets.Images.RoundedRect.SliceCenter,
			LayoutOrder = self.props.LayoutOrder
		}

		local createElement2 = Roact.createElement
		local v3 = {
			Size = UDim2.new(1, -24, 1, -14),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 7),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(1, -24, 0, v.Y),
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
		}

		local createElement3 = Roact.createElement
		local v4 = {}
		v4.Size = UDim2.new(1, -2, 1, 0)
		v4.AnchorPoint = Vector2.new(0.5, 0.5)
		v4.Position = UDim2.new(0.5, 0, 0.5, 0)
		v4.Text = self.props.text
		v4.ClearTextOnFocus = false
		v4.TextEditable = self.props.enabled
		v4.BackgroundTransparency = 1
		v4.TextXAlignment = Enum.TextXAlignment.Left
		v4.TextYAlignment = Enum.TextYAlignment.Top
		v4.TextColor3 = textDefault.Color
		v4.TextTransparency = textDefault.Transparency
		local font

		if not FoundationFontFaceMigration then
			font = body.Font
		end

		v4.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v4.FontFace = fontFace

		v4.TextSize = body.RelativeSize * props.Font.BaseSize
		v4.TextWrapped = true
		v4.MultiLine = true
		v4.SelectionImageObject = callback(CursorKind.InputFields)

		v4[Roact.Ref] = self.textBoxRef

		v4[Roact.Change.Text] = function(state)
			local success, result = pcall(function()
				return utf8.len(utf8.nfcnormalize(state.Text))
			end)

			if not success or self.props.maxTextLength < result then
				state.Text = self.props.text
				return
			end

			self.props.textChanged(state.Text)
			self:setState({ cursorPosition = state.CursorPosition }, function()
				self:calculateNeedsRescroll(props, body)
			end)
		end

		v4[Roact.Change.AbsoluteSize] = function(p)
			self:setState({ textBoxWidth = p.AbsoluteSize.X }, function()
				self:calculateNeedsRescroll(props, body)
			end)
		end

		v4[Roact.Change.CursorPosition] = function(p)
			self:setState({ cursorPosition = p.CursorPosition }, function()
				self:calculateNeedsRescroll(props, body)
			end)
		end

		return createElement(ImageSetLabel, v2, {
			ScrollingFrame = createElement2("ScrollingFrame", v3, {
				TextBox = createElement3("TextBox", v4, {
					PlaceholderText = Roact.createElement(ThemedTextLabel, {
						themeKey = "TextDefault",
						fontKey = "Body",
						Text = self.props.PlaceholderText,
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0, 0, 0, 0),
						TextTransparency = 0.5,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						Visible = self.props.text == ""
					})
				})
			})
		})
	end)
end

function extended:render()
	return withSelectionCursorProvider(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

function extended.didUpdate(p, p2)
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
