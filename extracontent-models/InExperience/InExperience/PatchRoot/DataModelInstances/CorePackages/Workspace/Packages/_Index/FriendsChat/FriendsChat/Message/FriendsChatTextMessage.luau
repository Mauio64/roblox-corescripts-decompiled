local TextService = game:GetService("TextService")
local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.Signals)

local SignalsReact = require(Parent.SignalsReact)
local UserProfileStore = require(Parent.UserProfiles).Stores.UserProfileStore
local GetConversationMessageStore = require(Parent.AppChat.GetConversationMessageStore)
local computeNameColor = require(Parent.ChatUIPrimitives).Utils.computeNameColor
local getMessageTextSize = require(Parent.ChatUIPrimitives).Utils.getMessageTextSize
local useFinishChatWindowMessageRenderIntervals = require(Parent.ChatUIPrimitives).Hooks.useFinishChatWindowMessageRenderIntervals

local function fadeTransparency(n1: number, p1) -- line: 51
	return p1:map(function(n2: number) -- line: 52
		-- upvalues: n1 (copy)
		return n1 + n2 * (1 - n1)
	end)
end

local color3 = Color3.fromRGB(255, 255, 255)

local function resolveNameField(p2, p3, s1: string) -- line: 68
	-- upvalues: UserProfileStore (copy)
	local v22 = p3(p2)

	if v22 == nil or v22.type == "system" then
		return nil
	end

	local sender_user_id = v22.sender_user_id

	if sender_user_id == nil then
		return nil
	end

	local v24 = UserProfileStore.get().fetchNamesByUserIds({ (tostring(sender_user_id)) })(p2)
	local v25 = if not v24 or not v24.data then nil else v24.data[1]

	if v25 == nil or v25.names == nil then
		return nil
	end

	local v26 = v25.names[s1]

	if v26 then
		return (v26(p2))
	end

	return nil
end
local function makeDisplayNameGetter(p4) -- line: 88
	-- upvalues: resolveNameField (copy)
	return function(p5) -- line: 89
		-- upvalues: resolveNameField (copy), p4 (copy)
		return (resolveNameField(p5, p4, "getDisplayName"))
	end
end
local function makeUsernameGetter(p6) -- line: 94
	-- upvalues: resolveNameField (copy)
	return function(p7) -- line: 95
		-- upvalues: resolveNameField (copy), p6 (copy)
		return (resolveNameField(p7, p6, "getUsername"))
	end
end
local function FriendsChatTextMessage(t1: {[any]: any}) -- line: 108
	-- upvalues: Foundation (copy), getMessageTextSize (copy), React (copy), GetConversationMessageStore (copy), resolveNameField (copy), SignalsReact (copy), useFinishChatWindowMessageRenderIntervals (copy), TextService (copy), computeNameColor (copy), color3 (copy)
	local v30 = Foundation.Hooks.useTokens()
	local chatWindowSettings = t1.chatWindowSettings
	local v32 = ((if not chatWindowSettings then nil else chatWindowSettings.FontFace)) or v30.Typography.BodySmall.Font
	local v33 = getMessageTextSize(chatWindowSettings, t1.isSpatialUIEnabled) or v30.Typography.BodySmall.FontSize
	local v34 = if not chatWindowSettings or not chatWindowSettings.TextColor3 then v30.Color.Content.Default.Color3 else chatWindowSettings.TextColor3
	local v35 = if not chatWindowSettings then nil else chatWindowSettings.TextStrokeColor3
	local v36 = (not chatWindowSettings or not chatWindowSettings.TextStrokeTransparency) and 1 or chatWindowSettings.TextStrokeTransparency
	local v37 = t1.textTransparency or React.createBinding(0)
	local v38 = React.useMemo(function() -- line: 130
		-- upvalues: t1 (copy), GetConversationMessageStore (copy)
		return function(p8) -- line: 131
			-- upvalues: t1 (copy), GetConversationMessageStore (copy)
			local v74 = t1.getMessageId(p8)

			if v74 == nil then
				return nil
			end

			return GetConversationMessageStore(p8).getMessage(v74, p8)
		end
	end, { t1.getMessageId })
	local v39 = React.useMemo(function() -- line: 140
		-- upvalues: v38 (copy), resolveNameField (copy)
		local t2 = {}
		local v57 = v38

		function t2.displayName(p9) -- line: 89
			-- upvalues: resolveNameField (copy), v57 (copy)
			return (resolveNameField(p9, v57, "getDisplayName"))
		end

		local v58 = v38

		function t2.username(p10) -- line: 95
			-- upvalues: resolveNameField (copy), v58 (copy)
			return (resolveNameField(p10, v58, "getUsername"))
		end

		return t2
	end, { v38 })
	local v40 = SignalsReact.useSignalBinding(v38)
	local v41 = SignalsReact.useSignalBinding(t1.getLayoutOrder)
	local v42 = SignalsReact.useSignalBinding(v39.displayName)
	local v43 = SignalsReact.useSignalBinding(v39.username)
	local v44 = React.useCallback(function() -- line: 158
		-- upvalues: t1 (copy)
		return t1.getMessageId(false)
	end, { t1.getMessageId })
	local v45 = useFinishChatWindowMessageRenderIntervals(v44)
	local v46 = React.useCallback(function(p11) -- line: 162
		-- upvalues: v45 (copy)
		if p11 and (p11.Text and p11.Text ~= "") then
			v45()
		end
	end, { v45 })
	local v47 = React.useMemo(function() -- line: 177
		-- upvalues: v33 (copy)
		local v60 = math.floor(v33 * 3 / 2)

		return UDim2.fromOffset(v60, v33)
	end, { v33 })
	local v48, v49 = React.useBinding(v47)

	React.useEffect(function() -- line: 188
		-- upvalues: v49 (copy), v47 (copy)
		v49(v47)
	end, { v47 })
	React.useEffect(function() -- line: 192
		-- upvalues: v32 (copy), v33 (copy), TextService (copy), v49 (copy)
		local u61 = false

		task.spawn(function() -- line: 194
			-- upvalues: v32 (copy), v33 (copy), TextService (copy), u61 (ref), v49 (copy)
			local v77 = if typeof(v32) ~= "Font" then if typeof(v32) ~= "EnumItem" then nil else Font.fromEnum(v32) else v32

			if v77 == nil then
				return
			end

			local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

			GetTextBoundsParams.Text = "          "
			GetTextBoundsParams.Font = v77
			GetTextBoundsParams.Size = v33
			GetTextBoundsParams.Width = 1e999

			local ok, result = pcall(function() -- line: 206
				-- upvalues: TextService (copy), GetTextBoundsParams (copy)
				return TextService:GetTextBoundsAsync(GetTextBoundsParams)
			end)

			if u61 or not ok or result == nil then
				return
			end

			v49(UDim2.fromOffset(result.X, result.Y))
		end)

		return function() -- line: 214
			-- upvalues: u61 (ref)
			u61 = true
		end
	end, {
		v32,
		v33
	})

	local v50 = React.joinBindings({
		message = v40,
		displayName = v42,
		username = v43
	}):map(function(p12) -- line: 223
		-- upvalues: computeNameColor (copy), color3 (copy)
		local message = p12.message

		if message == nil then
			return ""
		end

		local v64 = message.richContent or ""

		if message.type == "system" or message.sender_user_id == nil then
			return v64
		end

		local displayName = p12.displayName

		if displayName == nil or displayName == "" then
			return `          : { v64 }`
		end

		local username = p12.username
		local v67 = if username == nil or username == "" then color3 else computeNameColor(username)

		return string.format("<font color=\"#%s\">%s</font>: %s", v67:ToHex(), displayName, v64)
	end)
	local v51 = React.joinBindings({
		message = v40,
		displayName = v42,
		textTransparency = v37
	}):map(function(p13) -- line: 251
		if p13.textTransparency >= 0.9 then
			return false
		end

		local message = p13.message

		if message == nil then
			return false
		end

		if message.type == "system" or message.sender_user_id == nil then
			return false
		end

		local displayName = p13.displayName

		return displayName == nil or displayName == ""
	end)
	local v52 = v40:map(function(p14) -- line: 266
		return p14 ~= nil
	end)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = v41,
		Visible = v52
	}, {
		body = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			FontFace = if typeof(v32) ~= "Font" then nil else v32,
			Font = if typeof(v32) ~= "Font" then v32 else nil,
			TextSize = v33,
			TextColor3 = v34,
			TextStrokeColor3 = v35,
			TextStrokeTransparency = v37:map(function(n3: number) -- line: 52
				-- upvalues: v36 (copy)
				return v36 + n3 * (1 - v36)
			end),
			TextTransparency = v37,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			RichText = true,
			Text = v50,
			[React.Change.Text] = v46
		}),
		skeleton = React.createElement(Foundation.Skeleton, {
			Size = v48,
			Position = UDim2.fromOffset(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Visible = v51
		})
	})
end

return React.memo(FriendsChatTextMessage)
