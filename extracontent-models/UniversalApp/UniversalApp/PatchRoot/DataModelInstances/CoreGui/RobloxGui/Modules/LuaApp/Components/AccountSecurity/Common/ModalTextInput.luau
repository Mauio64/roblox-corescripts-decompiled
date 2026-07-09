local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local GenericTextBox = AuthCommon.Components.GenericTextBox
local PasswordBox = AuthCommon.Components.PasswordBox
local Promise = require(Modules.LuaApp.Promise)
local TextBoxStateWrapper = AuthCommon.Components.TextBoxStateWrapper
local withStyle = UIBlox.Style.withStyle
local v11 = Roact.PureComponent:extend(script.Name)

local function v12() -- line: 21
	-- upvalues: Promise (copy)
	return Promise.resolve(true)
end

v11.defaultProps = {
	onChanged = v12,
	onFocused = v12,
	setError = v12,
	setValue = v12,
	textInputType = Enum.TextInputType.NoSuggestions,
	validate = v12
}

function v11.init(p1) -- line: 34
	function p1.validateAndSetStateForInput(p2) -- line: 35
		-- upvalues: p1 (copy)
		local text = p2.text

		p1.props.onChanged(text)
		p1.props.setValue(text)
		p1.props.validate(text):andThen(p1.props.setError):catch(print)
	end
end
function v11.render(p3) -- line: 45
	-- upvalues: withStyle (copy), Roact (copy), TextBoxStateWrapper (copy), PasswordBox (copy), GenericTextBox (copy)
	local errorText = p3.props.errorText
	local helpComponent = p3.props.helpComponent
	local labelText = p3.props.labelText
	local layoutOrder = p3.props.layoutOrder
	local onFocused = p3.props.onFocused
	local placeholderText = p3.props.placeholderText
	local textInputType = p3.props.textInputType
	local setValue = p3.props.setValue

	return withStyle(function(p4) -- line: 55
		-- upvalues: Roact (copy), TextBoxStateWrapper (copy), textInputType (copy), PasswordBox (copy), GenericTextBox (copy), errorText (copy), setValue (copy), helpComponent (copy), labelText (copy), layoutOrder (copy), p3 (copy), onFocused (copy), placeholderText (copy)
		local BodyFont = p4.Font.Body.Font
		local v27 = p4.Font.BaseSize * p4.Font.Body.RelativeSize
		local TextDefaultColor = p4.Theme.TextDefault.Color
		local TextDefaultTransparency = p4.Theme.TextDefault.Transparency
		local BackgroundUIContrastColor = p4.Theme.BackgroundUIContrast.Color
		local BackgroundUIContrastTransparency = p4.Theme.BackgroundUIContrast.Transparency
		local UIDefaultColor = p4.Theme.UIDefault.Color

		return Roact.createElement(TextBoxStateWrapper, {
			ChildClass = textInputType == Enum.TextInputType.Password and PasswordBox or GenericTextBox,
			ErrorState = errorText ~= nil,
			ErrorText = setValue ~= "" and errorText,
			HelpComponent = helpComponent,
			LabelText = labelText,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, 36),
			ChildProps = {
				ClearTextOnFocus = false,
				PaddingX = 12,
				Text = "",
				Color = BackgroundUIContrastColor,
				Font = BodyFont,
				onChangeText = p3.validateAndSetStateForInput,
				onFocused = onFocused,
				PlaceholderColor = UIDefaultColor,
				PlaceholderText = placeholderText,
				TextColor = TextDefaultColor,
				TextInputType = textInputType,
				TextSize = v27,
				TextTransparency = TextDefaultTransparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				Transparency = BackgroundUIContrastTransparency
			}
		})
	end)
end

return v11
