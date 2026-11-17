game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local Style = require(CorePackages.Workspace.Packages.Style)
local GetTextSize = Style.GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
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
		local textSize = GetTextSize(v, v2, p.Tokens.Typography.BodyLarge.Font, vector2, {
			addTemporaryPadding = false
		})

		if textSize.Y > data.scrollingFrameHeight + data.canvasPosition then
			return {
				canvasPosition = textSize.Y - data.scrollingFrameHeight
			}
		end

		if textSize.Y - v2 < data.canvasPosition then
			return {
				canvasPosition = textSize.Y - v2
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
		local textSize = GetTextSize(
			self.props.text,
			body.RelativeSize * props.Font.BaseSize,
			props.Tokens.Typography.BodyLarge.Font,
			vector2,
			{ addTemporaryPadding = false }
		)

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
		}, {
			ScrollingFrame = Roact.createElement("ScrollingFrame", {
				Size = UDim2.new(1, -24, 1, -14),
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
					MultiLine = true,
					SelectionImageObject = callback(CursorKind.InputFields),
					[Roact.Ref] = self.textBoxRef,
					[Roact.Change.Text] = function(state)
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
