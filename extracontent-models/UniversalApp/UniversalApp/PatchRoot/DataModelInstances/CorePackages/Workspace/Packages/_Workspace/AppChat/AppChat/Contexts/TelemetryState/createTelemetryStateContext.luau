local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)

local function createStateContext(p1) -- line: 18
	-- upvalues: React (copy), Cryo (copy)
	local v6 = React.createContext({
		get = function() -- line: 20
			-- upvalues: Cryo (copy), p1 (copy)
			return Cryo.Dictionary.union({}, p1)
		end,
		set = function() -- line: 23
		end
	})

	return {
		Provider = v6.Provider,
		useClearState = function() -- line: 28
			-- upvalues: React (copy), v6 (copy), p1 (copy)
			local set = React.useContext(v6).set

			return React.useCallback(function() -- line: 30
				-- upvalues: set (copy), p1 (copy)
				set(p1)
			end, { set })
		end,
		useGetState = function() -- line: 34
			-- upvalues: React (copy), v6 (copy)
			return React.useContext(v6).get
		end,
		useMergeState = function() -- line: 37
			-- upvalues: React (copy), v6 (copy), Cryo (copy)
			local set = React.useContext(v6).set

			return React.useCallback(function(p2) -- line: 39
				-- upvalues: set (copy), Cryo (copy)
				set(function(p3) -- line: 40
					-- upvalues: Cryo (copy), p2 (copy)
					return Cryo.Dictionary.join(p3, p2)
				end)
			end, { set })
		end,
		useSetState = function() -- line: 45
			-- upvalues: React (copy), v6 (copy)
			return React.useContext(v6).set
		end
	}
end

return createStateContext
