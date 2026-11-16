local PlayabilityRodux = script:FindFirstAncestor("PlayabilityRodux")
local parent = PlayabilityRodux.Parent

local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local SetPlayabilityStatus = require(PlayabilityRodux.PlayabilityStatus.SetPlayabilityStatus)

return function(options, p)
	local v = options or {}

	if p.type == SetPlayabilityStatus.name then
		return (Immutable.JoinDictionaries(v, p.playabilityStatus))
	end

	return v
end
