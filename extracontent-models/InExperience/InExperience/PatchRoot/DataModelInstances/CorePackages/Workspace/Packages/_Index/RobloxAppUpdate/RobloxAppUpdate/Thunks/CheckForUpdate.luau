local RobloxAppUpdate = script:FindFirstAncestor("RobloxAppUpdate")
local RobloxAppUpdateParent = RobloxAppUpdate.Parent
local Dash = require(RobloxAppUpdateParent.Dash)
local joinGamePlayButton = require(RobloxAppUpdateParent.DiscoveryAnalytics).Points.joinGamePlayButton
local SetNetworkingErrorToast = require(RobloxAppUpdateParent.RobloxAppToastsRodux).Thunks.SetNetworkingErrorToast
local OpenCentralOverlayForUpdateRequiredPrompt = require(RobloxAppUpdate.Thunks.OpenCentralOverlayForUpdateRequiredPrompt)
local UpdateMessageType = require(RobloxAppUpdate.UpdateMessageType)

return function(p1, p2, p3, p4, t1: {[any]: any}?) -- line: 18
	-- upvalues: Dash (copy), joinGamePlayButton (copy), SetNetworkingErrorToast (copy), OpenCentralOverlayForUpdateRequiredPrompt (copy), UpdateMessageType (copy)
	return function(p5) -- line: 19
		-- upvalues: p1 (copy), p4 (copy), p2 (copy), t1 (copy), Dash (copy), joinGamePlayButton (copy), p3 (copy), SetNetworkingErrorToast (copy), OpenCentralOverlayForUpdateRequiredPrompt (copy), UpdateMessageType (copy)
		if p1 == nil then
			warn("appUpdateImpl is nil")

			if p4 then
				p4()
			end

			return
		end

		if not p2 or p1:canPerformBinaryUpdate() then
			p1:checkForUpdate():andThen(function(p6) -- line: 28
				-- upvalues: t1 (copy), Dash (copy), joinGamePlayButton (copy), p3 (copy), p5 (copy), SetNetworkingErrorToast (copy), OpenCentralOverlayForUpdateRequiredPrompt (copy), p1 (copy), UpdateMessageType (copy), p4 (copy)
				local appUpdateStatus = p6.appUpdateStatus
				local t2 = {
					appUpdateStatus = appUpdateStatus
				}

				if t1 then
					t2 = Dash.join(t2, t1)
				end

				joinGamePlayButton(p3.InfluxDb, "checkForUpdate", t2)

				if p6.errorMessage then
					warn(p6.errorMessage)
					p5:dispatch(SetNetworkingErrorToast({
						HttpError = Enum.HttpError.OK
					}))

					return
				end

				if appUpdateStatus == Enum.AppUpdateStatus.Available then
					p5:dispatch(OpenCentralOverlayForUpdateRequiredPrompt(p1:canPerformBinaryUpdate(), false, UpdateMessageType.Default))

					return
				end

				if appUpdateStatus == Enum.AppUpdateStatus.AvailableBoundChannel then
					p5:dispatch(OpenCentralOverlayForUpdateRequiredPrompt(p1:canPerformBinaryUpdate(), false, UpdateMessageType.InternalChannel))

					return
				end

				if appUpdateStatus == Enum.AppUpdateStatus.AvailableBetaProgram then
					p5:dispatch(OpenCentralOverlayForUpdateRequiredPrompt(p1:canPerformBinaryUpdate(), false, UpdateMessageType.BetaProgram))

					return
				end

				if p4 then
					p4()
				end
			end)

			return
		end

		if p4 then
			p4()
		end
	end
end
