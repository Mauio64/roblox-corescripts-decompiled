local Parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(Parent.React)
local ReactIs = require(Parent.ReactIs)
local Foundation = require(Parent.Foundation)
local FFlagExpChatEnableFriendsTab = require(Parent.SharedFlags).FFlagExpChatEnableFriendsTab
local ChannelChip = require(script.Parent.ChannelChip)
local ChatAutocompleteDropdown = require(script.Parent.Autocomplete.ChatAutocompleteDropdown)
local useChatAutocompleteEngine = require(script.Parent.Autocomplete.useChatAutocompleteEngine)
local v9 = game:DefineFastFlag("ExpChatFixInputBarSendEligibility", false)

local function fade(n1: number, n2: number) -- line: 24
	return n1 + n2 * (1 - n1)
end
local function deriveTransparency(n3: number, p1) -- line: 28
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p1) then
		return p1:map(function(n4: number) -- line: 33
			-- upvalues: n3 (copy)
			local v81 = n3

			return v81 + n4 * (1 - v81)
		end)
	end

	return n3 + p1 * (1 - n3)
end
local function deriveBackgroundStyle(color3: Color3, n5: number, p2) -- line: 43
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p2) then
		return p2:map(function(n6: number) -- line: 49
			-- upvalues: color3 (copy), n5 (copy)
			local t1 = {
				Color3 = color3
			}
			local v84 = n5

			t1.Transparency = v84 + n6 * (1 - v84)

			return t1
		end)
	end

	return {
		Color3 = color3,
		Transparency = n5 + p2 * (1 - n5)
	}
end
local function ChatInputBarView(t2: {[any]: any}) -- line: 83
	-- upvalues: Foundation (copy), FFlagExpChatEnableFriendsTab (copy), React (copy), useChatAutocompleteEngine (copy), v9 (copy), ChatAutocompleteDropdown (copy), deriveBackgroundStyle (copy), ReactIs (copy), ChannelChip (copy)
	local v22 = Foundation.Hooks.useTokens()
	local onChange = t2.onChange
	local onSend = t2.onSend
	local canLocalUserChat = t2.canLocalUserChat
	local v26 = t2.transparencyValue or 0
	local v27 = t2.textSize or v22.Typography.CaptionMedium.FontSize
	local maximumCharacterLimit = t2.maximumCharacterLimit
	local v29 = FFlagExpChatEnableFriendsTab and (not canLocalUserChat and t2.disabledOverlay ~= nil)
	local v30 = React.useRef(nil)
	local v31 = t2.textBoxRef or v30
	local v32 = React.useRef(nil)
	local v33 = useChatAutocompleteEngine(v31, t2.autocomplete)
	local v34 = React.useRef(t2.defaultValue or "")
	local v35, v36 = React.useState(function() -- line: 99
		-- upvalues: t2 (copy)
		return (t2.defaultValue or "") == ""
	end)
	local v37, v38 = React.useBinding(0)
	local v39 = React.useCallback(function(p3) -- line: 105
		-- upvalues: v38 (copy)
		v38(p3.AbsoluteSize.X)
	end, {})
	local v40 = React.useCallback(function() -- line: 109
		-- upvalues: v31 (copy), onSend (copy), v36 (copy)
		local current = v31.current
		local v87 = not current and "" or current.Text

		if v87 == "" then
			return
		end

		onSend(v87)

		if current then
			current.Text = ""
		end

		v36(true)
	end, {
		onSend,
		v31
	})
	local v41 = React.useCallback(function() -- line: 122
		-- upvalues: v31 (copy)
		local current = v31.current

		if current then
			current:ReleaseFocus(true)
		end
	end, { v31 })
	local v42 = React.useCallback(function(p4) -- line: 129
		-- upvalues: maximumCharacterLimit (copy), v34 (copy), v36 (copy), onChange (copy), v33 (copy)
		local p4Text = p4.Text

		if maximumCharacterLimit ~= nil then
			local v91 = utf8.nfcnormalize(p4Text)

			if (utf8.len(v91) or #v91) > maximumCharacterLimit then
				p4.Text = v34.current

				return
			end

			v34.current = p4Text
		end

		v36(p4Text == "")

		if onChange then
			onChange(p4Text)
		end

		v33.onTextChanged(p4Text)
	end, {
		onChange,
		maximumCharacterLimit,
		v33.onTextChanged
	})
	local v43 = React.useCallback(function() -- line: 147
		-- upvalues: t2 (copy)
		if t2.onFocusGained then
			t2.onFocusGained()
		end
	end, { t2.onFocusGained })
	local v44 = React.useCallback(function(_, b1: boolean) -- line: 154
		-- upvalues: v31 (copy), v33 (copy), v40 (copy), t2 (copy)
		local current = v31.current

		if (not current or not v33.interceptSend(current, b1)) and b1 then
			v40()
		end

		if t2.onFocusLost then
			t2.onFocusLost()
		end
	end, {
		v40,
		t2.onFocusLost,
		v31,
		v33.interceptSend
	})

	if v9 then
		React.useEffect(function() -- line: 174
			-- upvalues: canLocalUserChat (copy), v36 (copy)
			if not canLocalUserChat then
				v36(true)
			end
		end, { canLocalUserChat })
	end

	local v45 = if not v9 then v35 else v35 or not canLocalUserChat
	local createElement = React.createElement
	local View = Foundation.View
	local t3 = {
		tag = "auto-y",
		Size = UDim2.new(1, 0, 0, 0),
		ref = v32
	}
	local t4 = {
		Dropdown = if not t2.autocomplete then nil else React.createElement(ChatAutocompleteDropdown, {
			isOpen = v33.isOpen,
			results = v33.results,
			selectedIndex = v33.selectedIndex,
			keyboardIndex = v33.keyboardIndex,
			renderEntry = v33.renderEntry,
			anchorRef = v32,
			onHover = v33.setSelectedIndex,
			onSelect = v33.commitSelection,
			onDismiss = v33.dismiss
		})
	}
	local createElement2 = React.createElement
	local View2 = Foundation.View
	local t5 = {
		tag = "auto-y",
		Size = UDim2.fromScale(1, 0)
	}
	local t6 = {}
	local createElement3 = React.createElement
	local View3 = Foundation.View
	local t7 = {
		cornerRadius = UDim.new(0, 20),
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		backgroundStyle = deriveBackgroundStyle(v22.DarkMode.Surface.Surface_100.Color3, 0.2, v26)
	}
	local t8 = {
		Color = v22.Color.Stroke.Default.Color3
	}
	local DefaultTransparency = v22.Color.Stroke.Default.Transparency

	t8.Transparency = if not ReactIs.isBinding(v26) then DefaultTransparency + v26 * (1 - DefaultTransparency) else v26:map(function(n7: number) -- line: 33
		-- upvalues: DefaultTransparency (copy)
		local v96 = DefaultTransparency

		return v96 + n7 * (1 - v96)
	end)
	t7.stroke = t8
	t7.padding = {
		right = UDim.new(0, 2)
	}

	local t9 = {
		CustomDisabledContent = if not v29 then nil else t2.disabledOverlay
	}
	local v79

	if not v29 then
		local createElement4 = React.createElement
		local View4 = Foundation.View
		local t10 = {
			tag = "auto-y",
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.new(1, -36, 0, 0),
			padding = {
				top = UDim.new(0, 10),
				bottom = UDim.new(0, 10),
				left = UDim.new(0, 10),
				right = UDim.new(0, 10)
			}
		}
		local t11 = {
			SideChip = React.createElement(ChannelChip, {
				transparency = v26,
				sideChipText = t2.sideChipText,
				showSideChip = t2.showSideChip,
				onSideChipActivated = t2.onSideChipActivated,
				onAbsoluteSizeChanged = v39
			})
		}
		local v69

		if not canLocalUserChat then
			local createElement5 = React.createElement
			local FoundationText = Foundation.Text
			local t12 = {
				tag = "text-caption-medium text-wrap text-align-x-left text-align-y-top content-muted",
				AnchorPoint = Vector2.new(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = t2.disabledChatPlaceholderText or "",
				Position = UDim2.fromScale(1, 0),
				Size = v37:map(function(n8: number) -- line: 250
					return UDim2.new(1, -(n8 + 8), 0, 0)
				end)
			}
			local v68

			if ReactIs.isBinding(v26) then
				local n9 = 0.5

				v68 = v26:map(function(n10: number) -- line: 33
					-- upvalues: n9 (copy)
					local v99 = n9

					return v99 + n10 * (1 - v99)
				end)
			else
				v68 = v26 * 0.5 + 0.5
			end

			t12.TextTransparency = v68
			v69 = createElement5(FoundationText, t12)
		else
			v69 = nil
		end

		t11.DisabledLabel = v69

		local v78

		if canLocalUserChat then
			local createElement6 = React.createElement
			local View5 = Foundation.View
			local t13 = {
				tag = "auto-y",
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),
				Size = v37:map(function(n11: number) -- line: 262
					return UDim2.new(1, -(n11 + 8), 0, 0)
				end)
			}
			local t14 = {}
			local createElement7 = React.createElement
			local t15 = {
				AnchorPoint = Vector2.new(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				ClearTextOnFocus = false,
				MaxVisibleGraphemes = maximumCharacterLimit or -1,
				Font = v22.Typography.CaptionMedium.Font,
				PlaceholderText = t2.placeholderText or "",
				PlaceholderColor3 = v22.DarkMode.Content.Muted.Color3,
				Size = UDim2.fromScale(1, 0),
				Text = t2.defaultValue or "",
				TextColor3 = v22.DarkMode.Content.Emphasis.Color3,
				TextSize = v27
			}
			local v77

			if ReactIs.isBinding(v26) then
				local n12 = 0

				v77 = v26:map(function(n13: number) -- line: 33
					-- upvalues: n12 (copy)
					local v102 = n12

					return v102 + n13 * (1 - v102)
				end)
			else
				v77 = v26 * 1 + 0
			end

			t15.TextTransparency = v77
			t15.TextWrapped = true
			t15.TextXAlignment = Enum.TextXAlignment.Left
			t15.TextYAlignment = Enum.TextYAlignment.Top
			t15.TextEditable = t2.enableFocusedWrite ~= false
			t15.ZIndex = 2
			t15[React.Change.Text] = v42
			t15[React.Event.ReturnPressedFromOnScreenKeyboard] = v41
			t15[React.Event.Focused] = v43
			t15[React.Event.FocusLost] = v44
			t15.ref = v31
			t14.TextBox = createElement7("TextBox", t15)
			v78 = createElement6(View5, t13, t14)
		else
			v78 = nil
		end

		t11.TextBoxContainer = v78
		v79 = createElement4(View4, t10, t11)
	else
		v79 = nil
	end

	t9.TextContainer = v79
	t9.SendButtonContainer = if v29 then nil else React.createElement("CanvasGroup", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		GroupTransparency = v26,
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.new(0, 36, 1, 0)
	}, {
		Layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		SendButton = React.createElement(Foundation.IconButton, {
			isCircular = true,
			icon = Foundation.Enums.IconName.ArrowMediumUp,
			variant = if not v45 then Foundation.Enums.ButtonVariant.Emphasis else Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.InputSize.Small,
			isDisabled = v45,
			onActivated = v40
		})
	})
	t9.DisabledOverlay = if FFlagExpChatEnableFriendsTab or (canLocalUserChat or not t2.disabledOverlay) then nil else React.createElement(Foundation.View, {
		ZIndex = 5,
		Size = UDim2.fromScale(1, 1)
	}, {
		Overlay = t2.disabledOverlay
	})
	t6.InputGroup = createElement3(View3, t7, t9)
	t4.Container = createElement2(View2, t5, t6)

	return createElement(View, t3, t4)
end

return React.memo(ChatInputBarView)
