local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")

local context = React.createContext(nil)

local function MediaPreloadProvider(p2)
	return React.createElement(context.Provider, { value = p2.controllerProvider }, p2.children)
end

return {
	Provider = MediaPreloadProvider,
	Context = context,
	useMediaControllerProvider = function()
		return React.useContext(context)
	end
}
