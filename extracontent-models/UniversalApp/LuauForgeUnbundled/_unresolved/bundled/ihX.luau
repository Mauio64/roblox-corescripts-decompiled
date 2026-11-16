local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/ftX")

local useContactImporterConfiguration = require("@luauforge/bundled/coQ").Utils.useContactImporterConfiguration
local module2 = require("@luauforge/bundled/ihY")
return function(p2)
	local v5 = module2()
	local v6 = useContactImporterConfiguration(p2)
	local v7 = useDispatch()

	return function()
		if v6.shouldShowContactImporterModal then
			v5()
		else
			v7(module())
		end
	end
end
