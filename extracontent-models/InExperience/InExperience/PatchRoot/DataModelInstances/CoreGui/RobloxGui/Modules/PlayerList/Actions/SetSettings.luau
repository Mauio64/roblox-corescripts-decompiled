local ActionCreator = require(script.Parent.Parent.ActionCreator)

return ActionCreator("SetSettings", function(p)
	return { preferredTransparency = p.preferredTransparency, reducedMotion = p.reducedMotion }
end)
