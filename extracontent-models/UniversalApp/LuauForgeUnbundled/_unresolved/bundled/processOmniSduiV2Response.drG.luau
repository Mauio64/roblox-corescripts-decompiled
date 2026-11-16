local omniFeedTypes = require("@luauforge/bundled/dqn").OmniFeedTypes
local module = require("@luauforge/bundled/drt")
local sduiErrors = module.SduiErrors
local sduiLogger = module.SduiLogger

local function getSduiV2SortTopicIds(sorts)
	local topicIds = {}

	for k, item in sorts do
		if item.treatmentType == omniFeedTypes.ServerDrivenUiV2 then
			table.insert(topicIds, item.topicId or "nil")
		end
	end

	return topicIds
end

local function filterSduiV2Sorts(sorts)
	local result = {}

	for k, item in sorts do
		if item.treatmentType ~= omniFeedTypes.ServerDrivenUiV2 then
			table.insert(result, item)
		end
	end

	return result
end

local function buildTopicString(list)
	return table.concat(list, " ")
end

local function processOmniSduiV2Response(state, p2, p3)
	local sduiV2SortTopicIds = getSduiV2SortTopicIds(state.sorts)

	if #sduiV2SortTopicIds == 0 then
		return
	end

	local reportError = if p3.reportError then p3.reportError else sduiLogger.reportError

	local v5 = false
	local v6 = sduiErrors.SduiErrorType.ErrorStoringOmniData
	local v7 = nil

	if state.sduiv2 == nil or typeof(state.sduiv2) ~= "table" then
		v6 = sduiErrors.SduiErrorType.NilSduiTreeInResponse
		v5 = true
		v7 = "Has V2 sdui sorts, but no sduiv2 tree in response."
	else
		local success, result = pcall(function()
			p3.seedSduiV2Payload(state.sduiv2, p2)
		end)

		if not success then
			v7 = `Error seeding V2 SDUI store: {result}`
			v5 = true
		end
	end

	if not v5 then
		state.sduiv2 = nil
		return
	end

	reportError(
		v6,
		{
			name = "discovery-api/omni-recommendation/sduiv2",
			message = `{v7} topicIds: {table.concat(sduiV2SortTopicIds, " ")}`
		},
		p2
	)

	state.sorts = filterSduiV2Sorts(state.sorts)
	state.sduiv2 = nil
end

return processOmniSduiV2Response
