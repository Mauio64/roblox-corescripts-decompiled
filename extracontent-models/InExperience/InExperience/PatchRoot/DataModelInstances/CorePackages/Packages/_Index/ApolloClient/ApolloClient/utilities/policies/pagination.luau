local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local function __rest(p1, p2) -- line: 21
	-- upvalues: Array (copy), Object (copy)
	local t2 = {}

	Array.forEach(p2, function(p3) -- line: 23
		-- upvalues: t2 (copy), Object (copy)
		t2[p3] = Object.None
	end)

	return Object.assign({}, p1, t2)
end

require(script.Parent.Parent.Parent.cache.inmemory.policies_types)
require(script.Parent.Parent.graphql.storeUtils)

local mergeDeep = require(script.Parent.Parent.common.mergeDeep).mergeDeep
local getExtras = nil
local makeEmptyData = nil
local t6 = nil

function t1.concatPagination(p4) -- line: 47
	-- upvalues: Array (copy)
	if p4 == nil then
		p4 = false
	end

	return {
		keyArgs = p4,
		merge = function(_, p6, p7) -- line: 53
			-- upvalues: Array (copy)
			if p6 then
				return (Array.concat(p6, p7))
			end

			return p7
		end
	}
end
function t1.offsetLimitPagination(p8) -- line: 65
	-- upvalues: Array (copy)
	if p8 == nil then
		p8 = false
	end

	return {
		keyArgs = p8,
		merge = function(_, p10, p11, p12) -- line: 72
			-- upvalues: Array (copy)
			local args = p12.args
			local v28 = if p10 == nil then {} else Array.slice(p10, 1)

			if args ~= nil then
				local v29 = if args.offset ~= nil then args.offset else 0

				for i = 1, #p11 do
					v28[v29 + i] = p11[i]
				end

				return v28
			end

			return (Array.concat(v28, p11))
		end
	}
end
function t1.relayStylePagination(p13) -- line: 139
	-- upvalues: Array (copy), Boolean (copy), Object (copy), getExtras (ref), makeEmptyData (ref), mergeDeep (copy)
	if p13 == nil then
		p13 = false
	end

	return {
		keyArgs = p13,
		read = function(_, p15, p16) -- line: 146
			-- upvalues: Array (copy), Boolean (copy), Object (copy), getExtras (ref)
			if not p15 then
				return
			end

			local t3 = {}
			local s1 = ""
			local s2 = ""

			Array.forEach(p15.edges, function(p17) -- line: 158
				-- upvalues: p16 (copy), t3 (copy), s1 (ref), Boolean (copy), s2 (ref)
				if p16:canRead(p16:readField("node", p17)) then
					table.insert(t3, p17)

					if p17.cursor then
						s1 = Boolean.toJSBoolean(s1) and s1 or (p17.cursor or "")
						s2 = Boolean.toJSBoolean(p17.cursor) and p17.cursor or s2
					end
				end
			end)

			local pageInfo = p15.pageInfo
			local v38 = pageInfo and pageInfo.startCursor
			local v39 = pageInfo and pageInfo.endCursor

			return Object.assign({}, getExtras(p15), {
				edges = t3,
				pageInfo = Object.assign({}, p15.pageInfo, {
					startCursor = Boolean.toJSBoolean(v38) and v38 or s1,
					endCursor = Boolean.toJSBoolean(v39) and v39 or s2
				})
			})
		end,
		merge = function(_, p19, p20, p21) -- line: 199
			-- upvalues: makeEmptyData (ref), Array (copy), Object (copy), mergeDeep (copy), Boolean (copy), getExtras (ref)
			if p19 == nil then
				p19 = makeEmptyData()
			end

			local args = p21.args
			local v45 = if not p20.edges then {} else Array.map(p20.edges, function(p22) -- line: 210
				-- upvalues: Object (copy), p21 (copy)
				local v67 = Object.assign({
					cursor = ""
				}, p22)

				if p21:isReference(v67) then
					v67.cursor = p21:readField("cursor", v67)
				end

				return v67
			end)

			if p20.pageInfo then
				local pageInfo = p20.pageInfo
				local startCursor = pageInfo.startCursor
				local endCursor = pageInfo.endCursor
				local v49 = v45[1]
				local v50 = v45[#v45]

				if v49 and startCursor then
					v49.cursor = startCursor
				end

				if v50 and endCursor then
					v50.cursor = endCursor
				end

				local v51 = v49 and v49.cursor

				if v51 and not startCursor then
					p20 = mergeDeep(p20, {
						pageInfo = {
							startCursor = v51
						}
					})
				end

				local v52 = v50 and v50.cursor

				if v52 and not endCursor then
					p20 = mergeDeep(p20, {
						pageInfo = {
							endCursor = v52
						}
					})
				end
			end

			local edges = p19.edges
			local t4 = {}

			if args ~= nil and args.after then
				local v55 = Array.findIndex(edges, function(p23) -- line: 262
					-- upvalues: args (copy)
					return p23.cursor == args.after
				end)

				if v55 >= 1 then
					edges = Array.slice(edges, 1, v55 + 1)
				end
			elseif args ~= nil and Boolean.toJSBoolean(args.before) then
				local v56 = Array.findIndex(edges, function(p24) -- line: 273
					-- upvalues: args (copy)
					return p24.cursor == args.before
				end)

				t4 = if not (v56 < 0) then Array.slice(edges, v56) else edges
				edges = {}
			elseif Boolean.toJSBoolean(p20.edges) then
				edges = {}
			end

			local v57 = Array.concat(edges, v45, t4)
			local v58 = Object.assign({}, p20.pageInfo, p19.pageInfo)

			if p20.pageInfo then
				local pageInfo = p20.pageInfo
				local hasPreviousPage = pageInfo.hasPreviousPage
				local hasNextPage = pageInfo.hasNextPage
				local startCursor = pageInfo.startCursor
				local endCursor = pageInfo.endCursor
				local v64 = Object.assign({}, pageInfo, {
					hasPreviousPage = Object.None,
					hasNextPage = Object.None,
					startCursor = Object.None,
					endCursor = Object.None
				})

				Object.assign(v58, v64)

				if not Boolean.toJSBoolean(#edges) then
					if hasPreviousPage ~= nil then
						v58.hasPreviousPage = hasPreviousPage
					end

					if startCursor ~= nil then
						v58.startCursor = startCursor
					end
				end

				if not Boolean.toJSBoolean(#t4) then
					if hasNextPage ~= nil then
						v58.hasNextPage = hasNextPage
					end

					if endCursor ~= nil then
						v58.endCursor = endCursor
					end
				end
			end

			return Object.assign({}, getExtras(p19), getExtras(p20), {
				edges = v57,
				pageInfo = v58
			})
		end
	}
end
function getExtras(t5: {[any]: any}) -- line: 358
	-- upvalues: __rest (copy), t6 (ref)
	return __rest(t5, t6)
end

t6 = {
	"edges",
	"pageInfo"
}

function makeEmptyData() -- line: 363
	return {
		edges = {},
		pageInfo = {
			hasPreviousPage = false,
			hasNextPage = true,
			startCursor = "",
			endCursor = ""
		}
	}
end

return t1
