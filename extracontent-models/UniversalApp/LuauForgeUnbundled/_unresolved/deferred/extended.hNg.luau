local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")

local genericTextBox = AuthCommon.Components.GenericTextBox
local passwordBox = AuthCommon.Components.PasswordBox
local module2 = require("@luauforge/bundled/ecV")
local textBoxStateWrapper = AuthCommon.Components.TextBoxStateWrapper

local withStyle = UIBlox.Style.withStyle

local extended = Roact.PureComponent:extend("ModalTextInput")

local function fn()
	return module2.resolve(true)
end

extended.defaultProps = {
	onChanged = fn,
	onFocused = fn,
	setError = fn,
	setValue = fn,
	textInputType = Enum.TextInputType.NoSuggestions,
	validate = fn
}

function extended:init()
	function self.validateAndSetStateForInput(p3)
		local text = p3.text
		self.props.onChanged(text)
		self.props.setValue(text)

		self.props.validate(text):andThen(self.props.setError):catch(print)
	end
end

function extended.render(p2)
	local errorText = p2.props.errorText
	local helpComponent = p2.props.helpComponent
	local labelText = p2.props.labelText
	local layoutOrder = p2.props.layoutOrder
	local onFocused = p2.props.onFocused
	local placeholderText = p2.props.placeholderText
	local textInputType = p2.props.textInputType
	local setValue = p2.props.setValue

	return withStyle(function(p3)
		local font = p3.Font.Body.Font
		local v5 = p3.Font.BaseSize * p3.Font.Body.RelativeSize
		local color = p3.Theme.TextDefault.Color
		local transparency = p3.Theme.TextDefault.Transparency
		local color2 = p3.Theme.BackgroundUIContrast.Color
		local transparency2 = p3.Theme.BackgroundUIContrast.Transparency
		local color3 = p3.Theme.UIDefault.Color

		return Roact.createElement(textBoxStateWrapper, {
			ChildClass = textInputType == Enum.TextInputType.Password and passwordBox or genericTextBox,
			ErrorState = errorText ~= nil,
			ErrorText = setValue ~= "" and errorText,
			HelpComponent = helpComponent,
			LabelText = labelText,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, 36),
			ChildProps = {
				ClearTextOnFocus = false,
				Color = color2,
				Font = font,
				onChangeText = p2.validateAndSetStateForInput,
				onFocused = onFocused,
				PaddingX = 12,
				PlaceholderColor = color3,
				PlaceholderText = placeholderText,
				Text = "",
				TextColor = color,
				TextInputType = textInputType,
				TextSize = v5,
				TextTransparency = transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				Transparency = transparency2
			}
		})
	end)
end

return extended
