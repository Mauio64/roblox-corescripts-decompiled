local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiErrors = SduiCoreSystem.SduiErrors

local set = {}

for k in game:DefineFastString("SduiEagerProcessCollectionIds", "400000000"):gmatch("(%w+)") do
	set[k] = true
end

local function processCollectionConfig(p, p2: string, p3)
	if not (p2 and set[tostring(p2)]) then
		return p
	end

	local formatted = `{p3.appPage}-{p2}`
	local success, result = pcall(function()
		local v, v2 = SduiBuilder.tryCreateEagerProcessedComponentConfig(p, p3, formatted, {}, true)

		if v then
			return v2
		end

		error(v2)
	end)

	if success and result then
		return result
	end

	local v = typeof(result) ~= "string" and "" or result
	p3.dependencies.logger.reportError(
		SduiErrors.SduiErrorType.FailedToEagerlyProcess,
		{
			name = formatted,
			message = `Failed to process collection config {v}`
		},
		p3.appPage
	)
	return p
end

return processCollectionConfig
