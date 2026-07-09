local CorePackages = game:GetService("CorePackages")
local Common = game:GetService("CoreGui").RobloxGui.Modules.Common
local Roact = require(Common.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local GenericTextBox = AuthCommon.Components.GenericTextBox
local AuthStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local v8 = Roact.PureComponent:extend("CodeBox")

v8.defaultProps = {
	TextInputType = Enum.TextInputType.Number
}

function v8.init(p1) -- line: 24
	-- upvalues: Roact (copy)
	p1:setState({
		isFocused = false
	})

	local v10, v11 = Roact.createBinding("")

	p1.CurrentText = v10
	p1.UpdateCurrentText = v11
	p1.textBoxRef = Roact.createRef()

	function p1.onChangeText(p2) -- line: 32
		-- upvalues: p1 (copy)
		local p2Text = p2.Text

		if p1.props.textFilter then
			p2Text = p2Text:gsub(p1.props.textFilter, "")
		end

		if p1.props.characterCount and #p2Text > p1.props.characterCount then
			p2Text = p2Text:sub(1, p1.props.characterCount)
		end

		if p2Text ~= p2.Text then
			p2.Text = p2Text

			return
		end

		if p1.props.onValueChanged then
			p1.props.onValueChanged(p2.Text)
		end
	end
	function p1.onFocused(p3) -- line: 50
		-- upvalues: p1 (copy)
		spawn(function() -- line: 51
			-- upvalues: p1 (copy), p3 (copy)
			if p1.isMounted then
				p1:setState({
					isFocused = p3:isFocused()
				})
			end
		end)

		if p1.props.onFocused then
			p1.props.onFocused(p3)
		end
	end
	function p1.onFocusLost(p4, p5, p6) -- line: 65
		-- upvalues: p1 (copy)
		spawn(function() -- line: 66
			-- upvalues: p1 (copy), p4 (copy)
			if p1.isMounted then
				p1:setState({
					isFocused = p4:isFocused()
				})
			end
		end)

		if p1.props.onFocusLost then
			p1.props.onFocusLost(p4, p5, p6)
		end
	end
end
function v8.didMount(p7) -- line: 80
	p7.isMounted = true
	spawn(function() -- line: 82
		-- upvalues: p7 (copy)
		if p7.isMounted and (p7.props.shouldFocus and p7.textBoxRef.current) then
			p7.textBoxRef.current:CaptureFocus()
		end
	end)
end
function v8.willUnmount(p8) -- line: 91
	p8.isMounted = false
end
function v8.didUpdate(p9, p10, _) -- line: 95
	if p9.textBoxRef.current and (not p10.shouldFocus and p9.props.shouldFocus) then
		p9.UpdateCurrentText("")
		p9.textBoxRef.current:CaptureFocus()
	end
end
function v8.render(p12) -- line: 102
	-- upvalues: withStyle (copy), AuthStatefulRoundCornerBorder (copy), Roact (copy), GenericTextBox (copy)
	return withStyle(function(p13) -- line: 103
		-- upvalues: p12 (copy), AuthStatefulRoundCornerBorder (copy), Roact (copy), GenericTextBox (copy)
		local BodyFont = p13.Font.Body.Font
		local TextDefaultColor = p13.Theme.TextDefault.Color
		local TextDefaultTransparency = p13.Theme.TextDefault.Transparency
		local BackgroundUIContrastColor = p13.Theme.BackgroundUIContrast.Color
		local BackgroundUIContrastTransparency = p13.Theme.BackgroundUIContrast.Transparency
		local BackgroundUIDefaultColor = p13.Theme.BackgroundUIDefault.Color
		local PlaceholderText = p12.props.PlaceholderText
		local v32 = p12.props.errorState and AuthStatefulRoundCornerBorder.BorderState.Error or (p12.state.isFocused and AuthStatefulRoundCornerBorder.BorderState.Focused or AuthStatefulRoundCornerBorder.BorderState.Default)

		return Roact.createElement(AuthStatefulRoundCornerBorder, {
			size = UDim2.new(1, 0, 0, 36),
			borderState = v32
		}, { Roact.createElement(GenericTextBox, {
			Active = false,
			TextSize = 16,
			ClearTextOnFocus = false,
			Size = UDim2.new(1, 0, 1, 0),
			Color = BackgroundUIContrastColor,
			Font = BodyFont,
			Transparency = BackgroundUIContrastTransparency,
			TextColor = TextDefaultColor,
			PlaceholderColor = BackgroundUIDefaultColor,
			TextTransparency = TextDefaultTransparency,
			Text = p12.CurrentText,
			TextEditable = p12.props.TextEditable,
			PlaceholderText = PlaceholderText,
			TextInputType = p12.props.TextInputType,
			TextBoxRef = p12.textBoxRef,
			onChangeText = p12.onChangeText,
			onFocused = p12.onFocused,
			onFocusLost = p12.onFocusLost,
			ManualFocusRelease = p12.props.ManualFocusRelease
		}) })
	end)
end

return v8
