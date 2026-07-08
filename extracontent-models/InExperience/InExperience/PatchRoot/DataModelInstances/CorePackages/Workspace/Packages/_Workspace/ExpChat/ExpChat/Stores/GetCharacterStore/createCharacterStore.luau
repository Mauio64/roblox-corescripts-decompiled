local Parent = script:FindFirstAncestor("ExpChat").Parent
local createSignal = require(Parent.Signals).createSignal

local function createCharacterStore() -- line: 19
	-- upvalues: createSignal (copy)
	local v4, v5 = createSignal({})

	local function getKey(p1) -- line: 23
		return (tostring(p1))
	end

	return {
		getCharacters = v4,
		handleCharacterAdded = function(p2, p3) -- line: 27
			-- upvalues: v5 (copy)
			local str = tostring(p2)

			v5(function(p4) -- line: 30
				-- upvalues: str (copy), p3 (copy)
				local v14 = table.clone(p4)

				v14[str] = p3

				return v14
			end)
		end,
		handlePlayerRemoved = function(p5) -- line: 37
			-- upvalues: v5 (copy)
			local str = tostring(p5)

			v5(function(p6) -- line: 40
				-- upvalues: str (copy)
				local v16 = table.clone(p6)

				v16[str] = nil

				return v16
			end)
		end
	}
end

return createCharacterStore
