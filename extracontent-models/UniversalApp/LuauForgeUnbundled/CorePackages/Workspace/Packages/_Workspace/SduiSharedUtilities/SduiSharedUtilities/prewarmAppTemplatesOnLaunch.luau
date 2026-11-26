local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/RobloxAppEnums").AppPage
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem")
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiLogger = SduiCoreSystem.SduiLogger
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local SduiLoadTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiLoadTimer")
local fetchSduiTemplates = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/fetchSduiTemplates")

local function makePrewarmTimerKey(p2)
	return `{p2}Prewarm`
end
local v5 = {
	{
		surfaceKeys = { appPage.ExperienceDetail },
		timerKey = `{appPage.ExperienceDetail}Prewarm`,
		isEnabled = function()
			return SharedFlags.FFlagSduiEdpTemplatePrewarm
		end
	}
}

local function prewarmSurface(p2)
	local loadTimer = SduiLoadTimer.createLoadTimer(p2.timerKey)
	loadTimer.start("preload")

	local v6 = fetchSduiTemplates({ surfaceKeys = p2.surfaceKeys, loadTimer = loadTimer })

	local joined = table.concat(p2.surfaceKeys, ",")
	v6:catch(function(p3)
		sduiLogger.reportError(
			sduiErrors.SduiErrorType.FailedToPrewarmTemplates,
			{
				message = sduiParseHelpers.stringifyValue(p3),
				name = joined
			},
			joined
		)
	end)

	return v6
end

local function prewarmAppTemplatesOnLaunch()
	local result = {}

	for k, v6 in v5 do
		if v6.isEnabled() then
			table.insert(result, prewarmSurface(v6))
		end
	end

	return result
end

return prewarmAppTemplatesOnLaunch
