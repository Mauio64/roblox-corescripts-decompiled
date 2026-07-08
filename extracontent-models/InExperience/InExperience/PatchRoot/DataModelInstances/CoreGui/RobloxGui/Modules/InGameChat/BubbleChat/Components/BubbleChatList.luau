local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local ChatBubble = require(script.Parent.ChatBubble)
local Types = require(script.Parent.Parent.Types)

game:GetService("CoreGui"):WaitForChild("RobloxGui")

local v8 = Roact.Component:extend("BubbleChatList")

v8.validateProps = t.strictInterface({
	userId = t.string,
	isVisible = t.optional(t.boolean),
	theme = t.optional(t.string),
	onLastBubbleFadeOut = t.optional(t.callback),
	chatSettings = Types.IChatSettings,
	renderFirstInsert = t.optional(t.callback),
	insertSize = t.optional(t.Vector2),
	messageIds = t.array(t.string)
})
v8.defaultProps = {
	theme = "Light"
}

function v8.getDerivedStateFromProps(p1, p2) -- line: 32
	-- upvalues: Cryo (copy)
	local t1 = {}

	if p2.bubbles then
		for _, v in ipairs(p2.bubbles) do
			if not Cryo.List.find(p1.messageIds, v.messageId) then
				table.insert(t1, {
					fadingOut = true,
					messageId = v.messageId
				})
			end
		end
	end

	for _, v in ipairs(p1.messageIds) do
		table.insert(t1, {
			fadingOut = false,
			messageId = v
		})
	end

	return {
		bubbles = t1
	}
end
function v8.init(p3, p4) -- line: 60
	-- upvalues: Cryo (copy)
	if (not p4.messageIds or #p4.messageIds == 0) and p4.onLastBubbleFadeOut then
		p4.onLastBubbleFadeOut()
	end

	function p3.onBubbleFadeOut(p5) -- line: 67
		-- upvalues: Cryo (copy), p3 (copy)
		local v30 = Cryo.List.filter(p3.state.bubbles, function(p6) -- line: 68
			-- upvalues: p5 (copy)
			return p6.messageId ~= p5
		end)

		if #v30 == 0 and p3.props.onLastBubbleFadeOut then
			p3.props.onLastBubbleFadeOut()

			return
		end

		p3:setState({
			bubbles = v30
		})
	end
end
function v8.render(p7) -- line: 83
	-- upvalues: Roact (copy), ChatBubble (copy)
	local t2 = {}
	local chatSettings = p7.props.chatSettings

	t2.Layout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		Padding = UDim.new(0, chatSettings.BubblesSpacing)
	})
	t2.CaretPadding = chatSettings.TailVisible and (p7.props.showCarat and Roact.createElement("UIPadding", {
		PaddingBottom = UDim.new(0, 8)
	}))

	for i, v in ipairs(p7.state.bubbles) do
		local v24 = i == #p7.state.bubbles
		local v25 = v24 and p7.props.renderFirstInsert or nil
		local insertSize = p7.props.insertSize

		t2["Bubble" .. v.messageId] = Roact.createElement(ChatBubble, {
			messageId = v.messageId,
			isMostRecent = v24,
			theme = p7.props.theme,
			fadingOut = v.fadingOut,
			onFadeOut = p7.onBubbleFadeOut,
			chatSettings = chatSettings,
			renderInsert = v25,
			insertSize = insertSize,
			showCarat = p7.props.showCarat
		})
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Visible = p7.props.isVisible,
		Size = UDim2.fromScale(1, 1)
	}, t2)
end

local function mapStateToProps(p8, p9) -- line: 127
	return {
		messageIds = p8.userMessages[p9.userId] or {}
	}
end

return RoactRodux.connect(mapStateToProps)(v8)
