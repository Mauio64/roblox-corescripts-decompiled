require("@luauforge/bundled/enl")

local function resolveActorName(p2)
	if p2 == nil then
		return nil
	end

	if p2.displayName ~= nil and p2.displayName ~= "" then
		return p2.displayName
	end

	if p2.username == nil or p2.username == "" then
		return nil
	end

	return p2.username
end

return resolveActorName
