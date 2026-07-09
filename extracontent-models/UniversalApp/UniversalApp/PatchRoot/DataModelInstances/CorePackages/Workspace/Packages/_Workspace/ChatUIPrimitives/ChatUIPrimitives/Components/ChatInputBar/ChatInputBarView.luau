local Parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(Parent.React)
local ReactIs = require(Parent.ReactIs)
local Foundation = require(Parent.Foundation)
local ChannelChip = require(script.Parent.ChannelChip)

local function fade(n1: number, n2: number) -- line: 15
	return n1 + n2 * (1 - n1)
end
local function deriveTransparency(n3: number, p1) -- line: 19
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p1) then
		return p1:map(function(n4: number) -- line: 24
			-- upvalues: n3 (copy)
			local v71 = n3

			return v71 + n4 * (1 - v71)
		end)
	end

	return n3 + p1 * (1 - n3)
end
local function deriveBackgroundStyle(color3: Color3, n5: number, p2) -- line: 34
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p2) then
		return p2:map(function(n6: number) -- line: 40
			-- upvalues: color3 (copy), n5 (copy)
			local t1 = {
				Color3 = color3
			}
			local v74 = n5

			t1.Transparency = v74 + n6 * (1 - v74)

			return t1
		end)
	end

	return {
		Color3 = color3,
		Transparency = n5 + p2 * (1 - n5)
	}
end
local function ChatInputBarView(t2: {[any]: any}) -- line: 71
	-- upvalues: Foundation (copy), React (copy), deriveBackgroundStyle (copy), ReactIs (copy), ChannelChip (copy)
	local v18 = Foundation.Hooks.useTokens()
	local onChange = t2.onChange
	local onSend = t2.onSend
	local canLocalUserChat = t2.canLocalUserChat
	local v22 = t2.transparencyValue or 0
	local v23 = t2.textSize or v18.Typography.CaptionMedium.FontSize
	local maximumCharacterLimit = t2.maximumCharacterLimit
	local v25 = React.useRef(nil)
	local v26 = t2.textBoxRef or v25
	local v27 = React.useRef(t2.defaultValue or "")
	local v28, v29 = React.useState(function() -- line: 84
		-- upvalues: t2 (copy)
		return (t2.defaultValue or "") == ""
	end)
	local v30, v31 = React.useBinding(0)
	local v32 = React.useCallback(function(p3) -- line: 90
		-- upvalues: v31 (copy)
		v31(p3.AbsoluteSize.X)
	end, {})
	local v33 = React.useCallback(function() -- line: 94
		-- upvalues: v26 (copy), onSend (copy), v29 (copy)
		local current = v26.current
		local v77 = not current and "" or current.Text

		if v77 == "" then
			return
		end

		onSend(v77)

		if current then
			current.Text = ""
		end

		v29(true)
	end, {
		onSend,
		v26
	})
	local v34 = React.useCallback(function(p4) -- line: 107
		-- upvalues: maximumCharacterLimit (copy), v27 (copy), v29 (copy), onChange (copy)
		local p4Text = p4.Text

		if maximumCharacterLimit ~= nil then
			local v80 = utf8.nfcnormalize(p4Text)

			if (utf8.len(v80) or #v80) > maximumCharacterLimit then
				p4.Text = v27.current

				return
			end

			v27.current = p4Text
		end

		v29(p4Text == "")

		if onChange then
			onChange(p4Text)
		end
	end, {
		onChange,
		maximumCharacterLimit
	})
	local v35 = React.useCallback(function() -- line: 124
		-- upvalues: t2 (copy)
		if t2.onFocusGained then
			t2.onFocusGained()
		end
	end, { t2.onFocusGained })
	local v36 = React.useCallback(function(_, b1: boolean) -- line: 130
		-- upvalues: v33 (copy), t2 (copy), v26 (copy)
		if b1 then
			v33()

			if t2.retainFocusOnSend then
				task.delay(0, function() -- line: 134
					-- upvalues: v26 (copy)
					local current = v26.current

					if current then
						current:CaptureFocus()
					end
				end)
			end
		end

		if t2.onFocusLost then
			t2.onFocusLost()
		end
	end, {
		v33,
		t2.onFocusLost,
		t2.retainFocusOnSend,
		v26
	})
	local createElement = React.createElement
	local View = Foundation.View
	local t3 = {
		tag = "auto-xy",
		Size = UDim2.new(1, 0, 0, 0)
	}
	local t4 = {}
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
		backgroundStyle = deriveBackgroundStyle(v18.DarkMode.Surface.Surface_100.Color3, 0.2, v22)
	}
	local t8 = {
		Color = v18.Color.Stroke.Default.Color3
	}
	local DefaultTransparency = v18.Color.Stroke.Default.Transparency

	t8.Transparency = if not ReactIs.isBinding(v22) then DefaultTransparency + v22 * (1 - DefaultTransparency) else v22:map(function(n7: number) -- line: 24
		-- upvalues: DefaultTransparency (copy)
		local v84 = DefaultTransparency

		return v84 + n7 * (1 - v84)
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
			transparency = v22,
			sideChipText = t2.sideChipText,
			showSideChip = t2.showSideChip,
			onSideChipActivated = t2.onSideChipActivated,
			onAbsoluteSizeChanged = v32
		})
	}
	local v60

	if not canLocalUserChat then
		local createElement5 = React.createElement
		local FoundationText = Foundation.Text
		local t12 = {
			tag = "text-caption-medium text-wrap text-align-x-left text-align-y-top content-muted",
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = t2.disabledChatPlaceholderText or "",
			Position = UDim2.fromScale(1, 0),
			Size = v30:map(function(n8: number) -- line: 200
				return UDim2.new(1, -(n8 + 8), 0, 0)
			end)
		}
		local v59

		if ReactIs.isBinding(v22) then
			local n9 = 0.5

			v59 = v22:map(function(n10: number) -- line: 24
				-- upvalues: n9 (copy)
				local v87 = n9

				return v87 + n10 * (1 - v87)
			end)
		else
			v59 = v22 * 0.5 + 0.5
		end

		t12.TextTransparency = v59
		v60 = createElement5(FoundationText, t12)
	else
		v60 = nil
	end

	t11.DisabledLabel = v60

	local v69

	if canLocalUserChat then
		local createElement6 = React.createElement
		local View5 = Foundation.View
		local t13 = {
			tag = "auto-y",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = v30:map(function(n11: number) -- line: 212
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
			Font = v18.Typography.CaptionMedium.Font,
			PlaceholderText = t2.placeholderText or "",
			PlaceholderColor3 = v18.DarkMode.Content.Muted.Color3,
			Size = UDim2.fromScale(1, 0),
			Text = t2.defaultValue or "",
			TextColor3 = v18.DarkMode.Content.Emphasis.Color3,
			TextSize = v23
		}
		local v68

		if ReactIs.isBinding(v22) then
			local n12 = 0

			v68 = v22:map(function(n13: number) -- line: 24
				-- upvalues: n12 (copy)
				local v90 = n12

				return v90 + n13 * (1 - v90)
			end)
		else
			v68 = v22 * 1 + 0
		end

		t15.TextTransparency = v68
		t15.TextWrapped = true
		t15.TextXAlignment = Enum.TextXAlignment.Left
		t15.TextYAlignment = Enum.TextYAlignment.Top
		t15.TextEditable = t2.enableFocusedWrite ~= false
		t15.ZIndex = 2
		t15[React.Change.Text] = v34
		t15[React.Event.ReturnPressedFromOnScreenKeyboard] = v33
		t15[React.Event.Focused] = v35
		t15[React.Event.FocusLost] = v36
		t15.ref = v26
		t14.TextBox = createElement7("TextBox", t15)
		v69 = createElement6(View5, t13, t14)
	else
		v69 = nil
	end

	t11.TextBoxContainer = v69
	t9.TextContainer = createElement4(View4, t10, t11)
	t9.SendButtonContainer = React.createElement("CanvasGroup", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		GroupTransparency = v22,
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
			variant = if not v28 then Foundation.Enums.ButtonVariant.Emphasis else Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.InputSize.Small,
			isDisabled = v28,
			onActivated = v33
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
