game:DefineFastFlag("LuaAppGameCarouselUseAutoSizing", false)

return function() -- line: 3
	return not not game:GetEngineFeature("AutomaticSizing2") and (game:GetFastFlag("LuaAppGameCarouselUseAutoSizing") or false)
end
