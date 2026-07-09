local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)

require(ParentParent.Signals)

local MessageLayoutContainer = require(ParentParent.ChatUIPrimitives).MessageLayoutContainer

local function MessageListArea(t1: {[any]: any}) -- line: 22
	-- upvalues: Foundation (copy), React (copy), MessageLayoutContainer (copy)
	local v7 = Foundation.Hooks.useTokens()

	if t1.channelState == "no-channel" then
		return React.createElement(Foundation.Empty, {
			text = "[PLACEHOLDER] Chat channel not configured.",
			icon = {
				name = "icons/status/oof_xlarge"
			}
		})
	end

	if t1.channelState == "not-member" then
		return React.createElement(Foundation.Empty, {
			text = "[PLACEHOLDER] You are not a member of this channel.",
			icon = {
				name = "icons/status/oof_xlarge"
			}
		})
	end

	return React.createElement(MessageLayoutContainer, {
		layoutStyle = "textLine",
		messagesSignal = t1.messagesSignal,
		Size = UDim2.fromScale(1, 1),
		contentPadding = {
			top = UDim.new(0, v7.Size.Size_100),
			bottom = UDim.new(0, v7.Size.Size_100),
			left = UDim.new(0, v7.Size.Size_200),
			right = UDim.new(0, 56)
		}
	})
end

return MessageListArea
