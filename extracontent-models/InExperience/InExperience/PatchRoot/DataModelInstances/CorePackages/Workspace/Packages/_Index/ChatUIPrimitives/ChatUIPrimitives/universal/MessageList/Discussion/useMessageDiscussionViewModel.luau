local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.Parent.Parent.Types)
require(script.Parent.Parent.groupMessages)
local useMessageRowContents = require(script.Parent.Parent.useMessageRowContents)

local function renderKeyOf(p) -- 1 equivalent call inferred from this helper
	local author = p.message.author
	local v = author == nil and "" or author.userId
	return `{p.groupPosition.isFirst}|{v}`
end

local function useMessageDiscussionViewModel(callback)
	local v = useMessageRowContents(callback)
	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return renderKeyOf(callback(p)) -- inferred equivalent call
		end)
	end, { callback })
	local v3 = SignalsReact.useSignalState(v2)

	local getSentAtUnixMilliseconds = React.useMemo(function()
		return Signals.createComputed(function(p)
			return callback(p).message.sentAtUnixMilliseconds
		end)
	end, { callback })

	return {
		showIdentity = React.useMemo(function()
			local v4 = callback(false)
			return {
				showIdentity = v4.groupPosition.isFirst and v4.message.author ~= nil
			}
		end, { callback, v3 }).showIdentity,
		getIdentity = v.getIdentity,
		getSentAtUnixMilliseconds = getSentAtUnixMilliseconds,
		contents = v.contents
	}
end

return useMessageDiscussionViewModel
