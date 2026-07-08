local ParentParent = script.Parent.Parent
local Cryo = require(ParentParent.Cryo)
local Regex = require(script.Parent.Regex)
local RegExp = require(ParentParent.RegExp)
local StringUtilities = require(ParentParent.StringUtilities)
local StringSplit = StringUtilities.StringSplit
local StringTrim = StringUtilities.StringTrim
local ParseQuery = StringUtilities.ParseQuery

require(script.Parent.Types)

local function filterParams(t1: {[any]: any}, b1: boolean) -- line: 19
	-- upvalues: Cryo (copy)
	return Cryo.List.filter(t1, function(p1) -- line: 20
		-- upvalues: b1 (copy)
		return p1.optional == b1 or not b1 and p1.optional == nil
	end)
end
local function requiredParams(t2: {[any]: any}) -- line: 25
	-- upvalues: filterParams (copy)
	return filterParams(t2, false)
end
local function optionalParams(t3: {[any]: any}) -- line: 29
	-- upvalues: filterParams (copy)
	return filterParams(t3, true)
end
local function mapValidToArgName(t4: {[any]: any}) -- line: 33
	-- upvalues: Regex (copy), RegExp (copy)
	return function(p2) -- line: 34
		-- upvalues: Regex (copy), t4 (copy), RegExp (copy)
		local v55 = Regex.matchWhole(Regex.oneOrMore(p2.pattern))
		local v56 = t4[p2.name]

		if v56 ~= nil and RegExp(v55):exec(v56) then
			return p2.name
		end

		return nil
	end
end
local function validateParams(t5: {[any]: any}?, t6: {[any]: any}) -- line: 44
	-- upvalues: Cryo (copy), Regex (copy), RegExp (copy)
	local v23 = t5 or {}
	local v24 = false
	local v25 = Cryo.List.filter(t6, function(p3) -- line: 20
		-- upvalues: v24 (copy)
		return p3.optional == v24 or not v24 and p3.optional == nil
	end)

	local function v26(p4) -- line: 34
		-- upvalues: Regex (copy), v23 (copy), RegExp (copy)
		local v59 = Regex.matchWhole(Regex.oneOrMore(p4.pattern))
		local v60 = v23[p4.name]

		if v60 ~= nil and RegExp(v59):exec(v60) then
			return p4.name
		end

		return nil
	end

	local v27 = Cryo.List.filterMap(v25, v26)

	if #v27 ~= #v25 then
		return false, {}
	end

	local v28 = true
	local v29 = Cryo.List.filter(t6, function(p5) -- line: 20
		-- upvalues: v28 (copy)
		return p5.optional == v28 or not v28 and p5.optional == nil
	end)
	local v30 = Cryo.List.filterMap(v29, v26)
	local v31 = Cryo.List.join(v27, v30)
	local v32 = Cryo.List.toSet(v31)

	return true, (Cryo.Dictionary.filter(v23, function(_, p7) -- line: 59
		-- upvalues: v32 (copy)
		return v32[p7] ~= nil
	end))
end
local function validatePathParams(t7: {[any]: any}, t8: {[any]: any}) -- line: 65
	-- upvalues: Cryo (copy), validateParams (copy)
	local v35 = false

	if #t7 < #Cryo.List.filter(t8, function(p8) -- line: 20
		-- upvalues: v35 (copy)
		return p8.optional == v35 or not v35 and p8.optional == nil
	end) then
		return false, {}
	end

	local v36 = Cryo.Dictionary.map(t8, function(p9, p10) -- line: 73
		-- upvalues: t7 (copy)
		return t7[p10], p9.name
	end)

	return validateParams(v36, t8)
end
local function validateUrlParams(p11, p12) -- line: 79
	-- upvalues: StringTrim (copy), StringSplit (copy), ParseQuery (copy), Cryo (copy), validatePathParams (copy), validateParams (copy)
	local v39 = not p11.path and "" or StringTrim(p11.path, "/")
	local v40 = if v39 == "" then {} else StringSplit(v39, "/")
	local v41 = ParseQuery(p11.query)
	local v42 = Cryo.Dictionary.map(v41, function(p13) -- line: 84
		if #p13 == 1 then
			return p13[1]
		end

		return p13
	end)
	local v43, v44 = validatePathParams(v40, p12.pathParams or {})

	if not v43 then
		return false, {}
	end

	local v45, v46 = validateParams(v42, p12.queryParams or {})

	if not v45 then
		return false, {}
	end

	return true, Cryo.Dictionary.union(v44, v46)
end

return {
	validateUrlMatch = function(p14, p15) -- line: 101
		-- upvalues: RegExp (copy), validateUrlParams (copy)
		for v49, v50 in p15 do
			if not RegExp(v49, "i"):test(p14.matchedPath) then
				continue
			end

			local v51, v52 = validateUrlParams(p14.url, v50)

			if v51 then
				return v51, v50.paramCallback(v52)
			end
		end

		return false, nil
	end,
	validateUrlParams = validateUrlParams
}
