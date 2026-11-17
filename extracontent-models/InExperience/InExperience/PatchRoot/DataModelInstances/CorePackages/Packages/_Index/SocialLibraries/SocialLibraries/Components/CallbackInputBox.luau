local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)

local roact = dependencies.Roact
local imageSetLabel = dependencies.UIBlox.Core.ImageSet.ImageSetLabel
local normalizeFontFace = dependencies.Foundation.Utility.normalizeFontFace

local extended = roact.PureComponent:extend("CallbackInputBox")

extended.defaultProps = {
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
	focusChangedCallback = function() end,
	onSelectCallback = function() end,
	returnPressedFromOnScreenKeyboardCallback = function() end,
	inputBoxRef = nil,
	[roact.Change.AbsoluteSize] = function() end
}

function extended:init()
	self.clearRef = roact.createRef()
	self.inputBoxRef = self.props.inputBoxRef or roact.createRef()

	self.inputText = self.props.initialInputText

	self.textChangedEventUnlocked = false

	function self.focusTextbox()
		self.props.onSelectCallback()

		if not self.inputBoxRef.current:IsFocused() then
			self.inputBoxRef.current:captureFocus()
		end
	end
end

function extended:render()
	local placeholderTextTransparency = self.props.placeholderTextTransparency
	local inputTextTransparency = self.props.inputTextTransparency
	local textTransparency

	if self.inputText and self.inputText ~= "" then
		textTransparency = inputTextTransparency
	else
		textTransparency = placeholderTextTransparency
	end

	return roact.createElement("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) }, {
		layout = roact.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		inputBox = roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), LayoutOrder = 1 },
			{
				layout = roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				inputTextBox = roact.createElement("TextBox", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -self.props.clearButtonSize, 1, 0),
					Position = UDim2.new(0, 0, 0, 0),
					TextColor3 = self.props.inputTextColor3,
					TextSize = self.props.inputTextSize,
					TextTransparency = textTransparency,
					FontFace = normalizeFontFace(self.props.inputTextFont),
					PlaceholderText = self.props.placeholderText,
					PlaceholderColor3 = self.props.placeholderTextColor3,
					TextXAlignment = self.props.inputTextXAlignment,
					TextYAlignment = self.props.inputTextYAlignment,
					OverlayNativeInput = true,
					ClearTextOnFocus = false,
					ClipsDescendants = self.props.clipsDescendants,
					LayoutOrder = 1,
					ManualFocusRelease = self.props.manualFocusRelease,
					MultiLine = self.props.multiLine,
					TextWrapped = self.props.textWrapped,
					TextInputType = self.props.textInputType,
					ReturnKeyType = self.props.returnKeyType,
					SelectionImageObject = self.props.inputBoxSelectionImageObject,
					[roact.Event.ReturnPressedFromOnScreenKeyboard] = self.props.returnPressedFromOnScreenKeyboardCallback,
					[roact.Event.TouchTap] = self.focusTextbox,
					[roact.Event.Focused] = function(p)
						if self.inputBoxRef.current and self.inputBoxRef.current.Text ~= "" then
							if self.clearRef.current and not self.props.clearButtonDisabled then
								self.clearRef.current.Visible = true
							end

							p.TextColor3 = self.props.inputTextColor3
							p.TextTransparency = inputTextTransparency
						else
							p.TextColor3 = self.props.placeholderTextColor3
							p.TextTransparency = placeholderTextTransparency
						end

						self.props.focusChangedCallback(true)
					end,
					[roact.Event.FocusLost] = function(p, p2)
						if self.inputBoxRef.current and self.inputBoxRef.current.Text == "" then
							p.TextColor3 = self.props.placeholderTextColor3
							p.TextTransparency = placeholderTextTransparency
						end

						self.props.focusChangedCallback(false, p2)
					end,
					[roact.Change.Text] = function(p)
						if p.Text ~= "" or self.textChangedEventUnlocked then
							if p.Text == "" then
								if self.clearRef.current then
									self.clearRef.current.Visible = false
								end

								p.TextColor3 = self.props.placeholderTextColor3
								p.TextTransparency = placeholderTextTransparency
							else
								if self.clearRef.current and not self.props.clearButtonDisabled then
									self.clearRef.current.Visible = true
								end

								p.TextColor3 = self.props.inputTextColor3
								p.TextTransparency = inputTextTransparency
							end

							self.inputText = p.Text

							if self.props.textChangedCallback then
								self.props.textChangedCallback(p.Text)
							end
						end

						self.textChangedEventUnlocked = true
					end,
					[roact.Ref] = self.inputBoxRef,
					[roact.Change.AbsoluteSize] = self.props[roact.Change.AbsoluteSize]
				}),
				Clear = roact.createElement("ImageButton", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, self.props.clearButtonSize, 0, self.props.clearButtonSize),
					AutoButtonColor = false,
					LayoutOrder = 2,
					Visible = not self.props.clearButtonDisabled,
					SelectionImageObject = self.props.clearButtonSelectionImageObject,
					Selectable = self.clearRef.current and self.clearRef.current.Visible == true,
					[roact.Event.Activated] = function()
						if self.inputBoxRef.current then
							self.inputBoxRef.current.Text = ""
						end

						self.inputText = ""

						if self.clearRef.current then
							self.clearRef.current.Visible = false
						end
					end
				}, {
					layout = roact.createElement("UIListLayout", {
						VerticalAlignment = "Center",
						HorizontalAlignment = "Center"
					}),
					Icon = roact.createElement(imageSetLabel, {
						BackgroundTransparency = 1,
						Size = UDim2.new(0, self.props.clearButtonSize, 0, self.props.clearButtonSize),
						Image = self.props.clearIcon,
						ImageColor3 = self.props.clearIconColor3,
						ImageTransparency = self.props.clearIconTransparency,
						Visible = self.props.showCancelIconOnLoad,
						[roact.Ref] = self.clearRef
					})
				})
			}
		)
	})
end

function extended.didMount(data)
	if data.inputBoxRef.current then
		data.inputBoxRef.current.Text = data.inputText

		if data.props.captureFocusOnMount then
			spawn(function()
				if data.inputBoxRef and data.inputBoxRef.current then
					data.inputBoxRef.current:captureFocus()
				end
			end)
		end
	end
end

return extended
