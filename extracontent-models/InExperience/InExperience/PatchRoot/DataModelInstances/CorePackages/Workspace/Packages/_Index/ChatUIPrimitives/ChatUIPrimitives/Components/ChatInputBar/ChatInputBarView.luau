local Parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(Parent.React)
local ReactIs = require(Parent.ReactIs)
local Foundation = require(Parent.Foundation)
local ChannelChip = require(script.Parent.ChannelChip)
local ChatAutocompleteDropdown = require(script.Parent.Autocomplete.ChatAutocompleteDropdown)
local useChatAutocompleteEngine = require(script.Parent.Autocomplete.useChatAutocompleteEngine)

local function fade(n1: number, n2: number) -- line: 19
	return n1 + n2 * (1 - n1)
end
local function deriveTransparency(n3: number, p1) -- line: 23
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p1) then
		return p1:map(function(n4: number) -- line: 28
			-- upvalues: n3 (copy)
			local v75 = n3

			return v75 + n4 * (1 - v75)
		end)
	end

	return n3 + p1 * (1 - n3)
end
local function deriveBackgroundStyle(color3: Color3, n5: number, p2) -- line: 38
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p2) then
		return p2:map(function(n6: number) -- line: 44
			-- upvalues: color3 (copy), n5 (copy)
			local t1 = {
				Color3 = color3
			}
			local v78 = n5

			t1.Transparency = v78 + n6 * (1 - v78)

			return t1
		end)
	end

	return {
		Color3 = color3,
		Transparency = n5 + p2 * (1 - n5)
	}
end
local function ChatInputBarView(t2: {[any]: any}) -- line: 79
	-- upvalues: Foundation (copy), React (copy), useChatAutocompleteEngine (copy), ChatAutocompleteDropdown (copy), deriveBackgroundStyle (copy), ReactIs (copy), ChannelChip (copy)
	local v20 = Foundation.Hooks.useTokens()
	local onChange = t2.onChange
	local onSend = t2.onSend
	local canLocalUserChat = t2.canLocalUserChat
	local v24 = t2.transparencyValue or 0
	local v25 = t2.textSize or v20.Typography.CaptionMedium.FontSize
	local maximumCharacterLimit = t2.maximumCharacterLimit
	local v27 = React.useRef(nil)
	local v28 = t2.textBoxRef or v27
	local v29 = React.useRef(nil)
	local v30 = useChatAutocompleteEngine(v28, t2.autocomplete)
	local v31 = React.useRef(t2.defaultValue or "")
	local v32, v33 = React.useState(function() -- line: 94
		-- upvalues: t2 (copy)
		return (t2.defaultValue or "") == ""
	end)
	local v34, v35 = React.useBinding(0)
	local v36 = React.useCallback(function(p3) -- line: 100
		-- upvalues: v35 (copy)
		v35(p3.AbsoluteSize.X)
	end, {})
	local v37 = React.useCallback(function() -- line: 104
		-- upvalues: v28 (copy), onSend (copy), v33 (copy)
		local current = v28.current
		local v81 = not current and "" or current.Text

		if v81 == "" then
			return
		end

		onSend(v81)

		if current then
			current.Text = ""
		end

		v33(true)
	end, {
		onSend,
		v28
	})
	local v38 = React.useCallback(function(p4) -- line: 117
		-- upvalues: maximumCharacterLimit (copy), v31 (copy), v33 (copy), onChange (copy), v30 (copy)
		local p4Text = p4.Text

		if maximumCharacterLimit ~= nil then
			local v84 = utf8.nfcnormalize(p4Text)

			if (utf8.len(v84) or #v84) > maximumCharacterLimit then
				p4.Text = v31.current

				return
			end

			v31.current = p4Text
		end

		v33(p4Text == "")

		if onChange then
			onChange(p4Text)
		end

		v30.onTextChanged(p4Text)
	end, {
		onChange,
		maximumCharacterLimit,
		v30.onTextChanged
	})
	local v39 = React.useCallback(function() -- line: 135
		-- upvalues: t2 (copy)
		if t2.onFocusGained then
			t2.onFocusGained()
		end
	end, { t2.onFocusGained })
	local v40 = React.useCallback(function(_, b1: boolean) -- line: 142
		-- upvalues: v28 (copy), v30 (copy), v37 (copy), t2 (copy)
		local current = v28.current

		if (not current or not v30.interceptSend(current, b1)) and b1 then
			v37()

			if t2.retainFocusOnSend then
				task.delay(0, function() -- line: 149
					-- upvalues: v28 (copy)
					local current2 = v28.current

					if current2 then
						current2:CaptureFocus()
					end
				end)
			end
		end

		if t2.onFocusLost then
			t2.onFocusLost()
		end
	end, {
		v37,
		t2.onFocusLost,
		t2.retainFocusOnSend,
		v28,
		v30.interceptSend
	})
	local createElement = React.createElement
	local View = Foundation.View
	local t3 = {
		tag = "auto-y",
		Size = UDim2.new(1, 0, 0, 0),
		ref = v29
	}
	local t4 = {
		Dropdown = if not t2.autocomplete then nil else React.createElement(ChatAutocompleteDropdown, {
			isOpen = v30.isOpen,
			results = v30.results,
			selectedIndex = v30.selectedIndex,
			keyboardIndex = v30.keyboardIndex,
			renderEntry = v30.renderEntry,
			anchorRef = v29,
			onHover = v30.setSelectedIndex,
			onSelect = v30.commitSelection,
			onDismiss = v30.dismiss
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
		backgroundStyle = deriveBackgroundStyle(v20.DarkMode.Surface.Surface_100.Color3, 0.2, v24)
	}
	local t8 = {
		Color = v20.Color.Stroke.Default.Color3
	}
	local DefaultTransparency = v20.Color.Stroke.Default.Transparency

	t8.Transparency = if not ReactIs.isBinding(v24) then DefaultTransparency + v24 * (1 - DefaultTransparency) else v24:map(function(n7: number) -- line: 28
		-- upvalues: DefaultTransparency (copy)
		local v89 = DefaultTransparency

		return v89 + n7 * (1 - v89)
	end)
	t7.stroke = t8
	t7.padding = {
		right = UDim.new(0, 2)
	}

	local t9 = {}
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
			transparency = v24,
			sideChipText = t2.sideChipText,
			showSideChip = t2.showSideChip,
			onSideChipActivated = t2.onSideChipActivated,
			onAbsoluteSizeChanged = v36
		})
	}
	local v64

	if not canLocalUserChat then
		local createElement5 = React.createElement
		local FoundationText = Foundation.Text
		local t12 = {
			tag = "text-caption-medium text-wrap text-align-x-left text-align-y-top content-muted",
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = t2.disabledChatPlaceholderText or "",
			Position = UDim2.fromScale(1, 0),
			Size = v34:map(function(n8: number) -- line: 237
				return UDim2.new(1, -(n8 + 8), 0, 0)
			end)
		}
		local v63

		if ReactIs.isBinding(v24) then
			local n9 = 0.5

			v63 = v24:map(function(n10: number) -- line: 28
				-- upvalues: n9 (copy)
				local v92 = n9

				return v92 + n10 * (1 - v92)
			end)
		else
			v63 = v24 * 0.5 + 0.5
		end

		t12.TextTransparency = v63
		v64 = createElement5(FoundationText, t12)
	else
		v64 = nil
	end

	t11.DisabledLabel = v64

	local v73

	if canLocalUserChat then
		local createElement6 = React.createElement
		local View5 = Foundation.View
		local t13 = {
			tag = "auto-y",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = v34:map(function(n11: number) -- line: 249
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
			Font = v20.Typography.CaptionMedium.Font,
			PlaceholderText = t2.placeholderText or "",
			PlaceholderColor3 = v20.DarkMode.Content.Muted.Color3,
			Size = UDim2.fromScale(1, 0),
			Text = t2.defaultValue or "",
			TextColor3 = v20.DarkMode.Content.Emphasis.Color3,
			TextSize = v25
		}
		local v72

		if ReactIs.isBinding(v24) then
			local n12 = 0

			v72 = v24:map(function(n13: number) -- line: 28
				-- upvalues: n12 (copy)
				local v95 = n12

				return v95 + n13 * (1 - v95)
			end)
		else
			v72 = v24 * 1 + 0
		end

		t15.TextTransparency = v72
		t15.TextWrapped = true
		t15.TextXAlignment = Enum.TextXAlignment.Left
		t15.TextYAlignment = Enum.TextYAlignment.Top
		t15.TextEditable = t2.enableFocusedWrite ~= false
		t15.ZIndex = 2
		t15[React.Change.Text] = v38
		t15[React.Event.ReturnPressedFromOnScreenKeyboard] = v37
		t15[React.Event.Focused] = v39
		t15[React.Event.FocusLost] = v40
		t15.ref = v28
		t14.TextBox = createElement7("TextBox", t15)
		v73 = createElement6(View5, t13, t14)
	else
		v73 = nil
	end

	t11.TextBoxContainer = v73
	t9.TextContainer = createElement4(View4, t10, t11)
	t9.SendButtonContainer = React.createElement("CanvasGroup", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		GroupTransparency = v24,
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
			variant = if not v32 then Foundation.Enums.ButtonVariant.Emphasis else Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.InputSize.Small,
			isDisabled = v32,
			onActivated = v37
		})
	})
	t9.DisabledOverlay = if canLocalUserChat or not t2.disabledOverlay then nil else React.createElement(Foundation.View, {
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
