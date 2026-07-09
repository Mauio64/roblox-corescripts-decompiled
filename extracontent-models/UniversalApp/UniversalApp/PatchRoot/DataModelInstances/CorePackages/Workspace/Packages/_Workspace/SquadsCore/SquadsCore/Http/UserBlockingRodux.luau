local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local RODUX_KEY = require(SquadsCore.Common.Constants).RODUX_KEY

return (require(SquadsCoreParent.UserBlockingRodux).config({
	keyPath = RODUX_KEY .. ".UserBlocking"
}))
