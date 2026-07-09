local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)

require(ParentParent.Signals)
require(script.Parent.ChatApp)

local v3 = React.createContext(nil)

return {
	Context = v3,
	Provider = function(t1: {[any]: any}) -- line: 20
		-- upvalues: React (copy), v3 (copy)
		local v5 = React.useMemo(function() -- line: 22
			-- upvalues: t1 (copy)
			return {
				write = function(p1) -- line: 24
					-- upvalues: t1 (copy)
					t1.setMessages(function(p2) -- line: 25
						-- upvalues: p1 (copy)
						for v9, v10 in p2 do
							if v10.messageId == p1.messageId then
								local v11 = table.clone(p2)

								v11[v9] = p1

								return v11
							end
						end

						local v12 = table.clone(p2)

						table.insert(v12, p1)

						return v12
					end)
				end,
				remove = function(s1: string) -- line: 38
					-- upvalues: t1 (copy)
					t1.setMessages(function(p3) -- line: 39
						-- upvalues: s1 (copy)
						local t2 = {}

						for _, v16 in p3 do
							if v16.messageId ~= s1 then
								table.insert(t2, v16)
							end
						end

						return t2
					end)
				end
			}
		end, { t1.setMessages })

		return React.createElement(v3.Provider, {
			value = v5
		}, t1.children)
	end,
	useMessageWriter = function() -- line: 55
		-- upvalues: React (copy), v3 (copy)
		return React.useContext(v3)
	end
}
