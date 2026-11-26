local CorePackages = game:GetService("CorePackages")

local MemStorageService = game:GetService("MemStorageService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local module2 = require("@luauforge/bundled/gfK")

local module3 = require("@luauforge/bundled/ggi")
local module4 = require("@luauforge/bundled/ggp")

local extended = Roact.Component:extend("NativeShellEventReceiver")

function extended:didMount()
	local networking = self.props.networking
	local guiService = self.props.guiService

	self.connections = { MemStorageService:bind(module2.NativeShellEvent, function(p3)
			if p3 == "NETWORK_ERROR_401" then
				self.props.logout(networking, guiService)
			end

			MemStorageService:RemoveItem(module2.NativeShellEvent)
		end) }
end

function extended.render(p2) end

function extended.willUnmount(p2)
	for k, connection in pairs(p2.connections) do
		connection:Disconnect()
	end
end

local v5 = RoactRodux.connect(nil, function(callback)
	return {
		logout = function(p2, p3)
			callback(module3(p2, p3, module4.NativeSessionCheck))
		end
	}
end)(extended)

return (roactServices.connect({ guiService = appGuiService, networking = module })(v5))
