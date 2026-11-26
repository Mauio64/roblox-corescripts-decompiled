local resolvePlayerTarget = require("@game/CorePackages/Workspace/Packages/_Index/ChatMute/ChatMute/resolvePlayerTarget")

return function(p2, p3)
	return resolvePlayerTarget(p2, p3, "CoreScripts.TextChat.Mute.Success")
end
