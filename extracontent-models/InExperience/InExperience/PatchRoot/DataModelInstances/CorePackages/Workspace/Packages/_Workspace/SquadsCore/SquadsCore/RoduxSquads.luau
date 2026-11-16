local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local RoduxSquads = require(parent.RoduxSquads)

local Constants = require(SquadsCore.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY

return RoduxSquads.config({
	keyPath = RODUX_KEY .. ".Squad"
})
