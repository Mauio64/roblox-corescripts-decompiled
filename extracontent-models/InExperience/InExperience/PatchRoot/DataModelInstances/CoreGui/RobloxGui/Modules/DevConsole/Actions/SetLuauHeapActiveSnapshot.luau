local Action = require(script.Parent.Parent.Action)

return Action(script.Name, function(active: number)
	return { active = active }
end)
