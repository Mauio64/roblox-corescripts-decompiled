local CloudClientOffer = script:FindFirstAncestor("CloudClientOffer")
local parent = CloudClientOffer.Parent

local CentralOverlay = require(parent.CentralOverlay)
local Signals = require(parent.Signals)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType

require(CloudClientOffer.createCloudClientOffer)

local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay

local function OpenCloudClientOfferSheet(data, p)
	return function(object)
		local flag = false
		local function closeThen(callback) -- 3 equivalent calls inferred from this helper
			return function()
				if flag then
					return
				end

				flag = true
				object:dispatch(CloseCentralOverlay())
				callback()
			end
		end

		local v = nil
		object:dispatch(SetCentralOverlay(CentralOverlayType.CloudClientOfferSheet, {
			offerKind = p.kind,
			onAccept = closeThen(data.accept), -- inferred equivalent call
			onDecline = closeThen(data.decline), -- inferred equivalent call
			onDismiss = closeThen(data.dismiss), -- inferred equivalent call
			onUnmount = function()
				if v ~= nil then
					v()
					v = nil
				end

				if not flag then
					flag = true
					data.dismiss()
				end
			end
		}))

		v = Signals.createEffect(function(p2)
			if data.getHeldOffer(p2) == nil and not flag then
				flag = true
				object:dispatch(CloseCentralOverlay())
			end
		end)
	end
end

return OpenCloudClientOfferSheet
