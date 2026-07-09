local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local OmniFeedTypes = require(Parent.DiscoveryTypes).OmniFeedTypes
local ServerDrivenUi = require(Parent.ServerDrivenUi)
local SduiErrors = ServerDrivenUi.SduiErrors
local SduiLogger = ServerDrivenUi.SduiLogger

local function getSduiV2SortTopicIds(t1: {[any]: any}) -- line: 22
	-- upvalues: OmniFeedTypes (copy)
	local t2 = {}

	for _, v13 in t1 do
		if v13.treatmentType == OmniFeedTypes.ServerDrivenUiV2 then
			table.insert(t2, v13.topicId or "nil")
		end
	end

	return t2
end
local function filterSduiV2Sorts(t3: {[any]: any}) -- line: 32
	-- upvalues: OmniFeedTypes (copy)
	local t4 = {}

	for _, v17 in t3 do
		if v17.treatmentType ~= OmniFeedTypes.ServerDrivenUiV2 then
			table.insert(t4, v17)
		end
	end

	return t4
end
local function buildTopicString(t5: {[any]: any}) -- line: 44
	return table.concat(t5, " ")
end
local function processOmniSduiV2Response(p1, s1: string, t6: {[any]: any}) -- line: 48
	-- upvalues: getSduiV2SortTopicIds (copy), SduiLogger (copy), SduiErrors (copy), filterSduiV2Sorts (copy)
	local v22 = getSduiV2SortTopicIds(p1.sorts)

	if #v22 == 0 then
		return
	end

	local v23 = if not t6.reportError then SduiLogger.reportError else t6.reportError
	local v24 = false
	local ErrorStoringOmniData = SduiErrors.SduiErrorType.ErrorStoringOmniData
	local v26 = nil

	if p1.sduiv2 ~= nil and typeof(p1.sduiv2) == "table" then
		local ok, result = pcall(function() -- line: 61
			-- upvalues: t6 (copy), p1 (copy), s1 (copy)
			t6.seedSduiV2Payload(p1.sduiv2, s1)
		end)

		if not ok then
			v24 = true
			v26 = `Error seeding V2 SDUI store: { result }`
		end
	else
		v24 = true
		ErrorStoringOmniData = SduiErrors.SduiErrorType.NilSduiTreeInResponse
		v26 = "Has V2 sdui sorts, but no sduiv2 tree in response."
	end

	if not v24 then
		p1.sduiv2 = nil

		return
	end

	v23(ErrorStoringOmniData, {
		name = "discovery-api/omni-recommendation/sduiv2",
		message = `{ v26 } topicIds: { table.concat(v22, " ") }`
	}, s1)
	p1.sorts = filterSduiV2Sorts(p1.sorts)
	p1.sduiv2 = nil
end

return processOmniSduiV2Response
