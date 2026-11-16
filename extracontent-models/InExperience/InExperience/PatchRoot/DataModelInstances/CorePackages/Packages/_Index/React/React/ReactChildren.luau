local parent = script.Parent.Parent
require(parent.Shared)

local Shared = require(parent.Shared)
local invariant = Shared.invariant

local Shared2 = require(parent.Shared)
local ReactSymbols = Shared2.ReactSymbols
local getIteratorFn = ReactSymbols.getIteratorFn
local REACT_ELEMENT_TYPE = ReactSymbols.REACT_ELEMENT_TYPE
local REACT_PORTAL_TYPE = ReactSymbols.REACT_PORTAL_TYPE

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local ReactElement = require(script.Parent.ReactElement)
local isValidElement = ReactElement.isValidElement
local cloneAndReplaceKey = ReactElement.cloneAndReplaceKey

local function escape(key: string) -- 1 equivalent call inferred from this helper
	local v = string.gsub(key, "=", "=0")
	return "$" .. string.gsub(v, ":", "=2")
end

local function escapeUserProvidedKey(p: string)
	return p
end

local function getElementKey(p, p2: number) -- 3 equivalent calls inferred from this helper
	if typeof(p) ~= "table" or p == nil or p.key == nil then
		return (tostring(p2))
	end

	return escape(tostring(p.key)) -- inferred equivalent call
end

local function mapIntoArray(p, list, p2: string, p3: string, fn)
	local typeName = typeof(p)

	if typeName == "nil" or typeName == "boolean" or typeName == "userdata" then
		p = nil
	end

	local v = false

	if p == nil or typeName == "string" or typeName == "number" then
		v = true
	elseif typeName == "table" then
		local Typeof = p["$$typeof"]

		v = Typeof == REACT_ELEMENT_TYPE or Typeof == REACT_PORTAL_TYPE or false
	end

	if v then
		local v2 = fn(p)

		if p3 == "" then
			p3 = "." .. getElementKey(p, 1) -- inferred equivalent call
		end

		if Array.isArray(v2) then
			mapIntoArray(v2, list, p3 == nil and "" or p3 .. "/", "", function(p4)
				return p4
			end)
		elseif v2 ~= nil then
			if isValidElement(v2) then
				local key = v2.key
				v2 = cloneAndReplaceKey(
					v2,
					p2 .. ((not key or p and p.key == key) and "" or tostring(key) .. "/") .. p3
				)
			end

			table.insert(list, v2)
		end

		return 1
	else
		local total = 0
		local v2 = p3 == "" and "." or p3 .. ":"

		if Array.isArray(p) then
			for i = 1, #p do
				local v3 = p[i]
				total += mapIntoArray(v3, list, p2, v2 .. getElementKey(v3, i), fn) -- inferred equivalent call
			end

			return total
		else
			local iteratorFn = getIteratorFn(p)

			if typeof(iteratorFn) ~= "function" then
				return total
			end

			local v3 = iteratorFn(p)

			local v4 = v3.next()
			local v5 = 1

			while not v4.done do
				local value = v4.value
				local v6 = v2 .. getElementKey(value, v5) -- inferred equivalent call

				v5 += 1
				total += mapIntoArray(value, list, p2, v6, fn)

				v4 = v3.next()
			end

			return total
		end
	end
end

local function mapChildren(p, fn, _)
	if p == nil then
		return nil
	end

	local v = {}
	local v2 = 1
	mapIntoArray(p, v, "", "", function(p2)
		local v3 = fn(p2, v2)
		v2 += 1
		return v3
	end)

	return v
end

local function countChildren(p)
	local count = 0
	mapChildren(p, function()
		count += 1
	end)

	return count
end

local function forEachChildren(p, callback, p2)
	mapChildren(p, function(...)
		callback(...)
	end, p2)
end

local function onlyChild(p)
	invariant(isValidElement(p), "React.Children.only expected to receive a single React element child.")

	return p
end

return {
	forEach = forEachChildren,
	map = mapChildren,
	count = countChildren,
	only = onlyChild,
	toArray = function(p)
		return mapChildren(p, function(p2)
			return p2
		end) or {}
	end
}
