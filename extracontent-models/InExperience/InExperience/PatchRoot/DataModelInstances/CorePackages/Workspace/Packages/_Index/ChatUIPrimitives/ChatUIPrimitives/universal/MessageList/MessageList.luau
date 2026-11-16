local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)

local Sizing = require(script.Parent.Parent.Sizing)
local HeaderItem = require(script.Parent.HeaderItem)
local MessageListClock = require(script.Parent.MessageListClock)
local MessageListView = require(script.Parent.MessageListView)
local ObservingUserContext = require(script.Parent.ObservingUserContext)
local useMessageListViewModel = require(script.Parent.useMessageListViewModel)

local function MessageListContent(props)
	local v = useMessageListViewModel(props)
	local observingUserId

	if props.observingUserId ~= "" then
		observingUserId = props.observingUserId
	end

	local createElement = React.createElement
	local provider = ObservingUserContext.Context.Provider

	local createElement2 = React.createElement
	local provider2 = Sizing.Context.Provider
	local v2 = { value = v.sizing }

	local createElement3 = React.createElement
	local v3 = {
		enabled = props.displayMode == "discussion"
	}
	local createElement4 = React.createElement
	local provider3 = HeaderItem.Context.Provider
	local v4 = { value = props.header }

	local createElement5 = React.createElement
	local view = Foundation.View
	local v5 = { Size = UDim2.fromScale(1, 1) }
	local v6 = {
		ResponsiveContainer = React.createElement(Responsive.ResponsiveContainerFrame),
		MessageListView = 0
	}
	local messageListView

	if v.isMeasured then
		messageListView = React.createElement(MessageListView, { listProps = v.listProps })
	end

	v6.MessageListView = messageListView
	return createElement(provider, { value = observingUserId }, {
		Sizing = createElement2(provider2, v2, {
			Clock = createElement3(MessageListClock, v3, {
				Header = createElement4(provider3, v4, { Frame = createElement5(view, v5, v6) })
			})
		})
	})
end

local function MessageList(p)
	return React.createElement(Responsive.ResponsiveProvider, nil, {
		Content = React.createElement(MessageListContent, p)
	})
end

return React.memo(MessageList)
