local resolvePlayerTarget = require(script.Parent.resolvePlayerTarget)

return function(p: string?, p2: string)
	return resolvePlayerTarget(p, p2, "CoreScripts.TextChat.Mute.Success")
end
