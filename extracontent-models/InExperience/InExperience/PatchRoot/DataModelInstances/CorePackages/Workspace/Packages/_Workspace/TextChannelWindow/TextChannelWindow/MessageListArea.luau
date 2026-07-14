local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)

require(ParentParent.Signals)

local ChatUIPrimitives = require(ParentParent.ChatUIPrimitives)
local useInExperienceLocalization = require(script.Parent.useInExperienceLocalization)
local MessageLayoutContainer = ChatUIPrimitives.MessageLayoutContainer

local function MessageListArea(t1: {[any]: any}) -- line: 27
	-- upvalues: Foundation (copy), useInExperienceLocalization (copy), React (copy), MessageLayoutContainer (copy)
	local v9 = Foundation.Hooks.useTokens()
	local v10 = useInExperienceLocalization()

	if t1.channelState == "no-channel" then
		return React.createElement(Foundation.Empty, {
			icon = {
				name = "icons/status/oof_xlarge"
			},
			text = v10("CoreScripts.TextChat.Error.NoChannelSelected")
		})
	end

	if t1.channelState == "not-member" then
		return React.createElement(Foundation.Empty, {
			icon = {
				name = "icons/status/oof_xlarge"
			},
			text = v10("CoreScripts.TextChat.Error.NoChannelAccess")
		})
	end

	if t1.channelState ~= "member" then
		return React.createElement(Foundation.Empty, {
			icon = {
				name = "icons/status/oof_xlarge"
			},
			text = v10("CoreScripts.TextChat.InputBar.Hint.ChatUnavailable")
		})
	end

	return React.createElement(MessageLayoutContainer, {
		layoutStyle = "textLine",
		messagesSignal = t1.messagesSignal,
		Size = UDim2.fromScale(1, 1),
		contentPadding = {
			top = UDim.new(0, v9.Size.Size_100),
			bottom = UDim.new(0, v9.Size.Size_100),
			left = UDim.new(0, v9.Size.Size_200),
			right = UDim.new(0, 56)
		}
	})
end

return MessageListArea
