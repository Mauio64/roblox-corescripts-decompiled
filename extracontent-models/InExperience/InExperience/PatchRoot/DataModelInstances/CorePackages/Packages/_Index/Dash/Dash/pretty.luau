local scriptParent = script.Parent

require(scriptParent.Types)

local append = require(scriptParent.append)
local assign = require(scriptParent.assign)
local cycles = require(scriptParent.cycles)
local includes = require(scriptParent.includes)
local join = require(scriptParent.join)
local map = require(scriptParent.map)
local keys = require(scriptParent.keys)
local slice = require(scriptParent.slice)
local concat = table.concat
local insert = table.insert
local sort = table.sort

local function indentLines(t1: {[any]: any}, s1: string) -- line: 38
	-- upvalues: map (copy)
	return map(t1, function(s2: string) -- line: 39
		-- upvalues: s1 (copy)
		return s1 .. s2
	end)
end
local function sortObjectKeys(p1) -- line: 44
	-- upvalues: keys (copy), sort (copy)
	local v22 = keys(p1)

	sort(v22, function(p2, p3) -- line: 46
		if type(p2) == "number" and type(p3) == "number" then
			return p2 < p3
		end

		return tostring(p2) < tostring(p3)
	end)

	return v22
end
local function constructValueOptions(t2: {[any]: any}, p4) -- line: 56
	-- upvalues: assign (copy), cycles (copy)
	return (assign({
		indent = "\t",
		depth = 2,
		visited = {}
	}, t2, {
		depth = t2.depth and t2.depth - 1 or nil,
		cycles = t2.cycles or cycles(p4, t2.depth, {
			nextRef = 0,
			visited = {},
			refs = {},
			depth = t2.depth,
			omit = t2.omit or {}
		})
	}))
end
local function insertClosedBracket(t3: {[any]: any}, b1: boolean, b2: boolean) -- line: 78
	-- upvalues: insert (copy)
	if b1 then
		if b2 then
			t3[#t3] = t3[#t3] .. "}"

			return
		end

		insert(t3, "}")

		return
	end

	t3[#t3] = ("%s}"):format(t3[#t3])
end

local u17 = nil

local function prettyLines(p5, t4: {[any]: any}?) -- line: 93
	-- upvalues: constructValueOptions (copy), join (copy), keys (copy), sort (copy), includes (copy), append (copy), indentLines (copy), prettyLines (copy), map (copy), slice (copy), u17 (ref), insert (copy)
	local v30 = t4 or {}

	if type(p5) == "table" then
		local v31 = constructValueOptions(v30, p5)

		if v31.depth == -1 then
			return { "..." }
		end

		if v31.visited[p5] then
			return { "&" .. v31.cycles.refs[p5] }
		end

		v31.visited[p5] = true

		local multiline = v31.multiline
		local v33 = not multiline and ", " or ","
		local v34 = v31.cycles.refs[p5]
		local t5 = { (v34 and ("<%s>"):format(v34) or "") .. "{" }
		local v36 = join(v31, {
			noQuotes = true,
			multiline = false
		})
		local n1 = 0
		local v38 = true
		local v39 = keys(p5)

		sort(v39, function(p6, p7) -- line: 46
			if type(p6) == "number" and type(p7) == "number" then
				return p6 < p7
			end

			return tostring(p6) < tostring(p7)
		end)

		if #p5 > 0 and v31.arrayLength then
			t5[1] = ("#%d %s"):format(#p5, t5[1])
		end

		for _, v in ipairs(v39) do
			if type(v) == "number" and v == n1 + 1 then
				n1 = v
			end

			if not v31.omit or not includes(v31.omit, v) then
				local v42 = p5[v]
				local v43 = type(v) == "number" and (v >= 1 and v <= n1)

				if v38 then
					v38 = false
				else
					t5[#t5] = t5[#t5] .. v33
				end

				if multiline then
					if v43 then
						append(t5, indentLines(prettyLines(v42, v31), v31.indent))
					else
						local v44 = prettyLines(v, v36)
						local indent = v31.indent
						local v46 = map(v44, function(s3: string) -- line: 39
							-- upvalues: indent (copy)
							return indent .. s3
						end)
						local v47 = prettyLines(v42, v31)
						local v48 = slice(v47, 2)
						local indent2 = v31.indent
						local v50 = map(v48, function(s4: string) -- line: 39
							-- upvalues: indent2 (copy)
							return indent2 .. s4
						end)

						v46[#v46] = ("%s = %s"):format(v46[#v46], v47[1])
						append(t5, v46)
						append(t5, v50)
					end
				elseif v43 then
					t5[#t5] = t5[#t5] .. u17(v42, v31)
				else
					t5[#t5] = t5[#t5] .. u17(v, v36) .. " = " .. u17(v42, v31)
				end
			end
		end

		if multiline then
			if v38 then
				t5[#t5] = t5[#t5] .. "}"

				return t5
			end

			insert(t5, "}")

			return t5
		end

		t5[#t5] = ("%s}"):format(t5[#t5])

		return t5
	end

	if type(p5) == "string" and v30 and not v30.noQuotes then
		return { ("\"%s\""):format(p5) }
	end

	return { (tostring(p5)) }
end

function u17(p8, t6: {[any]: any}?) -- line: 199
	-- upvalues: concat (copy), prettyLines (copy)
	return concat(prettyLines(p8, t6), "\n")
end

return u17
