local parent = script:FindFirstAncestor("SocialContextToasts").Parent

local t = require(parent.t)
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError

local strictInterface = t.strictInterface({
	toastType = t.string,
	friendId = t.string,
	universeId = t.string,
	placeId = t.string,
	actionType = t.string
})

return function(object, p)
	local v, v2 = strictInterface(p)

	if not v then
		mutedError(v2)
	end

	object:sendEventDeferred("SocialContextToast", "socialContextToastEvent", p)
end
