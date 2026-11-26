local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiBuilder = SduiCoreSystem.SduiBuilder
local sduiErrors = SduiCoreSystem.SduiErrors

local set = {}

for k in game:DefineFastString("SduiEagerProcessCollectionIds", "400000000"):gmatch("(%w+)") do
	set[k] = true
end

local function processCollectionConfig(p2, p3, p4)
	if not (p3 and set[tostring(p3)]) then
		return p2
	end

	local formatted = `{p4.appPage}-{p3}`
	local success, result = pcall(function()
		local v5, v6 = sduiBuilder.tryCreateEagerProcessedComponentConfig(p2, p4, formatted, {}, true)

		if v5 then
			return v6
		end

		error(v6)
	end)

	if success and result then
		return result
	end

	local v5 = typeof(result) ~= "string" and "" or result
	p4.dependencies.logger.reportError(
		sduiErrors.SduiErrorType.FailedToEagerlyProcess,
		{
			name = formatted,
			message = `Failed to process collection config {v5}`
		},
		p4.appPage
	)
	return p2
end

return processCollectionConfig
