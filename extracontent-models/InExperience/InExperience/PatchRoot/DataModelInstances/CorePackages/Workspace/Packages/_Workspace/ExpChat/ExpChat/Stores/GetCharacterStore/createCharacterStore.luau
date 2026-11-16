local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)

local createSignal = Signals.createSignal

local function createCharacterStore()
	local signal, v = createSignal({})

	local function getKey(p) -- 2 equivalent calls inferred from this helper
		return (tostring(p))
	end

	return {
		getCharacters = signal,
		handleCharacterAdded = function(p, p2)
			local key = getKey(p) -- inferred equivalent call
			v(function(p3)
				local clone = table.clone(p3)
				clone[key] = p2
				return clone
			end)
		end,
		handlePlayerRemoved = function(p)
			local key = getKey(p) -- inferred equivalent call
			v(function(p2)
				local clone = table.clone(p2)
				clone[key] = nil
				return clone
			end)
		end
	}
end

return createCharacterStore
