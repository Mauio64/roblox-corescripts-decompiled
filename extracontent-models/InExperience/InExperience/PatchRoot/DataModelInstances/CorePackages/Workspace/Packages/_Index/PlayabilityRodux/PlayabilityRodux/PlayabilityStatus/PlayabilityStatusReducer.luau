local PlayabilityRodux = script:FindFirstAncestor("PlayabilityRodux")
local PlayabilityRoduxParent = PlayabilityRodux.Parent
local Immutable = require(PlayabilityRoduxParent.AppCommonLib).Immutable
local SetPlayabilityStatus = require(PlayabilityRodux.PlayabilityStatus.SetPlayabilityStatus)

return function(p1, p2) -- line: 7
	-- upvalues: SetPlayabilityStatus (copy), Immutable (copy)
	local v7 = p1 or {}

	if p2.type == SetPlayabilityStatus.name then
		v7 = Immutable.JoinDictionaries(v7, p2.playabilityStatus)
	end

	return v7
end
