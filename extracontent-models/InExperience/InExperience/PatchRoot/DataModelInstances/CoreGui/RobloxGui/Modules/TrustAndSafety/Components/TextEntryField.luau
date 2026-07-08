local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local Dependencies = require(ParentParent.Dependencies)
local ThemedTextLabel = require(Dependencies.ThemedTextLabel)
local FillCircle = require(ParentParent.Components.FillCircle)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local v16 = Roact.PureComponent:extend("TextEntryField")

v16.validateProps = t.strictInterface({
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

function v16.init(p1) -- line: 47
	-- upvalues: Roact (copy)
	p1.textBoxRef = p1.props.textBoxRef or Roact.createRef()
	p1.state = {
		textBoxWidth = 100,
		scrollingFrameHeight = 100,
		canvasPosition = 0,
		cursorPosition = 0
	}
end
function v16.calculateNeedsRescroll(p2, p3, p4) -- line: 58
	-- upvalues: TextService (copy)
	p2:setState(function(p5, p6) -- line: 59
		-- upvalues: p4 (copy), p3 (copy), TextService (copy)
		if p5.cursorPosition == -1 then
			return nil
		end

		local v31 = p6.text:sub(1, p5.cursorPosition - 1)
		local v32 = p4.RelativeSize * p3.Font.BaseSize
		local vector2 = Vector2.new(p6.textBoxWidth, 10000)
		local TextSize = TextService:GetTextSize(v31, v32, p4.Font, vector2)

		if TextSize.Y > p5.scrollingFrameHeight + p5.canvasPosition then
			return {
				canvasPosition = TextSize.Y - p5.scrollingFrameHeight
			}
		end

		if TextSize.Y - v32 < p5.canvasPosition then
			return {
				canvasPosition = TextSize.Y - v32
			}
		end

		return nil
	end)
end
function v16.renderWithSelectionCursor(p7, p8) -- line: 82
	-- upvalues: withStyle (copy), TextService (copy), Roact (copy), ImageSetLabel (copy), Assets (copy), CursorKind (copy), ThemedTextLabel (copy), FillCircle (copy)
	return withStyle(function(p9) -- line: 83
		-- upvalues: TextService (copy), p7 (copy), Roact (copy), ImageSetLabel (copy), Assets (copy), p8 (copy), CursorKind (copy), ThemedTextLabel (copy), FillCircle (copy)
		local TextDefault = p9.Theme.TextDefault
		local Body = p9.Font.Body
		local TextSize = TextService:GetTextSize(p7.props.text, Body.RelativeSize * p9.Font.BaseSize, Body.Font, Vector2.new(p7.state.textBoxWidth, 10000))

		return Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = Assets.Images.RoundedRect.Image,
			ImageColor3 = p9.Theme.BackgroundMuted.Color,
			ImageTransparency = p9.Theme.BackgroundMuted.Transparency,
			Position = p7.props.Position,
			ScaleType = Assets.Images.RoundedRect.ScaleType,
			Size = p7.props.Size,
			SliceCenter = Assets.Images.RoundedRect.SliceCenter,
			LayoutOrder = p7.props.LayoutOrder
		}, {
			ScrollingFrame = Roact.createElement("ScrollingFrame", {
				Size = UDim2.new(1, -24, 1, -14),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 7),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(1, -24, 0, TextSize.Y),
				ScrollBarThickness = 8,
				VerticalScrollBarInset = Enum.ScrollBarInset.Always,
				CanvasPosition = Vector2.new(0, p7.state.canvasPosition),
				Selectable = false,
				[Roact.Change.CanvasPosition] = function(p10) -- line: 117
					-- upvalues: p7 (copy)
					p7:setState({
						canvasPosition = p10.CanvasPosition.Y
					})
				end,
				[Roact.Change.AbsoluteSize] = function(p11) -- line: 123
					-- upvalues: p7 (copy), p9 (copy), Body (copy)
					p7:setState({
						scrollingFrameHeight = p11.AbsoluteSize.Y
					}, function() -- line: 124
						-- upvalues: p7 (copy), p9 (copy), Body (copy)
						p7:calculateNeedsRescroll(p9, Body)
					end)
				end
			}, {
				TextBox = Roact.createElement("TextBox", {
					Size = UDim2.new(1, -2, 1, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Text = p7.props.text,
					ClearTextOnFocus = false,
					TextEditable = p7.props.enabled,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextColor3 = TextDefault.Color,
					TextTransparency = TextDefault.Transparency,
					Font = Body.Font,
					TextSize = Body.RelativeSize * p9.Font.BaseSize,
					TextWrapped = true,
					MultiLine = true,
					SelectionImageObject = p8(CursorKind.InputFields),
					[Roact.Ref] = p7.textBoxRef,
					[Roact.Change.Text] = function(p12) -- line: 149
						-- upvalues: p7 (copy), p9 (copy), Body (copy)
						local ok, result = pcall(function() -- line: 150
							-- upvalues: p12 (copy)
							return utf8.len(utf8.nfcnormalize(p12.Text))
						end)

						if not ok or result > p7.props.maxTextLength then
							p12.Text = p7.props.text

							return
						end

						p7.props.textChanged(p12.Text)
						p7:setState({
							cursorPosition = p12.CursorPosition
						}, function() -- line: 159
							-- upvalues: p7 (copy), p9 (copy), Body (copy)
							p7:calculateNeedsRescroll(p9, Body)
						end)
					end,
					[Roact.Change.AbsoluteSize] = function(p13) -- line: 164
						-- upvalues: p7 (copy), p9 (copy), Body (copy)
						p7:setState({
							textBoxWidth = p13.AbsoluteSize.X
						}, function() -- line: 165
							-- upvalues: p7 (copy), p9 (copy), Body (copy)
							p7:calculateNeedsRescroll(p9, Body)
						end)
					end,
					[Roact.Change.CursorPosition] = function(p14) -- line: 170
						-- upvalues: p7 (copy), p9 (copy), Body (copy)
						p7:setState({
							cursorPosition = p14.CursorPosition
						}, function() -- line: 171
							-- upvalues: p7 (copy), p9 (copy), Body (copy)
							p7:calculateNeedsRescroll(p9, Body)
						end)
					end
				}, {
					PlaceholderText = Roact.createElement(ThemedTextLabel, {
						themeKey = "TextDefault",
						fontKey = "Body",
						TextTransparency = 0.5,
						TextWrapped = true,
						Text = p7.props.PlaceholderText,
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0, 0, 0, 0),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						Visible = p7.props.text == ""
					})
				})
			}),
			TextAmmountIndicator = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 1,
				Position = UDim2.new(1, -10, 1, -16),
				AnchorPoint = Vector2.new(1, 0.5),
				Size = UDim2.new(0, 20, 0, 20)
			}, { Roact.createElement(FillCircle, {
				popCircleFraction = 1,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				fillFraction = utf8.len(utf8.nfcnormalize(p7.props.text)) / (p7.props.maxTextLength - 10),
				largerCircleFraction = (p7.props.maxTextLength - 20) / p7.props.maxTextLength,
				shakeCircleFraction = p7.props.maxTextLength / (p7.props.maxTextLength - 10),
				BackgroundColor = p9.Theme.BackgroundMuted.Color
			}) })
		})
	end)
end
function v16.render(p15) -- line: 214
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p16) -- line: 215
		-- upvalues: p15 (copy)
		return p15:renderWithSelectionCursor(p16)
	end)
end
function v16.didUpdate(p17, p18, _) -- line: 220
	if not p17.props.enabled and p18.enabled then
		if p17.textBoxRef.current and p17.textBoxRef.current:IsFocused() then
			p17.textBoxRef.current:ReleaseFocus()

			return
		end
	elseif p17.props.enabled and not p18.enabled and p17.props.autoFocusOnEnabled and p17.textBoxRef.current then
		p17.textBoxRef.current:CaptureFocus()
	end
end

return Roact.forwardRef(function(p20, p21) -- line: 233
	-- upvalues: Roact (copy), v16 (copy), Cryo (copy)
	return Roact.createElement(v16, Cryo.Dictionary.join(p20, {
		textBoxRef = p21
	}))
end)
