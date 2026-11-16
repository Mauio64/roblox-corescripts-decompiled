require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonTypes")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils").Hooks.RoactRodux.useDispatch
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppHooks").useRoactService
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags").AppEventIngestService
local unlockPlayIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryAnalytics").Events.unlockPlayIntent
local openPlayButtonUpsellDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryRouting").OpenPlayButtonUpsellDialog
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/CentralOverlay").Thunks.CloseCentralOverlay
local flaggedMutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Loggers").flaggedMutedError
local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryTypes")
local playableUxTreatmentEnum = DiscoveryTypes.PlayableUxTreatmentEnum
local playabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum
require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/PlayabilityRodux")

local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry
local fFlagLuaAppCloudClientPlayButtonOffer = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppCloudClientPlayButtonOffer

local function asReconfirmLaunchModalData(data)
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

return function(p2, p3, p4, p5)
	local v5 = useRoactService(appEventIngestService)
	local v6 = useDispatch()

	local v7 = React.useCallback(function(p6)
		unlockPlayIntent(v5, {
			universeId = p3,
			upsellName = p6,
			playabilityStatus = p2 and p2.playabilityStatus or nil,
			pageName = p5
		})
	end, { v5, p3, p2, p5 })

	return React.useCallback(function(p6, p7, p8)
		if
			p2
			and p2.playableUxTreatment
			and p2.playableUxTreatment.treatment
			and p2.playabilityStatus == playabilityStatusEnum.Playable
		then
			if p2.playableUxTreatment.treatment == playableUxTreatmentEnum.ReconfirmLaunchModal then
				local data = p2.playableUxTreatment.data

				if data then
					if
						type(data.titleText) ~= "string"
						or type(data.bodyText) ~= "string"
						or type(data.primaryActionText) ~= "string"
						or type(data.secondaryActionText) ~= "string"
					then
						data = nil
					end
				else
					data = nil
				end

				if data then
					v6(openPlayButtonUpsellDialog(
						data.titleText,
						data.bodyText,
						data.primaryActionText,
						data.secondaryActionText,
						function()
							v6(closeCentralOverlay())

							if fFlagLuaAppCloudClientPlayButtonOffer then
								p4(p6, if fFlagLuaAppDemoModePlayButtonTelemetry then p7 else nil, {
									hasShownUpsell = true
								})
							else
								p4(p6, if fFlagLuaAppDemoModePlayButtonTelemetry then p7 else nil)
							end
						end,
						function()
							v6(closeCentralOverlay())
						end,
						function()
							v6(closeCentralOverlay())
						end
					))

					v7("ReconfirmLaunchModal")
				else
					flaggedMutedError(
						"PlayableUxTreatmentMissingData",
						`playableUxTreatment data is missing for treatment {playableUxTreatmentEnum.ReconfirmLaunchModal} on universeId {p3}`
					)

					if fFlagLuaAppCloudClientPlayButtonOffer and p8 ~= nil then
						if not fFlagLuaAppDemoModePlayButtonTelemetry then
							p7 = nil
						end

						p4(p6, p7, p8)
					else
						if not fFlagLuaAppDemoModePlayButtonTelemetry then
							p7 = nil
						end

						p4(p6, p7)
					end

					v7("GameLaunch")
				end
			else
				flaggedMutedError(
					"PlayableUxTreatmentUnsupported",
					`playableUxTreatment treatment {p2.playableUxTreatment.treatment} is unsupported for universeId {p3}`
				)

				if fFlagLuaAppCloudClientPlayButtonOffer and p8 ~= nil then
					if not fFlagLuaAppDemoModePlayButtonTelemetry then
						p7 = nil
					end

					p4(p6, p7, p8)
				else
					if not fFlagLuaAppDemoModePlayButtonTelemetry then
						p7 = nil
					end

					p4(p6, p7)
				end

				v7("GameLaunch")
			end
		elseif fFlagLuaAppCloudClientPlayButtonOffer and p8 ~= nil then
			if not fFlagLuaAppDemoModePlayButtonTelemetry then
				p7 = nil
			end

			p4(p6, p7, p8)
		else
			if not fFlagLuaAppDemoModePlayButtonTelemetry then
				p7 = nil
			end

			p4(p6, p7)
		end
	end, { p2, p3, p4, v7, v6 })
end
