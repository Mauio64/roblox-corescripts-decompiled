local Pagination = {}

local parent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local function __rest(p, p2)
	local nones = {}
	Array.forEach(p2, function(p3)
		nones[p3] = Object.None
	end)
	return Object.assign({}, p, nones)
end

require(script.Parent.Parent.Parent.cache.inmemory.policies_types)

require(script.Parent.Parent.graphql.storeUtils)

local mergeDeep = require(script.Parent.Parent.common.mergeDeep)
local mergeDeep2 = mergeDeep.mergeDeep

local getExtras
local makeEmptyData
local v = nil

function Pagination.concatPagination(keyArgs)
	if keyArgs == nil then
		keyArgs = false
	end

	return {
		keyArgs = keyArgs,
		merge = function(_, p, p2)
			if p then
				return (Array.concat(p, p2))
			end

			return p2
		end
	}
end

function Pagination.offsetLimitPagination(keyArgs)
	if keyArgs == nil then
		keyArgs = false
	end

	return {
		keyArgs = keyArgs,
		merge = function(_, p, list, p2)
			local args = p2.args

			local result = p == nil and {} or Array.slice(p, 1)

			if args == nil then
				return (Array.concat(result, list))
			end

			local v2 = args.offset == nil and 0 or args.offset

			for i = 1, #list do
				result[v2 + i] = list[i]
			end

			return result
		end
	}
end

function Pagination.relayStylePagination(keyArgs)
	if keyArgs == nil then
		keyArgs = false
	end

	return {
		keyArgs = keyArgs,
		read = function(_, p, object)
			if not p then
				return
			end

			local edges = {}
			local v2 = ""
			local v3 = ""

			Array.forEach(p.edges, function(p2)
				if object:canRead(object:readField("node", p2)) then
					table.insert(edges, p2)

					if p2.cursor then
						v2 = Boolean.toJSBoolean(v2) and v2 or p2.cursor or ""

						v3 = Boolean.toJSBoolean(p2.cursor) and p2.cursor or v3
					end
				end
			end)

			local pageInfo = p.pageInfo
			local startCursor = pageInfo and pageInfo.startCursor
			local endCursor = pageInfo and pageInfo.endCursor

			return Object.assign({}, getExtras(p), {
				edges = edges,
				pageInfo = Object.assign({}, p.pageInfo, {
					startCursor = Boolean.toJSBoolean(startCursor) and startCursor or v2,
					endCursor = Boolean.toJSBoolean(endCursor) and endCursor or v3
				})
			})
		end,
		merge = function(_, p, p2, object)
			if p == nil then
				p = makeEmptyData()
			end

			local args = object.args

			local v2 = not p2.edges and {} or Array.map(p2.edges, function(p3)
				local v2 = Object.assign({ cursor = "" }, p3)

				if object:isReference(v2) then
					v2.cursor = object:readField("cursor", v2)
				end

				return v2
			end)

			if p2.pageInfo then
				local pageInfo = p2.pageInfo
				local startCursor = pageInfo.startCursor
				local endCursor = pageInfo.endCursor
				local v3 = v2[1]
				local v4 = v2[#v2]

				if v3 and startCursor then
					v3.cursor = startCursor
				end

				if v4 and endCursor then
					v4.cursor = endCursor
				end

				local cursor = v3 and v3.cursor

				if cursor and not startCursor then
					p2 = mergeDeep2(p2, {
						pageInfo = { startCursor = cursor }
					})
				end

				local cursor2 = v4 and v4.cursor

				if cursor2 and not endCursor then
					p2 = mergeDeep2(p2, {
						pageInfo = { endCursor = cursor2 }
					})
				end
			end

			local v3 = p.edges
			local v4 = {}

			if args == nil or not args.after then
				if args == nil or not Boolean.toJSBoolean(args.before) then
					if Boolean.toJSBoolean(p2.edges) then
						v3 = {}
					end
				else
					local index = Array.findIndex(v3, function(p3): boolean
						return p3.cursor == args.before
					end)

					if index < 0 then
						v4 = v3
					else
						v4 = Array.slice(v3, index)
					end

					v3 = {}
				end
			else
				local index = Array.findIndex(v3, function(p3): boolean
					return p3.cursor == args.after
				end)

				if index >= 1 then
					v3 = Array.slice(v3, 1, index + 1)
				end
			end

			local joined = Array.concat(v3, v2, v4)

			local pageInfo2 = Object.assign({}, p2.pageInfo, p.pageInfo)

			if p2.pageInfo then
				local pageInfo = p2.pageInfo

				local hasPreviousPage = pageInfo.hasPreviousPage
				local hasNextPage = pageInfo.hasNextPage
				local startCursor = pageInfo.startCursor
				local endCursor = pageInfo.endCursor
				local v5 = Object.assign({}, pageInfo, {
					hasPreviousPage = Object.None,
					hasNextPage = Object.None,
					startCursor = Object.None,
					endCursor = Object.None
				})

				Object.assign(pageInfo2, v5)

				if not Boolean.toJSBoolean(#v3) then
					if hasPreviousPage ~= nil then
						pageInfo2.hasPreviousPage = hasPreviousPage
					end

					if startCursor ~= nil then
						pageInfo2.startCursor = startCursor
					end
				end

				if not Boolean.toJSBoolean(#v4) then
					if hasNextPage ~= nil then
						pageInfo2.hasNextPage = hasNextPage
					end

					if endCursor ~= nil then
						pageInfo2.endCursor = endCursor
					end
				end
			end

			return Object.assign({}, getExtras(p), getExtras(p2), {
				edges = joined,
				pageInfo = pageInfo2
			})
		end
	}
end

getExtras = function(p)
	return __rest(p, v)
end

v = { "edges", "pageInfo" }

makeEmptyData = function()
	return {
		edges = {},
		pageInfo = { hasPreviousPage = false, hasNextPage = true, startCursor = "", endCursor = "" }
	}
end

return Pagination
