local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local Foundation = require(ExpChatParent.Foundation)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Config = require(ExpChat.Config)
local ChannelChip = require(script.Parent.ChannelChip)
local SharedFlags = require(ExpChatParent.SharedFlags)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagExpChatEnableFocusNavigation = require(ExpChat.Flags.FFlagExpChatEnableFocusNavigation)
local v12 = game:DefineFastFlag("ExpChatFocusablePlaceholderText", false)
local FFlagExpChatInputBarV2CustomSendButton = require(ExpChat.Flags.FFlagExpChatInputBarV2CustomSendButton)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatFixBackspaceNilTargetChannel = ExpChatShared.Flags.FFlagExpChatFixBackspaceNilTargetChannel
local FFlagExpChatPresetChatGamepadEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatGamepadEnabled)

local function renderCustomSendButton(t1: {[any]: any}, p1, b1: boolean?, p2: ((...any) -> ...any)) -- line: 79
	-- upvalues: React (copy), FFlagExpChatPresetChatGamepadEnabled (copy), FFlagExpChatEnableFocusNavigation (copy), Foundation (copy)
	local v23 = if not b1 then p1.Color.ActionEmphasis else p1.Color.ActionStandard
	local Size_800 = p1.Size.Size_800

	return React.createElement("CanvasGroup", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		GroupTransparency = if not b1 then t1.transparencyValue else t1.setTransparency(0.5, t1.transparencyValue),
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.new(0, t1.sendButtonContainerWidth + 6, 1, 0)
	}, {
		Layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		SendButton = React.createElement("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = v23.Background.Color3,
			BackgroundTransparency = v23.Background.Transparency,
			BorderSizePixel = 0,
			Selectable = not b1 and if not FFlagExpChatPresetChatGamepadEnabled then not FFlagExpChatEnableFocusNavigation and nil else nil,
			Size = UDim2.fromOffset(Size_800, Size_800),
			Text = "",
			[React.Event.Activated] = if not b1 then p2 else nil
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			IconLayout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Icon = React.createElement(Foundation.Icon, {
				name = Foundation.Enums.IconName.ArrowMediumUp,
				size = Foundation.Enums.IconSize.Small,
				style = v23.Foreground
			})
		})
	})
end
local function ChatInputBarV2(t2: {[any]: any}) -- line: 136
	-- upvalues: Foundation (copy), React (copy), FFlagEnableConsoleExpControls (copy), FFlagExpChatEnableFocusNavigation (copy), ChannelChip (copy), FFlagExpChatFixBackspaceNilTargetChannel (copy), FFlagExpChatUseMessagesStore (copy), Config (copy), v12 (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatInputBarV2CustomSendButton (copy), renderCustomSendButton (copy), FFlagExpChatPresetChatGamepadEnabled (copy)
	local v26 = Foundation.Hooks.useTokens()
	local setTransparency = t2.setTransparency
	local chatInputBarSettings = t2.chatInputBarSettings
	local chatInputBarBackgroundTransparency = t2.chatInputBarBackgroundTransparency
	local isSpatialUIEnabled = t2.isSpatialUIEnabled
	local canLocalUserChatDerived = t2.canLocalUserChatDerived
	local targetChannelWidth = t2.targetChannelWidth
	local showPlaceholderText = t2.showPlaceholderText
	local hasEmptyInputText = t2.hasEmptyInputText
	local cursor = t2.cursor
	local placeholderRef = t2.placeholderRef
	local textBoxRef = t2.textBoxRef
	local customTextBoxRef = t2.customTextBoxRef
	local onAbsoluteSizeChanged = t2.onAbsoluteSizeChanged
	local onFocused = t2.onFocused
	local onFocusLost = t2.onFocusLost
	local onTextChanged = t2.onTextChanged
	local onReturnPressedFromOnScreenKeyboard = t2.onReturnPressedFromOnScreenKeyboard
	local onSendActivated = t2.onSendActivated

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(1, 0, 0, 0)
	}, {
		Container = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, {
			InputGroup = React.createElement("Frame", {
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = chatInputBarSettings.BackgroundColor3,
				BackgroundTransparency = setTransparency(chatInputBarBackgroundTransparency, t2.transparencyValue),
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1, 0)
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				UIStroke = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = v26.Color.Stroke.Default.Color3,
					Transparency = setTransparency(v26.Color.Stroke.Default.Transparency, t2.transparencyValue)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingRight = UDim.new(0, 2)
				}),
				TextContainer = React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					SelectionBehaviorDown = if not FFlagEnableConsoleExpControls or FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
					SelectionBehaviorLeft = if not FFlagEnableConsoleExpControls or FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
					SelectionBehaviorRight = if not FFlagEnableConsoleExpControls or FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
					SelectionBehaviorUp = if not FFlagEnableConsoleExpControls or FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
					SelectionGroup = FFlagEnableConsoleExpControls and not FFlagExpChatEnableFocusNavigation or nil,
					Position = UDim2.fromScale(0, 0),
					Size = UDim2.new(1, -(t2.sendButtonContainerWidth + 6), 0, 0)
				}, {
					TargetChannelChip = React.createElement(ChannelChip, {
						transparency = setTransparency(0, t2.transparencyValue),
						onAbsoluteSizeChanged = onAbsoluteSizeChanged,
						onChannelChipActivated = if not FFlagExpChatFixBackspaceNilTargetChannel then t2.resetTargetChannel else function() -- line: 216
							-- upvalues: t2 (copy)
							t2.resetTargetChannel(t2.isGlobalChatTabActive)
						end,
						targetTextChannelDisplayName = t2.targetTextChannelDisplayName or "",
						isChannelBarVisible = t2.isChannelBarVisible,
						developerChannelTabsEnabled = t2.developerChannelTabsEnabled
					}),
					DisabledPlaceholderLabel = ((if not FFlagExpChatUseMessagesStore then not t2.canLocalUserChat else not canLocalUserChatDerived)) and React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Font = Config.ChatInputBarFont,
						Text = t2.disabledChatPlaceholderText,
						Position = UDim2.fromScale(1, 0),
						Size = targetChannelWidth:map(function(n1: number) -- line: 233
							return UDim2.new(1, -(n1 + 8), 0, 0)
						end),
						TextColor3 = showPlaceholderText and chatInputBarSettings.PlaceholderColor3 or chatInputBarSettings.TextColor3,
						TextSize = if not isSpatialUIEnabled then chatInputBarSettings.TextSize else chatInputBarSettings.SpatialPanelTextSize,
						TextTransparency = setTransparency(not showPlaceholderText and 0 or 0.5, t2.transparencyValue),
						Selectable = not not v12 or nil,
						SelectionImageObject = if not v12 then nil else cursor,
						TextWrapped = not (FFlagExpChatPresetChatEnabled and (showPlaceholderText and t2.shouldTruncatePlaceholder)),
						TextTruncate = if not FFlagExpChatPresetChatEnabled or not showPlaceholderText then nil else Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						ref = if not v12 then nil else placeholderRef
					}),
					TextBoxContainer = ((if not FFlagExpChatUseMessagesStore then t2.canLocalUserChat else canLocalUserChatDerived)) and React.createElement("Frame", {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Position = UDim2.fromScale(1, 0),
						Size = targetChannelWidth:map(function(n2: number) -- line: 268
							return UDim2.new(1, -(n2 + 8), 0, 0)
						end)
					}, {
						TextBox = ((if not FFlagExpChatUseMessagesStore then t2.canLocalUserChat else canLocalUserChatDerived)) and React.createElement("TextBox", {
							AnchorPoint = Vector2.new(0, 0),
							AutomaticSize = Enum.AutomaticSize.XY,
							BackgroundTransparency = 1,
							ClearTextOnFocus = false,
							FontFace = chatInputBarSettings.FontFace,
							PlaceholderText = showPlaceholderText and t2.placeholderText or "",
							Selectable = not not FFlagEnableConsoleExpControls or nil,
							SelectionImageObject = cursor,
							Size = UDim2.fromScale(1, 0),
							Text = "",
							PlaceholderColor3 = chatInputBarSettings.PlaceholderColor3,
							TextColor3 = chatInputBarSettings.TextColor3,
							TextSize = if not isSpatialUIEnabled then chatInputBarSettings.TextSize else chatInputBarSettings.SpatialPanelTextSize,
							TextTransparency = setTransparency(not showPlaceholderText and 0 or 0.5, t2.transparencyValue),
							TextStrokeTransparency = setTransparency(chatInputBarSettings.TextStrokeTransparency, t2.transparencyValue),
							TextStrokeColor3 = chatInputBarSettings.TextStrokeColor3,
							TextWrapped = not (FFlagExpChatPresetChatEnabled and (showPlaceholderText and t2.shouldTruncatePlaceholder)),
							TextTruncate = if not FFlagExpChatPresetChatEnabled or not showPlaceholderText then nil else Enum.TextTruncate.AtEnd,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top,
							ZIndex = 2,
							[React.Event.Focused] = onFocused,
							[React.Event.FocusLost] = onFocusLost,
							[React.Change.Text] = onTextChanged,
							[React.Event.ReturnPressedFromOnScreenKeyboard] = onReturnPressedFromOnScreenKeyboard,
							ref = if not chatInputBarSettings.TextBox then textBoxRef else customTextBoxRef
						})
					}),
					UIPadding = React.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, 10),
						PaddingLeft = UDim.new(0, 10),
						PaddingRight = UDim.new(0, 10),
						PaddingTop = UDim.new(0, 10)
					})
				}),
				SendButtonContainer = if not FFlagExpChatInputBarV2CustomSendButton then React.createElement("CanvasGroup", {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(1, 0),
					GroupTransparency = t2.transparencyValue,
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.new(0, t2.sendButtonContainerWidth + 6, 1, 0)
				}, {
					Layout = React.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					SendButton = React.createElement(Foundation.IconButton, {
						isCircular = true,
						icon = Foundation.Enums.IconName.ArrowMediumUp,
						variant = if not hasEmptyInputText then Foundation.Enums.ButtonVariant.Emphasis else Foundation.Enums.ButtonVariant.Standard,
						size = Foundation.Enums.InputSize.Small,
						isDisabled = hasEmptyInputText,
						Selectable = if not FFlagExpChatPresetChatGamepadEnabled then not FFlagExpChatEnableFocusNavigation and nil else nil,
						onActivated = onSendActivated
					})
				}) else renderCustomSendButton(t2, v26, hasEmptyInputText, onSendActivated)
			})
		})
	})
end

return React.memo(ChatInputBarV2)
