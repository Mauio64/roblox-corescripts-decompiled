local module = require("@luauforge/bundled/gxM")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")

local function useChartsTitleText()
	local v5 = useAppPolicy(function(p2)
		return p2.getGamesPageCreationCenterTitle()
	end)

	local v6 = module({
		creationCenter = "CommonUI.Features.Label.CreationCenter",
		chartsTitle = "CommonUI.Features.Label.Charts"
	})

	if v5 then
		return v6.creationCenter
	end

	return v6.chartsTitle
end

return useChartsTitleText
