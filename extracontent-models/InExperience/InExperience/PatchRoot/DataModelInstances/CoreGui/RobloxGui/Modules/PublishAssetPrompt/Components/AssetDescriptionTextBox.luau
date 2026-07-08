local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v15 = Images["component_assets/circle_17_stroke_1"]
local rect = Rect.new(8, 8, 8, 8)
local ParentParent = script.Parent.Parent
local GetFFlagValidateDescription = require(ParentParent.GetFFlagValidateDescription)
local v19 = Roact.PureComponent:extend("AssetDescriptionTextBox")

v19.validateProps = t.strictInterface({
	Size = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	onAssetDescriptionUpdated = t.callback,
	descriptionTextBoxRef = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	assetType = t.optional(t.enum(Enum.AssetType)),
	defaultDescription = t.optional(t.string)
})

local function getStringLength(s1: string) -- line: 53
	local v24 = utf8.len(utf8.nfcnormalize(s1))

	if v24 == nil then
		return 0
	end

	return v24
end
local function isDescriptionTooLong(s2: string, n1: number) -- line: 62
	local v27 = utf8.len(utf8.nfcnormalize(s2))

	return n1 < if v27 ~= nil then v27 else 0
end

function v19.init(p1) -- line: 66
	p1:setState({
		lastValidDescription = "",
		descriptionLength = 0,
		scrollingFrameHeight = 100,
		canvasHeight = 100,
		canvasPosition = 0,
		cursorPosition = 0,
		textBoxWidth = 100,
		isDescriptionValid = true,
		assetDescription = p1.props.defaultDescription or ""
	})
	p1.wasInitiallyFocused = false

	function p1.tryFocusTextBox() -- line: 81
		-- upvalues: p1 (copy)
		if p1.wasInitiallyFocused then
			return
		end

		local v59 = p1.props.descriptionTextBoxRef:getValue()

		if v59 and v59:IsDescendantOf(game) then
			v59:CaptureFocus()
			p1.wasInitiallyFocused = true
		end
	end
end
function v19.calculateNeedsRescroll(t1: {[any]: any}, p2, t2: {[any]: any}) -- line: 95
	-- upvalues: TextService (copy)
	if t1.state.cursorPosition == -1 then
		return
	end

	local v32 = (t1.state.assetDescription or ""):sub(1, t1.state.cursorPosition - 1)
	local v33 = t2.RelativeSize * p2.Font.BaseSize
	local vector2 = Vector2.new(t1.state.textBoxWidth, 10000)
	local TextSize = TextService:GetTextSize(v32, v33, t2.Font, vector2)

	if TextSize.Y > t1.state.scrollingFrameHeight + t1.state.canvasPosition then
		t1:setState({
			canvasPosition = TextSize.Y - t1.state.scrollingFrameHeight
		})

		return
	end

	if TextSize.Y - v33 < t1.state.canvasPosition then
		t1:setState({
			canvasPosition = TextSize.Y - v33
		})
	end
end
function v19.onTextChanged(t3: {[any]: any}, p3, p4, t4: {[any]: any}) -- line: 128
	-- upvalues: GetFFlagValidateDescription (copy), TextService (copy)
	local p3Text = p3.Text
	local v41 = not GetFFlagValidateDescription() or p3Text ~= ""
	local lastValidDescription = t3.state.lastValidDescription
	local v43 = utf8.len(utf8.nfcnormalize(p3Text))

	if ((if v43 ~= nil then v43 else 0)) > 1000 then
		p3Text = lastValidDescription
		p3.Text = p3Text
	else
		lastValidDescription = p3.Text
	end

	local v44 = utf8.len(utf8.nfcnormalize(p3Text))
	local v45 = if v44 ~= nil then v44 else 0
	local v46 = t4.RelativeSize * p4.Font.BaseSize
	local vector2 = Vector2.new(t3.state.textBoxWidth, 10000)
	local TextSize = TextService:GetTextSize(p3Text, v46, t4.Font, vector2)

	t3:setState({
		lastValidDescription = lastValidDescription,
		assetDescription = p3Text,
		descriptionLength = v45,
		canvasHeight = math.max(100, TextSize.Y),
		isDescriptionValid = v41
	})
	t3.props.onAssetDescriptionUpdated(p3Text, v41)
end
function v19.renderWithProviders(p5, p6, p7) -- line: 161
	-- upvalues: GetFFlagValidateDescription (copy), Roact (copy), ImageSetLabel (copy), v15 (copy), rect (copy), Focusable (copy), RobloxTranslator (copy), CursorKind (copy)
	local p6Font = p6.Font
	local CaptionBody = p6Font.CaptionBody
	local Theme = p6.Theme
	local v55 = not not GetFFlagValidateDescription() and not p5.state.isDescriptionValid

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = p5.props.Size,
		Position = p5.props.Position
	}, {
		TextboxContainer = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Image = v15,
			ImageColor3 = Theme.UIDefault.Color,
			ImageTransparency = Theme.UIDefault.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.new(1, 0, 1, -15),
			SliceCenter = rect
		}, {
			ScrollingFrame = Roact.createElement("ScrollingFrame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				CanvasPosition = Vector2.new(0, p5.state.canvasPosition),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 12,
				BorderSizePixel = 0,
				[Roact.Change.CanvasPosition] = function(p8) -- line: 191
					-- upvalues: p5 (copy)
					p5:setState({
						canvasPosition = p8.CanvasPosition.Y
					})
				end,
				[Roact.Change.AbsoluteSize] = function(p9) -- line: 197
					-- upvalues: p5 (copy), p6 (copy), CaptionBody (copy)
					p5:setState({
						scrollingFrameHeight = p9.AbsoluteSize.Y
					})
					p5:calculateNeedsRescroll(p6, CaptionBody)
				end
			}, {
				Textbox = Roact.createElement(Focusable.TextBox, {
					Text = p5.state.assetDescription,
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					Font = p6Font.Header2.Font,
					TextSize = p6Font.BaseSize * CaptionBody.RelativeSize,
					PlaceholderColor3 = Theme.PlaceHolder.Color,
					PlaceholderText = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.AssetDescriptionPlaceholder"),
					Position = UDim2.fromOffset(6, 0),
					Size = UDim2.new(1, -24, 0, p5.state.canvasHeight),
					MultiLine = true,
					TextColor3 = Theme.TextDefault.Color,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					OverlayNativeInput = true,
					NextSelectionUp = p5.props.NextSelectionUp,
					[Roact.Change.TextFits] = p5.onTextFitsChanged,
					SelectionImageObject = p7(CursorKind.InputFields),
					[Roact.Ref] = p5.props.descriptionTextBoxRef,
					[Roact.Event.AncestryChanged] = p5.tryFocusTextBox,
					[Roact.Change.Text] = function(p10) -- line: 230
						-- upvalues: p5 (copy), p6 (copy), CaptionBody (copy)
						p5:onTextChanged(p10, p6, CaptionBody)
					end,
					[Roact.Change.AbsoluteSize] = function(p11) -- line: 234
						-- upvalues: p5 (copy), p6 (copy), CaptionBody (copy)
						p5:setState({
							textBoxWidth = p11.AbsoluteSize.X
						})
						p5:calculateNeedsRescroll(p6, CaptionBody)
					end,
					[Roact.Change.CursorPosition] = function(p12) -- line: 241
						-- upvalues: p5 (copy), p6 (copy), CaptionBody (copy)
						p5:setState({
							cursorPosition = p12.CursorPosition
						})
						p5:calculateNeedsRescroll(p6, CaptionBody)
					end
				})
			})
		}),
		LengthDisplay = if not (p5.state.descriptionLength / 1000 > 0.9) then nil else Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(not GetFFlagValidateDescription() and 1 or 0.2, 0, 0, 15),
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.fromScale(1, 1),
			Text = p5.state.descriptionLength .. "/" .. 1000,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextColor3 = Theme.TextDefault.Color
		}),
		WarningText = GetFFlagValidateDescription() and (v55 and Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			TextSize = 12,
			Position = UDim2.new(0, 0, 1, -15),
			Text = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.InvalidDescription"),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Size = UDim2.new(0.8, 0, 0, 20),
			TextColor3 = Theme.Alert.Color,
			Font = p6Font.Body.Font
		}))
	})
end
function v19.render(p13) -- line: 278
	-- upvalues: withStyle (copy), withSelectionCursorProvider (copy)
	return withStyle(function(p14) -- line: 279
		-- upvalues: withSelectionCursorProvider (copy), p13 (copy)
		return withSelectionCursorProvider(function(p15) -- line: 280
			-- upvalues: p13 (copy), p14 (copy)
			return p13:renderWithProviders(p14, p15)
		end)
	end)
end
function v19.didMount(p16) -- line: 286
	p16.tryFocusTextBox()
end

local function mapStateToProps(p17) -- line: 290
	return {
		assetType = p17.promptRequest.promptInfo.assetType
	}
end

return RoactRodux.connect(mapStateToProps)(v19)
