local Foundation = script:FindFirstAncestor("Foundation")
local Flags = require(Foundation.Utility.Flags)

local function calculateNumberInputValueFromPositions(n1: number, n2: number, n3: number, n4: number, n5: number?) -- line: 7
	-- upvalues: Flags (copy)
	return n1 + ((if not Flags.FoundationNumberInputBeta then n3 - n2 else math.floor((n3 - n2) * (n5 or 1)))) * n4
end

return calculateNumberInputValueFromPositions
