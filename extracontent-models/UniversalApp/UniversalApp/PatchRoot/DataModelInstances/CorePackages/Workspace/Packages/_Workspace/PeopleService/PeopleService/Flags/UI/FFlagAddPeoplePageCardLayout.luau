game:DefineFastFlag("AddPeoplePageCardLayout4", false)

local EngineFeature = game:GetEngineFeature("AddPeoplePageLayoutSettings")

return function() -- line: 5
	-- upvalues: EngineFeature (copy)
	return game:GetFastFlag("AddPeoplePageCardLayout4") and EngineFeature
end
