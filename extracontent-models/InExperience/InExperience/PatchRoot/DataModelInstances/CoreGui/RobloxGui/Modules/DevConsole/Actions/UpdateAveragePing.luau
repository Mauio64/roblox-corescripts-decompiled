local Action = require(script.Parent.Parent.Action)

return Action("UpdateAveragePing", function(averagePing)
	return { AveragePing = averagePing }
end)
