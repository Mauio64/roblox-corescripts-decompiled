local ParentParent = script.Parent.Parent

game:GetService("Players")
require(ParentParent.Actions.ErrorOccurred)
require(ParentParent.Actions.SetPromptState)

local UpsellFlow = require(ParentParent.Enums.UpsellFlow)

require(ParentParent.Enums.PromptState)
require(ParentParent.Enums.PurchaseError)

local hideWindow = require(ParentParent.Thunks.hideWindow)
local getUpsellFlow = require(ParentParent.NativeUpsell.getUpsellFlow)
local Analytics = require(ParentParent.Services.Analytics)
local ExternalSettings = require(ParentParent.Services.ExternalSettings)
local Network = require(ParentParent.Services.Network)
local PlatformInterface = require(ParentParent.Services.PlatformInterface)
local Thunk = require(ParentParent.Thunk)

require(ParentParent.Promise)

local t1 = {
	Analytics,
	ExternalSettings,
	Network,
	PlatformInterface
}

local function openSecuritySettings(s1: string?) -- line: 26
	-- upvalues: Thunk (copy), t1 (copy), Analytics (copy), ExternalSettings (copy), PlatformInterface (copy), getUpsellFlow (copy), UpsellFlow (copy), hideWindow (copy)
	return Thunk.new(script.Name, t1, function(p1, p2) -- line: 27
		-- upvalues: Analytics (copy), ExternalSettings (copy), PlatformInterface (copy), getUpsellFlow (copy), UpsellFlow (copy), s1 (copy), hideWindow (copy)
		local v15 = p2[Analytics]
		local v16 = p2[ExternalSettings]
		local v17 = p2[PlatformInterface]
		local v18 = p1:getState()

		if getUpsellFlow(v16.getPlatform()) == UpsellFlow.Web then
			local productId = v18.productInfo.productId
			local requestType = v18.requestType

			v15.signalTwoSVSettingsErrorConfirmed(productId, requestType)

			if s1 then
				v17.openSecuritySettings(s1)
			else
				v17.openSecuritySettings()
			end
		end

		p1:dispatch(hideWindow())
	end)
end

return openSecuritySettings
