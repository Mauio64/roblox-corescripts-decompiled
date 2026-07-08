local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Wrappers = require(Foundation.Utility.Wrappers)
local Signal = Wrappers.Signal
local Connection = Wrappers.Connection

local function findLayerCollector(p1) -- line: 10
	if not p1 then
		return nil
	end

	return p1:FindFirstAncestorWhichIsA("LayerCollector")
end
local function useLayerCollector(p2) -- line: 18
	-- upvalues: React (copy), findLayerCollector (copy), Signal (copy), Connection (copy)
	local v11, v12 = React.useState(nil)
	local v13 = React.useCallback(function() -- line: 21
		-- upvalues: v12 (copy), findLayerCollector (copy), p2 (copy)
		v12(findLayerCollector(p2))
	end, { p2 })

	React.useEffect(function() -- line: 25
		-- upvalues: p2 (copy), v13 (copy), Signal (copy), Connection (copy)
		if p2 then
			v13()

			local v14 = Signal.Connect(p2.AncestryChanged, v13)

			return function() -- line: 31
				-- upvalues: Connection (copy), v14 (copy)
				Connection.Disconnect(v14)
			end
		end

		return nil
	end, { p2 })

	return v11
end

return useLayerCollector
