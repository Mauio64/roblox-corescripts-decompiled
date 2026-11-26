local module = require("@luauforge/bundled/dTk")
require("@luauforge/bundled/dTq")
local module2 = require("@luauforge/bundled/dTw")

local fFlagAXUnifiedEventStrictPayloads = require("@luauforge/bundled/dTp").FFlagAXUnifiedEventStrictPayloads

local useUnifiedEventTagging = module2.useUnifiedEventTagging
local unifiedEventLogConstants = module2.UnifiedEventLogConstants

local function addFields(p2, items)
	if items == nil then
		return
	end

	for k, item in items do
		p2[k] = item
	end
end

local function isStampableAnalyticsKey(value): boolean
	if type(value) ~= "string" then
		return false
	end

	local v5 = unifiedEventLogConstants.ATTRIBUTE_PREFIX .. value
	return #v5 <= 100 and string.match(v5, "^[A-Za-z0-9_]+$") ~= nil
end

local function keepStampableFields(items)
	local result = {}

	for k, item in items do
		local v5

		if type(k) == "string" then
			local v6 = unifiedEventLogConstants.ATTRIBUTE_PREFIX .. k
			v5 = #v6 <= 100 and string.match(v6, "^[A-Za-z0-9_]+$") ~= nil
		else
			v5 = false
		end

		if v5 then
			result[k] = item
		end
	end

	return result
end

local function useSduiUnifiedEventTagging(p2, data, callback, items, p3, items2, callback2)
	local v5 = {}
	local v6

	if data ~= nil then
		v6 = data.getAncestorAnalyticsDataSnapshot()

		if v6 ~= nil then
			for k, v8 in v6 do
				v5[k] = v8
			end
		end

		local collectionData = data.getCollectionData()

		if collectionData ~= nil then
			for k, v9 in collectionData do
				v5[k] = v9
			end
		end

		local analyticsDataSnapshot = data.getAnalyticsDataSnapshot()

		if analyticsDataSnapshot ~= nil then
			for k, v10 in analyticsDataSnapshot do
				v5[k] = v10
			end
		end
	end

	if items ~= nil then
		for k, item in items do
			v5[k] = item
		end
	end

	if items2 ~= nil then
		for k, item in items2 do
			local v8 = if v6 ~= nil then v6[item] else nil
			v5[item] = v8
		end
	end

	local v8 = keepStampableFields(v5)

	local v9 = callback == nil or callback(v8)

	if fFlagAXUnifiedEventStrictPayloads and callback2 ~= nil and v9 then
		v8 = callback2(v8)
	end

	useUnifiedEventTagging({ ref = p2, payload = v8, isReady = v9, options = p3 })

	local ref = module.useRef({})
	module.useEffect(function()
		if not v9 then
			return
		end

		local current = p2.current

		if current ~= nil then
			for k in ref.current do
				if v8[k] == nil then
					current:SetAttribute(unifiedEventLogConstants.ATTRIBUTE_PREFIX .. k, nil)
				end
			end
		end

		local set = {}

		for k in v8 do
			set[k] = true
		end

		ref.current = set
	end, { v8, v9 })
end

return useSduiUnifiedEventTagging
