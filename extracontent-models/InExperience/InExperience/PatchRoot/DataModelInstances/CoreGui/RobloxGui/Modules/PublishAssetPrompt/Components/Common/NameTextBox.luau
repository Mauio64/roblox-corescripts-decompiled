local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local v11 = Roact.PureComponent:extend("NameTextBox")
local v12 = game:DefineFastFlag("RemoveNameRegex", false)

v11.validateProps = t.strictInterface({
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
v11.defaultProps = {
	maxLength = 50,
	centerText = true,
	invalidInputText = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.InvalidName")
}

local function isNameTooLong(s1: string, n1: number) -- line: 47
	local v16 = utf8.len(utf8.nfcnormalize(s1))

	if v16 == nil then
		return true
	end

	return n1 < v16
end

function v11.init(p1) -- line: 56
	p1:setState({
		lastValidName = "",
		isNameValid = true,
		name = p1.props.defaultName or ""
	})
	p1.wasInitiallyFocused = false

	function p1.tryFocusTextBox() -- line: 65
		-- upvalues: p1 (copy)
		if p1.wasInitiallyFocused then
			return
		end

		local v29 = p1.props.nameTextBoxRef and p1.props.nameTextBoxRef:getValue()

		if v29 and v29:IsDescendantOf(game) then
			v29:CaptureFocus()
			p1.wasInitiallyFocused = true
		end
	end
	function p1.onTextChanged(p2) -- line: 77
		-- upvalues: p1 (copy)
		local p2Text = p2.Text
		local maxLength = p1.props.maxLength
		local v33 = utf8.len(utf8.nfcnormalize(p2Text))

		if v33 == nil or maxLength < v33 then
			p2Text = string.sub(p2Text, 1, utf8.offset(p2Text, maxLength + 1) - 1)
			p2.Text = p2Text
		end

		local v34 = p1:checkIsNameValid(p2Text)
		local lastValidName = p1.state.lastValidName

		if v34 then
			lastValidName = p2.Text
		end

		p1:setState({
			lastValidName = lastValidName,
			isNameValid = v34,
			name = p2Text
		})
		p1.props.onNameUpdated(p2Text, v34)
	end
end
function v11.checkIsNameValid(_, p4) -- line: 104
	-- upvalues: v12 (copy)
	if not v12 then
		if not string.match(p4, "[0-9a-zA-Z_'%s]+$") then
			return false
		end

		if string.sub(p4, 1, 1) == " " then
			return false
		end
	end

	if string.match(p4, "^%s*$") then
		return false
	end

	return true
end
function v11.renderWithProviders(p5, p6, p7) -- line: 124
	-- upvalues: Roact (copy), Focusable (copy), CursorKind (copy)
	local p6Font = p6.Font
	local Theme = p6.Theme
	local Body = p6Font.Body
	local isNameValid = p5.state.isNameValid

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = p5.props.Size,
		Position = p5.props.Position,
		LayoutOrder = p5.props.LayoutOrder
	}, {
		TextBoxContainer = Roact.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundColor3 = Theme.BackgroundMuted.Color,
			Size = p5.props.Size
		}, {
			Textbox = Roact.createElement(Focusable.TextBox, {
				Text = p5.state.name,
				BackgroundTransparency = 1,
				ClearTextOnFocus = false,
				Font = Body.Font,
				TextSize = p6Font.BaseSize * Body.RelativeSize,
				PlaceholderColor3 = Theme.PlaceHolder.Color,
				PlaceholderText = p5.props.defaultName,
				Position = UDim2.fromOffset(6, 0),
				Size = UDim2.new(1, -12, 1, 0),
				TextColor3 = Theme.TextDefault.Color,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = if p5.props.centerText then nil else Enum.TextYAlignment.Top,
				OverlayNativeInput = true,
				[Roact.Change.Text] = p5.onTextChanged,
				SelectionImageObject = p7(CursorKind.InputFields),
				NextSelectionDown = p5.props.NextSelectionDown,
				[Roact.Ref] = p5.props.nameTextBoxRef,
				[Roact.Event.AncestryChanged] = p5.tryFocusTextBox
			}, {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
					PaddingTop = if p5.props.centerText then nil else UDim.new(0, 6)
				})
			}),
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			UIStroke = Roact.createElement("UIStroke", {
				Thickness = 0.5,
				Transparency = Theme.Divider.Transparency,
				Color = Theme.Divider.Color,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			})
		}),
		WarningText = not isNameValid and Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			TextWrapped = true,
			TextSize = 12,
			Position = UDim2.new(0, 0, 1, 0),
			Text = p5.props.invalidInputText,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Size = UDim2.new(1, 0, 0, 20),
			TextColor3 = Theme.Alert.Color,
			Font = p6Font.Body.Font
		})
	})
end
function v11.render(p8) -- line: 200
	-- upvalues: withStyle (copy), withSelectionCursorProvider (copy)
	return withStyle(function(p9) -- line: 201
		-- upvalues: withSelectionCursorProvider (copy), p8 (copy)
		return withSelectionCursorProvider(function(p10) -- line: 202
			-- upvalues: p8 (copy), p9 (copy)
			return p8:renderWithProviders(p9, p10)
		end)
	end)
end
function v11.didMount(p11) -- line: 208
	p11.tryFocusTextBox()
end

return v11
