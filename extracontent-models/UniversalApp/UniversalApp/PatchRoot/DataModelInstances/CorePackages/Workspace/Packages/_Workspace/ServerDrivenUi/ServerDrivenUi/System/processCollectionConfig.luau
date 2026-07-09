local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiErrors = SduiCoreSystem.SduiErrors
local t1 = {}

for match in game:DefineFastString("SduiEagerProcessCollectionIds", "400000000"):gmatch("(%w+)") do
	t1[match] = true
end

local function processCollectionConfig(p1, s1: string, p2) -- line: 21
	-- upvalues: t1 (copy), SduiBuilder (copy), SduiErrors (copy)
	if not s1 or not t1[tostring(s1)] then
		return p1
	end

	local v11 = `{ p2.appPage }-{ s1 }`
	local ok, result = pcall(function() -- line: 30
		-- upvalues: SduiBuilder (copy), p1 (copy), p2 (copy), v11 (copy)
		local v15, v16 = SduiBuilder.tryCreateEagerProcessedComponentConfig(p1, p2, v11, {}, true)

		if v15 then
			return v16
		end

		error(v16)
	end)

	if not ok or not result then
		local v14 = typeof(result) ~= "string" and "" or result

		p2.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToEagerlyProcess, {
			name = v11,
			message = `Failed to process collection config { v14 }`
		}, p2.appPage)

		return p1
	end

	return result
end

return processCollectionConfig
