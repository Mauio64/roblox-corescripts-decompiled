local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local ImageSetLabel = dependencies.UIBlox.Core.ImageSet.ImageSetLabel
local v5 = Roact.PureComponent:extend("CallbackInputBox")

v5.defaultProps = {
	initialInputText = "",
	inputTextFont = Enum.Font.BuilderSans,
	inputTextColor3 = Color3.new(1, 0, 1),
	inputTextSize = 14,
	inputTextYAlignment = Enum.TextYAlignment.Center,
	inputTextXAlignment = Enum.TextXAlignment.Center,
	inputTextTransparency = 0,
	placeholderTextTransparency = 0.6,
	placeholderTextColor3 = Color3.new(1, 0, 0),
	placeholderText = "Test placeholder text",
	clearIcon = "rbxasset://textures/ui/LuaChat/icons/ic-close-white.png",
	clearIconColor3 = Color3.new(1, 1, 0),
	clearIconTransparency = 0,
	clearButtonSize = 24,
	clipsDescendants = true,
	manualFocusRelease = false,
	captureFocusOnMount = false,
	multiLine = false,
	textWrapped = false,
	showCancelIconOnLoad = false,
	textInputType = Enum.TextInputType.Default,
	returnKeyType = Enum.ReturnKeyType.Default,
	inputBoxSelectionImageObject = nil,
	clearButtonSelectionImageObject = nil,
	clearButtonDisabled = nil,
	textChangedCallback = nil,
	focusChangedCallback = function() -- line: 40
	end,
	onSelectCallback = function() -- line: 41
	end,
	returnPressedFromOnScreenKeyboardCallback = function() -- line: 42
	end,
	inputBoxRef = nil,
	[Roact.Change.AbsoluteSize] = function() -- line: 46
	end
}

function v5.init(p1) -- line: 49
	-- upvalues: Roact (copy)
	p1.clearRef = Roact.createRef()
	p1.inputBoxRef = p1.props.inputBoxRef or Roact.createRef()
	p1.inputText = p1.props.initialInputText
	p1.textChangedEventUnlocked = false

	function p1.focusTextbox() -- line: 60
		-- upvalues: p1 (copy)
		p1.props.onSelectCallback()

		if not p1.inputBoxRef.current:IsFocused() then
			p1.inputBoxRef.current:captureFocus()
		end
	end
end
function v5.render(p2) -- line: 68
	-- upvalues: Roact (copy), ImageSetLabel (copy)
	local placeholderTextTransparency = p2.props.placeholderTextTransparency
	local inputTextTransparency = p2.props.inputTextTransparency
	local v10 = if not not p2.inputText and p2.inputText ~= "" then inputTextTransparency else placeholderTextTransparency

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		layout = Roact.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		inputBox = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			inputTextBox = Roact.createElement("TextBox", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -p2.props.clearButtonSize, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				TextColor3 = p2.props.inputTextColor3,
				TextSize = p2.props.inputTextSize,
				TextTransparency = v10,
				Font = p2.props.inputTextFont,
				PlaceholderText = p2.props.placeholderText,
				PlaceholderColor3 = p2.props.placeholderTextColor3,
				TextXAlignment = p2.props.inputTextXAlignment,
				TextYAlignment = p2.props.inputTextYAlignment,
				OverlayNativeInput = true,
				ClearTextOnFocus = false,
				ClipsDescendants = p2.props.clipsDescendants,
				LayoutOrder = 1,
				ManualFocusRelease = p2.props.manualFocusRelease,
				MultiLine = p2.props.multiLine,
				TextWrapped = p2.props.textWrapped,
				TextInputType = p2.props.textInputType,
				ReturnKeyType = p2.props.returnKeyType,
				SelectionImageObject = p2.props.inputBoxSelectionImageObject,
				[Roact.Event.ReturnPressedFromOnScreenKeyboard] = p2.props.returnPressedFromOnScreenKeyboardCallback,
				[Roact.Event.TouchTap] = p2.focusTextbox,
				[Roact.Event.Focused] = function(p3) -- line: 134
					-- upvalues: p2 (copy), inputTextTransparency (copy), placeholderTextTransparency (copy)
					if p2.inputBoxRef.current and p2.inputBoxRef.current.Text ~= "" then
						if p2.clearRef.current and not p2.props.clearButtonDisabled then
							p2.clearRef.current.Visible = true
						end

						p3.TextColor3 = p2.props.inputTextColor3
						p3.TextTransparency = inputTextTransparency
					else
						p3.TextColor3 = p2.props.placeholderTextColor3
						p3.TextTransparency = placeholderTextTransparency
					end

					p2.props.focusChangedCallback(true)
				end,
				[Roact.Event.FocusLost] = function(p4, p5) -- line: 150
					-- upvalues: p2 (copy), placeholderTextTransparency (copy)
					if p2.inputBoxRef.current and p2.inputBoxRef.current.Text == "" then
						p4.TextColor3 = p2.props.placeholderTextColor3
						p4.TextTransparency = placeholderTextTransparency
					end

					p2.props.focusChangedCallback(false, p5)
				end,
				[Roact.Change.Text] = function(p6) -- line: 159
					-- upvalues: p2 (copy), inputTextTransparency (copy), placeholderTextTransparency (copy)
					if p6.Text ~= "" or p2.textChangedEventUnlocked then
						if p6.Text ~= "" then
							if p2.clearRef.current and not p2.props.clearButtonDisabled then
								p2.clearRef.current.Visible = true
							end

							p6.TextColor3 = p2.props.inputTextColor3
							p6.TextTransparency = inputTextTransparency
						else
							if p2.clearRef.current then
								p2.clearRef.current.Visible = false
							end

							p6.TextColor3 = p2.props.placeholderTextColor3
							p6.TextTransparency = placeholderTextTransparency
						end

						p2.inputText = p6.Text

						if p2.props.textChangedCallback then
							p2.props.textChangedCallback(p6.Text)
						end
					end

					p2.textChangedEventUnlocked = true
				end,
				[Roact.Ref] = p2.inputBoxRef,
				[Roact.Change.AbsoluteSize] = p2.props[Roact.Change.AbsoluteSize]
			}),
			Clear = Roact.createElement("ImageButton", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, p2.props.clearButtonSize, 0, p2.props.clearButtonSize),
				AutoButtonColor = false,
				LayoutOrder = 2,
				Visible = not p2.props.clearButtonDisabled,
				SelectionImageObject = p2.props.clearButtonSelectionImageObject,
				Selectable = p2.clearRef.current and p2.clearRef.current.Visible == true,
				[Roact.Event.Activated] = function() -- line: 200
					-- upvalues: p2 (copy)
					if p2.inputBoxRef.current then
						p2.inputBoxRef.current.Text = ""
					end

					p2.inputText = ""

					if p2.clearRef.current then
						p2.clearRef.current.Visible = false
					end
				end
			}, {
				layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = "Center",
					HorizontalAlignment = "Center"
				}),
				Icon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, p2.props.clearButtonSize, 0, p2.props.clearButtonSize),
					Image = p2.props.clearIcon,
					ImageColor3 = p2.props.clearIconColor3,
					ImageTransparency = p2.props.clearIconTransparency,
					Visible = p2.props.showCancelIconOnLoad,
					[Roact.Ref] = p2.clearRef
				})
			})
		})
	})
end
function v5.didMount(p7) -- line: 232
	if p7.inputBoxRef.current then
		p7.inputBoxRef.current.Text = p7.inputText

		if p7.props.captureFocusOnMount then
			spawn(function() -- line: 237
				-- upvalues: p7 (copy)
				if p7.inputBoxRef and p7.inputBoxRef.current then
					p7.inputBoxRef.current:captureFocus()
				end
			end)
		end
	end
end

return v5
