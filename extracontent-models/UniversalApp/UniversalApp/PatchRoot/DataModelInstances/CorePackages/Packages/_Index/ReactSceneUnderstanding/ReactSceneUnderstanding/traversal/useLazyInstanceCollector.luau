local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")
local Cryo = require(ReactSceneUnderstanding.Parent.Cryo)
local React = require(ReactSceneUnderstanding.Parent.React)
local ReactUtils = require(ReactSceneUnderstanding.Parent.ReactUtils)
local SceneUnderstanding = require(ReactSceneUnderstanding.Parent.SceneUnderstanding)
local DataModelTraversalOptions = SceneUnderstanding.DataModelTraversalOptions
local useEffect = React.useEffect
local useMemo = React.useMemo
local useState = React.useState
local usePrevious = ReactUtils.usePrevious

local function useLazyInstanceCollector(t1: {[any]: any}, p1: ((...any) -> ...any)?, p2) -- line: 17
	-- upvalues: DataModelTraversalOptions (copy), usePrevious (copy), useMemo (copy), SceneUnderstanding (copy), Cryo (copy), useState (copy), useEffect (copy)
	local v15 = DataModelTraversalOptions.new(p2)
	local v16 = usePrevious(p2)
	local v17 = useMemo(function() -- line: 26
		-- upvalues: SceneUnderstanding (copy), t1 (copy), p1 (copy), p2 (copy)
		return SceneUnderstanding.createLazyInstanceCollector(t1, p1, p2)
	end, Cryo.List.join(t1, { p1 }))
	local v18, v19 = useState({})

	if p2 and (v16 and p2.instanceProcessingLimit ~= v16.instanceProcessingLimit) then
		v17.setInstancesProcessedPerFrame(v15.instanceProcessingLimit)
	end

	useEffect(function() -- line: 38
		-- upvalues: v17 (copy), v19 (copy)
		v17.onStepped(function(p3) -- line: 39
			-- upvalues: v19 (copy)
			v19(table.clone(p3))
		end)
		v17.listen()

		return function() -- line: 47
			-- upvalues: v17 (copy)
			v17.destroy()
		end
	end, { v17 })

	return v18
end

return useLazyInstanceCollector
