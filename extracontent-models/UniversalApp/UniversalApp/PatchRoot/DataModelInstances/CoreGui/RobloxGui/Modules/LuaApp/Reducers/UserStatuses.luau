local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Immutable = require(Modules.Common.Immutable)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local FetchingUser = require(Modules.LuaApp.Actions.FetchingUser)
local AddUser = require(Modules.LuaApp.Actions.AddUser)

return function(t1: {[any]: any}?, p1) -- line: 13
	-- upvalues: FetchingUser (copy), Immutable (copy), AddUser (copy), RetrievalStatus (copy)
	local v8 = t1 or {}

	assert(v8, "")

	if p1.type == FetchingUser.name then
		return (Immutable.Set(v8, p1.userId, p1.status))
	end

	if p1.type == AddUser.name then
		v8 = Immutable.Set(v8, p1.user.id, RetrievalStatus.Done)
	end

	return v8
end
