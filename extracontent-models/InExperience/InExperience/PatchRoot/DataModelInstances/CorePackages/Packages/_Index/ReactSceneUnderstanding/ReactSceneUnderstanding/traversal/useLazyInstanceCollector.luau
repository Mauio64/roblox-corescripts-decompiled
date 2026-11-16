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

local function useLazyInstanceCollector(p, callback, p2)
	local v = DataModelTraversalOptions.new(p2)

	local v2 = usePrevious(p2)

	local v3 = useMemo(function()
		return SceneUnderstanding.createLazyInstanceCollector(p, callback, p2)
	end, Cryo.List.join(p, { callback }))

	local state, setState = useState({})

	if p2 and v2 and p2.instanceProcessingLimit ~= v2.instanceProcessingLimit then
		v3.setInstancesProcessedPerFrame(v.instanceProcessingLimit)
	end

	useEffect(function()
		v3.onStepped(function(p3)
			setState(table.clone(p3))
		end)
		v3.listen()

		return function()
			v3.destroy()
		end
	end, { v3 })

	return state
end

return useLazyInstanceCollector
