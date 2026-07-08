local ParentParent = script.Parent.Parent
local parse = require(ParentParent.GraphQL).parse
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set
local String = LuauPolyfill.String
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array
local console = LuauPolyfill.console
local v10 = Map.new(nil)
local v11 = Map.new(nil)
local u12 = true
local u13 = false

local function normalize(s1: string) -- line: 30
	-- upvalues: String (copy)
	local v22 = s1:gsub(",+%s+", " ")

	return String.trim(v22)
end
local function cacheKeyFromLoc(t1: {[any]: any}) -- line: 35
	-- upvalues: normalize (copy)
	return normalize(t1.source.body:sub(t1.start, t1._end))
end
local function processFragments(p1) -- line: 39
	-- upvalues: Set (copy), String (copy), v11 (copy), u12 (ref), console (copy), Object (copy)
	local v25 = Set.new(nil)
	local t2 = {}

	for i = 1, #p1.definitions do
		local v28 = p1.definitions[i]

		if v28.kind == "FragmentDefinition" then
			local value = v28.name.value
			local loc = v28.loc
			local v31 = loc.source.body:sub(loc.start, loc._end):gsub(",+%s+", " ")
			local v32 = String.trim(v31)
			local v33 = v11:get(value)

			if v33 and not v33:has(v32) then
				if u12 then
					console.warn("Warning: fragment with name " .. value .. " already exists.\n" .. "graphql-tag enforces all fragment names across your application to be unique; read more about\n" .. "this in the docs: http://dev.apollodata.com/core/fragments.html#unique-names")
				end
			elseif not v33 then
				v33 = Set.new()
				v11:set(value, v33)
			end

			v33:add(v32)

			if not v25:has(v32) then
				v25:add(v32)
				table.insert(t2, v28)
			end
		else
			table.insert(t2, v28)
		end
	end

	return Object.assign({}, p1, {
		definitions = t2
	})
end
local function stripLoc(p2) -- line: 83
	-- upvalues: Set (copy), Object (copy), Array (copy)
	local v35 = Set.new(nil)

	for i = 1, #v35 do
		local v37 = v35[i]

		if v37.loc then
			v35:delete(v37.loc)
		end

		for j = 1, #Object.keys(v37) do
			local v39 = v37[tostring(Object.keys(v37)[j])]

			if v39 and typeof(v39) == "table" and not Array.isArray(v39) then
				v35:add(v39)
			end
		end
	end

	local loc = p2.loc

	if loc then
		loc.startToken = nil
		loc.endToken = nil
	end

	return p2
end
local function parseDocument(s2: string) -- line: 107
	-- upvalues: String (copy), v10 (copy), parse (copy), u13 (ref), stripLoc (copy), processFragments (copy)
	local v42 = s2:gsub(",+%s+", " ")
	local v43 = String.trim(v42)

	if not v10:has(v43) then
		local v44 = parse(s2, {
			experimentalFragmentVariables = u13
		})

		if not v44 or v44.kind ~= "Document" then
			error("Not a valid GraphQL document.")
		end

		v10:set(v43, (stripLoc(processFragments(v44))))
	end

	return (v10:get(v43))
end
local function gql(p3) -- line: 130
	-- upvalues: parseDocument (copy)
	if typeof(p3) == "string" then
		return (parseDocument(p3))
	end

	if typeof(p3) == "table" and p3.kind == "Document" then
		return p3
	end

	error("graphql-tag-lua does not currently support non-strings or Fragments. Please file an issue or PR if you need this feature added.")
end

function resetCaches() -- line: 159
	-- upvalues: v10 (copy), v11 (copy)
	v10:clear()
	v11:clear()
end
function disableFragmentWarnings() -- line: 164
	-- upvalues: u12 (ref)
	u12 = false
end
function enableExperimentalFragmentVariables() -- line: 168
	-- upvalues: u13 (ref)
	u13 = true
end
function disableExperimentalFragmentVariables() -- line: 172
	-- upvalues: u13 (ref)
	u13 = false
end

local t3 = {
	gql = gql,
	resetCaches = resetCaches,
	disableFragmentWarnings = disableFragmentWarnings,
	enableExperimentalFragmentVariables = enableExperimentalFragmentVariables,
	disableExperimentalFragmentVariables = disableExperimentalFragmentVariables
}

return {
	default = gql,
	gql = gql,
	resetCaches = t3.resetCaches,
	disableFragmentWarnings = t3.disableFragmentWarnings,
	enableExperimentalFragmentVariables = t3.enableExperimentalFragmentVariables,
	disableExperimentalFragmentVariables = t3.disableExperimentalFragmentVariables
}
