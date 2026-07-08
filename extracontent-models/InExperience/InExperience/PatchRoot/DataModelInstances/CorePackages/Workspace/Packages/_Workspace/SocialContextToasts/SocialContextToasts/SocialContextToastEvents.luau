local Parent = script:FindFirstAncestor("SocialContextToasts").Parent
local t = require(Parent.t)
local mutedError = require(Parent.Loggers).mutedError
local v4 = t.strictInterface({
	toastType = t.string,
	friendId = t.string,
	universeId = t.string,
	placeId = t.string,
	actionType = t.string
})

return function(p1, p2) -- line: 15
	-- upvalues: v4 (copy), mutedError (copy)
	local v7, v8 = v4(p2)

	if not v7 then
		mutedError(v8)
	end

	p1:sendEventDeferred("SocialContextToast", "socialContextToastEvent", p2)
end
