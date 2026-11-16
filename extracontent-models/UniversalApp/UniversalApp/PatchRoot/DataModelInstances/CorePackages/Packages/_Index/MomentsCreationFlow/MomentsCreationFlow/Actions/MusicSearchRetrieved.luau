local parent = script:FindFirstAncestor("MomentsCreationFlow").Parent

local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(musics)
	return { musics = musics }
end)
