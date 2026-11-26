local module = require("@luauforge/bundled/dUj")

local sduiErrorType = require("@luauforge/bundled/dTq").SduiErrors.SduiErrorType

local ASSET_TYPE_NAME_TO_ID_STRING = module.Constants.ASSET_TYPE_NAME_TO_ID_STRING

local v5 = {}
local v6 = { Asset = true, Bundle = true }

for k, v7 in Enum.BundleType:GetEnumItems() do
	v5[v7.Name] = tostring(v7.Value)
end

for k, v7 in module.Constants.BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND do
	v5[v7] = k
end

return {
	readOptionalId = function(value)
		if typeof(value) == "number" then
			return (tostring(value))
		end

		if typeof(value) == "string" and value ~= "" then
			return value
		end

		return nil
	end,
	getItemSubTypeId = function(p2, p3)
		if tonumber(p2) ~= nil then
			return p2
		end

		if p3 == "Bundle" then
			return v5[p2]
		end

		return ASSET_TYPE_NAME_TO_ID_STRING[p2]
	end,
	getUnifiedEventSubType = function(value, p2)
		if typeof(value) == "number" then
			value = tostring(value)
		elseif typeof(value) ~= "string" or value == "" then
			value = nil
		end

		if value == nil then
			value = nil
		elseif tonumber(value) == nil then
			value = if p2 == "Bundle" then v5[value] else ASSET_TYPE_NAME_TO_ID_STRING[value]
		end

		if value == nil then
			return nil
		end

		return (tonumber(value))
	end,
	readActionParams = function(p2, p3, p4)
		local actionParams = if p3 then p3.actionParams else nil

		if actionParams ~= nil then
			return actionParams
		end

		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = p2, message = "Missing actionParams", propName = nil },
			p4.appPage
		)

		return nil
	end,
	readRequiredId = function(p2, p3, p4, p5)
		local requiredId = p3[p4]

		if typeof(requiredId) == "number" then
			requiredId = tostring(requiredId)
		elseif typeof(requiredId) ~= "string" or requiredId == "" then
			requiredId = nil
		end

		if requiredId == nil then
			local formatted = `Missing actionParam: {p4}`
			p5.dependencies.logger.reportError(
				sduiErrorType.InvalidActionParams,
				{ name = p2, message = formatted, propName = p4 },
				p5.appPage
			)
		end

		return requiredId
	end,
	readCatalogItem = function(p2, p3, p4)
		local itemId = p3.itemId

		if typeof(itemId) == "number" then
			itemId = tostring(itemId)
		elseif typeof(itemId) ~= "string" or itemId == "" then
			itemId = nil
		end

		if itemId == nil then
			p4.dependencies.logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = p2,
					message = "Missing actionParam: itemId",
					propName = "itemId"
				},
				p4.appPage
			)
		end

		if itemId == nil then
			return nil
		end

		local itemType = p3.itemType

		if typeof(itemType) == "string" and v6[itemType] then
			return { itemId = itemId, itemType = itemType }
		end

		local formatted = `Invalid or missing itemType: {itemType}`
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = p2, message = formatted, propName = "itemType" },
			p4.appPage
		)

		return nil
	end,
	reportInvalidParams = function(p2, p3, p4, p5)
		p3.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = p2, message = p4, propName = p5 },
			p3.appPage
		)
	end,
	reportFailedToExecute = function(p2, p3, p4)
		p3.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{ name = p2, message = p4 },
			p3.appPage
		)
	end
}
