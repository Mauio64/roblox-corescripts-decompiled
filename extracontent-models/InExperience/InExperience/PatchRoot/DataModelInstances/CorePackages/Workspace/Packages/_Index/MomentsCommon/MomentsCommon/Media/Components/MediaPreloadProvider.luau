local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local React = require(parent.React)

require(MomentsCommon.Media.MediaTypes)

local context = React.createContext(nil)

local function MediaPreloadProvider(p)
	return React.createElement(context.Provider, { value = p.controllerProvider }, p.children)
end

return {
	Provider = MediaPreloadProvider,
	Context = context,
	useMediaControllerProvider = function()
		return React.useContext(context)
	end
}
