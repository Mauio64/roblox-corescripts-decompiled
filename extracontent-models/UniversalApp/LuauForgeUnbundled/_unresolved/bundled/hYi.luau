local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
game:DefineFastFlag("UniversalAppCsat4", false)

return function()
	return game:GetEngineFeature("UniversalAppCsatAppStorageKey")
		and game:GetFastFlag("UniversalAppCsat4")
		and not isTenFootInterface()
end
