local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local getTextBoundsAsync = Foundation.Utility.getTextBoundsAsync
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local getMessageTextSize = ChatUIPrimitives.Utils.getMessageTextSize

local ChatUIPrimitives2 = require(parent.ChatUIPrimitives)
local useFinishChatWindowMessageRenderIntervals = ChatUIPrimitives2.Hooks.useFinishChatWindowMessageRenderIntervals

require(script.Parent.MessageDisplayStore.useMessageDisplayStore)
local FFlagFriendsChatMessageSendPerfTracking = require(FriendsChat.Flags.FFlagFriendsChatMessageSendPerfTracking)
local FFlagFriendsChatLazyMountMessageSkeleton = require(FriendsChat.Flags.FFlagFriendsChatLazyMountMessageSkeleton)

local function fadeTransparency(p: number, p2: number) -- 1 equivalent call inferred from this helper
	return p + p2 * (1 - p)
end

local function isSystemDisplay(p): boolean -- 1 equivalent call inferred from this helper
	return p ~= nil and p.displayStyle == "system"
end

local function displayWantsSkeleton(p): boolean -- 2 equivalent calls inferred from this helper
	return p ~= nil and (p.skeletonWidth == "prefix" or p.skeletonWidth == "full")
end

local function FriendsChatTextMessage(props)
	local v = Foundation.Hooks.useTokens()

	local chatWindowSettings = props.chatWindowSettings
	local v2

	if chatWindowSettings then
		v2 = chatWindowSettings.FontFace
	end

	local fontFace = normalizeFontFace(v2 or v.Typography.BodySmall.Font)
	local font = Font.new(fontFace.Family, Enum.FontWeight.SemiBold, fontFace.Style)

	local textSize = getMessageTextSize(chatWindowSettings, props.isSpatialUIEnabled) or v.Typography.BodySmall.FontSize
	local v3 = math.max(1, textSize - 2)
	local textColor

	if chatWindowSettings and chatWindowSettings.TextColor3 then
		textColor = chatWindowSettings.TextColor3
	else
		textColor = v.Color.Content.Default.Color3
	end

	local color3 = v.Color.Content.Muted.Color3
	local textStrokeColor3

	if chatWindowSettings then
		textStrokeColor3 = chatWindowSettings.TextStrokeColor3
	end

	local v4 = not (chatWindowSettings and chatWindowSettings.TextStrokeTransparency) and 1
		or chatWindowSettings.TextStrokeTransparency

	local textTransparency = props.textTransparency or React.createBinding(0)

	local getDisplayId = props.getDisplayId
	local getDisplayFromId = props.getDisplayFromId
	local localize = props.localize
	local v5 = React.useMemo(function()
		return { systemTextSize = v3, localize = localize }
	end, { v3, localize })
	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return getDisplayFromId(getDisplayId(p), p, v5)
		end)
	end, { getDisplayId, getDisplayFromId, v5 })

	local display2 = SignalsReact.useSignalBinding(v6)
	local layoutOrder = SignalsReact.useSignalBinding(props.getLayoutOrder)

	local getMessageIdFromDisplayId = props.getMessageIdFromDisplayId
	local v7 = useFinishChatWindowMessageRenderIntervals((React.useCallback(function()
		if FFlagFriendsChatMessageSendPerfTracking and getMessageIdFromDisplayId then
			return getMessageIdFromDisplayId(getDisplayId(false))
		end

		return getDisplayId(false)
	end, { getDisplayId, getMessageIdFromDisplayId })))
	local ref = React.useRef(nil)
	local v8 = React.useCallback(function(p)
		if p and p.Text and p.Text ~= "" then
			v7()
		end
	end, { v7 })

	React.useEffect(function()
		if not FFlagFriendsChatMessageSendPerfTracking then
			return
		end

		local current = ref.current

		if current ~= nil and current.Text ~= "" then
			v7()
		end
	end, { v7 })

	local v9 = React.useMemo(function()
		local v9 = math.floor(textSize * 3 / 2)
		return UDim2.fromOffset(v9, textSize)
	end, { textSize })

	local placeholder, v10 = React.useBinding(v9)

	React.useEffect(function()
		v10(v9)
	end, { v9 })

	React.useEffect(function()
		local v11 = false
		task.spawn(function()
			local textBoundsAsync = getTextBoundsAsync("          ", fontFace, textSize)

			if v11 or textBoundsAsync == nil then
				return
			end

			v10(UDim2.fromOffset(textBoundsAsync.X, textBoundsAsync.Y))
		end)
		return function()
			v11 = true
		end
	end, { fontFace, textSize })

	local mapped = display2:map(function(p)
		if p == nil then
			return ""
		end

		if p.skeletonWidth == "prefix" then
			return `          {p.content}`
		end

		return p.content
	end)

	local v11 = { font = fontFace, textSize = textSize, textColor = textColor }

	local v12 = { font = font, textSize = v3, textColor = color3 }

	local mapped2 = display2:map(function(p)
		if isSystemDisplay(p) then -- inferred equivalent call
			return v12
		end

		return v11
	end)

	local mapped3 = mapped2:map(function(p)
		return p.font
	end)

	local mapped4 = mapped2:map(function(p)
		return p.textSize
	end)

	local mapped5 = mapped2:map(function(p)
		return p.textColor
	end)

	local mapped6 = textTransparency:map(function(p)
		return fadeTransparency(v4, p) -- inferred equivalent call
	end)

	local mapped7 = React.joinBindings({ display = display2, textTransparency = textTransparency }):map(function(p)
		if p.textTransparency >= 0.9 then
			return false
		end

		return displayWantsSkeleton(p.display) -- inferred equivalent call
	end)

	local mapped8 = React.joinBindings({ display = display2, placeholder = placeholder }):map(function(p)
		local display = p.display

		if display == nil or display.skeletonWidth ~= "full" then
			return p.placeholder
		end

		return UDim2.new(1, 0, 0, p.placeholder.Y.Offset)
	end)

	local mapped9 = display2:map(function(p): boolean
		return p ~= nil
	end)
	local v13

	if FFlagFriendsChatLazyMountMessageSkeleton then
		local v14 = React.useMemo(function()
			return Signals.createComputed(function(p)
				return displayWantsSkeleton(v6(p)) -- inferred equivalent call
			end)
		end, { v6 })
		v13 = SignalsReact.useSignalState(v14)
	else
		v13 = true
	end

	local createElement = React.createElement
	local v14 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = layoutOrder,
		Visible = mapped9,
		ref = props.guiObjectRef
	}
	local v15 = {
		body = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			FontFace = mapped3,
			TextSize = mapped4,
			TextColor3 = mapped5,
			TextStrokeColor3 = textStrokeColor3,
			TextStrokeTransparency = mapped6,
			TextTransparency = textTransparency,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			RichText = true,
			Text = mapped,
			ref = ref,
			[React.Change.Text] = v8
		}, {
			stroke = React.createElement("UIStroke", {
				Color = textStrokeColor3 or Color3.fromRGB(0, 0, 0),
				Thickness = v.Stroke.Thin,
				Transparency = mapped6
			})
		}),
		skeleton = 0
	}
	local skeleton

	if v13 then
		skeleton = React.createElement(Foundation.Skeleton, {
			Size = mapped8,
			Position = UDim2.fromOffset(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Visible = mapped7
		})
	end

	v15.skeleton = skeleton
	return createElement("Frame", v14, v15)
end

return React.memo(FriendsChatTextMessage)
