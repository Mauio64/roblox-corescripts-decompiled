local ProfileShareLinks = script:FindFirstAncestor("ProfileShareLinks")
local parent = ProfileShareLinks.Parent
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local Constants = require(ProfileShareLinks.Common.Constants)
local getDeepValue = require(ProfileShareLinks.Common.getDeepValue)

return function()
	return useSelector(function(p)
		return getDeepValue(p, `{Constants.RODUX_KEY}.ProfileShareLinks.shortUrl`)
	end)
end
