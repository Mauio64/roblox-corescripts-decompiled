local Parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(Parent.React)
local ReactIs = require(Parent.ReactIs)
local Foundation = require(Parent.Foundation)
local FFlagExpChatEnableFriendsTab = require(Parent.SharedFlags).FFlagExpChatEnableFriendsTab
local ChannelChip = require(script.Parent.ChannelChip)
local ChatAutocompleteDropdown = require(script.Parent.Autocomplete.ChatAutocompleteDropdown)
local useChatAutocompleteEngine = require(script.Parent.Autocomplete.useChatAutocompleteEngine)

local function fade(n1: number, n2: number) -- line: 21
	return n1 + n2 * (1 - n1)
end
local function deriveTransparency(n3: number, p1) -- line: 25
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p1) then
		return p1:map(function(n4: number) -- line: 30
			-- upvalues: n3 (copy)
			local v78 = n3

			return v78 + n4 * (1 - v78)
		end)
	end

	return n3 + p1 * (1 - n3)
end
local function deriveBackgroundStyle(color3: Color3, n5: number, p2) -- line: 40
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p2) then
		return p2:map(function(n6: number) -- line: 46
			-- upvalues: color3 (copy), n5 (copy)
			local t1 = {
				Color3 = color3
			}
			local v81 = n5

			t1.Transparency = v81 + n6 * (1 - v81)

			return t1
		end)
	end

	return {
		Color3 = color3,
		Transparency = n5 + p2 * (1 - n5)
	}
end
local function ChatInputBarView(t2: {[any]: any}) -- line: 81
	-- upvalues: Foundation (copy), FFlagExpChatEnableFriendsTab (copy), React (copy), useChatAutocompleteEngine (copy), ChatAutocompleteDropdown (copy), deriveBackgroundStyle (copy), ReactIs (copy), ChannelChip (copy)
	local v21 = Foundation.Hooks.useTokens()
	local onChange = t2.onChange
	local onSend = t2.onSend
	local canLocalUserChat = t2.canLocalUserChat
	local v25 = t2.transparencyValue or 0
	local v26 = t2.textSize or v21.Typography.CaptionMedium.FontSize
	local maximumCharacterLimit = t2.maximumCharacterLimit
	local v28 = FFlagExpChatEnableFriendsTab and (not canLocalUserChat and t2.disabledOverlay ~= nil)
	local v29 = React.useRef(nil)
	local v30 = t2.textBoxRef or v29
	local v31 = React.useRef(nil)
	local v32 = useChatAutocompleteEngine(v30, t2.autocomplete)
	local v33 = React.useRef(t2.defaultValue or "")
	local v34, v35 = React.useState(function() -- line: 97
		-- upvalues: t2 (copy)
		return (t2.defaultValue or "") == ""
	end)
	local v36, v37 = React.useBinding(0)
	local v38 = React.useCallback(function(p3) -- line: 103
		-- upvalues: v37 (copy)
		v37(p3.AbsoluteSize.X)
	end, {})
	local v39 = React.useCallback(function() -- line: 107
		-- upvalues: v30 (copy), onSend (copy), v35 (copy)
		local current = v30.current
		local v84 = not current and "" or current.Text

		if v84 == "" then
			return
		end

		onSend(v84)

		if current then
			current.Text = ""
		end

		v35(true)
	end, {
		onSend,
		v30
	})
	local v40 = React.useCallback(function(p4) -- line: 120
		-- upvalues: maximumCharacterLimit (copy), v33 (copy), v35 (copy), onChange (copy), v32 (copy)
		local p4Text = p4.Text

		if maximumCharacterLimit ~= nil then
			local v87 = utf8.nfcnormalize(p4Text)

			if (utf8.len(v87) or #v87) > maximumCharacterLimit then
				p4.Text = v33.current

				return
			end

			v33.current = p4Text
		end

		v35(p4Text == "")

		if onChange then
			onChange(p4Text)
		end

		v32.onTextChanged(p4Text)
	end, {
		onChange,
		maximumCharacterLimit,
		v32.onTextChanged
	})
	local v41 = React.useCallback(function() -- line: 138
		-- upvalues: t2 (copy)
		if t2.onFocusGained then
			t2.onFocusGained()
		end
	end, { t2.onFocusGained })
	local v42 = React.useCallback(function(_, b1: boolean) -- line: 145
		-- upvalues: v30 (copy), v32 (copy), v39 (copy), t2 (copy)
		local current = v30.current

		if (not current or not v32.interceptSend(current, b1)) and b1 then
			v39()

			if t2.retainFocusOnSend then
				task.delay(0, function() -- line: 152
					-- upvalues: v30 (copy)
					local current2 = v30.current

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
		v39,
		t2.onFocusLost,
		t2.retainFocusOnSend,
		v30,
		v32.interceptSend
	})
	local createElement = React.createElement
	local View = Foundation.View
	local t3 = {
		tag = "auto-y",
		Size = UDim2.new(1, 0, 0, 0),
		ref = v31
	}
	local t4 = {
		Dropdown = if not t2.autocomplete then nil else React.createElement(ChatAutocompleteDropdown, {
			isOpen = v32.isOpen,
			results = v32.results,
			selectedIndex = v32.selectedIndex,
			keyboardIndex = v32.keyboardIndex,
			renderEntry = v32.renderEntry,
			anchorRef = v31,
			onHover = v32.setSelectedIndex,
			onSelect = v32.commitSelection,
			onDismiss = v32.dismiss
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
		backgroundStyle = deriveBackgroundStyle(v21.DarkMode.Surface.Surface_100.Color3, 0.2, v25)
	}
	local t8 = {
		Color = v21.Color.Stroke.Default.Color3
	}
	local DefaultTransparency = v21.Color.Stroke.Default.Transparency

	t8.Transparency = if not ReactIs.isBinding(v25) then DefaultTransparency + v25 * (1 - DefaultTransparency) else v25:map(function(n7: number) -- line: 30
		-- upvalues: DefaultTransparency (copy)
		local v92 = DefaultTransparency

		return v92 + n7 * (1 - v92)
	end)
	t7.stroke = t8
	t7.padding = {
		right = UDim.new(0, 2)
	}

	local t9 = {
		CustomDisabledContent = if not v28 then nil else t2.disabledOverlay
	}
	local v76

	if not v28 then
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
				transparency = v25,
				sideChipText = t2.sideChipText,
				showSideChip = t2.showSideChip,
				onSideChipActivated = t2.onSideChipActivated,
				onAbsoluteSizeChanged = v38
			})
		}
		local v66

		if not canLocalUserChat then
			local createElement5 = React.createElement
			local FoundationText = Foundation.Text
			local t12 = {
				tag = "text-caption-medium text-wrap text-align-x-left text-align-y-top content-muted",
				AnchorPoint = Vector2.new(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = t2.disabledChatPlaceholderText or "",
				Position = UDim2.fromScale(1, 0),
				Size = v36:map(function(n8: number) -- line: 241
					return UDim2.new(1, -(n8 + 8), 0, 0)
				end)
			}
			local v65

			if ReactIs.isBinding(v25) then
				local n9 = 0.5

				v65 = v25:map(function(n10: number) -- line: 30
					-- upvalues: n9 (copy)
					local v95 = n9

					return v95 + n10 * (1 - v95)
				end)
			else
				v65 = v25 * 0.5 + 0.5
			end

			t12.TextTransparency = v65
			v66 = createElement5(FoundationText, t12)
		else
			v66 = nil
		end

		t11.DisabledLabel = v66

		local v75

		if canLocalUserChat then
			local createElement6 = React.createElement
			local View5 = Foundation.View
			local t13 = {
				tag = "auto-y",
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),
				Size = v36:map(function(n11: number) -- line: 253
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
				Font = v21.Typography.CaptionMedium.Font,
				PlaceholderText = t2.placeholderText or "",
				PlaceholderColor3 = v21.DarkMode.Content.Muted.Color3,
				Size = UDim2.fromScale(1, 0),
				Text = t2.defaultValue or "",
				TextColor3 = v21.DarkMode.Content.Emphasis.Color3,
				TextSize = v26
			}
			local v74

			if ReactIs.isBinding(v25) then
				local n12 = 0

				v74 = v25:map(function(n13: number) -- line: 30
					-- upvalues: n12 (copy)
					local v98 = n12

					return v98 + n13 * (1 - v98)
				end)
			else
				v74 = v25 * 1 + 0
			end

			t15.TextTransparency = v74
			t15.TextWrapped = true
			t15.TextXAlignment = Enum.TextXAlignment.Left
			t15.TextYAlignment = Enum.TextYAlignment.Top
			t15.TextEditable = t2.enableFocusedWrite ~= false
			t15.ZIndex = 2
			t15[React.Change.Text] = v40
			t15[React.Event.ReturnPressedFromOnScreenKeyboard] = v39
			t15[React.Event.Focused] = v41
			t15[React.Event.FocusLost] = v42
			t15.ref = v30
			t14.TextBox = createElement7("TextBox", t15)
			v75 = createElement6(View5, t13, t14)
		else
			v75 = nil
		end

		t11.TextBoxContainer = v75
		v76 = createElement4(View4, t10, t11)
	else
		v76 = nil
	end

	t9.TextContainer = v76
	t9.SendButtonContainer = if v28 then nil else React.createElement("CanvasGroup", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		GroupTransparency = v25,
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
			variant = if not v34 then Foundation.Enums.ButtonVariant.Emphasis else Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.InputSize.Small,
			isDisabled = v34,
			onActivated = v39
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
