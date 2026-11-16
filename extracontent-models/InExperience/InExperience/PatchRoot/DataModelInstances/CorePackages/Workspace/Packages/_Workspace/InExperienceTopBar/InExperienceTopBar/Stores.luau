local InExperienceTopBar = script:FindFirstAncestor("InExperienceTopBar")

local Flags = require(InExperienceTopBar.Flags)
local getTopBarStore

if Flags.FFlagTopBarSignalizeSetCores then
	getTopBarStore = require(script.GetTopBarStore)
end

return { GetTopBarStore = getTopBarStore }
