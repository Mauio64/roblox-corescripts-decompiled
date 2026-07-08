local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local ChatUIPrimitivesParent = ChatUIPrimitives.Parent
local React = require(ChatUIPrimitivesParent.React)
local Signals = require(ChatUIPrimitivesParent.Signals)
local SignalsReact = require(ChatUIPrimitivesParent.SignalsReact)
local Foundation = require(ChatUIPrimitivesParent.Foundation)
local useMessagePool = require(script.Parent.useMessagePool)
local useMessagesMap = require(script.Parent.useMessagesMap)
local BottomLockedScrollView = require(script.Parent.BottomLockedScrollView)
local TextLineEntry = require(script.Parent.TextLineEntry)
local BubbleEntry = require(script.Parent.BubbleEntry)

require(ChatUIPrimitives.Types)

local function createSlotElementFactory(p1, p2) -- line: 29
	-- upvalues: React (copy)
	return function(p3) -- line: 33
		-- upvalues: React (copy), p1 (copy), p2 (copy)
		return React.createElement(p1, {
			getMessageId = p3.getMessageId,
			getLayoutOrder = p3.getLayoutOrder,
			getMessagesMap = p2
		})
	end
end

local v13 = Signals.createSignal({})
local t1 = {
	left = UDim.new(0, 8),
	right = UDim.new(0, 8)
}

local function MessageLayoutContainer(t2: {[any]: any}) -- line: 56
	-- upvalues: v13 (copy), React (copy), Signals (copy), useMessagesMap (copy), BubbleEntry (copy), TextLineEntry (copy), useMessagePool (copy), SignalsReact (copy), Foundation (copy), BottomLockedScrollView (copy), t1 (copy)
	local v19 = t2.messagesSignal or v13
	local v20 = React.useMemo(function() -- line: 61
		-- upvalues: Signals (copy), v19 (copy)
		return Signals.createComputed(function(p4) -- line: 62
			-- upvalues: v19 (copy)
			local t3 = {}

			for _, v32 in (v19(p4)) do
				t3[#t3 + 1] = v32.messageId
			end

			return t3
		end)
	end, {})
	local v21 = useMessagesMap(v19)
	local v22 = if t2.layoutStyle ~= "bubble" then TextLineEntry else BubbleEntry
	local v23 = useMessagePool({
		messageIdsSignal = v20,
		createSlotElement = function(p5) -- line: 33
			-- upvalues: React (copy), v22 (copy), v21 (copy)
			return React.createElement(v22, {
				getMessageId = p5.getMessageId,
				getLayoutOrder = p5.getLayoutOrder,
				getMessagesMap = v21
			})
		end
	})
	local v24 = SignalsReact.useSignalState(v23)
	local v25 = React.useMemo(function() -- line: 89
		-- upvalues: v24 (copy), React (copy)
		local v28 = table.clone(v24)

		v28["$layout"] = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2)
		})

		return v28
	end, { v24 })

	return React.createElement(Foundation.View, {
		tag = "fill padding-y-xsmall",
		Size = t2.Size or UDim2.fromScale(1, 1)
	}, {
		scrollView = React.createElement(BottomLockedScrollView, {
			Size = UDim2.fromScale(1, 1),
			contentPadding = t2.contentPadding or t1,
			children = v25
		})
	})
end

return React.memo(MessageLayoutContainer)
