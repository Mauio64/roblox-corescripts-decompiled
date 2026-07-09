local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Common = Modules.Common
local Roact = require(Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local GenericTextButton = require(Modules.LuaApp.Components.GenericTextButton)
local Colors = require(Modules.LuaApp.Themes.Colors)
local v10 = Roact.Component:extend("CodeBoxes")

v10.defaultProps = {
	characterCount = 6,
	value = "",
	Transparency = 0
}

function v10.init(p1) -- line: 26
	-- upvalues: Roact (copy)
	p1.state = {
		textCursorVisible = true,
		textBoxOffset = 1000
	}
	p1.textBoxRef = Roact.createRef()

	function p1.onTextChanged(p2, p3) -- line: 34
		-- upvalues: p1 (copy)
		local v34 = p2.Text:gsub("[^%d]", "")

		if p3 < #p2.Text then
			v34 = v34:sub(1, p3)
		end

		if v34 ~= p2.Text then
			p2.Text = v34

			return
		end

		if p1.props.onValueChanged then
			p1.props.onValueChanged(v34)
		end

		if p3 == #p2.Text and p1.props.onAllBoxesFilled then
			p1.props.onAllBoxesFilled()
		end
	end
	function p1.onCodeBoxActivated(_) -- line: 62
		-- upvalues: p1 (copy)
		local textBoxRef = p1.textBoxRef

		if not textBoxRef then
			return
		end

		if not textBoxRef.current then
			return
		end

		textBoxRef.current:CaptureFocus()
	end
	function p1.updateTextBoxOffset(p5) -- line: 74
		-- upvalues: p1 (copy)
		if p1.mounted and p1.props.screenHeight then
			p1:setState({
				textBoxOffset = p1.props.screenHeight - p5.AbsolutePosition.Y + 100
			})
		end
	end
end
function v10.didMount(p6) -- line: 83
	p6.mounted = true
	spawn(function() -- line: 85
		-- upvalues: p6 (copy)
		if p6.mounted and (p6.props.shouldFocus and p6.textBoxRef.current) then
			p6.textBoxRef.current:CaptureFocus()
		end

		while p6.mounted do
			p6:setState({
				textCursorVisible = not p6.state.textCursorVisible
			})
			wait(0.5)
		end
	end)
end
function v10.willUnmount(p7) -- line: 99
	p7.mounted = false
end
function v10.didUpdate(p8, p9, _) -- line: 103
	if p8.textBoxRef.current and (not p9.shouldFocus and p8.props.shouldFocus) then
		p8.textBoxRef.current:CaptureFocus()
	end
end
function v10.render(p11) -- line: 109
	-- upvalues: Roact (copy), UserInputService (copy), GenericTextButton (copy), AppFonts (copy), Colors (copy)
	local characterCount = p11.props.characterCount
	local propsLayoutOrder = p11.props.LayoutOrder
	local value = p11.props.value
	local propsTransparency = p11.props.Transparency
	local textBoxRef = p11.textBoxRef
	local onInvisibleTextBoxAncestryChanged = p11.props.onInvisibleTextBoxAncestryChanged
	local onInvisibleTextBoxFocused = p11.props.onInvisibleTextBoxFocused
	local v25 = 0.3 + propsTransparency * 0.7
	local t1 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 13)
		})
	}
	local uDim2 = UDim2.new(1 / characterCount, 13 / (characterCount + 1) - 13, 1, 0)

	for i = 1, characterCount do
		local v29 = value:sub(i, i) or ""

		if textBoxRef and textBoxRef.current and i == #value + 1 and UserInputService:GetFocusedTextBox() == textBoxRef.current then
			v29 = not p11.state.textCursorVisible and "" or "|"
		end

		t1[i] = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = uDim2,
			LayoutOrder = i
		}, {
			Character = Roact.createElement(GenericTextButton, {
				TextSize = 16,
				isDisabled = false,
				isLoading = false,
				AutoButtonColor = false,
				Size = UDim2.new(1, 0, 1, 0),
				Text = v29,
				Font = AppFonts.default:getDefault(),
				themeSettings = {
					Color = Colors.Black,
					Transparency = v25,
					OnPressColor = Colors.Black,
					OnPressTransparency = v25,
					Text = {
						Color = Colors.White,
						Transparency = propsTransparency
					},
					Border = {
						Hidden = true,
						Transparency = 1
					}
				},
				onActivated = p11.onCodeBoxActivated
			})
		})
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundTransparency = 1,
		LayoutOrder = propsLayoutOrder,
		[Roact.Change.AbsolutePosition] = p11.updateTextBoxOffset
	}, {
		CodeCharacters = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, 36),
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0)
		}, t1),
		InvisibleTextBox = Roact.createElement("TextBox", {
			Size = UDim2.new(0, 1, 0, 1),
			Position = UDim2.new(0, 0, 0, p11.state.textBoxOffset),
			BackgroundTransparency = 1,
			TextTransparency = 1,
			Text = value,
			TextSize = 1,
			OverlayNativeInput = true,
			ManualFocusRelease = true,
			ClearTextOnFocus = false,
			TextInputType = Enum.TextInputType.Number,
			[Roact.Ref] = textBoxRef,
			[Roact.Change.Text] = function(p12) -- line: 198
				-- upvalues: p11 (copy), characterCount (copy)
				p11.onTextChanged(p12, characterCount)
			end,
			[Roact.Event.AncestryChanged] = onInvisibleTextBoxAncestryChanged,
			[Roact.Event.Focused] = onInvisibleTextBoxFocused
		})
	})
end

return (RoactRodux.connect(function(p13, _) -- line: 207
	return {
		screenHeight = p13.ScreenSize.Y
	}
end)(v10))
