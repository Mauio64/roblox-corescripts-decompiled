local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local Cryo = InGameMenuDependencies.Cryo
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Images = UIBlox.App.ImageSet.Images
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v12 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v13 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local ParentParent = script.Parent.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local FillCircle = require(script.Parent.FillCircle)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local FoundationImage = Foundation.Image
local v20 = Roact.PureComponent:extend("TextEntryField")
local v21 = Images["component_assets/circle_17"]

v20.validateProps = t.strictInterface({
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

function v20.init(p1) -- line: 63
	-- upvalues: Roact (copy)
	p1.textBoxRef = p1.props.textBoxRef or Roact.createRef()
	p1.state = {
		textBoxWidth = 100,
		scrollingFrameHeight = 100,
		canvasPosition = 0,
		cursorPosition = 0
	}
end
function v20.calculateNeedsRescroll(p2, p3, p4) -- line: 74
	-- upvalues: TextService (copy)
	p2:setState(function(p5, p6) -- line: 75
		-- upvalues: p4 (copy), p3 (copy), TextService (copy)
		if p5.cursorPosition == -1 then
			return nil
		end

		local v36 = p6.text:sub(1, p5.cursorPosition - 1)
		local v37 = p4.RelativeSize * p3.Font.BaseSize
		local vector2 = Vector2.new(p6.textBoxWidth, 10000)
		local TextSize = TextService:GetTextSize(v36, v37, p4.Font, vector2)

		if TextSize.Y > p5.scrollingFrameHeight + p5.canvasPosition then
			return {
				canvasPosition = TextSize.Y - p5.scrollingFrameHeight
			}
		end

		if TextSize.Y - v37 < p5.canvasPosition then
			return {
				canvasPosition = TextSize.Y - v37
			}
		end

		return nil
	end)
end
function v20.renderWithSelectionCursor(p7, p8) -- line: 97
	-- upvalues: withFoundationOrUIBloxStyle (copy), TextService (copy), v21 (copy), Roact (copy), v13 (copy), ThemedTextLabel (copy), Images (copy), FillCircle (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), Assets (copy), ImageSetLabel (copy)
	return withFoundationOrUIBloxStyle(function(p9) -- line: 98
		return {
			Theme = {
				TextDefault = {
					Color = p9.Color.Content.Default.Color3,
					Transparency = p9.Color.Content.Default.Transparency
				},
				BackgroundMuted = {
					Color = p9.Color.Surface.Surface_200.Color3,
					Transparency = p9.Color.Surface.Surface_200.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				Body = {
					Font = p9.Typography.BodyLarge.Font,
					RelativeSize = p9.Typography.BodyLarge.FontSize
				}
			}
		}
	end, function(p10) -- line: 109
		-- upvalues: TextService (copy), p7 (copy), v21 (copy), Roact (copy), p8 (copy), v13 (copy), ThemedTextLabel (copy), Images (copy), FillCircle (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), Assets (copy), ImageSetLabel (copy)
		local TextDefault = p10.Theme.TextDefault
		local Body = p10.Font.Body
		local TextSize = TextService:GetTextSize(p7.props.text, Body.RelativeSize * p10.Font.BaseSize, Body.Font, Vector2.new(p7.state.textBoxWidth, 10000))
		local ImageRectSize = v21.ImageRectSize
		local ImageRectOffset = v21.ImageRectOffset
		local ImageRectSizeX = ImageRectSize.X
		local v48 = ImageRectSizeX / 2
		local t1 = {
			ScrollingFrame = Roact.createElement("ScrollingFrame", {
				Size = UDim2.new(1, -24, 1, -44),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 7),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(1, -24, 0, TextSize.Y),
				ScrollBarThickness = 8,
				VerticalScrollBarInset = Enum.ScrollBarInset.Always,
				CanvasPosition = Vector2.new(0, p7.state.canvasPosition),
				Selectable = false,
				[Roact.Change.CanvasPosition] = function(p11) -- line: 138
					-- upvalues: p7 (copy)
					p7:setState({
						canvasPosition = p11.CanvasPosition.Y
					})
				end,
				[Roact.Change.AbsoluteSize] = function(p12) -- line: 144
					-- upvalues: p7 (copy), p10 (copy), Body (copy)
					p7:setState({
						scrollingFrameHeight = p12.AbsoluteSize.Y
					}, function() -- line: 145
						-- upvalues: p7 (copy), p10 (copy), Body (copy)
						p7:calculateNeedsRescroll(p10, Body)
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
					TextSize = Body.RelativeSize * p10.Font.BaseSize,
					TextWrapped = true,
					SelectionImageObject = p8(v13.InputFields),
					[Roact.Ref] = p7.textBoxRef,
					[Roact.Change.Text] = function(p13) -- line: 170
						-- upvalues: p7 (copy), p10 (copy), Body (copy)
						if utf8.len(utf8.nfcnormalize(p13.Text)) > p7.props.maxTextLength then
							local v54 = utf8.offset(p13.Text, p7.props.maxTextLength + 1) - 1

							p13.Text = string.sub(p13.Text, 1, v54)

							return
						end

						p7.props.textChanged(p13.Text)
						p7:setState({
							cursorPosition = p13.CursorPosition
						}, function() -- line: 177
							-- upvalues: p7 (copy), p10 (copy), Body (copy)
							p7:calculateNeedsRescroll(p10, Body)
						end)
					end,
					[Roact.Change.AbsoluteSize] = function(p14) -- line: 182
						-- upvalues: p7 (copy), p10 (copy), Body (copy)
						p7:setState({
							textBoxWidth = p14.AbsoluteSize.X
						}, function() -- line: 183
							-- upvalues: p7 (copy), p10 (copy), Body (copy)
							p7:calculateNeedsRescroll(p10, Body)
						end)
					end,
					[Roact.Change.CursorPosition] = function(p15) -- line: 188
						-- upvalues: p7 (copy), p10 (copy), Body (copy)
						p7:setState({
							cursorPosition = p15.CursorPosition
						}, function() -- line: 189
							-- upvalues: p7 (copy), p10 (copy), Body (copy)
							p7:calculateNeedsRescroll(p10, Body)
						end)
					end
				}, {
					PlaceholderText = Roact.createElement(ThemedTextLabel, {
						themeKey = "TextDefault",
						fontKey = "Body",
						TextTransparency = 0.5,
						Text = p7.props.PlaceholderText,
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0, 0, 0, 0),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						Visible = p7.props.text == ""
					})
				})
			}),
			BottomBar = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				ImageTransparency = 0,
				Image = v21.Image,
				ImageColor3 = p10.Theme.BackgroundMuted.Color,
				ScaleType = Enum.ScaleType.Slice,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 32),
				SliceCenter = Rect.new(v48 - 1, 0, v48 + 1, 1),
				SliceScale = 1 / Images.ImagesResolutionScale,
				ImageRectSize = Vector2.new(ImageRectSizeX, v48),
				ImageRectOffset = ImageRectOffset + Vector2.new(0, v48)
			}, {
				TextAmmountIndicator = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Position = UDim2.new(1, -10, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					Size = UDim2.new(0, 20, 0, 20)
				}, { Roact.createElement(FillCircle, {
					popCircleFraction = 1,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					fillFraction = utf8.len(utf8.nfcnormalize(p7.props.text)) / (p7.props.maxTextLength - 10),
					largerCircleFraction = (p7.props.maxTextLength - 20) / p7.props.maxTextLength,
					shakeCircleFraction = p7.props.maxTextLength / (p7.props.maxTextLength - 10),
					BackgroundColor = p10.Theme.BackgroundMuted.Color
				}) })
			})
		}

		if FFlagCoreUiMigrateUIBloxToFoundation then
			return Roact.createElement(FoundationImage, {
				Image = Assets.Images.RoundedRectImageKey,
				imageStyle = {
					Color3 = p10.Theme.BackgroundMuted.Color,
					Transparency = p10.Theme.BackgroundMuted.Transparency
				},
				Position = p7.props.Position,
				Size = p7.props.Size,
				LayoutOrder = p7.props.LayoutOrder,
				slice = {
					center = Rect.new(8, 8, 9, 9)
				}
			}, t1)
		end

		return Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = Assets.Images.RoundedRect.Image,
			ImageColor3 = p10.Theme.BackgroundMuted.Color,
			ImageTransparency = p10.Theme.BackgroundMuted.Transparency,
			Position = p7.props.Position,
			ScaleType = Assets.Images.RoundedRect.ScaleType,
			Size = p7.props.Size,
			SliceCenter = Assets.Images.RoundedRect.SliceCenter,
			LayoutOrder = p7.props.LayoutOrder
		}, t1)
	end)
end
function v20.render(p16) -- line: 273
	-- upvalues: v12 (copy)
	return v12(function(p17) -- line: 274
		-- upvalues: p16 (copy)
		return p16:renderWithSelectionCursor(p17)
	end)
end
function v20.didUpdate(p18, p19, _) -- line: 279
	if not p18.props.enabled and p19.enabled then
		if p18.textBoxRef.current and p18.textBoxRef.current:IsFocused() then
			p18.textBoxRef.current:ReleaseFocus()

			return
		end
	elseif p18.props.enabled and not p19.enabled and p18.props.autoFocusOnEnabled and p18.textBoxRef.current then
		p18.textBoxRef.current:CaptureFocus()
	end
end

return Roact.forwardRef(function(p21, p22) -- line: 292
	-- upvalues: Roact (copy), v20 (copy), Cryo (copy)
	return Roact.createElement(v20, Cryo.Dictionary.join(p21, {
		textBoxRef = p22
	}))
end)
