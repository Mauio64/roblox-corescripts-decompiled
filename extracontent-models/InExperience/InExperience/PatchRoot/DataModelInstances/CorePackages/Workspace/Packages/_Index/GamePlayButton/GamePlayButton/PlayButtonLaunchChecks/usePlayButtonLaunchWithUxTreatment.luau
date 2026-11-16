local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
require(GamePlayButton.PlayButtonTypes)

local parent = GamePlayButton.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local unlockPlayIntent = DiscoveryAnalytics.Events.unlockPlayIntent
local DiscoveryRouting = require(parent.DiscoveryRouting)
local OpenPlayButtonUpsellDialog = DiscoveryRouting.OpenPlayButtonUpsellDialog
local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local Loggers = require(parent.Loggers)
local flaggedMutedError = Loggers.flaggedMutedError
local DiscoveryTypes = require(parent.DiscoveryTypes)
local PlayableUxTreatmentEnum = DiscoveryTypes.PlayableUxTreatmentEnum
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum
require(parent.PlayabilityRodux)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppCloudClientPlayButtonOffer = SharedFlags2.FFlagLuaAppCloudClientPlayButtonOffer

local function asReconfirmLaunchModalData(data) -- 1 equivalent call inferred from this helper
	if not data then
		return nil
	end

	if
		type(data.titleText) == "string"
		and type(data.bodyText) == "string"
		and type(data.primaryActionText) == "string"
		and type(data.secondaryActionText) == "string"
	then
		return data
	end

	return nil
end

return function(p, universeId, callback, pageName: string?)
	local v = useRoactService(AppEventIngestService)
	local v2 = useDispatch()

	local v3 = React.useCallback(function(upsellName)
		unlockPlayIntent(v, {
			universeId = universeId,
			upsellName = upsellName,
			playabilityStatus = p and p.playabilityStatus or nil,
			pageName = pageName
		})
	end, { v, universeId, p, pageName })

	return React.useCallback(function(p2, p3: string?, p4)
		if
			p
			and p.playableUxTreatment
			and p.playableUxTreatment.treatment
			and p.playabilityStatus == PlayabilityStatusEnum.Playable
		then
			if p.playableUxTreatment.treatment == PlayableUxTreatmentEnum.ReconfirmLaunchModal then
				local reconfirmLaunchModalData = asReconfirmLaunchModalData(p.playableUxTreatment.data) -- inferred equivalent call

				if reconfirmLaunchModalData then
					v2(OpenPlayButtonUpsellDialog(
						reconfirmLaunchModalData.titleText,
						reconfirmLaunchModalData.bodyText,
						reconfirmLaunchModalData.primaryActionText,
						reconfirmLaunchModalData.secondaryActionText,
						function()
							v2(CloseCentralOverlay())

							if FFlagLuaAppCloudClientPlayButtonOffer then
								local v4

								if FFlagLuaAppDemoModePlayButtonTelemetry then
									v4 = p3
								end

								callback(p2, v4, { hasShownUpsell = true })
							else
								local v4

								if FFlagLuaAppDemoModePlayButtonTelemetry then
									v4 = p3
								end

								callback(p2, v4)
							end
						end,
						function()
							v2(CloseCentralOverlay())
						end,
						function()
							v2(CloseCentralOverlay())
						end
					))

					v3("ReconfirmLaunchModal")
				else
					flaggedMutedError(
						"PlayableUxTreatmentMissingData",
						`playableUxTreatment data is missing for treatment {PlayableUxTreatmentEnum.ReconfirmLaunchModal} on universeId {universeId}`
					)

					if FFlagLuaAppCloudClientPlayButtonOffer and p4 ~= nil then
						if not FFlagLuaAppDemoModePlayButtonTelemetry then
							p3 = nil
						end

						callback(p2, p3, p4)
					else
						if not FFlagLuaAppDemoModePlayButtonTelemetry then
							p3 = nil
						end

						callback(p2, p3)
					end

					v3("GameLaunch")
				end
			else
				flaggedMutedError(
					"PlayableUxTreatmentUnsupported",
					`playableUxTreatment treatment {p.playableUxTreatment.treatment} is unsupported for universeId {universeId}`
				)

				if FFlagLuaAppCloudClientPlayButtonOffer and p4 ~= nil then
					if not FFlagLuaAppDemoModePlayButtonTelemetry then
						p3 = nil
					end

					callback(p2, p3, p4)
				else
					if not FFlagLuaAppDemoModePlayButtonTelemetry then
						p3 = nil
					end

					callback(p2, p3)
				end

				v3("GameLaunch")
			end
		elseif FFlagLuaAppCloudClientPlayButtonOffer and p4 ~= nil then
			if not FFlagLuaAppDemoModePlayButtonTelemetry then
				p3 = nil
			end

			callback(p2, p3, p4)
		else
			if not FFlagLuaAppDemoModePlayButtonTelemetry then
				p3 = nil
			end

			callback(p2, p3)
		end
	end, { p, universeId, callback, v3, v2 })
end
