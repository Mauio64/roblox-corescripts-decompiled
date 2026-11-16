local GetFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagIsSquadEnabled")

if game:DefineFastFlag("SquadAppChatRTNFixWithSquadMainFlag", false) then
	return (GetFFlagIsSquadEnabled())
end

return (game:DefineFastFlag("SquadAppChatRTNFix", false))
