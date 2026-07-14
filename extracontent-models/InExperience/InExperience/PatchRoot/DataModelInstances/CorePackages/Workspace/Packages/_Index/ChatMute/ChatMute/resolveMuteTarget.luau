local resolvePlayerTarget = require(script.Parent.resolvePlayerTarget)

return function(s1: string?, s2: string) -- line: 5
	-- upvalues: resolvePlayerTarget (copy)
	return resolvePlayerTarget(s1, s2, "CoreScripts.TextChat.Mute.Success")
end
