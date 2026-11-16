local parent = script.Parent.Parent
game:GetService("Players")

require(parent.Actions.ErrorOccurred)
require(parent.Actions.SetPromptState)
local UpsellFlow = require(parent.Enums.UpsellFlow)
require(parent.Enums.PromptState)
require(parent.Enums.PurchaseError)
local hideWindow = require(parent.Thunks.hideWindow)
local getUpsellFlow = require(parent.NativeUpsell.getUpsellFlow)
local Analytics = require(parent.Services.Analytics)
local ExternalSettings = require(parent.Services.ExternalSettings)
local Network = require(parent.Services.Network)
local PlatformInterface = require(parent.Services.PlatformInterface)
local Thunk = require(parent.Thunk)
require(parent.Promise)

local v = { Analytics, ExternalSettings, Network, PlatformInterface }

local function openSecuritySettings(p: string?)
	return Thunk.new(script.Name, v, function(object, p2)
		local v2 = p2[Analytics]
		local v3 = p2[ExternalSettings]
		local v4 = p2[PlatformInterface]
		local state = object:getState()

		if getUpsellFlow(v3.getPlatform()) == UpsellFlow.Web then
			local productId = state.productInfo.productId
			local requestType = state.requestType

			v2.signalTwoSVSettingsErrorConfirmed(productId, requestType)

			if p then
				v4.openSecuritySettings(p)
			else
				v4.openSecuritySettings()
			end
		end

		object:dispatch(hideWindow())
	end)
end

return openSecuritySettings
