game:DefineFastFlag("AddPeoplePageCardLayout4", false)

local engineFeature = game:GetEngineFeature("AddPeoplePageLayoutSettings")

return function()
	return game:GetFastFlag("AddPeoplePageCardLayout4") and engineFeature
end
