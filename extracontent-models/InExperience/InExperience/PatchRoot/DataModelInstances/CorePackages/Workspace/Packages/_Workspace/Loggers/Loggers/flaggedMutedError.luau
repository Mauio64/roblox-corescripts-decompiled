local mutedError = require(script.Parent.mutedError)

game:DefineFastString("SuppressMutedErrorKeys", "")
local function getFStringSuppressMutedErrorKeys() -- 1 equivalent call inferred from this helper
	return game:GetFastString("SuppressMutedErrorKeys")
end

local v = ""
local partSet = {}

local function shouldSuppressMutedError(p: string)
	local fStringSuppressMutedErrorKeys = getFStringSuppressMutedErrorKeys() -- inferred equivalent call

	if fStringSuppressMutedErrorKeys == v then
		return partSet[p] or false
	end

	v = fStringSuppressMutedErrorKeys
	partSet = {}
	local parts = fStringSuppressMutedErrorKeys:split(",")

	for _, part in parts do
		partSet[part] = true
	end

	return partSet[p] or false
end

local function flaggedMutedError(p: string, p2: string, p3)
	if not shouldSuppressMutedError(p) then
		mutedError(p2, p3)
	end
end

return flaggedMutedError
