local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local Focusable = RoactGamepad.Focusable

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local Style = require(CorePackages.Workspace.Packages.Style)
local GetTextSize = Style.GetTextSize
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind

local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local component_assetscircle_17_stroke_1 = Images["component_assets/circle_17_stroke_1"]
local rect = Rect.new(8, 8, 8, 8)

local extended = Roact.PureComponent:extend("AssetDescriptionTextBox")

extended.validateProps = t.strictInterface({
	Size = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	onAssetDescriptionUpdated = t.callback,
	descriptionTextBoxRef = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	assetType = t.optional(t.enum(Enum.AssetType)),
	defaultDescription = t.optional(t.string)
})

local function getStringLength(p: string) -- 3 equivalent calls inferred from this helper
	local v = utf8.len(utf8.nfcnormalize(p))
	return if v == nil then 0 else v
end

local function isDescriptionTooLong(p: string, p2: number): boolean
	return p2 < getStringLength(p) -- inferred equivalent call
end

function extended:init()
	self:setState({
		lastValidDescription = "",
		assetDescription = self.props.defaultDescription or "",
		descriptionLength = 0,
		scrollingFrameHeight = 100,
		canvasHeight = 100,
		canvasPosition = 0,
		cursorPosition = 0,
		textBoxWidth = 100
	})

	self.wasInitiallyFocused = false

	function self.tryFocusTextBox()
		if self.wasInitiallyFocused then
			return
		end

		local value = self.props.descriptionTextBoxRef:getValue()

		if value and value:IsDescendantOf(game) then
			value:CaptureFocus()
			self.wasInitiallyFocused = true
		end
	end
end

function extended:calculateNeedsRescroll(p, p2)
	if self.state.cursorPosition == -1 then
		return
	end

	local v = (self.state.assetDescription or ""):sub(1, self.state.cursorPosition - 1)
	local v2 = p2.RelativeSize * p.Font.BaseSize
	local vector2 = Vector2.new(self.state.textBoxWidth, 10000)
	local textSize = GetTextSize(v, v2, p.Tokens.Typography.BodySmall.Font, vector2, {
		addTemporaryPadding = false
	})

	if textSize.Y > self.state.scrollingFrameHeight + self.state.canvasPosition then
		self:setState({
			canvasPosition = textSize.Y - self.state.scrollingFrameHeight
		})
	elseif textSize.Y - v2 < self.state.canvasPosition then
		self:setState({
			canvasPosition = textSize.Y - v2
		})
	end
end

function extended:onTextChanged(p, p2, p3)
	local assetDescription = p.Text

	local v = self.state.lastValidDescription

	if getStringLength(assetDescription) > 1000 then -- inferred equivalent call
		p.Text = v
		assetDescription = v
	else
		v = p.Text
	end

	local stringLength = getStringLength(assetDescription) -- inferred equivalent call
	local v2 = p3.RelativeSize * p2.Font.BaseSize
	local vector2 = Vector2.new(self.state.textBoxWidth, 10000)
	self:setState({
		lastValidDescription = v,
		assetDescription = assetDescription,
		descriptionLength = stringLength,
		canvasHeight = math.max(
			100,
			GetTextSize(assetDescription, v2, p2.Tokens.Typography.BodySmall.Font, vector2, {
				addTemporaryPadding = false
			}).Y
		)
	})

	self.props.onAssetDescriptionUpdated(assetDescription)
end

function extended:renderWithProviders(props, callback)
	local font = props.Font
	local captionBody = font.CaptionBody
	local theme = props.Theme

	local createElement = Roact.createElement
	local v = { BackgroundTransparency = 1, Size = self.props.Size, Position = self.props.Position }
	local v2 = {
		TextboxContainer = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = component_assetscircle_17_stroke_1,
			ImageColor3 = theme.UIDefault.Color,
			ImageTransparency = theme.UIDefault.Transparency,
			LayoutOrder = 1,
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.new(1, 0, 1, -15),
			SliceCenter = rect
		}, {
			ScrollingFrame = Roact.createElement("ScrollingFrame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				CanvasPosition = Vector2.new(0, self.state.canvasPosition),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 12,
				BorderSizePixel = 0,
				[Roact.Change.CanvasPosition] = function(p)
					self:setState({ canvasPosition = p.CanvasPosition.Y })
				end,
				[Roact.Change.AbsoluteSize] = function(p)
					self:setState({ scrollingFrameHeight = p.AbsoluteSize.Y })

					self:calculateNeedsRescroll(props, captionBody)
				end
			}, {
				Textbox = Roact.createElement(Focusable.TextBox, {
					Text = self.state.assetDescription,
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
					TextSize = font.BaseSize * captionBody.RelativeSize,
					PlaceholderColor3 = theme.PlaceHolder.Color,
					PlaceholderText = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.AssetDescriptionPlaceholder"),
					Position = UDim2.fromOffset(6, 0),
					Size = UDim2.new(1, -24, 0, self.state.canvasHeight),
					MultiLine = true,
					TextColor3 = theme.TextDefault.Color,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					OverlayNativeInput = true,
					NextSelectionUp = self.props.NextSelectionUp,
					[Roact.Change.TextFits] = self.onTextFitsChanged,
					SelectionImageObject = callback(CursorKind.InputFields),
					[Roact.Ref] = self.props.descriptionTextBoxRef,
					[Roact.Event.AncestryChanged] = self.tryFocusTextBox,
					[Roact.Change.Text] = function(p)
						self:onTextChanged(p, props, captionBody)
					end,
					[Roact.Change.AbsoluteSize] = function(p)
						self:setState({ textBoxWidth = p.AbsoluteSize.X })

						self:calculateNeedsRescroll(props, captionBody)
					end,
					[Roact.Change.CursorPosition] = function(p)
						self:setState({ cursorPosition = p.CursorPosition })

						self:calculateNeedsRescroll(props, captionBody)
					end
				})
			})
		}),
		LengthDisplay = 0
	}
	local lengthDisplay

	if self.state.descriptionLength / 1000 > 0.9 then
		lengthDisplay = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, 15),
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.fromScale(1, 1),
			Text = self.state.descriptionLength .. "/" .. 1000,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextColor3 = theme.TextDefault.Color,
			BackgroundTransparency = 1
		})
	end

	v2.LengthDisplay = lengthDisplay
	return createElement("Frame", v, v2)
end

function extended:render()
	return withStyle(function(p)
		return withSelectionCursorProvider(function(p2)
			return self:renderWithProviders(p, p2)
		end)
	end)
end

function extended.didMount(p)
	p.tryFocusTextBox()
end

local function mapStateToProps(p)
	return { assetType = p.promptRequest.promptInfo.assetType }
end

return RoactRodux.connect(mapStateToProps)(extended)
