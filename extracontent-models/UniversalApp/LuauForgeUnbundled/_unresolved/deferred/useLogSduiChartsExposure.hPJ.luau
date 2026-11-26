local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")

local React = require(CorePackages.Packages.React)
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers

local defineFastString = game:DefineFastString(
	"LuaAppChartsAppPageIxpLayer",
	appUserLayers.ChartsMigrationLayer
)

local v5 = false

local function useLogSduiChartsExposure(p2)
	React.useEffect(function()
		if v5 or p2 == false then
			return
		end

		v5 = true
		IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
	end, { p2 })
end

return useLogSduiChartsExposure
