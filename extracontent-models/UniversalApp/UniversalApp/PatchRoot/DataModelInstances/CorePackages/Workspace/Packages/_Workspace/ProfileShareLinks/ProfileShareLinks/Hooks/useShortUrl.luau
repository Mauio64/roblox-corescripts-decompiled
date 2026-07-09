local ProfileShareLinks = script:FindFirstAncestor("ProfileShareLinks")
local ProfileShareLinksParent = ProfileShareLinks.Parent
local useSelector = require(ProfileShareLinksParent.RoactUtils).Hooks.RoactRodux.useSelector
local Constants = require(ProfileShareLinks.Common.Constants)
local getDeepValue = require(ProfileShareLinks.Common.getDeepValue)

return function() -- line: 9
	-- upvalues: useSelector (copy), getDeepValue (copy), Constants (copy)
	return useSelector(function(p1) -- line: 10
		-- upvalues: getDeepValue (copy), Constants (copy)
		return getDeepValue(p1, `{ Constants.RODUX_KEY }.ProfileShareLinks.shortUrl`)
	end)
end
