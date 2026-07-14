local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
require(script.Parent.ResolverTypes)

local transformJsonLeafFirst = require(script.Parent.transformJsonLeafFirst)

require(GenericAbuseReporting.BeduiV2.Types)

local function getByPath(p1, s1: string) -- line: 18
	local parts = string.split(s1, ".")

	for _, v in ipairs(parts) do
		if type(p1) ~= "table" or p1 == nil then
			return nil
		end

		p1 = p1[v]

		if p1 == nil then
			return nil
		end
	end

	return p1
end
local function isTruthy(p2) -- line: 47
	return p2 ~= nil and (p2 ~= false and p2 ~= "")
end

local t5 = {
	["$attribute"] = {
		is = function(p3) -- line: 57
			return type(p3) == "table" and (p3["$attribute"] ~= nil and type(p3["$attribute"]) == "string")
		end,
		resolve = function(p4, t1: {[any]: any}) -- line: 60
			-- upvalues: getByPath (copy)
			return (getByPath(t1.attribute, p4["$attribute"]))
		end
	},
	["$resource"] = {
		is = function(p5) -- line: 66
			return type(p5) == "table" and (p5["$resource"] ~= nil and type(p5["$resource"]) == "string")
		end,
		resolve = function(p6, t2: {[any]: any}) -- line: 69
			local v18 = t2.resources[p6["$resource"]]

			if v18 then
				return v18.value
			end

			return nil
		end
	},
	["$switch"] = {
		is = function(p7) -- line: 75
			return type(p7) == "table" and (p7["$switch"] ~= nil and type(p7["$switch"]) == "table")
		end,
		resolve = function(p8, _: {[any]: any}) -- line: 78
			for _, v in ipairs(p8["$switch"]) do
				if type(v) == "string" then
					return v
				end

				if type(v) == "table" and v.condition then
					local condition = v.condition

					if not (condition ~= nil and (condition ~= false and condition ~= "")) then
						continue
					end

					return v.value
				end
			end

			return nil
		end
	},
	["$store"] = {
		is = function(p9) -- line: 93
			return type(p9) == "table" and (p9["$store"] ~= nil and type(p9["$store"]) == "string")
		end,
		resolve = function(p10, t4: {[any]: any}) -- line: 96
			-- upvalues: getByPath (copy)
			return (getByPath(t4.store, p10["$store"]))
		end
	}
}

return {
	resolveArConfig = function(p11, t6: {[any]: any}) -- line: 139
		-- upvalues: t5 (copy), transformJsonLeafFirst (copy)
		local resources = p11.resources
		local t7 = {
			attribute = p11.attributes,
			resources = {},
			store = t6.store
		}

		local function replacerFn(p12) -- line: 113
			-- upvalues: t5 (copy), t7 (copy)
			if type(p12) == "table" then
				if t5["$attribute"].is(p12) then
					return t5["$attribute"].resolve(p12, t7)
				end

				if t5["$resource"].is(p12) then
					return t5["$resource"].resolve(p12, t7)
				end

				if t5["$switch"].is(p12) then
					return t5["$switch"].resolve(p12, t7)
				end

				if t5["$store"].is(p12) then
					return t5["$store"].resolve(p12, t7)
				end
			end

			return p12
		end

		local v36 = transformJsonLeafFirst(resources, replacerFn)
		local t8 = {
			attribute = p11.attributes,
			resources = v36,
			store = t6.store
		}

		local function replacerFn2(p13) -- line: 113
			-- upvalues: t5 (copy), t8 (copy)
			if type(p13) == "table" then
				if t5["$attribute"].is(p13) then
					return t5["$attribute"].resolve(p13, t8)
				end

				if t5["$resource"].is(p13) then
					return t5["$resource"].resolve(p13, t8)
				end

				if t5["$switch"].is(p13) then
					return t5["$switch"].resolve(p13, t8)
				end

				if t5["$store"].is(p13) then
					return t5["$store"].resolve(p13, t8)
				end
			end

			return p13
		end

		return (transformJsonLeafFirst(p11, replacerFn2))
	end,
	resolveConfig = function(p14, t9: {[any]: any}) -- line: 105
		-- upvalues: t5 (copy), transformJsonLeafFirst (copy)
		local function replacerFn(p15) -- line: 113
			-- upvalues: t5 (copy), t9 (copy)
			if type(p15) == "table" then
				if t5["$attribute"].is(p15) then
					return t5["$attribute"].resolve(p15, t9)
				end

				if t5["$resource"].is(p15) then
					return t5["$resource"].resolve(p15, t9)
				end

				if t5["$switch"].is(p15) then
					return t5["$switch"].resolve(p15, t9)
				end

				if t5["$store"].is(p15) then
					return t5["$store"].resolve(p15, t9)
				end
			end

			return p15
		end

		return (transformJsonLeafFirst(p14, replacerFn))
	end
}
