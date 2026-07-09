local GetFFlagIsSquadEnabled = require(script.Parent.GetFFlagIsSquadEnabled)

if game:DefineFastFlag("SquadAppChatRTNFixWithSquadMainFlag", false) then
	return (GetFFlagIsSquadEnabled())
end

return (game:DefineFastFlag("SquadAppChatRTNFix", false))
