local ParentParent = script.Parent.Parent

require(ParentParent.Shared)

local invariant = require(ParentParent.Shared).invariant
local ReactSymbols = require(ParentParent.Shared).ReactSymbols
local getIteratorFn = ReactSymbols.getIteratorFn
local REACT_ELEMENT_TYPE = ReactSymbols.REACT_ELEMENT_TYPE
local REACT_PORTAL_TYPE = ReactSymbols.REACT_PORTAL_TYPE
local Array = require(ParentParent.LuauPolyfill).Array
local ReactElement = require(script.Parent.ReactElement)
local isValidElement = ReactElement.isValidElement
local cloneAndReplaceKey = ReactElement.cloneAndReplaceKey

local function escape(s1: string) -- line: 45
	local v20 = string.gsub(s1, "=", "=0")

	return "$" .. string.gsub(v20, ":", "=2")
end
local function escapeUserProvidedKey(s2: string) -- line: 60
	return s2
end
local function getElementKey(p1, n1: number) -- line: 73
	if typeof(p1) == "table" and (p1 ~= nil and p1.key ~= nil) then
		local str = tostring(p1.key)
		local v25 = string.gsub(str, "=", "=0")

		return "$" .. string.gsub(v25, ":", "=2")
	end

	return (tostring(n1))
end
local function mapIntoArray(p2, p3, s3: string, s4: string, p4: ((...any) -> ...any)) -- line: 86
	-- upvalues: REACT_ELEMENT_TYPE (copy), REACT_PORTAL_TYPE (copy), Array (copy), mapIntoArray (copy), isValidElement (copy), cloneAndReplaceKey (copy), getIteratorFn (copy)
	local v31 = typeof(p2)

	if v31 == "nil" or (v31 == "boolean" or v31 == "userdata") then
		p2 = nil
	end

	local v32 = false

	if p2 == nil then
		v32 = true
	elseif v31 == "string" or v31 == "number" then
		v32 = true
	elseif v31 == "table" then
		local v33 = p2["$$typeof"]

		if v33 == REACT_ELEMENT_TYPE or v33 == REACT_PORTAL_TYPE then
			v32 = true
		end
	end

	if v32 then
		local v34 = p4(p2)

		if s4 == "" then
			local v37

			if typeof(p2) == "table" and p2 ~= nil and p2.key ~= nil then
				local str = tostring(p2.key)
				local v36 = string.gsub(str, "=", "=0")

				v37 = "$" .. string.gsub(v36, ":", "=2")
			else
				v37 = tostring(1)
			end

			s4 = "." .. v37
		end

		if Array.isArray(v34) then
			local s5 = ""

			if s4 ~= nil then
				s5 = s4 .. "/"
			end

			mapIntoArray(v34, p3, s5, "", function(p5) -- line: 135
				return p5
			end)
		elseif v34 ~= nil then
			if isValidElement(v34) then
				local key = v34.key

				v34 = cloneAndReplaceKey(v34, s3 .. ((not key or not not p2 and key == p2.key) and "" or tostring(key) .. "/") .. s4)
			end

			table.insert(p3, v34)
		end

		return 1
	end

	local n2 = 0
	local v41 = if s4 ~= "" then s4 .. ":" else "."

	if Array.isArray(p2) then
		for i = 1, #p2 do
			local v43 = p2[i]
			local v46

			if typeof(v43) == "table" and v43 ~= nil and v43.key ~= nil then
				local str = tostring(v43.key)
				local v45 = string.gsub(str, "=", "=0")

				v46 = "$" .. string.gsub(v45, ":", "=2")
			else
				v46 = tostring(i)
			end

			local v47 = v41 .. v46

			n2 += mapIntoArray(v43, p3, s3, v47, p4)
		end

		return n2
	end

	local v48 = getIteratorFn(p2)

	if typeof(v48) == "function" then
		local v49 = v48(p2)
		local n3 = 1
		local v51 = v49.next()

		while not v51.done do
			local value = v51.value
			local v55

			if typeof(value) == "table" and value ~= nil and value.key ~= nil then
				local str = tostring(value.key)
				local v54 = string.gsub(str, "=", "=0")

				v55 = "$" .. string.gsub(v54, ":", "=2")
			else
				v55 = tostring(n3)
			end

			local v56 = v41 .. v55

			n3 += 1
			n2 += mapIntoArray(value, p3, s3, v56, p4)
			v51 = v49.next()
		end
	end

	return n2
end
local function mapChildren(p6, p7: ((...any) -> ...any), _) -- line: 253
	-- upvalues: mapIntoArray (copy)
	if p6 == nil then
		return nil
	end

	local t1 = {}
	local n4 = 1

	mapIntoArray(p6, t1, "", "", function(p9) -- line: 263
		-- upvalues: p7 (copy), n4 (ref)
		local v71 = p7(p9, n4)

		n4 += 1

		return v71
	end)

	return t1
end
local function countChildren(p10) -- line: 281
	-- upvalues: mapChildren (copy)
	local n5 = 0

	mapChildren(p10, function() -- line: 283
		-- upvalues: n5 (ref)
		n5 += 1
	end)

	return n5
end
local function forEachChildren(p11, p12: ((...any) -> ...any), p13) -- line: 305
	-- upvalues: mapChildren (copy)
	mapChildren(p11, function(...) -- line: 310
		-- upvalues: p12 (copy)
		p12(...)
	end, p13)
end
local function onlyChild(p14) -- line: 345
	-- upvalues: invariant (copy), isValidElement (copy)
	invariant(isValidElement(p14), "React.Children.only expected to receive a single React element child.")

	return p14
end

return {
	forEach = forEachChildren,
	map = mapChildren,
	count = countChildren,
	only = onlyChild,
	toArray = function(p15) -- line: 324
		-- upvalues: mapChildren (copy)
		return mapChildren(p15, function(p16) -- line: 325
			return p16
		end) or {}
	end
}
