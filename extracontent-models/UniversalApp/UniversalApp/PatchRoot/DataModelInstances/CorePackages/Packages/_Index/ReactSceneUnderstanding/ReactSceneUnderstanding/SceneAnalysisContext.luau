local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")

local React = require(ReactSceneUnderstanding.Parent.React)
require(ReactSceneUnderstanding.Parent.SceneUnderstanding)

local useState = React.useState

local context = React.createContext(nil)

local function SceneAnalysisProvider(props)
	local state, setState = useState({})
	local state2, setState2 = useState({})
	local state3, setState3 = useState({})
	local state4, setState4 = useState({})

	return React.createElement(context.Provider, {
		value = {
			rangeQueryOptions = props.rangeQueryOptions,
			viewportQueryOptions = props.viewportQueryOptions,
			dataModelTraversalOptions = props.dataModelTraversalOptions,
			sourceAssets = state,
			setSourceAssets = setState,
			assetsInView = state2,
			setAssetsInView = setState2,
			assetsInRange = state3,
			setAssetsInRange = setState3,
			audibleSounds = state4,
			setAudibleSounds = setState4
		}
	}, props.children)
end

return {
	Provider = SceneAnalysisProvider,
	use = function()
		local v = React.useContext(context)

		if v then
			return v
		end

		error("attempt to use SceneAnalysisContext with no provider. Add `ReactSceneUnderstanding.SceneAnalysisProvider` to the React tree and try again")
	end
}
