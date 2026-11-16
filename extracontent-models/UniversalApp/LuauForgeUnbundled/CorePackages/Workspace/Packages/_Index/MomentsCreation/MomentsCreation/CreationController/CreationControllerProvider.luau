local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local CreationControllerContext = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/CreationController/CreationControllerContext")
local createCreationController = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/CreationController/createCreationController")
local GetCreationFlowStore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/GetCreationFlowStore")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local function CreationControllerProvider(props)
	local host = props.host
	local excludeGallery = props.excludeGallery
	local initialAvatarMoment = props.initialAvatarMoment

	local v5 = React.useMemo(function()
		return createCreationController({
			store = GetCreationFlowStore(false),
			host = host,
			excludeGallery = excludeGallery,
			initialAvatarMoment = initialAvatarMoment
		})
	end, { host, excludeGallery, initialAvatarMoment })

	return React.createElement(CreationControllerContext.Provider, { value = v5 }, props.children)
end

return CreationControllerProvider
