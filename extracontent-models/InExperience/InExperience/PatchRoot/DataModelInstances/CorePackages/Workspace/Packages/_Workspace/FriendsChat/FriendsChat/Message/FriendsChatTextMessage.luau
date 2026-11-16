local TextService = game:GetService("TextService")

local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local getTextBoundsAsync = Foundation.Utility.getTextBoundsAsync
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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

	local font = v2 or v.Typography.BodySmall.Font

	if FoundationFontFaceMigration then
		font = normalizeFontFace(font)
	elseif typeof(font) ~= "Font" then
		font = Font.fromEnum(font)
	end

	local font2 = Font.new(font.Family, Enum.FontWeight.SemiBold, font.Style)

	local v3 = getMessageTextSize(chatWindowSettings, props.isSpatialUIEnabled) or v.Typography.BodySmall.FontSize
	local v4 = math.max(1, v3 - 2)
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

	local v5 = not (chatWindowSettings and chatWindowSettings.TextStrokeTransparency) and 1
		or chatWindowSettings.TextStrokeTransparency

	local textTransparency = props.textTransparency or React.createBinding(0)

	local getDisplayId = props.getDisplayId
	local getDisplayFromId = props.getDisplayFromId
	local localize = props.localize
	local v6 = React.useMemo(function()
		return { systemTextSize = v4, localize = localize }
	end, { v4, localize })
	local v7 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return getDisplayFromId(getDisplayId(p), p, v6)
		end)
	end, { getDisplayId, getDisplayFromId, v6 })

	local display2 = SignalsReact.useSignalBinding(v7)
	local layoutOrder = SignalsReact.useSignalBinding(props.getLayoutOrder)

	local getMessageIdFromDisplayId = props.getMessageIdFromDisplayId
	local v8 = useFinishChatWindowMessageRenderIntervals((React.useCallback(function()
		if FFlagFriendsChatMessageSendPerfTracking and getMessageIdFromDisplayId then
			return getMessageIdFromDisplayId(getDisplayId(false))
		end

		return getDisplayId(false)
	end, { getDisplayId, getMessageIdFromDisplayId })))
	local ref = React.useRef(nil)
	local v9 = React.useCallback(function(p)
		if p and p.Text and p.Text ~= "" then
			v8()
		end
	end, { v8 })

	React.useEffect(function()
		if not FFlagFriendsChatMessageSendPerfTracking then
			return
		end

		local current = ref.current

		if current ~= nil and current.Text ~= "" then
			v8()
		end
	end, { v8 })

	local v10 = React.useMemo(function()
		local v10 = math.floor(v3 * 3 / 2)
		return UDim2.fromOffset(v10, v3)
	end, { v3 })

	local placeholder, v11 = React.useBinding(v10)

	React.useEffect(function()
		v11(v10)
	end, { v10 })

	React.useEffect(function()
		local v12 = false
		task.spawn(function()
			if FoundationFontFaceMigration then
				local textBoundsAsync = getTextBoundsAsync("          ", font, v3)

				if v12 or textBoundsAsync == nil then
					return
				end

				v11(UDim2.fromOffset(textBoundsAsync.X, textBoundsAsync.Y))
			else
				local getTextBoundsParams = Instance.new("GetTextBoundsParams")
				getTextBoundsParams.Text = "          "
				getTextBoundsParams.Font = font
				getTextBoundsParams.Size = v3
				getTextBoundsParams.Width = 1e999
				local success, result = pcall(function()
					return TextService:GetTextBoundsAsync(getTextBoundsParams)
				end)

				if v12 or not success or result == nil then
					return
				end

				v11(UDim2.fromOffset(result.X, result.Y))
			end
		end)
		return function()
			v12 = true
		end
	end, { font, v3 })

	local mapped = display2:map(function(p)
		if p == nil then
			return ""
		end

		if p.skeletonWidth == "prefix" then
			return `          {p.content}`
		end

		return p.content
	end)

	local v12 = { font = font, textSize = v3, textColor = textColor }

	local v13 = { font = font2, textSize = v4, textColor = color3 }

	local mapped2 = display2:map(function(p)
		if isSystemDisplay(p) then -- inferred equivalent call
			return v13
		end

		return v12
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
		return fadeTransparency(v5, p) -- inferred equivalent call
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
	local v14

	if FFlagFriendsChatLazyMountMessageSkeleton then
		local v15 = React.useMemo(function()
			return Signals.createComputed(function(p)
				return displayWantsSkeleton(v7(p)) -- inferred equivalent call
			end)
		end, { v7 })
		v14 = SignalsReact.useSignalState(v15)
	else
		v14 = true
	end

	local createElement = React.createElement
	local v15 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = layoutOrder,
		Visible = mapped9,
		ref = props.guiObjectRef
	}
	local v16 = {
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
			[React.Change.Text] = v9
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

	if v14 then
		skeleton = React.createElement(Foundation.Skeleton, {
			Size = mapped8,
			Position = UDim2.fromOffset(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Visible = mapped7
		})
	end

	v16.skeleton = skeleton
	return createElement("Frame", v15, v16)
end

return React.memo(FriendsChatTextMessage)
