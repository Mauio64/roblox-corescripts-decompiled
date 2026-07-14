local Parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)

local function useMessagesMap(p1, p2: ((...any) -> ...any)?) -- line: 28
	-- upvalues: React (copy), Signals (copy)
	return React.useMemo(function() -- line: 32
		-- upvalues: Signals (copy), p1 (copy), p2 (copy)
		return Signals.createComputed(function(p3) -- line: 33
			-- upvalues: p1 (copy), p2 (copy)
			local t1 = {}

			for _, v10 in (p1(p3)) do
				t1[if not p2 then v10.messageId else p2(v10)] = v10
			end

			return t1
		end)
	end, {
		p1,
		p2
	})
end

return useMessagesMap
