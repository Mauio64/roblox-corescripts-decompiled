local parent = script:FindFirstAncestor("UsageTracker").Parent
local Cryo = require(parent.Cryo)

local isReactComponent = require(script.Parent.isReactComponent)
local UsageGraph = require(script.Parent.UsageGraph)

local function trackMemberAccess(p: string, p2, callback)
	local v = {}
	local set = {}
	local v2 = callback or isReactComponent
	local function wrap(p3: string, items)
		local v3 = {}
		local v4 = {}

		for k, item in items do
			if not (k ~= "__index" and typeof(k) == "string") then
				continue
			end

			local v5 = p3 .. "." .. k

			if v2(item) then
				v[v5] = {}
				v3[k] = item
			elseif typeof(item) == "table" and not set[item] then
				v4[k] = wrap(v5, item)
			else
				v4[k] = item
			end

			set[item] = true
		end

		return (setmetatable(v4, {
			__index = function(_, p4)
				local v5 = v3[p4]

				if not v5 then
					return (rawget(v4, p4))
				end

				local v6 = p3 .. "." .. p4
				local dmPath, lineNumber = debug.info(2, "sl")
				v[v6] = Cryo.List.join(v[v6], {
					{ dmPath = dmPath, lineNumber = lineNumber }
				})

				return v5
			end
		}))
	end

	local v3 = wrap(p, p2)
	v3[UsageGraph.UsageGraphKey] = v

	return v3
end

return trackMemberAccess
