local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local React = require(MomentsCommonParent.React)

require(MomentsCommon.Media.MediaTypes)

local v4 = React.createContext(nil)

local function MediaPreloadProvider(t1: {[any]: any}) -- line: 34
	-- upvalues: React (copy), v4 (copy)
	return React.createElement(v4.Provider, {
		value = t1.controllerProvider
	}, t1.children)
end

return {
	Provider = MediaPreloadProvider,
	Context = v4,
	useMediaControllerProvider = function() -- line: 40
		-- upvalues: React (copy), v4 (copy)
		return React.useContext(v4)
	end
}
