local SocialCommon = script:FindFirstAncestor("SocialCommon")
local parent = SocialCommon.Parent

local Rodux = require(parent.Rodux)

require(SocialCommon.Enums.ChatEntryPointNames)

return Rodux.makeActionCreator(script.Name, function(entryPoint)
	return { entryPoint = entryPoint }
end)
