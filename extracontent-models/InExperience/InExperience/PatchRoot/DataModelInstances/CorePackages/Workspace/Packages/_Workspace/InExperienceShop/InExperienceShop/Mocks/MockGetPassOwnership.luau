local parent = script:FindFirstAncestor("InExperienceShop").Parent

local Promise = require(parent.Promise)

return {
	getPassOwnership = function(_, _: number)
		return Promise.resolve(false)
	end
}
