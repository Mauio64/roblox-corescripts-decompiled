local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/CloudClientOffer/CentralOverlay")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CloudClientOffer/Signals")
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/CloudClientOffer/RobloxAppEnums").CentralOverlayType

require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/createCloudClientOffer")

local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay

local function OpenCloudClientOfferSheet(data, p2)
	return function(object)
		local flag = false
		local function closeThen(callback)
			return function()
				if flag then
					return
				end

				flag = true
				object:dispatch(closeCentralOverlay())
				callback()
			end
		end

		local v5 = nil
		local cloudClientOfferSheet = centralOverlayType.CloudClientOfferSheet
		local v7 = {
			offerKind = p2.kind,
			onAccept = 0,
			onDecline = 0,
			onDismiss = 0,
			onUnmount = 0
		}
		local accept = data.accept

		function v7.onAccept()
			if flag then
				return
			end

			flag = true
			object:dispatch(closeCentralOverlay())
			accept()
		end
		local decline = data.decline

		function v7.onDecline()
			if flag then
				return
			end

			flag = true
			object:dispatch(closeCentralOverlay())
			decline()
		end
		local dismiss = data.dismiss

		function v7.onDismiss()
			if flag then
				return
			end

			flag = true
			object:dispatch(closeCentralOverlay())
			dismiss()
		end
		function v7.onUnmount()
			if v5 ~= nil then
				v5()
				v5 = nil
			end

			if not flag then
				flag = true
				data.dismiss()
			end
		end

		object:dispatch(setCentralOverlay(cloudClientOfferSheet, v7))

		v5 = Signals.createEffect(function(p3)
			if data.getHeldOffer(p3) == nil and not flag then
				flag = true
				object:dispatch(closeCentralOverlay())
			end
		end)
	end
end

return OpenCloudClientOfferSheet
