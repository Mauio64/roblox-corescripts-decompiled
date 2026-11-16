require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Resolver/ResolverTypes")
local transformJsonLeafFirst = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Resolver/transformJsonLeafFirst")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Types")

local function getByPath(p2, value)
	local v5 = string.split(value, ".")

	for i, v6 in ipairs(v5) do
		if type(p2) ~= "table" or p2 == nil then
			return nil
		end

		p2 = p2[v6]

		if p2 == nil then
			return nil
		end
	end

	return p2
end

local function isTruthy(p2): boolean
	return p2 ~= nil and p2 ~= false and p2 ~= ""
end

local v5 = {
	["$attribute"] = {
		is = function(p2): boolean
			return type(p2) == "table" and p2["$attribute"] ~= nil and type(p2["$attribute"]) == "string"
		end,
		resolve = function(p2, p3)
			return getByPath(p3.attribute, p2["$attribute"])
		end
	},
	["$resource"] = {
		is = function(p2): boolean
			return type(p2) == "table" and p2["$resource"] ~= nil and type(p2["$resource"]) == "string"
		end,
		resolve = function(p2, p3)
			local resource = p3.resources[p2["$resource"]]

			if resource then
				return resource.value
			end

			return nil
		end
	},
	["$switch"] = {
		is = function(p2): boolean
			return type(p2) == "table" and p2["$switch"] ~= nil and type(p2["$switch"]) == "table"
		end,
		resolve = function(p2, p3)
			for i, v6 in ipairs(p2["$switch"]) do
				if type(v6) == "string" then
					return v6
				end

				if not (type(v6) == "table" and v6.condition) then
					continue
				end

				local condition = v6.condition
				local v7 = not (condition == nil or condition == false) and condition ~= ""

				if v7 then
					return v6.value
				end
			end

			return nil
		end
	},
	["$store"] = {
		is = function(p2): boolean
			return type(p2) == "table" and p2["$store"] ~= nil and type(p2["$store"]) == "string"
		end,
		resolve = function(p2, p3)
			return getByPath(p3.store, p2["$store"])
		end
	}
}

return {
	resolveArConfig = function(p2, p3)
		local resources = p2.resources
		local v6 = { attribute = p2.attributes, resources = {}, store = p3.store }

		local function replacerFn(p4)
			if type(p4) ~= "table" then
				return p4
			end

			if v5["$attribute"].is(p4) then
				return v5["$attribute"].resolve(p4, v6)
			end

			if v5["$resource"].is(p4) then
				return v5["$resource"].resolve(p4, v6)
			end

			if v5["$switch"].is(p4) then
				return v5["$switch"].resolve(p4, v6)
			end

			if v5["$store"].is(p4) then
				return v5["$store"].resolve(p4, v6)
			end

			return p4
		end

		local v7 = transformJsonLeafFirst(resources, replacerFn)

		local v8 = { attribute = p2.attributes, resources = v7, store = p3.store }

		local function replacerFn2(p4)
			if type(p4) ~= "table" then
				return p4
			end

			if v5["$attribute"].is(p4) then
				return v5["$attribute"].resolve(p4, v8)
			end

			if v5["$resource"].is(p4) then
				return v5["$resource"].resolve(p4, v8)
			end

			if v5["$switch"].is(p4) then
				return v5["$switch"].resolve(p4, v8)
			end

			if v5["$store"].is(p4) then
				return v5["$store"].resolve(p4, v8)
			end

			return p4
		end

		return (transformJsonLeafFirst(p2, replacerFn2))
	end,
	resolveConfig = function(p2, p3)
		local function replacerFn(p4)
			if type(p4) ~= "table" then
				return p4
			end

			if v5["$attribute"].is(p4) then
				return v5["$attribute"].resolve(p4, p3)
			end

			if v5["$resource"].is(p4) then
				return v5["$resource"].resolve(p4, p3)
			end

			if v5["$switch"].is(p4) then
				return v5["$switch"].resolve(p4, p3)
			end

			if v5["$store"].is(p4) then
				return v5["$store"].resolve(p4, p3)
			end

			return p4
		end

		return (transformJsonLeafFirst(p2, replacerFn))
	end
}
