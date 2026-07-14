local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)

require(script.Parent.Message)

local v3 = React.createContext(nil)

return {
	Context = v3,
	Provider = function(t1: {[any]: any}) -- line: 19
		-- upvalues: React (copy), v3 (copy)
		local v5 = React.useMemo(function() -- line: 21
			-- upvalues: t1 (copy)
			return {
				write = t1.upsertMessage,
				remove = t1.removeMessage
			}
		end, {
			t1.upsertMessage,
			t1.removeMessage
		})

		return React.createElement(v3.Provider, {
			value = v5
		}, t1.children)
	end,
	useMessageWriter = function() -- line: 31
		-- upvalues: React (copy), v3 (copy)
		return React.useContext(v3)
	end
}
