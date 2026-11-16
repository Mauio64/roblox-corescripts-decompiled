local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local Focusable = RoactGamepad.Focusable

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind

local extended = Roact.PureComponent:extend("NameTextBox")
local defineFastFlag = game:DefineFastFlag("RemoveNameRegex", false)

extended.validateProps = t.strictInterface({
	Size = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	centerText = t.optional(t.boolean),
	maxLength = t.optional(t.number),
	onNameUpdated = t.callback,
	LayoutOrder = t.optional(t.number),
	nameTextBoxRef = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	defaultName = t.optional(t.string),
	invalidInputText = t.optional(t.string)
})

extended.defaultProps = {
	maxLength = 50,
	centerText = true,
	invalidInputText = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.InvalidName")
}

local function isNameTooLong(text: string, maxLength: number): boolean -- 1 equivalent call inferred from this helper
	local v = utf8.len(utf8.nfcnormalize(text))
	return v == nil or maxLength < v
end

function extended:init()
	self:setState({
		name = self.props.defaultName or "",
		lastValidName = "",
		isNameValid = true
	})

	self.wasInitiallyFocused = false

	function self.tryFocusTextBox()
		if self.wasInitiallyFocused then
			return
		end

		local v = self.props.nameTextBoxRef and self.props.nameTextBoxRef:getValue()

		if v and v:IsDescendantOf(game) then
			v:CaptureFocus()
			self.wasInitiallyFocused = true
		end
	end

	function self.onTextChanged(p)
		local text = p.Text

		local maxLength = self.props.maxLength

		if isNameTooLong(text, maxLength) then -- inferred equivalent call
			text = string.sub(text, 1, utf8.offset(text, maxLength + 1) - 1)
			p.Text = text
		end

		local isNameValid = self:checkIsNameValid(text)

		local lastValidName = self.state.lastValidName

		if isNameValid then
			lastValidName = p.Text
		end

		self:setState({ lastValidName = lastValidName, isNameValid = isNameValid, name = text })

		self.props.onNameUpdated(text, isNameValid)
	end
end

function extended:checkIsNameValid(value): boolean
	if not defineFastFlag then
		if not (string.match(value, "[0-9a-zA-Z_'%s]+$") and string.sub(value, 1, 1) ~= " ") then
			return false
		end
	end

	return not string.match(value, "^%s*$")
end

function extended:renderWithProviders(props, callback)
	local font = props.Font
	local theme = props.Theme

	local body = font.Body

	local warningText = not self.state.isNameValid

	local createElement = Roact.createElement
	local v = {
		BackgroundTransparency = 1,
		Size = self.props.Size,
		Position = self.props.Position,
		LayoutOrder = self.props.LayoutOrder
	}

	local createElement2 = Roact.createElement
	local v2 = {
		BackgroundColor3 = theme.BackgroundMuted.Color,
		LayoutOrder = 1,
		Size = self.props.Size
	}

	local createElement3 = Roact.createElement
	local textBox = Focusable.TextBox
	local v3 = {}
	v3.Text = self.state.name
	v3.BackgroundTransparency = 1
	v3.ClearTextOnFocus = false
	local font2

	if not FoundationFontFaceMigration then
		font2 = body.Font
	end

	v3.Font = font2
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
	end

	v3.FontFace = fontFace

	v3.TextSize = font.BaseSize * body.RelativeSize
	v3.PlaceholderColor3 = theme.PlaceHolder.Color
	v3.PlaceholderText = self.props.defaultName
	v3.Position = UDim2.fromOffset(6, 0)
	v3.Size = UDim2.new(1, -12, 1, 0)
	v3.TextColor3 = theme.TextDefault.Color
	v3.TextTruncate = Enum.TextTruncate.AtEnd
	v3.TextWrapped = true
	v3.TextXAlignment = Enum.TextXAlignment.Left
	local textYAlignment

	if not self.props.centerText then
		textYAlignment = Enum.TextYAlignment.Top
	end

	v3.TextYAlignment = textYAlignment
	v3.OverlayNativeInput = true
	v3[Roact.Change.Text] = self.onTextChanged
	v3.SelectionImageObject = callback(CursorKind.InputFields)
	v3.NextSelectionDown = self.props.NextSelectionDown

	v3[Roact.Ref] = self.props.nameTextBoxRef
	v3[Roact.Event.AncestryChanged] = self.tryFocusTextBox

	local createElement4 = Roact.createElement
	local v5 = { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingTop = 0 }
	local paddingTop

	if not self.props.centerText then
		paddingTop = UDim.new(0, 6)
	end

	v5.PaddingTop = paddingTop
	local v4 = {
		TextBoxContainer = createElement2("Frame", v2, {
			Textbox = createElement3(textBox, v3, {
				UIPadding = createElement4("UIPadding", v5)
			}),
			UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			UIStroke = Roact.createElement("UIStroke", {
				Thickness = 0.5,
				Transparency = theme.Divider.Transparency,
				Color = theme.Divider.Color,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			})
		}),
		WarningText = 0
	}

	if warningText then
		local createElement5 = Roact.createElement
		local v6 = {
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = self.props.invalidInputText,
			LayoutOrder = 2,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Size = UDim2.new(1, 0, 0, 20),
			TextColor3 = theme.Alert.Color,
			TextWrapped = true,
			Font = 0,
			FontFace = 0,
			TextSize = 12
		}
		local font3

		if not FoundationFontFaceMigration then
			font3 = font.Body.Font
		end

		v6.Font = font3
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v6.FontFace = fontFace2
		warningText = createElement5("TextLabel", v6)
	end

	v4.WarningText = warningText
	return createElement("Frame", v, v4)
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

return extended
