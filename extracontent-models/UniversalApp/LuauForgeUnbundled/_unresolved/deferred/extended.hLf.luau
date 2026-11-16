local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ecR")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")

local genericTextBox = AuthCommon.Components.GenericTextBox
local authStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder

local extended = module.PureComponent:extend("CodeBox")

extended.defaultProps = { TextInputType = Enum.TextInputType.Number }

function extended:init()
	self:setState({ isFocused = false })

	local binding, v5 = module.createBinding("")
	self.CurrentText = binding
	self.UpdateCurrentText = v5
	self.textBoxRef = module.createRef()

	function self.onChangeText(p2)
		local text = p2.Text

		if self.props.textFilter then
			text = text:gsub(self.props.textFilter, "")
		end

		if self.props.characterCount and #text > self.props.characterCount then
			text = text:sub(1, self.props.characterCount)
		end

		if text ~= p2.Text then
			p2.Text = text
		elseif self.props.onValueChanged then
			self.props.onValueChanged(p2.Text)
		end
	end

	function self.onFocused(object2)
		spawn(function()
			if self.isMounted then
				self:setState({ isFocused = object2:isFocused() })
			end
		end)

		if self.props.onFocused then
			self.props.onFocused(object2)
		end
	end

	function self.onFocusLost(object2, p2, p3)
		spawn(function()
			if self.isMounted then
				self:setState({ isFocused = object2:isFocused() })
			end
		end)

		if self.props.onFocusLost then
			self.props.onFocusLost(object2, p2, p3)
		end
	end
end

function extended:didMount()
	self.isMounted = true
	spawn(function()
		if self.isMounted and self.props.shouldFocus and self.textBoxRef.current then
			self.textBoxRef.current:CaptureFocus()
		end
	end)
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.didUpdate(data, p2, p3)
	if data.textBoxRef.current and not p2.shouldFocus and data.props.shouldFocus then
		data.UpdateCurrentText("")
		data.textBoxRef.current:CaptureFocus()
	end
end

function extended.render(data)
	return withStyle(function(p2)
		local font = p2.Font.Body.Font
		local color = p2.Theme.TextDefault.Color
		local transparency = p2.Theme.TextDefault.Transparency
		local color2 = p2.Theme.BackgroundUIContrast.Color
		local transparency2 = p2.Theme.BackgroundUIContrast.Transparency
		local color3 = p2.Theme.BackgroundUIDefault.Color
		local placeholderText = data.props.PlaceholderText

		local err = data.props.errorState and authStatefulRoundCornerBorder.BorderState.Error
			or data.state.isFocused and authStatefulRoundCornerBorder.BorderState.Focused
			or authStatefulRoundCornerBorder.BorderState.Default

		return module.createElement(
			authStatefulRoundCornerBorder,
			{ size = UDim2.new(1, 0, 0, 36), borderState = err },
			{ module.createElement(genericTextBox, {
					Active = false,
					Size = UDim2.new(1, 0, 1, 0),
					Color = color2,
					Font = font,
					Transparency = transparency2,
					TextSize = 16,
					TextColor = color,
					PlaceholderColor = color3,
					TextTransparency = transparency,
					Text = data.CurrentText,
					TextEditable = data.props.TextEditable,
					PlaceholderText = placeholderText,
					TextInputType = data.props.TextInputType,
					TextBoxRef = data.textBoxRef,
					ClearTextOnFocus = false,
					onChangeText = data.onChangeText,
					onFocused = data.onFocused,
					onFocusLost = data.onFocusLost,
					ManualFocusRelease = data.props.ManualFocusRelease
				}) }
		)
	end)
end

return extended
