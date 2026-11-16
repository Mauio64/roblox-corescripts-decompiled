local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local function useMessagesMap(callback, callback2)
	return React.useMemo(function()
		return Signals.createComputed(function(p)
			local v = callback(p)
			local result = {}

			for _, v2 in v do
				local v3

				if callback2 then
					v3 = callback2(v2)
				else
					v3 = v2.messageId
				end

				result[v3] = v2
			end

			return result
		end)
	end, { callback, callback2 })
end

return useMessagesMap
