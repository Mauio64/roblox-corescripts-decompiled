local CorePackages = game:GetService("CorePackages")

local AppStorageService = game:GetService("AppStorageService")
local localStorageKey = require("@luauforge/bundled/dFv").Enums.LocalStorageKey
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local receivedDisplayName = require("@luauforge/bundled/ciE").Actions.ReceivedDisplayName

local extended = Roact.Component:extend("DisplayNameEventReceiver")

extended.defaultProps = { appStorageService = AppStorageService }

function extended:init()
	self.tokens = { self.props.RobloxEventReceiver:observeEvent("DisplayNameNotifications", function(p3)
			local userId = p3.UserId
			local newDisplayName = p3.NewDisplayName

			self.props.appStorageService:SetItem(localStorageKey.DisplayName, newDisplayName)
			self.props.appStorageService:Flush()
			self.props.receivedDisplayName(userId, newDisplayName)
		end) }
end

function extended.render(p2): nil
	return nil
end

function extended.willUnmount(p2)
	for k, token in pairs(p2.tokens) do
		token:disconnect()
	end
end

return RoactRodux.connect(function(p2)
	return { localUserId = p2.LocalUserId }
end, function(callback)
	return {
		receivedDisplayName = function(p2, p3)
			callback(receivedDisplayName(p2, p3))
		end
	}
end)(extended)
