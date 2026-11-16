local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SharedFlags = require(parent.SharedFlags)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local SduiLoadTimer = require(SduiSharedUtilities.SduiLoadTimer)
local fetchSduiTemplates = require(SduiSharedUtilities.fetchSduiTemplates)

local function makePrewarmTimerKey(experienceDetail: string) -- 1 equivalent call inferred from this helper
	return `{experienceDetail}Prewarm`
end

local v = {
	{
		surfaceKeys = { AppPage.ExperienceDetail },
		timerKey = makePrewarmTimerKey(AppPage.ExperienceDetail), -- inferred equivalent call
		isEnabled = function()
			return SharedFlags.FFlagSduiEdpTemplatePrewarm
		end
	}
}

local function prewarmSurface(p)
	local loadTimer = SduiLoadTimer.createLoadTimer(p.timerKey)
	loadTimer.start("preload")

	local v2 = fetchSduiTemplates({ surfaceKeys = p.surfaceKeys, loadTimer = loadTimer })

	local joined = table.concat(p.surfaceKeys, ",")
	v2:catch(function(p2)
		SduiLogger.reportError(
			SduiErrors.SduiErrorType.FailedToPrewarmTemplates,
			{
				message = SduiParseHelpers.stringifyValue(p2),
				name = joined
			},
			joined
		)
	end)

	return v2
end

local function prewarmAppTemplatesOnLaunch()
	local result = {}

	for _, v2 in v do
		if v2.isEnabled() then
			table.insert(result, prewarmSurface(v2))
		end
	end

	return result
end

return prewarmAppTemplatesOnLaunch
