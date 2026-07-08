local Parent = script:FindFirstAncestor("UsageTracker").Parent
local Cryo = require(Parent.Cryo)
local isReactComponent = require(script.Parent.isReactComponent)
local UsageGraph = require(script.Parent.UsageGraph)

local function trackMemberAccess(s1: string, t1: {[any]: any}, p1: ((...any) -> ...any)?) -- line: 11
	-- upvalues: isReactComponent (copy), Cryo (copy), UsageGraph (copy)
	local t2 = {}
	local t3 = {}
	local v11 = p1 or isReactComponent

	local function wrap(s2: string, t4: {[any]: any}) -- line: 17
		-- upvalues: v11 (copy), t2 (copy), t3 (copy), wrap (copy), Cryo (copy)
		local t5 = {}
		local t6 = {}

		for v18, v19 in t4 do
			if v18 ~= "__index" and typeof(v18) == "string" then
				local v20 = s2 .. "." .. v18

				if v11(v19) then
					t2[v20] = {}
					t5[v18] = v19
				elseif typeof(v19) == "table" and not t3[v19] then
					t6[v18] = wrap(v20, v19)
				else
					t6[v18] = v19
				end

				t3[v19] = true
			end
		end

		return (setmetatable(t6, {
			__index = function(_, p3) -- line: 41
				-- upvalues: t5 (copy), t6 (copy), s2 (copy), t2 (copy), Cryo (copy)
				local v23 = t5[p3]

				if not v23 then
					return (rawget(t6, p3))
				end

				local v24 = s2 .. "." .. p3
				local v25, v26 = debug.info(2, "sl")

				t2[v24] = Cryo.List.join(t2[v24], {{
					dmPath = v25,
					lineNumber = v26
				}})

				return v23
			end
		}))
	end

	local v13 = wrap(s1, t1)

	v13[UsageGraph.UsageGraphKey] = t2

	return v13
end

return trackMemberAccess
