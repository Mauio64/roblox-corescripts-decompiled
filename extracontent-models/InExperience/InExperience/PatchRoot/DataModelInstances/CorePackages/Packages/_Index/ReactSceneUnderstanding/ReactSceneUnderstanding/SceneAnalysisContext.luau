local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")
local React = require(ReactSceneUnderstanding.Parent.React)

require(ReactSceneUnderstanding.Parent.SceneUnderstanding)

local useState = React.useState
local v4 = React.createContext(nil)

local function SceneAnalysisProvider(t1: {[any]: any}) -- line: 102
	-- upvalues: useState (copy), React (copy), v4 (copy)
	local v7, v8 = useState({})
	local v9, v10 = useState({})
	local v11, v12 = useState({})
	local v13, v14 = useState({})

	return React.createElement(v4.Provider, {
		value = {
			rangeQueryOptions = t1.rangeQueryOptions,
			viewportQueryOptions = t1.viewportQueryOptions,
			dataModelTraversalOptions = t1.dataModelTraversalOptions,
			sourceAssets = v7,
			setSourceAssets = v8,
			assetsInView = v9,
			setAssetsInView = v10,
			assetsInRange = v11,
			setAssetsInRange = v12,
			audibleSounds = v13,
			setAudibleSounds = v14
		}
	}, t1.children)
end

return {
	Provider = SceneAnalysisProvider,
	use = function() -- line: 129
		-- upvalues: React (copy), v4 (copy)
		local v15 = React.useContext(v4)

		if v15 then
			return v15
		end

		error("attempt to use SceneAnalysisContext with no provider. Add `ReactSceneUnderstanding.SceneAnalysisProvider` to the React tree and try again")
	end
}
