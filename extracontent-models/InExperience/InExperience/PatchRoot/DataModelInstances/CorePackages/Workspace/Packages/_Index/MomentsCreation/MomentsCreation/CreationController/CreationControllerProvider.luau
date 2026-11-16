local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local React = require(parent.React)

local CreationControllerContext = require(MomentsCreation.CreationController.CreationControllerContext)
local createCreationController = require(MomentsCreation.CreationController.createCreationController)
local GetCreationFlowStore = require(MomentsCreation.Stores.GetCreationFlowStore)
require(MomentsCreation.Types.CreationFlowTypes)

local function CreationControllerProvider(props)
	local host = props.host
	local excludeGallery = props.excludeGallery
	local initialAvatarMoment = props.initialAvatarMoment

	local v = React.useMemo(function()
		return createCreationController({
			store = GetCreationFlowStore(false),
			host = host,
			excludeGallery = excludeGallery,
			initialAvatarMoment = initialAvatarMoment
		})
	end, { host, excludeGallery, initialAvatarMoment })

	return React.createElement(CreationControllerContext.Provider, { value = v }, props.children)
end

return CreationControllerProvider
