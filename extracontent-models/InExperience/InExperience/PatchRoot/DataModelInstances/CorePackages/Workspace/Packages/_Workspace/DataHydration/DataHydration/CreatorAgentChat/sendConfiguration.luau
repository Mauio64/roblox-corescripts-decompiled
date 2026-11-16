require(script.Parent.Types.acpSession)
require(script.Parent.Types.model)
local SendConfiguration = {}

function SendConfiguration.capture(tier, p)
	assert(tier == "default" or tier == "advanced", "invalid model tier")
	local clone

	if p ~= nil then
		clone = table.clone(p)
	end

	if clone ~= nil then
		if clone.clientToolConfig ~= nil then
			local clone2 = table.clone(clone.clientToolConfig)
			clone2.tools = table.freeze(table.clone(clone2.tools))
			clone.clientToolConfig = table.freeze(clone2)
		end

		table.freeze(clone)
	end

	return table.freeze({ tier = tier, experiment = clone })
end

function SendConfiguration.sameExperiment(data, data2): boolean
	if data == nil or data2 == nil then
		return data == data2
	end

	if data.specVersion ~= data2.specVersion or data.runId ~= data2.runId then
		return false
	end

	local clientToolConfig = data.clientToolConfig
	local clientToolConfig2 = data2.clientToolConfig

	if clientToolConfig == nil or clientToolConfig2 == nil then
		return clientToolConfig == clientToolConfig2
	end

	if clientToolConfig.mode ~= clientToolConfig2.mode or #clientToolConfig.tools ~= #clientToolConfig2.tools then
		return false
	end

	for k, tool in clientToolConfig.tools do
		if tool ~= clientToolConfig2.tools[k] then
			return false
		end
	end

	return true
end

return SendConfiguration
