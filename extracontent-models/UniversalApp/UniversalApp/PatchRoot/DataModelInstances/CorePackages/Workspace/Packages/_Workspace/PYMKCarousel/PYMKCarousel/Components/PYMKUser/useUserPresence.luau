local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local React = dependencies.React

require(ParentParentParent.UserList)

local useSelector = dependencies.Hooks.useSelector
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local FFlagHomepagePYMKPresence = require(ParentParentParent.SharedFlags).FFlagHomepagePYMKPresence

local function useUserPresence(t1: {[any]: any}) -- line: 18
	-- upvalues: FFlagHomepagePYMKPresence (copy), useSelector (copy), getDeepValue (copy), React (copy)
	if not FFlagHomepagePYMKPresence then
		return nil
	end

	local v10 = useSelector(function(p1) -- line: 22
		-- upvalues: getDeepValue (copy), t1 (copy)
		return getDeepValue(p1, string.format("PYMKCarousel.Presence.byUserId.%s", t1.userId)) or {}
	end)

	return (React.useMemo(function() -- line: 25
		-- upvalues: v10 (copy)
		if v10 and v10.userPresenceType then
			local str = tostring(v10.userPresenceType)

			return (string.gsub(str, "PresenceType%.", ""))
		end

		return "Offline"
	end, { v10 }))
end

return useUserPresence
