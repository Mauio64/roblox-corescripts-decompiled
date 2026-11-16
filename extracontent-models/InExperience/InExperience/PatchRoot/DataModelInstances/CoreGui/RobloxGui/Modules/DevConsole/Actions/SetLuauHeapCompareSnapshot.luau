local Action = require(script.Parent.Parent.Action)

return Action(script.Name, function(compare: number)
	return { compare = compare }
end)
