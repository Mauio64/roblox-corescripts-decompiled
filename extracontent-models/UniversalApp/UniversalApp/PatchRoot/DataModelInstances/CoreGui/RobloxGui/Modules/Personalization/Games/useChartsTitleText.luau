local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)

local function useChartsTitleText() -- line: 6
	-- upvalues: useAppPolicy (copy), useLocalization (copy)
	local v5 = useAppPolicy(function(p1) -- line: 7
		return p1.getGamesPageCreationCenterTitle()
	end)
	local v6 = useLocalization({
		creationCenter = "CommonUI.Features.Label.CreationCenter",
		chartsTitle = "CommonUI.Features.Label.Charts"
	})

	if v5 then
		return v6.creationCenter
	end

	return v6.chartsTitle
end

return useChartsTitleText
