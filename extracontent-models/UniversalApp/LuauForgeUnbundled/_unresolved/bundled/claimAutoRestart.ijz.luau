local luaAppRootErrorLastAutoRestart = require("@luauforge/bundled/dCq").Enums.LocalStorageKey.LuaAppRootErrorLastAutoRestart

local function claimAutoRestart(object, p2, p3): string
	local success, item = pcall(object.GetItem, object, luaAppRootErrorLastAutoRestart)

	if not success then
		return "storage_unavailable"
	end

	local v5 = tonumber(item)

	if v5 and p2 - v5 < p3 then
		return "cooldown"
	end

	if pcall(function()
		object:SetItem(luaAppRootErrorLastAutoRestart, (tostring(p2)))
		object:Flush()
	end) then
		return "claimed"
	end

	return "storage_unavailable"
end

return claimAutoRestart
