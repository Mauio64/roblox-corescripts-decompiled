local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local Promise = require(Parent.Promise)

local function userOwnsGamePass(_: number) -- line: 15
	-- upvalues: Promise (copy)
	return Promise.resolve(false)
end

return userOwnsGamePass
