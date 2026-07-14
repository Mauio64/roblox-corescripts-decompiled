local TextService = game:GetService("TextService")
local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local getMessageTextSize = require(Parent.ChatUIPrimitives).Utils.getMessageTextSize
local useFinishChatWindowMessageRenderIntervals = require(Parent.ChatUIPrimitives).Hooks.useFinishChatWindowMessageRenderIntervals

require(script.Parent.MessageDisplayStore.useMessageDisplayStore)

local function fadeTransparency(n1: number, n2: number) -- line: 51
	return n1 + n2 * (1 - n1)
end
local function isSystemDisplay(p1) -- line: 64
	return p1 ~= nil and p1.displayStyle == "system"
end
local function FriendsChatTextMessage(t1: {[any]: any}) -- line: 88
	-- upvalues: Foundation (copy), getMessageTextSize (copy), React (copy), Signals (copy), SignalsReact (copy), useFinishChatWindowMessageRenderIntervals (copy), TextService (copy)
	local v16 = Foundation.Hooks.useTokens()
	local chatWindowSettings = t1.chatWindowSettings
	local v18 = ((if not chatWindowSettings then nil else chatWindowSettings.FontFace)) or v16.Typography.BodySmall.Font
	local v19 = if typeof(v18) ~= "Font" then Font.fromEnum(v18) else v18
	local font = Font.new(v19.Family, Enum.FontWeight.SemiBold, v19.Style)
	local v21 = getMessageTextSize(chatWindowSettings, t1.isSpatialUIEnabled) or v16.Typography.BodySmall.FontSize
	local v22 = math.max(1, v21 - 2)
	local v23 = if not chatWindowSettings or not chatWindowSettings.TextColor3 then v16.Color.Content.Default.Color3 else chatWindowSettings.TextColor3
	local MutedColor3 = v16.Color.Content.Muted.Color3
	local v25 = if not chatWindowSettings then nil else chatWindowSettings.TextStrokeColor3
	local v26 = (not chatWindowSettings or not chatWindowSettings.TextStrokeTransparency) and 1 or chatWindowSettings.TextStrokeTransparency
	local v27 = t1.textTransparency or React.createBinding(0)
	local getDisplayId = t1.getDisplayId
	local getDisplayFromId = t1.getDisplayFromId
	local v30 = React.useMemo(function() -- line: 125
		-- upvalues: Signals (copy), getDisplayFromId (copy), getDisplayId (copy)
		return Signals.createComputed(function(p2) -- line: 126
			-- upvalues: getDisplayFromId (copy), getDisplayId (copy)
			return getDisplayFromId(getDisplayId(p2), p2)
		end)
	end, {
		getDisplayId,
		getDisplayFromId
	})
	local v31 = SignalsReact.useSignalBinding(v30)
	local v32 = SignalsReact.useSignalBinding(t1.getLayoutOrder)
	local v33 = React.useCallback(function() -- line: 140
		-- upvalues: getDisplayId (copy)
		return getDisplayId(false)
	end, { getDisplayId })
	local v34 = useFinishChatWindowMessageRenderIntervals(v33)
	local v35 = React.useCallback(function(p3) -- line: 144
		-- upvalues: v34 (copy)
		if p3 and (p3.Text and p3.Text ~= "") then
			v34()
		end
	end, { v34 })
	local v36 = React.useMemo(function() -- line: 156
		-- upvalues: v21 (copy)
		local v51 = math.floor(v21 * 3 / 2)

		return UDim2.fromOffset(v51, v21)
	end, { v21 })
	local v37, v38 = React.useBinding(v36)

	React.useEffect(function() -- line: 163
		-- upvalues: v38 (copy), v36 (copy)
		v38(v36)
	end, { v36 })
	React.useEffect(function() -- line: 167
		-- upvalues: v19 (copy), v21 (copy), TextService (copy), v38 (copy)
		local u52 = false

		task.spawn(function() -- line: 169
			-- upvalues: v19 (copy), v21 (copy), TextService (copy), u52 (ref), v38 (copy)
			local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

			GetTextBoundsParams.Text = "          "
			GetTextBoundsParams.Font = v19
			GetTextBoundsParams.Size = v21
			GetTextBoundsParams.Width = 1e999

			local ok, result = pcall(function() -- line: 175
				-- upvalues: TextService (copy), GetTextBoundsParams (copy)
				return TextService:GetTextBoundsAsync(GetTextBoundsParams)
			end)

			if u52 or (not ok or result == nil) then
				return
			end

			v38(UDim2.fromOffset(result.X, result.Y))
		end)

		return function() -- line: 183
			-- upvalues: u52 (ref)
			u52 = true
		end
	end, {
		v19,
		v21
	})

	local v39 = v31:map(function(p4) -- line: 188
		if p4 == nil then
			return ""
		end

		if p4.skeletonWidth == "prefix" then
			return `          { p4.content }`
		end

		return p4.content
	end)
	local t2 = {
		hasStroke = true,
		font = v19,
		textSize = v21,
		textColor = v23
	}
	local t3 = {
		hasStroke = false,
		font = font,
		textSize = v22,
		textColor = MutedColor3
	}
	local v42 = v31:map(function(p5) -- line: 216
		-- upvalues: t3 (copy), t2 (copy)
		if p5 ~= nil and p5.displayStyle == "system" then
			return t3
		end

		return t2
	end)
	local v43 = v42:map(function(t4: {[any]: any}) -- line: 220
		return t4.font
	end)
	local v44 = v42:map(function(t5: {[any]: any}) -- line: 224
		return t5.textSize
	end)
	local v45 = v42:map(function(t6: {[any]: any}) -- line: 228
		return t6.textColor
	end)
	local v46 = React.joinBindings({
		style = v42,
		textTransparency = v27
	}):map(function(p6) -- line: 235
		-- upvalues: v26 (copy)
		if not p6.style.hasStroke then
			return 1
		end

		local v59 = v26

		return v59 + p6.textTransparency * (1 - v59)
	end)
	local v47 = React.joinBindings({
		display = v31,
		textTransparency = v27
	}):map(function(p7) -- line: 248
		if p7.textTransparency >= 0.9 then
			return false
		end

		local display = p7.display

		if display == nil then
			return false
		end

		return display.skeletonWidth == "prefix" or display.skeletonWidth == "full"
	end)
	local v48 = React.joinBindings({
		display = v31,
		placeholder = v37
	}):map(function(p8) -- line: 262
		local display = p8.display

		if display ~= nil and display.skeletonWidth == "full" then
			return UDim2.new(1, 0, 0, p8.placeholder.Y.Offset)
		end

		return p8.placeholder
	end)
	local v49 = v31:map(function(p9) -- line: 270
		return p9 ~= nil
	end)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = v32,
		Visible = v49
	}, {
		body = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			FontFace = v43,
			TextSize = v44,
			TextColor3 = v45,
			TextStrokeColor3 = v25,
			TextStrokeTransparency = v46,
			TextTransparency = v27,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			RichText = true,
			Text = v39,
			[React.Change.Text] = v35
		}),
		skeleton = React.createElement(Foundation.Skeleton, {
			Size = v48,
			Position = UDim2.fromOffset(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Visible = v47
		})
	})
end

return React.memo(FriendsChatTextMessage)
