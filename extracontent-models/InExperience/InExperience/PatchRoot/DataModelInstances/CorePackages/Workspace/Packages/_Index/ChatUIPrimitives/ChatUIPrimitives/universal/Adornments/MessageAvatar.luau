local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.Parent.Types)

local function toAvatarImage(p)
	return if p and p.avatarContent then p.avatarContent else ""
end

local function AvatarImage(props)
	local v = SignalsReact.useSignalBinding(props.getIdentity)
	local image = React.useMemo(function()
		return v:map(toAvatarImage)
	end, { v })
	local tag = Foundation.Hooks.useDefaultTags(props.sizeTag, "stroke-standard stroke-default radius-circle")

	return React.createElement(Foundation.Image, {
		tag = tag,
		Image = image,
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	})
end

local function MessageAvatar(props)
	if props.visible then
		return React.createElement(AvatarImage, {
			getIdentity = props.getIdentity,
			sizeTag = props.sizeTag,
			LayoutOrder = props.LayoutOrder,
			testId = props.testId
		})
	end

	return React.createElement(Foundation.View, {
		tag = props.gutterTag or props.sizeTag,
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	})
end

return React.memo(MessageAvatar)
