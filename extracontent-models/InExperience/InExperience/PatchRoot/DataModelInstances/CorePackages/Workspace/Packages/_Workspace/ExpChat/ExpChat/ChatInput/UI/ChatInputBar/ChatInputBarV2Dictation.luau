local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local Foundation = require(ExpChatParent.Foundation)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Config = require(ExpChat.Config)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatFixBackspaceNilTargetChannel = ExpChatShared.Flags.FFlagExpChatFixBackspaceNilTargetChannel
local FFlagExpChatDictationFTUX = require(ExpChat.Flags.FFlagExpChatDictationFTUX)
local FFlagExpChatEnableFocusNavigation = require(ExpChat.Flags.FFlagExpChatEnableFocusNavigation)
local v11 = game:DefineFastFlag("ExpChatFocusablePlaceholderText", false)
local SharedFlags = require(ExpChatParent.SharedFlags)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local ChannelChip = require(script.Parent.ChannelChip)
local StopCountdown = require(script.Parent.StopCountdown)
local DictationFTUX = require(script.Parent.Dictation.DictationFTUX)
local DictationWaveform = require(script.Parent.Dictation.DictationWaveform)
local useDictationInputBar = require(script.Parent.Dictation.useDictationInputBar)
local useDictationTextArea = require(script.Parent.Dictation.useDictationTextArea)
local DictationAffordances = require(script.Parent.Dictation.DictationAffordances)

local function lerp(n1: number, n2: number, n3: number) -- line: 44
	return n1 + (n2 - n1) * n3
end
local function ChatInputBarV2Dictation(t1: {[any]: any}) -- line: 89
	-- upvalues: Foundation (copy), useDictationInputBar (copy), DictationAffordances (copy), React (copy), useDictationTextArea (copy), StopCountdown (copy), FFlagEnableConsoleExpControls (copy), FFlagExpChatEnableFocusNavigation (copy), ChannelChip (copy), FFlagExpChatFixBackspaceNilTargetChannel (copy), FFlagExpChatUseMessagesStore (copy), Config (copy), v11 (copy), FFlagExpChatPresetChatEnabled (copy), DictationWaveform (copy), FFlagExpChatDictationFTUX (copy), DictationFTUX (copy)
	local v28 = Foundation.Hooks.useTokens()
	local setTransparency = t1.setTransparency
	local chatInputBarSettings = t1.chatInputBarSettings
	local isSpatialUIEnabled = t1.isSpatialUIEnabled
	local canLocalUserChatDerived = t1.canLocalUserChatDerived
	local targetChannelWidth = t1.targetChannelWidth
	local showPlaceholderText = t1.showPlaceholderText
	local v35 = t1.hasEmptyInputText == true
	local cursor = t1.cursor
	local v37 = useDictationInputBar({
		inputText = t1.inputText,
		setInputText = t1.setInputText,
		chatInputBarSettings = chatInputBarSettings,
		customTextBoxRef = t1.customTextBoxRef,
		textBoxRef = t1.textBoxRef,
		targetTextChannel = t1.targetTextChannel,
		isGlobalChatTabActive = t1.isGlobalChatTabActive,
		onDictationActivityChanged = t1.onDictationActivityChanged,
		onSendActivated = t1.onSendActivated,
		onSendRecordingTap = t1.onSendRecordingTap,
		onTranscriptionStaged = t1.onTranscriptionStaged
	})
	local v38 = DictationAffordances.deriveMicSendButton(v37, {
		hasEmptyInputText = v35,
		idleSendIcon = Foundation.Enums.IconName.ArrowMediumUp,
		idleSendVariant = if not v35 then Foundation.Enums.ButtonVariant.Emphasis else Foundation.Enums.ButtonVariant.Standard,
		idleSendActivated = t1.onSendActivated,
		idleSendDisabled = v35
	})
	local v39 = DictationAffordances.deriveBackgroundColors(v37, {
		defaultColor3 = chatInputBarSettings.BackgroundColor3,
		defaultTransparency = t1.chatInputBarBackgroundTransparency,
		listeningColor3 = v28.Color.Shift.Shift_200.Color3,
		listeningTransparency = v28.Color.Shift.Shift_200.Transparency
	})
	local v40 = React.useMemo(function() -- line: 132
		-- upvalues: t1 (copy), v39 (copy)
		return t1.transparencyValue:map(function(n4: number) -- line: 133
			-- upvalues: v39 (copy)
			local t2 = {
				Color3 = v39.color3
			}
			local baseTransparency = v39.baseTransparency

			t2.Transparency = baseTransparency + (1 - baseTransparency) * n4

			return t2
		end)
	end, {
		t1.transparencyValue,
		v39.color3,
		v39.baseTransparency
	})
	local v41 = DictationAffordances.shouldPreventFade(v37)
	local v42 = React.useMemo(function() -- line: 142
		-- upvalues: v41 (copy), t1 (copy)
		if v41 then
			return t1.transparencyValue:map(function(_: number) -- line: 144
				return 0
			end)
		end

		return t1.transparencyValue
	end, {
		v41,
		t1.transparencyValue
	})
	local v43 = useDictationTextArea(v37, {
		transparencyValue = t1.transparencyValue,
		showPlaceholderText = showPlaceholderText
	})
	local useLongPressOverlay = v38.useLongPressOverlay
	local micGestureHandlers = v37.micGestureHandlers

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
			InputGroup = React.createElement(Foundation.View, {
				tag = "row align-y-center auto-y padding-x-xxsmall radius-circle",
				LayoutOrder = 1,
				backgroundStyle = v40,
				stroke = {
					Color = v28.Color.Stroke.Default.Color3,
					Transparency = setTransparency(v28.Color.Stroke.Default.Transparency, t1.transparencyValue)
				},
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1, 0)
			}, {
				StopCountdown = React.createElement(StopCountdown, {
					LayoutOrder = 1,
					countdownProgress = v37.dictation.bindings.countdownProgress,
					onActivated = v37.dictation.stopDictation,
					Visible = v37.dictation.bindings.isRecording
				}),
				TextContainer = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.Y,
					SelectionBehaviorDown = if not FFlagEnableConsoleExpControls or FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
					SelectionBehaviorLeft = if not FFlagEnableConsoleExpControls or FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
					SelectionBehaviorRight = if not FFlagEnableConsoleExpControls or FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
					SelectionBehaviorUp = if not FFlagEnableConsoleExpControls or FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
					SelectionGroup = FFlagEnableConsoleExpControls and not FFlagExpChatEnableFocusNavigation or nil,
					Size = UDim2.fromScale(0, 0)
				}, {
					TargetChannelChip = React.createElement(ChannelChip, {
						transparency = setTransparency(0, t1.transparencyValue),
						onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
						onChannelChipActivated = if not FFlagExpChatFixBackspaceNilTargetChannel then t1.resetTargetChannel else function() -- line: 217
							-- upvalues: t1 (copy)
							t1.resetTargetChannel(t1.isGlobalChatTabActive)
						end,
						targetTextChannelDisplayName = t1.targetTextChannelDisplayName or "",
						isChannelBarVisible = t1.isChannelBarVisible,
						developerChannelTabsEnabled = t1.developerChannelTabsEnabled
					}),
					DisabledPlaceholderLabel = ((if not FFlagExpChatUseMessagesStore then not t1.canLocalUserChat else not canLocalUserChatDerived)) and React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Font = Config.ChatInputBarFont,
						Text = t1.disabledChatPlaceholderText,
						Position = UDim2.fromScale(1, 0),
						Size = targetChannelWidth:map(function(n6: number) -- line: 234
							return UDim2.new(1, -(n6 + 8), 0, 0)
						end),
						TextColor3 = showPlaceholderText and chatInputBarSettings.PlaceholderColor3 or chatInputBarSettings.TextColor3,
						TextSize = if not isSpatialUIEnabled then chatInputBarSettings.TextSize else chatInputBarSettings.SpatialPanelTextSize,
						TextTransparency = setTransparency(not showPlaceholderText and 0 or 0.5, t1.transparencyValue),
						Selectable = not not v11 or nil,
						SelectionImageObject = if not v11 then nil else cursor,
						TextWrapped = not (FFlagExpChatPresetChatEnabled and (showPlaceholderText and t1.shouldTruncatePlaceholder)),
						TextTruncate = if not FFlagExpChatPresetChatEnabled or not showPlaceholderText then nil else Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						ref = if not v11 then nil else t1.placeholderRef
					}),
					TextBoxContainer = ((if not FFlagExpChatUseMessagesStore then t1.canLocalUserChat else canLocalUserChatDerived)) and React.createElement("Frame", {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Position = UDim2.fromScale(1, 0),
						Size = targetChannelWidth:map(function(n7: number) -- line: 268
							return UDim2.new(1, -(n7 + 8), 0, 0)
						end)
					}, {
						TextBox = ((if not FFlagExpChatUseMessagesStore then t1.canLocalUserChat else canLocalUserChatDerived)) and React.createElement("TextBox", {
							AnchorPoint = Vector2.new(0, 0),
							AutomaticSize = Enum.AutomaticSize.XY,
							BackgroundTransparency = 1,
							ClearTextOnFocus = false,
							FontFace = chatInputBarSettings.FontFace,
							PlaceholderText = showPlaceholderText and t1.placeholderText or "",
							Selectable = not not FFlagEnableConsoleExpControls or nil,
							SelectionImageObject = cursor,
							Size = UDim2.fromScale(1, 0),
							Text = "",
							PlaceholderColor3 = chatInputBarSettings.PlaceholderColor3,
							TextColor3 = chatInputBarSettings.TextColor3,
							TextSize = if not isSpatialUIEnabled then chatInputBarSettings.TextSize else chatInputBarSettings.SpatialPanelTextSize,
							TextTransparency = v43.textTransparency,
							TextStrokeTransparency = v43.textStrokeTransparency,
							TextStrokeColor3 = chatInputBarSettings.TextStrokeColor3,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top,
							ZIndex = 2,
							[React.Event.Focused] = t1.onFocused,
							[React.Event.FocusLost] = t1.onFocusLost,
							[React.Change.Text] = t1.onTextChanged,
							[React.Event.ReturnPressedFromOnScreenKeyboard] = t1.onReturnPressedFromOnScreenKeyboard,
							ref = if not chatInputBarSettings.TextBox then t1.textBoxRef else t1.customTextBoxRef
						})
					}),
					WaveformOverlay = React.createElement("Frame", {
						BackgroundTransparency = 1,
						ClipsDescendants = true,
						ZIndex = 3,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						Size = UDim2.new(1, 0, 0, if not isSpatialUIEnabled then chatInputBarSettings.TextSize else chatInputBarSettings.SpatialPanelTextSize),
						Visible = v37.dictation.bindings.isAudioActive
					}, {
						List = React.createElement(DictationWaveform, {
							isActive = v37.isRecording or v37.isListening,
							audioDeviceInput = v37.dictation.audioDeviceInput,
							transcribedSamplesBinding = v37.transcribedSamplesBinding,
							onSample = v37.onWaveformSample
						})
					}),
					UIFlexItem = React.createElement("UIFlexItem", {
						FlexMode = Enum.UIFlexMode.Fill
					}),
					UIPadding = React.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, 10),
						PaddingLeft = UDim.new(0, v28.Padding.Medium),
						PaddingRight = UDim.new(0, v28.Padding.Medium),
						PaddingTop = UDim.new(0, 10)
					})
				}),
				SendButtonContainer = React.createElement(Foundation.View, {
					tag = "auto-xy padding-xxsmall",
					LayoutOrder = 3,
					ref = v37.micButtonSlotRef,
					GroupTransparency = v42
				}, {
					SendButton = React.createElement(Foundation.IconButton, {
						isCircular = true,
						icon = v38.icon,
						variant = v38.variant,
						size = Foundation.Enums.InputSize.Small,
						isDisabled = v38.isDisabled,
						Selectable = not useLongPressOverlay and nil,
						onActivated = if not useLongPressOverlay then v38.onActivated else function() -- line: 364
						end
					}),
					InputTarget = if not useLongPressOverlay or micGestureHandlers == nil then nil else React.createElement("TextButton", {
						Active = true,
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
						Text = "",
						ZIndex = 2,
						Selectable = true,
						SelectionImageObject = v37.micCursor,
						[React.Event.Activated] = micGestureHandlers[React.Event.Activated],
						[React.Event.InputBegan] = micGestureHandlers[React.Event.InputBegan],
						[React.Event.InputEnded] = micGestureHandlers[React.Event.InputEnded]
					})
				}),
				FTUX = if not FFlagExpChatDictationFTUX or (not v37.ftux or not v37.ftux.shouldShow) then nil else React.createElement(DictationFTUX, {
					anchorRef = v37.micButtonSlotRef,
					onDismiss = if not FFlagExpChatDictationFTUX then nil else v37.ftux.dismiss
				})
			})
		})
	})
end

return React.memo(ChatInputBarV2Dictation)
