local parent = script:FindFirstAncestor("InExperienceShop").Parent

local Promise = require(parent.Promise)

local function userOwnsGamePass(_: number)
	return Promise.resolve(false)
end

return userOwnsGamePass
