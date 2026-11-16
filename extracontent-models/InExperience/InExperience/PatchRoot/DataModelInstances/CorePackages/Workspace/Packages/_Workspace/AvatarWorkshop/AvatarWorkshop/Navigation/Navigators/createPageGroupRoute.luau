local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

require(parent.React)

local createPagesNavigator = require(script.Parent.createPagesNavigator)

local function createPageGroupRoute(p: string, p2, p3)
	return {
		[p] = { screen = createPagesNavigator(p2, p3) }
	}
end

return createPageGroupRoute
