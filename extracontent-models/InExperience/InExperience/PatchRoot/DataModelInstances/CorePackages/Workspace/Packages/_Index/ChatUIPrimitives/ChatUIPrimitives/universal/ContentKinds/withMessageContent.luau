local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
require(parent.Signals)

require(script.Parent.Parent.Types)

local function withMessageContent(p, callback)
	local function MessageContentAdapter(p2)
		local getContent = React.useMemo(function()
			return function(p3)
				local v = callback(p2.getContent(p3))
				assert(v ~= nil, "Message content did not match its registered renderer")
				return v
			end
		end, { p2.getContent })

		return React.createElement(p, { getContent = getContent, LayoutOrder = p2.LayoutOrder })
	end

	return MessageContentAdapter
end

return withMessageContent
