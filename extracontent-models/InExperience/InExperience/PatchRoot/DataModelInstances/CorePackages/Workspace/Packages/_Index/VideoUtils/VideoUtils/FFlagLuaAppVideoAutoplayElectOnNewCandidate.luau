local parent = script:FindFirstAncestor("VideoUtils").Parent

local v = game:DefineFastFlag("LuaAppVideoAutoplayElectOnNewCandidate", false)

if v then
	local SharedFlags = require(parent.SharedFlags)
	return SharedFlags.FFlagLuaAppVideoAutoplayFeedElection
end

return v
