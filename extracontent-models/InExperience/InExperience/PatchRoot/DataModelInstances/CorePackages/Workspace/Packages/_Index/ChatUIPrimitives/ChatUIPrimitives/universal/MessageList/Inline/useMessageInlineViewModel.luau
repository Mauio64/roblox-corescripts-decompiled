local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.Parent.Parent.Types)
require(script.Parent.Parent.groupMessages)
local useMessageRowContents = require(script.Parent.Parent.useMessageRowContents)

local function hasIdentity(p) -- 2 equivalent calls inferred from this helper
	return p.message.author ~= nil and p.groupPosition.isFirst
end

local function renderKeyOf(p) -- 1 equivalent call inferred from this helper
	local v = p.message.deliveryState == nil and "" or p.message.deliveryState
	return `{hasIdentity(p)}|{v}` -- inferred equivalent call
end

local function useMessageInlineViewModel(callback)
	local v = useMessageRowContents(callback)
	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return renderKeyOf(callback(p)) -- inferred equivalent call
		end)
	end, { callback })
	local v3 = { callback, (SignalsReact.useSignalState(v2)) }
	local v4 = React.useMemo(function()
		local v4 = callback(false)
		return { hasIdentity = hasIdentity(v4), deliveryState = v4.message.deliveryState } -- inferred equivalent call
	end, v3)

	return {
		hasIdentity = v4.hasIdentity,
		getIdentity = v.getIdentity,
		contents = v.contents,
		deliveryState = v4.deliveryState,
		replyText = v.replyText
	}
end

return useMessageInlineViewModel
