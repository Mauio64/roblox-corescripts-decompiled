local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ViewRecycler = require(parent.ViewRecycler)
local SignalsReact = require(parent.SignalsReact)
local Signals = require(parent.Signals)

local Sizing = require(script.Parent.Parent.Sizing)
local BubbleItemFrame = require(script.Parent.Bubble.BubbleItemFrame)
local MessageBubbleItem = require(script.Parent.Bubble.MessageBubbleItem)
local DiscussionItemFrame = require(script.Parent.Discussion.DiscussionItemFrame)
local MessageDiscussionItem = require(script.Parent.Discussion.MessageDiscussionItem)
local InlineItemFrame = require(script.Parent.Inline.InlineItemFrame)
local MessageInlineItem = require(script.Parent.Inline.MessageInlineItem)
local HeaderItem = require(script.Parent.HeaderItem)
local SystemItem = require(script.Parent.SystemItem)
local TimestampItem = require(script.Parent.TimestampItem)
local groupMessages = require(script.Parent.groupMessages)
local isScrollInput = require(script.Parent.isScrollInput)
local projectMessageEnvelope = require(script.Parent.projectMessageEnvelope)
local useKeepEndOnResize = require(script.Parent.useKeepEndOnResize)
local useMessageListLayout = require(script.Parent.useMessageListLayout)
local usePropSignal = require(ChatUIPrimitives.Hooks.usePropSignal)
local FFlagExpChatMessageListScrollParity = require(ChatUIPrimitives.Flags.FFlagExpChatMessageListScrollParity)
local FIntExpChatMessageListOverscanRows = require(ChatUIPrimitives.Flags.FIntExpChatMessageListOverscanRows)
require(script.Parent.Parent.Types)

local v = ViewRecycler.ChatPreset.create()
local v2 = { viewportFraction = 1 }

local function getRowKey(p)
	return p.id
end

local v3 = {
	readiness = ViewRecycler.RecyclableViewReadiness.ReadyOnCommit,
	hideWhilePending = true
}

local function createItemView(p, p2) -- 9 equivalent calls inferred from this helper
	return (ViewRecycler.createRecyclableView(function(p3)
		return React.createElement(p2, {}, {
			Item = React.createElement(p, { itemSignal = p3.itemSignal })
		})
	end, v3))
end

local function HeaderFrame(p)
	return React.createElement(React.Fragment, nil, p.children)
end

local v4 = { kind = "header", id = "$header" }

local v5 = { kind = "endSpacer", id = "$endSpacer" }

local function EndSpacer()
	return React.createElement(Foundation.View, {
		tag = "size-full-200",
		testId = "message-list-end-spacer"
	})
end

local itemView = createItemView(HeaderItem.Component, HeaderFrame) -- inferred equivalent call

local recyclableView = ViewRecycler.createRecyclableView(EndSpacer, v3)
local v6 = {
	inline = {
		message = createItemView(MessageInlineItem, InlineItemFrame), -- inferred equivalent call
		timestamp = createItemView(TimestampItem, InlineItemFrame), -- inferred equivalent call
		system = createItemView(SystemItem, InlineItemFrame), -- inferred equivalent call
		header = itemView
	},
	bubble = {
		message = createItemView(MessageBubbleItem, BubbleItemFrame), -- inferred equivalent call
		timestamp = createItemView(TimestampItem, BubbleItemFrame), -- inferred equivalent call
		system = createItemView(SystemItem, BubbleItemFrame), -- inferred equivalent call
		header = itemView,
		endSpacer = recyclableView
	},
	discussion = {
		message = createItemView(MessageDiscussionItem, DiscussionItemFrame), -- inferred equivalent call
		system = createItemView(SystemItem, DiscussionItemFrame), -- inferred equivalent call
		header = itemView,
		endSpacer = recyclableView
	}
}

local function useMessageListViewModel(data)
	local v7 = React.useMemo(function()
		local v7 = {}
		return Signals.createComputed(function(p)
			local v8 = {}
			local result = {}

			for _, source in data.getMessageEnvelopes(p) do
				local v9 = v7[source.stableId]
				local rendered

				if v9 == nil or v9.source ~= source then
					rendered = projectMessageEnvelope(source)
				else
					rendered = v9.rendered
				end

				v8[source.stableId] = { source = source, rendered = rendered }

				table.insert(result, rendered)
			end

			v7 = v8
			return result
		end)
	end, { data.getMessageEnvelopes })
	local v8 = usePropSignal(data.maxGroupSize)
	local v9 = usePropSignal(data.maxGroupGapMs)
	local v10 = usePropSignal(data.groupingEnabled)

	local shouldInsertTimestampRows = data.displayMode ~= "discussion"

	local v11 = React.useMemo(function()
		local v11 = {}
		return Signals.createComputed(function(p)
			local v12 = v7(p)
			local selected

			if v10(p) == false then
				selected = groupMessages.ungroupedRows(v12, v11)
			else
				selected = groupMessages.groupMessages(v12, v8(p), v9(p), v11, {
					shouldInsertTimestampRows = shouldInsertTimestampRows
				})
			end

			v11 = selected
			return selected
		end)
	end, { v7, v8, v9, v10, shouldInsertTimestampRows })

	local v12 = SignalsReact.useSignalState(v11)

	local itemType = React.useCallback(function(p)
		local v13 = v6[data.displayMode]

		if v13 == nil then
			error("Invalid display mode: " .. data.displayMode)
		end

		local v14 = v13[p.kind]

		if v14 == nil then
			error("Invalid row kind: " .. p.kind)
		end

		return v14
	end, { data.displayMode })

	local v13 = Sizing.useMeasured()
	local sizing = Sizing.useResolvedSizing(not v13 and "regular" or v13.density, not v13 and 1 or v13.widthUnits)
	local v14

	if data.displayMode == "discussion" then
		v14 = sizing.discussion.estimatedRowHeight
	end

	local layout = useMessageListLayout(v14)
	local scrollBarThickness = sizing.list.scrollBarThickness
	local scrollBarInset = sizing.list.scrollBarInset
	local scrollBarColor = sizing.list.scrollBarColor

	local onUserScrollInput = data.onUserScrollInput
	local scrollingFrameProps = React.useMemo(function()
		local v15 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = scrollBarThickness,
			VerticalScrollBarInset = scrollBarInset,
			ScrollBarImageColor3 = scrollBarColor
		}

		if onUserScrollInput ~= nil then
			local onUserScrollInput2 = onUserScrollInput
			v15[React.Event.InputBegan] = function(_, p)
				if isScrollInput(p, false) then
					onUserScrollInput2()
				end
			end
			v15[React.Event.InputChanged] = function(_, p)
				if isScrollInput(p, true) then
					onUserScrollInput2()
				end
			end
		end

		return v15
	end, { scrollBarThickness, onUserScrollInput, scrollBarInset, scrollBarColor })

	local v15 = data.header ~= nil
	local v16 = data.displayMode == "bubble" or data.displayMode == "discussion"
	local v17 = React.useMemo(function()
		local items = v12

		if v15 or v16 then
			items = table.clone(v12)
		end

		if v15 then
			table.insert(items, 1, v4)
		end

		if v16 then
			table.insert(items, v5)
		end

		return { items = items, getItemKey = getRowKey }
	end, { v12, v15, v16 })

	local ref = React.useRef(nil)

	local state, setState = React.useState(nil)
	local ref2 = React.useRef(data.initialScrollPosition)

	if FFlagExpChatMessageListScrollParity then
		useKeepEndOnResize(state, ref)
	end

	local onNearOldestMessage = data.onNearOldestMessage
	local onNearNewestMessage = data.onNearNewestMessage
	local listProps = React.useMemo(function()
		local clone = table.clone(v)

		if ref2.current == "start" then
			clone.initialScrollAlignment = ViewRecycler.ScrollAlignment.Start
		end

		clone.listRef = ref
		clone.scrollingFrameRef = setState
		clone.scrollingFrameProps = scrollingFrameProps
		clone.data = v17
		clone.layout = layout
		clone.axis = ViewRecycler.Axis.Y
		clone.itemType = itemType
		clone.overscan = FIntExpChatMessageListOverscanRows

		if onNearOldestMessage ~= nil then
			clone.onStartReached = onNearOldestMessage
			clone.startReachedThreshold = v2
		end

		if onNearNewestMessage ~= nil then
			clone.onEndReached = onNearNewestMessage
			clone.endReachedThreshold = v2
		end

		return clone
	end, { v17, layout, itemType, scrollingFrameProps, onNearOldestMessage, onNearNewestMessage })

	local ref3 = React.useRef(false)
	React.useEffect(function()
		local current = ref.current

		if ref3.current or current == nil then
			return
		end

		ref3.current = true

		if ref2.current ~= "start" then
			return
		end

		current.scrollToStart()
	end, { state })

	local onCanvasPositionChanged = data.onCanvasPositionChanged
	React.useEffect(function()
		if state == nil or onCanvasPositionChanged == nil then
			return nil
		end

		local v18 = state
		local onCanvasPositionChanged2 = onCanvasPositionChanged
		local function report() -- 1 equivalent call inferred from this helper
			onCanvasPositionChanged2(v18.CanvasPosition)
		end

		report() -- inferred equivalent call
		local canvasPositionChangedConnection = v18:GetPropertyChangedSignal("CanvasPosition"):Connect(report)
		return function()
			canvasPositionChangedConnection:Disconnect()
		end
	end, { state, onCanvasPositionChanged })

	return {
		sizing = sizing,
		isMeasured = v13 ~= nil,
		listProps = listProps
	}
end

return useMessageListViewModel
