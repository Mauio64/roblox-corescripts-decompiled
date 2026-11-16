local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local Constants = require(SquadsCore.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY

local UserBlockingRodux = require(parent.UserBlockingRodux)

return (UserBlockingRodux.config({
	keyPath = RODUX_KEY .. ".UserBlocking"
}))
