local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(useTranslation: boolean, messageId: string)
	return { useTranslation = useTranslation, messageId = messageId }
end)
