local BuildExperience = script:FindFirstAncestor("BuildExperience")
local Signals = require(BuildExperience.Parent.Signals)
local createBuildCreatorCreditRefreshStore = require(script.createBuildCreatorCreditRefreshStore)

return Signals.createComputed(function()
	return createBuildCreatorCreditRefreshStore()
end)
