local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local React = require(MomentsCreationParent.React)
local CreationControllerContext = require(MomentsCreation.CreationController.CreationControllerContext)
local createCreationController = require(MomentsCreation.CreationController.createCreationController)
local GetCreationFlowStore = require(MomentsCreation.Stores.GetCreationFlowStore)

require(MomentsCreation.Types.CreationFlowTypes)

local function CreationControllerProvider(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), createCreationController (copy), GetCreationFlowStore (copy), CreationControllerContext (copy)
	local host = t1.host
	local excludeGallery = t1.excludeGallery
	local v11 = React.useMemo(function() -- line: 28
		-- upvalues: createCreationController (copy), GetCreationFlowStore (copy), host (copy), excludeGallery (copy)
		return createCreationController({
			store = GetCreationFlowStore(false),
			host = host,
			excludeGallery = excludeGallery
		})
	end, {
		host,
		excludeGallery
	})

	return React.createElement(CreationControllerContext.Provider, {
		value = v11
	}, t1.children)
end

return CreationControllerProvider
