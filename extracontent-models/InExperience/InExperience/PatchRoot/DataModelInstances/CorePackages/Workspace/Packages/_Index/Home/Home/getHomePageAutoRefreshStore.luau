local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local Signals = require(parent.Signals)
local createHomePageAutoRefreshStore = require(Home.createHomePageAutoRefreshStore)

return Signals.createComputed(function()
	return createHomePageAutoRefreshStore()
end)
