local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/Loggers/Loggers/mutedError")

game:DefineFastString("SuppressMutedErrorKeys", "")
local function getFStringSuppressMutedErrorKeys()
	return game:GetFastString("SuppressMutedErrorKeys")
end

local v5 = ""
local partSet = {}

local function shouldSuppressMutedError(p2)
	local fastString = game:GetFastString("SuppressMutedErrorKeys")

	if fastString == v5 then
		return partSet[p2] or false
	end

	v5 = fastString
	partSet = {}
	local parts = fastString:split(",")

	for k, part in parts do
		partSet[part] = true
	end

	return partSet[p2] or false
end

local function flaggedMutedError(p2, p3, p4)
	if not shouldSuppressMutedError(p2) then
		mutedError(p3, p4)
	end
end

return flaggedMutedError
