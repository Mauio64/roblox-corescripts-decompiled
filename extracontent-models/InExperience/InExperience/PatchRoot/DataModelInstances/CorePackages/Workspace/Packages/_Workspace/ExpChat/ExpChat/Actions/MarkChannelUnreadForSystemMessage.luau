local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(text: string, channelNameOverride: string, metadata: string?)
	return { text = text, channelNameOverride = channelNameOverride, metadata = metadata }
end)
