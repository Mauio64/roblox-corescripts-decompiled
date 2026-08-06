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
	local localize = t1.localize
	local v31 = React.useMemo(function() -- line: 126
		-- upvalues: v22 (copy), localize (copy)
		return {
			systemTextSize = v22,
			localize = localize
		}
	end, {
		v22,
		localize
	})
	local v32 = React.useMemo(function() -- line: 129
		-- upvalues: Signals (copy), getDisplayFromId (copy), getDisplayId (copy), v31 (copy)
		return Signals.createComputed(function(p2) -- line: 130
			-- upvalues: getDisplayFromId (copy), getDisplayId (copy), v31 (copy)
			return getDisplayFromId(getDisplayId(p2), p2, v31)
		end)
	end, {
		getDisplayId,
		getDisplayFromId,
		v31
	})
	local v33 = SignalsReact.useSignalBinding(v32)
	local v34 = SignalsReact.useSignalBinding(t1.getLayoutOrder)
	local v35 = React.useCallback(function() -- line: 144
		-- upvalues: getDisplayId (copy)
		return getDisplayId(false)
	end, { getDisplayId })
	local v36 = useFinishChatWindowMessageRenderIntervals(v35)
	local v37 = React.useCallback(function(p3) -- line: 148
		-- upvalues: v36 (copy)
		if p3 and (p3.Text and p3.Text ~= "") then
			v36()
		end
	end, { v36 })
	local v38 = React.useMemo(function() -- line: 160
		-- upvalues: v21 (copy)
		local v53 = math.floor(v21 * 3 / 2)

		return UDim2.fromOffset(v53, v21)
	end, { v21 })
	local v39, v40 = React.useBinding(v38)

	React.useEffect(function() -- line: 167
		-- upvalues: v40 (copy), v38 (copy)
		v40(v38)
	end, { v38 })
	React.useEffect(function() -- line: 171
		-- upvalues: v19 (copy), v21 (copy), TextService (copy), v40 (copy)
		local u54 = false

		task.spawn(function() -- line: 173
			-- upvalues: v19 (copy), v21 (copy), TextService (copy), u54 (ref), v40 (copy)
			local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

			GetTextBoundsParams.Text = "          "
			GetTextBoundsParams.Font = v19
			GetTextBoundsParams.Size = v21
			GetTextBoundsParams.Width = 1e999

			local ok, result = pcall(function() -- line: 179
				-- upvalues: TextService (copy), GetTextBoundsParams (copy)
				return TextService:GetTextBoundsAsync(GetTextBoundsParams)
			end)

			if u54 or (not ok or result == nil) then
				return
			end

			v40(UDim2.fromOffset(result.X, result.Y))
		end)

		return function() -- line: 187
			-- upvalues: u54 (ref)
			u54 = true
		end
	end, {
		v19,
		v21
	})

	local v41 = v33:map(function(p4) -- line: 192
		if p4 == nil then
			return ""
		end

		if p4.skeletonWidth == "prefix" then
			return `          { p4.content }`
		end

		return p4.content
	end)
	local t2 = {
		font = v19,
		textSize = v21,
		textColor = v23
	}
	local t3 = {
		font = font,
		textSize = v22,
		textColor = MutedColor3
	}
	local v44 = v33:map(function(p5) -- line: 218
		-- upvalues: t3 (copy), t2 (copy)
		if p5 ~= nil and p5.displayStyle == "system" then
			return t3
		end

		return t2
	end)
	local v45 = v44:map(function(t4: {[any]: any}) -- line: 222
		return t4.font
	end)
	local v46 = v44:map(function(t5: {[any]: any}) -- line: 226
		return t5.textSize
	end)
	local v47 = v44:map(function(t6: {[any]: any}) -- line: 230
		return t6.textColor
	end)
	local v48 = v27:map(function(p6) -- line: 234
		-- upvalues: v26 (copy)
		local v61 = v26

		return v61 + p6 * (1 - v61)
	end)
	local v49 = React.joinBindings({
		display = v33,
		textTransparency = v27
	}):map(function(p7) -- line: 244
		if p7.textTransparency >= 0.9 then
			return false
		end

		local display = p7.display

		if display == nil then
			return false
		end

		return display.skeletonWidth == "prefix" or display.skeletonWidth == "full"
	end)
	local v50 = React.joinBindings({
		display = v33,
		placeholder = v39
	}):map(function(p8) -- line: 258
		local display = p8.display

		if display ~= nil and display.skeletonWidth == "full" then
			return UDim2.new(1, 0, 0, p8.placeholder.Y.Offset)
		end

		return p8.placeholder
	end)
	local v51 = v33:map(function(p9) -- line: 266
		return p9 ~= nil
	end)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = v34,
		Visible = v51
	}, {
		body = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			FontFace = v45,
			TextSize = v46,
			TextColor3 = v47,
			TextStrokeColor3 = v25,
			TextStrokeTransparency = v48,
			TextTransparency = v27,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			RichText = true,
			Text = v41,
			[React.Change.Text] = v37
		}, {
			stroke = React.createElement("UIStroke", {
				Color = v25 or Color3.fromRGB(0, 0, 0),
				Thickness = v16.Stroke.Thin,
				Transparency = v48
			})
		}),
		skeleton = React.createElement(Foundation.Skeleton, {
			Size = v50,
			Position = UDim2.fromOffset(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Visible = v49
		})
	})
end

return React.memo(FriendsChatTextMessage)
