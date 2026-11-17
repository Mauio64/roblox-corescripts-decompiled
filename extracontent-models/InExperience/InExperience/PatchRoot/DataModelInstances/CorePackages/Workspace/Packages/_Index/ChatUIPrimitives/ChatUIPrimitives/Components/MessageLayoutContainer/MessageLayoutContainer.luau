local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Foundation = require(parent.Foundation)
local useMessagePool = require(script.Parent.useMessagePool)
local useMessagesMap = require(script.Parent.useMessagesMap)
local BottomLockedScrollView = require(script.Parent.BottomLockedScrollView)
local TextLineEntry = require(script.Parent.TextLineEntry)
local BubbleEntry = require(script.Parent.BubbleEntry)
require(ChatUIPrimitives.Types)
local FFlagExpChatLatestUsernameWithoutRender = require(ChatUIPrimitives.Flags.FFlagExpChatLatestUsernameWithoutRender)

local function createSlotElementFactory(p, getMessagesMap, fontFace, selectableRows: boolean?, selectionCursor, isTranslationSettingEnabled: boolean?, getLatestMessageId, onLatestUsernameChanged) -- 1 equivalent call inferred from this helper
	return function(p2)
		return React.createElement(p, {
			getMessageId = p2.getMessageId,
			getLayoutOrder = p2.getLayoutOrder,
			getMessagesMap = getMessagesMap,
			fontFace = fontFace,
			selectableRows = selectableRows,
			selectionCursor = selectionCursor,
			isTranslationSettingEnabled = isTranslationSettingEnabled,
			getLatestMessageId = getLatestMessageId,
			reportLatestUsername = onLatestUsernameChanged
		})
	end
end

local signal = Signals.createSignal({})

local v = { left = UDim.new(0, 8), right = UDim.new(0, 8) }

local function MessageLayoutContainer(props)
	local messagesSignal = props.messagesSignal or signal

	local messageIdsSignal = React.useMemo(function()
		return Signals.createComputed(function(p)
			local v2 = messagesSignal(p)
			local messageIds = {}

			for _, v3 in v2 do
				messageIds[#messageIds + 1] = v3.messageId
			end

			return messageIds
		end)
	end, { messagesSignal })

	local v2 = React.useMemo(function()
		if props.selectableRows then
			return Signals.createComputed(function(p)
				local v2 = messageIdsSignal(p)
				return v2[#v2]
			end)
		end

		return nil
	end, { messageIdsSignal, props.selectableRows })

	if FFlagExpChatLatestUsernameWithoutRender then
		local onLatestUsernameChanged = props.onLatestUsernameChanged
		React.useEffect(function()
			if v2 == nil or onLatestUsernameChanged == nil then
				return nil
			end

			return Signals.createEffect(function(p)
				if v2(p) == nil then
					onLatestUsernameChanged(nil)
				end
			end)
		end, { v2, onLatestUsernameChanged })
	end

	local getMessagesMap = useMessagesMap(messagesSignal)
	local v3

	if props.layoutStyle == "bubble" then
		v3 = BubbleEntry
	else
		v3 = TextLineEntry
	end

	local v4 = useMessagePool({
		messageIdsSignal = messageIdsSignal,
		createSlotElement = React.useMemo(function()
			return createSlotElementFactory( -- inferred equivalent call
				v3,
				getMessagesMap,
				props.fontFace,
				props.selectableRows,
				props.selectionCursor,
				props.isTranslationSettingEnabled,
				v2,
				props.onLatestUsernameChanged
			)
		end, {
			v3,
			getMessagesMap,
			props.fontFace or false,
			props.selectableRows or false,
			props.selectionCursor or false,
			props.isTranslationSettingEnabled or false,
			v2,
			props.onLatestUsernameChanged or false
		})
	})

	local v5 = SignalsReact.useSignalState(v4)

	local children = React.useMemo(function()
		local clone = table.clone(v5)
		clone["$layout"] = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2)
		})

		return clone
	end, { v5 })

	return React.createElement(Foundation.View, {
		tag = "fill padding-y-xsmall",
		Size = props.Size or UDim2.fromScale(1, 1)
	}, {
		scrollView = React.createElement(BottomLockedScrollView, {
			Size = UDim2.fromScale(1, 1),
			contentPadding = props.contentPadding or v,
			children = children,
			onScroll = props.onScroll,
			selectableRows = props.selectableRows
		})
	})
end

return React.memo(MessageLayoutContainer)
