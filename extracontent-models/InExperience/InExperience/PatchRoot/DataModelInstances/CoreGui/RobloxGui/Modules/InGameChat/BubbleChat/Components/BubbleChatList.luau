local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local ChatBubble = require(script.Parent.ChatBubble)
local Types = require(script.Parent.Parent.Types)

local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")

local extended = Roact.Component:extend("BubbleChatList")

extended.validateProps = t.strictInterface({
	userId = t.string,
	isVisible = t.optional(t.boolean),
	theme = t.optional(t.string),
	onLastBubbleFadeOut = t.optional(t.callback),
	chatSettings = Types.IChatSettings,
	renderFirstInsert = t.optional(t.callback),
	insertSize = t.optional(t.Vector2),
	messageIds = t.array(t.string)
})

extended.defaultProps = { theme = "Light" }

function extended.getDerivedStateFromProps(p, p2)
	local bubbles = {}

	if p2.bubbles then
		for _, bubble in ipairs(p2.bubbles) do
			if not Cryo.List.find(p.messageIds, bubble.messageId) then
				table.insert(bubbles, { messageId = bubble.messageId, fadingOut = true })
			end
		end
	end

	for _, messageId in ipairs(p.messageIds) do
		table.insert(bubbles, { messageId = messageId, fadingOut = false })
	end

	return { bubbles = bubbles }
end

function extended:init(p)
	if (not p.messageIds or #p.messageIds == 0) and p.onLastBubbleFadeOut then
		p.onLastBubbleFadeOut()
	end

	function self.onBubbleFadeOut(p2)
		local filtered = Cryo.List.filter(self.state.bubbles, function(p3): boolean
			return p3.messageId ~= p2
		end)

		if #filtered == 0 and self.props.onLastBubbleFadeOut then
			self.props.onLastBubbleFadeOut()
		else
			self:setState({ bubbles = filtered })
		end
	end
end

function extended.render(props)
	local chatSettings = props.props.chatSettings
	local children = {
		["Layout"] = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, chatSettings.BubblesSpacing)
		}),
		CaretPadding = chatSettings.TailVisible and props.props.showCarat and Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 8)
		})
	}

	for i, bubble in ipairs(props.state.bubbles) do
		local isMostRecent = i == #props.state.bubbles
		local renderFirstInsert

		if isMostRecent then
			renderFirstInsert = props.props.renderFirstInsert or nil
		end

		local insertSize = props.props.insertSize

		children["Bubble" .. bubble.messageId] = Roact.createElement(ChatBubble, {
			messageId = bubble.messageId,
			isMostRecent = isMostRecent,
			theme = props.props.theme,
			fadingOut = bubble.fadingOut,
			onFadeOut = props.onBubbleFadeOut,
			chatSettings = chatSettings,
			renderInsert = renderFirstInsert,
			insertSize = insertSize,
			showCarat = props.props.showCarat
		})
	end

	return Roact.createElement(
		"Frame",
		{
			Visible = props.props.isVisible,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1
		},
		children
	)
end

local function mapStateToProps(p, p2)
	return {
		messageIds = p.userMessages[p2.userId] or {}
	}
end

return RoactRodux.connect(mapStateToProps)(extended)
