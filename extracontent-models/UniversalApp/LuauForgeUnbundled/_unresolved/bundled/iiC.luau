local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local module = require("@luauforge/bundled/fCy")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/egx")
local module3 = require("@luauforge/bundled/dzO")

local extended = Roact.Component:extend("RobuxEventReceiver")

function extended:init()
	self.isMounted = false

	local robloxEventReceiver = self.props.RobloxEventReceiver

	function self.updateRobux()
		local localUserId = self.props.localUserId
		local requestRobuxInfo = self.props.requestRobuxInfo
		local networking = self.props.networking

		module3.isNonEmptyString(localUserId, "RobuxEventReceiver.updateRobux.localUserId")

		if typeof(localUserId) == "string" and localUserId ~= "" then
			requestRobuxInfo(networking, localUserId)
		end
	end

	self.tokens = { robloxEventReceiver:observeEvent("AppInput", function(p2, p3)
			if p3 == "Focused" then
				delay(3, function()
					if not self.isMounted then
						return
					end

					self.updateRobux()
				end)
			end
		end) }
end

function extended.render(p2)
	return Roact.oneChild(p2.props[Roact.Children])
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	for k, token in pairs(self.tokens) do
		token:disconnect()
	end

	self.isMounted = false
end

local v5 = RoactRodux.connect(function(p2, p3)
	return { localUserId = p2.LocalUserId }
end, function(callback)
	return {
		requestRobuxInfo = function(p2, p3)
			return callback(module(p2, p3, true))
		end
	}
end)(extended)

return roactServices.connect({ networking = module2 })(v5)
