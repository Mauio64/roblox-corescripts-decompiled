local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
require(script.Parent.ResolverTypes)

local transformJsonLeafFirst = require(script.Parent.transformJsonLeafFirst)

require(GenericAbuseReporting.BeduiV2.Types)

local FFlagAbuseReportConfigStoreResolver = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportConfigStoreResolver

local function getByPath(p1, s1: string) -- line: 23
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
local function isTruthy(p2) -- line: 54
	return p2 ~= nil and (p2 ~= false and p2 ~= "")
end

local t7 = {
	["$attribute"] = {
		is = function(p3) -- line: 64
			return type(p3) == "table" and (p3["$attribute"] ~= nil and type(p3["$attribute"]) == "string")
		end,
		resolve = function(p4, t1: {[any]: any}) -- line: 67
			-- upvalues: getByPath (copy)
			return (getByPath(t1.attribute, p4["$attribute"]))
		end
	},
	["$resource"] = {
		is = function(p5) -- line: 73
			return type(p5) == "table" and (p5["$resource"] ~= nil and type(p5["$resource"]) == "string")
		end,
		resolve = function(p6, t2: {[any]: any}) -- line: 76
			local v20 = t2.resources[p6["$resource"]]

			if v20 then
				return v20.value
			end

			return nil
		end
	},
	["$context"] = {
		is = function(p7) -- line: 82
			return type(p7) == "table" and (p7["$context"] ~= nil and type(p7["$context"]) == "string")
		end,
		resolve = function(p8, t3: {[any]: any}) -- line: 85
			-- upvalues: getByPath (copy)
			return (getByPath(t3.context, p8["$context"]))
		end
	},
	["$switch"] = {
		is = function(p9) -- line: 90
			return type(p9) == "table" and (p9["$switch"] ~= nil and type(p9["$switch"]) == "table")
		end,
		resolve = function(p10, _: {[any]: any}) -- line: 93
			for _, v in ipairs(p10["$switch"]) do
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
	["$formData"] = {
		is = function(p11) -- line: 108
			return type(p11) == "table" and (p11["$formData"] ~= nil and type(p11["$formData"]) == "string")
		end,
		resolve = function(p12, t5: {[any]: any}) -- line: 111
			-- upvalues: getByPath (copy)
			return (getByPath(t5.formData, p12["$formData"]))
		end
	},
	["$store"] = {
		is = function(p13) -- line: 116
			return type(p13) == "table" and (p13["$store"] ~= nil and type(p13["$store"]) == "string")
		end,
		resolve = function(p14, t6: {[any]: any}) -- line: 119
			-- upvalues: getByPath (copy)
			return (getByPath(t6.store, p14["$store"]))
		end
	}
}

return {
	resolveArConfig = function(p15, t8: {[any]: any}) -- line: 168
		-- upvalues: FFlagAbuseReportConfigStoreResolver (copy), t7 (copy), transformJsonLeafFirst (copy)
		local resources = p15.resources
		local t9 = {
			attribute = p15.attributes,
			resources = {},
			context = if FFlagAbuseReportConfigStoreResolver then {} else t8.context,
			formData = if FFlagAbuseReportConfigStoreResolver then {} else t8.formData,
			store = if not FFlagAbuseReportConfigStoreResolver then {} else t8.store
		}

		local function replacerFn(p16) -- line: 138
			-- upvalues: t7 (copy), t9 (copy), FFlagAbuseReportConfigStoreResolver (copy)
			if type(p16) == "table" then
				if t7["$attribute"].is(p16) then
					return t7["$attribute"].resolve(p16, t9)
				end

				if t7["$resource"].is(p16) then
					return t7["$resource"].resolve(p16, t9)
				end

				if not FFlagAbuseReportConfigStoreResolver and t7["$context"].is(p16) then
					return t7["$context"].resolve(p16, t9)
				end

				if t7["$switch"].is(p16) then
					return t7["$switch"].resolve(p16, t9)
				end

				if not FFlagAbuseReportConfigStoreResolver and t7["$formData"].is(p16) then
					return t7["$formData"].resolve(p16, t9)
				end

				if FFlagAbuseReportConfigStoreResolver and t7["$store"].is(p16) then
					return t7["$store"].resolve(p16, t9)
				end
			end

			return p16
		end

		local v44 = transformJsonLeafFirst(resources, replacerFn)
		local t10 = {
			attribute = p15.attributes,
			resources = v44,
			context = if FFlagAbuseReportConfigStoreResolver then {} else t8.context,
			formData = if FFlagAbuseReportConfigStoreResolver then {} else t8.formData,
			store = if not FFlagAbuseReportConfigStoreResolver then {} else t8.store
		}

		local function replacerFn2(p17) -- line: 138
			-- upvalues: t7 (copy), t10 (copy), FFlagAbuseReportConfigStoreResolver (copy)
			if type(p17) == "table" then
				if t7["$attribute"].is(p17) then
					return t7["$attribute"].resolve(p17, t10)
				end

				if t7["$resource"].is(p17) then
					return t7["$resource"].resolve(p17, t10)
				end

				if not FFlagAbuseReportConfigStoreResolver and t7["$context"].is(p17) then
					return t7["$context"].resolve(p17, t10)
				end

				if t7["$switch"].is(p17) then
					return t7["$switch"].resolve(p17, t10)
				end

				if not FFlagAbuseReportConfigStoreResolver and t7["$formData"].is(p17) then
					return t7["$formData"].resolve(p17, t10)
				end

				if FFlagAbuseReportConfigStoreResolver and t7["$store"].is(p17) then
					return t7["$store"].resolve(p17, t10)
				end
			end

			return p17
		end

		return (transformJsonLeafFirst(p15, replacerFn2))
	end,
	resolveConfig = function(p18, t11: {[any]: any}) -- line: 128
		-- upvalues: t7 (copy), FFlagAbuseReportConfigStoreResolver (copy), transformJsonLeafFirst (copy)
		local function replacerFn(p19) -- line: 138
			-- upvalues: t7 (copy), t11 (copy), FFlagAbuseReportConfigStoreResolver (copy)
			if type(p19) == "table" then
				if t7["$attribute"].is(p19) then
					return t7["$attribute"].resolve(p19, t11)
				end

				if t7["$resource"].is(p19) then
					return t7["$resource"].resolve(p19, t11)
				end

				if not FFlagAbuseReportConfigStoreResolver and t7["$context"].is(p19) then
					return t7["$context"].resolve(p19, t11)
				end

				if t7["$switch"].is(p19) then
					return t7["$switch"].resolve(p19, t11)
				end

				if not FFlagAbuseReportConfigStoreResolver and t7["$formData"].is(p19) then
					return t7["$formData"].resolve(p19, t11)
				end

				if FFlagAbuseReportConfigStoreResolver and t7["$store"].is(p19) then
					return t7["$store"].resolve(p19, t11)
				end
			end

			return p19
		end

		return (transformJsonLeafFirst(p18, replacerFn))
	end
}
