local parent = script.Parent
require(parent.Types)

local append = require(parent.append)
local assign = require(parent.assign)
local cycles = require(parent.cycles)
local includes = require(parent.includes)
local join = require(parent.join)
local map = require(parent.map)
local keys = require(parent.keys)
local slice = require(parent.slice)

local concat = table.concat
local insert = table.insert
local sort = table.sort

local function indentLines(p, indent: string) -- 2 equivalent calls inferred from this helper
	return map(p, function(p2: string)
		return indent .. p2
	end)
end

local function sortObjectKeys(p)
	local v = keys(p)
	sort(v, function(value, value2): boolean
		if type(value) == "number" and type(value2) == "number" then
			return value < value2
		end

		return tostring(value) < tostring(value2)
	end)

	return v
end

local function constructValueOptions(data, value)
	local depth

	if data.depth then
		depth = data.depth - 1 or nil
	end

	return (assign({ visited = {}, indent = "\t", depth = 2 }, data, {
		depth = depth,
		cycles = data.cycles or cycles(value, data.depth, {
			visited = {},
			refs = {},
			nextRef = 0,
			depth = data.depth,
			omit = data.omit or {}
		})
	}))
end

local function insertClosedBracket(list, flag: boolean, flag2: boolean) -- 1 equivalent call inferred from this helper
	if not flag then
		list[#list] = ("%s}"):format(list[#list])
	elseif flag2 then
		list[#list] = list[#list] .. "}"
	else
		insert(list, "}")
	end
end

local fn
local function prettyLines(value, options)
	local v = options or {}

	if type(value) == "table" then
		local v2 = constructValueOptions(v, value)

		if v2.depth == -1 then
			return { "..." }
		end

		if v2.visited[value] then
			return { "&" .. v2.cycles.refs[value] }
		end

		v2.visited[value] = true

		local multiline = v2.multiline
		local v3 = multiline and "," or ", "
		local ref = v2.cycles.refs[value]
		local result = { (ref and ("<%s>"):format(ref) or "") .. "{" }

		local v4 = join(v2, { noQuotes = true, multiline = false })

		local v5 = 0
		local flag = true
		local v6 = keys(value)
		sort(v6, function(value2, value3): boolean
			if type(value2) == "number" and type(value3) == "number" then
				return value2 < value3
			end

			return tostring(value2) < tostring(value3)
		end)

		if #value > 0 and v2.arrayLength then
			result[1] = ("#%d %s"):format(#value, result[1])
		end

		for _, v7 in ipairs(v6) do
			if type(v7) == "number" and v7 == v5 + 1 then
				v5 = v7
			end

			if v2.omit and includes(v2.omit, v7) then
				continue
			end

			local v8 = value[v7]
			local v9

			if type(v7) == "number" and v7 >= 1 then
				v9 = v7 <= v5
			else
				v9 = false
			end

			if flag then
				flag = false
			else
				result[#result] = result[#result] .. v3
			end

			if multiline then
				if v9 then
					append(result, indentLines(prettyLines(v8, v2), v2.indent))
				else
					local v10 = indentLines(prettyLines(v7, v4), v2.indent) -- inferred equivalent call
					local v11 = prettyLines(v8, v2)
					local v12 = indentLines(slice(v11, 2), v2.indent) -- inferred equivalent call

					v10[#v10] = ("%s = %s"):format(v10[#v10], v11[1])
					append(result, v10)
					append(result, v12)
				end
			elseif v9 then
				result[#result] = result[#result] .. fn(v8, v2)
			else
				result[#result] = result[#result] .. fn(v7, v4) .. " = " .. fn(v8, v2)
			end
		end

		if not multiline then
			result[#result] = ("%s}"):format(result[#result])

			return result
		end

		if flag then
			insertClosedBracket(result, true, true) -- inferred equivalent call
			return result
		end

		insert(result, "}")
		return result
	elseif type(value) == "string" and v and not v.noQuotes then
		return { ("\"%s\""):format(value) }
	else
		return { (tostring(value)) }
	end
end

fn = function(p, p2)
	return concat(prettyLines(p, p2), "\n")
end

return fn
