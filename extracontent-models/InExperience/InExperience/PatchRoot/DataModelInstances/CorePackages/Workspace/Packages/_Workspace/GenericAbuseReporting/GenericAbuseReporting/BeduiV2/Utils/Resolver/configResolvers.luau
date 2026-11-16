local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
require(script.Parent.ResolverTypes)
local transformJsonLeafFirst = require(script.Parent.transformJsonLeafFirst)
require(GenericAbuseReporting.BeduiV2.Types)

local function getByPath(p, value: string)
	local v = string.split(value, ".")

	for _, v2 in ipairs(v) do
		if type(p) ~= "table" or p == nil then
			return nil
		end

		p = p[v2]

		if p == nil then
			return nil
		end
	end

	return p
end

local function isTruthy(condition): boolean -- 1 equivalent call inferred from this helper
	return condition ~= nil and condition ~= false and condition ~= ""
end

local v = {
	["$attribute"] = {
		is = function(p): boolean
			return type(p) == "table" and p["$attribute"] ~= nil and type(p["$attribute"]) == "string"
		end,
		resolve = function(p, p2)
			return getByPath(p2.attribute, p["$attribute"])
		end
	},
	["$resource"] = {
		is = function(p): boolean
			return type(p) == "table" and p["$resource"] ~= nil and type(p["$resource"]) == "string"
		end,
		resolve = function(p, p2)
			local resource = p2.resources[p["$resource"]]
			return if resource then resource.value else nil
		end
	},
	["$switch"] = {
		is = function(p): boolean
			return type(p) == "table" and p["$switch"] ~= nil and type(p["$switch"]) == "table"
		end,
		resolve = function(p, _)
			for _, v in ipairs(p["$switch"]) do
				if type(v) == "string" then
					return v
				end

				if type(v) == "table" and v.condition and isTruthy(v.condition) then -- inferred equivalent call
					return v.value
				end
			end

			return nil
		end
	},
	["$store"] = {
		is = function(p): boolean
			return type(p) == "table" and p["$store"] ~= nil and type(p["$store"]) == "string"
		end,
		resolve = function(p, p2)
			return getByPath(p2.store, p["$store"])
		end
	}
}

local function resolveConfig(p, p2) -- 2 equivalent calls inferred from this helper
	local function replacerFn(p3)
		if type(p3) ~= "table" then
			return p3
		end

		if v["$attribute"].is(p3) then
			return v["$attribute"].resolve(p3, p2)
		end

		if v["$resource"].is(p3) then
			return v["$resource"].resolve(p3, p2)
		end

		if v["$switch"].is(p3) then
			return v["$switch"].resolve(p3, p2)
		end

		if v["$store"].is(p3) then
			return v["$store"].resolve(p3, p2)
		end

		return p3
	end

	return (transformJsonLeafFirst(p, replacerFn))
end

return {
	resolveArConfig = function(p, p2)
		local config = resolveConfig(p.resources, { -- inferred equivalent call
			attribute = p.attributes,
			resources = {},
			store = p2.store
		})

		return resolveConfig(p, { attribute = p.attributes, resources = config, store = p2.store }) -- inferred equivalent call
	end,
	resolveConfig = resolveConfig
}
