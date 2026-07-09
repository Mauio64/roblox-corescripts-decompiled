local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local LuaApp = Modules.LuaApp
local OpenCentralOverlayForPeopleList = require(LuaApp.Thunks.OpenCentralOverlayForPeopleList)
local OpenProfilePeekView = require(Modules.LuaApp.Thunks.OpenProfilePeekView)
local UserModel = require(CorePackages.Workspace.Packages.UserLib).Models.UserModel

local function v7(p1, s1: string) -- line: 22
	-- upvalues: UserModel (copy)
	local v10 = p1 and p1.Users[s1] or {}

	return v10.presence == UserModel.PresenceType.IN_GAME and v10.lastLocation
end

return function(s2: string, t1: {[any]: any}) -- line: 27
	-- upvalues: v7 (copy), OpenCentralOverlayForPeopleList (copy), OpenProfilePeekView (copy)
	return function(p2) -- line: 28
		-- upvalues: t1 (copy), v7 (copy), s2 (copy), OpenCentralOverlayForPeopleList (copy), OpenProfilePeekView (copy)
		local v14 = p2:getState()
		local v15 = t1.userInGame or v7

		if t1.openJoinable and (t1.contextualMenuProps and v15(v14, s2)) then
			p2:dispatch(OpenCentralOverlayForPeopleList(t1.contextualMenuProps))

			return
		end

		p2:dispatch(OpenProfilePeekView(s2, t1.profilePeekViewProps))
	end
end
