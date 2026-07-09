local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local MemStorageService = game:GetService("MemStorageService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)
local v12 = Roact.Component:extend("NativeShellEventReceiver")

function v12.didMount(p1) -- line: 21
	-- upvalues: MemStorageService (copy), MemStorageKeys (copy)
	local networking = p1.props.networking
	local guiService = p1.props.guiService

	p1.connections = { MemStorageService:bind(MemStorageKeys.NativeShellEvent, function(p2) -- line: 26
		-- upvalues: p1 (copy), networking (copy), guiService (copy), MemStorageService (copy), MemStorageKeys (copy)
		if p2 == "NETWORK_ERROR_401" then
			p1.props.logout(networking, guiService)
		end

		MemStorageService:RemoveItem(MemStorageKeys.NativeShellEvent)
	end) }
end
function v12.render(_) -- line: 35
end
function v12.willUnmount(p4) -- line: 37
	for _, v in pairs(p4.connections) do
		v:Disconnect()
	end
end

local v13 = RoactRodux.connect(nil, function(p5) -- line: 43
	-- upvalues: Logout (copy), luaLogoutReasonNames (copy)
	return {
		logout = function(p6, p7) -- line: 45
			-- upvalues: p5 (copy), Logout (copy), luaLogoutReasonNames (copy)
			p5(Logout(p6, p7, luaLogoutReasonNames.NativeSessionCheck))
		end
	}
end)(v12)

return (RoactServices.connect({
	guiService = AppGuiService,
	networking = RoactNetworking
})(v13))
