local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local React = require(CorePackages.Packages.React)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local v5 = game:DefineFastString("LuaAppChartsAppPageIxpLayer", AppUserLayers.ChartsMigrationLayer)
local u6 = false

local function useLogSduiChartsExposure(b1: boolean?) -- line: 11
	-- upvalues: React (copy), u6 (ref), IXPService (copy), v5 (copy)
	React.useEffect(function() -- line: 12
		-- upvalues: u6 (ref), b1 (copy), IXPService (copy), v5 (copy)
		if u6 or b1 == false then
			return
		end

		u6 = true
		IXPService:LogFlagLinkedUserLayerExposure(v5)
	end, { b1 })
end

return useLogSduiChartsExposure
