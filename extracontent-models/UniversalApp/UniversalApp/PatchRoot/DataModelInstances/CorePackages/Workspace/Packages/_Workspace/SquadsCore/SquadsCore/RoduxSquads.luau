local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local RoduxSquads = require(SquadsCoreParent.RoduxSquads)
local RODUX_KEY = require(SquadsCore.Common.Constants).RODUX_KEY

return RoduxSquads.config({
	keyPath = RODUX_KEY .. ".Squad"
})
