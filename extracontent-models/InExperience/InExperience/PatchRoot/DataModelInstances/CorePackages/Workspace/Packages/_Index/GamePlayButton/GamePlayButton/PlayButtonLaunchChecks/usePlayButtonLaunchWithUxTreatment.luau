local GamePlayButton = script:FindFirstAncestor("GamePlayButton")

require(GamePlayButton.PlayButtonTypes)

local GamePlayButtonParent = GamePlayButton.Parent
local React = require(GamePlayButtonParent.React)
local useDispatch = require(GamePlayButtonParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(GamePlayButtonParent.RobloxAppHooks).useRoactService
local AppEventIngestService = require(GamePlayButtonParent.RoactServiceTags).AppEventIngestService
local unlockPlayIntent = require(GamePlayButtonParent.DiscoveryAnalytics).Events.unlockPlayIntent
local OpenUpsellModal = require(GamePlayButtonParent.DiscoveryRouting).OpenUpsellModal
local OpenPlayButtonUpsellDialog = require(GamePlayButtonParent.DiscoveryRouting).OpenPlayButtonUpsellDialog
local CloseCentralOverlay = require(GamePlayButtonParent.CentralOverlay).Thunks.CloseCentralOverlay
local flaggedMutedError = require(GamePlayButtonParent.Loggers).flaggedMutedError
local DiscoveryTypes = require(GamePlayButtonParent.DiscoveryTypes)
local PlayableUxTreatmentEnum = DiscoveryTypes.PlayableUxTreatmentEnum
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum

require(GamePlayButtonParent.PlayabilityRodux)

local FFlagLuaAppPlayButtonUpsellLinking = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppPlayButtonUpsellLinking
local FFlagLuaAppLogPageContextUnlockPlayIntent = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppLogPageContextUnlockPlayIntent
local FFlagLuaAppDemoModePlayButtonTelemetry = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppDemoModePlayButtonTelemetry

local function asReconfirmLaunchModalData(t1: {[any]: any}?) -- line: 24
	if not t1 then
		return nil
	end

	if type(t1.titleText) ~= "string" or type(t1.bodyText) ~= "string" or type(t1.primaryActionText) ~= "string" or type(t1.secondaryActionText) ~= "string" then
		return nil
	end

	return t1
end

return function(p1, p2, p3, s1: string?) -- line: 48
	-- upvalues: useRoactService (copy), AppEventIngestService (copy), useDispatch (copy), React (copy), unlockPlayIntent (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), PlayabilityStatusEnum (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), PlayableUxTreatmentEnum (copy), flaggedMutedError (copy), FFlagLuaAppPlayButtonUpsellLinking (copy), OpenPlayButtonUpsellDialog (copy), CloseCentralOverlay (copy), OpenUpsellModal (copy)
	local v24 = useRoactService(AppEventIngestService)
	local v25 = useDispatch()
	local v26 = React.useCallback(function(p4) -- line: 57
		-- upvalues: unlockPlayIntent (copy), v24 (copy), p2 (copy), p1 (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), s1 (copy)
		unlockPlayIntent(v24, {
			universeId = p2,
			upsellName = p4,
			playabilityStatus = p1 and p1.playabilityStatus or nil,
			pageName = if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s1
		})
	end, {
		v24,
		p2,
		p1,
		if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s1
	})

	return React.useCallback(function(p5, s2: string?) -- line: 72
		-- upvalues: p1 (copy), PlayabilityStatusEnum (copy), p3 (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), PlayableUxTreatmentEnum (copy), flaggedMutedError (copy), p2 (copy), v26 (copy), FFlagLuaAppPlayButtonUpsellLinking (copy), v25 (copy), OpenPlayButtonUpsellDialog (copy), CloseCentralOverlay (copy), OpenUpsellModal (copy)
		if not p1 or (not p1.playableUxTreatment or not p1.playableUxTreatment.treatment or p1.playabilityStatus ~= PlayabilityStatusEnum.Playable) then
			p3(p5, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s2)

			return
		end

		if p1.playableUxTreatment.treatment == PlayableUxTreatmentEnum.ReconfirmLaunchModal then
			local data = p1.playableUxTreatment.data
			local v31 = if data then if type(data.titleText) == "string" and (type(data.bodyText) == "string" and (type(data.primaryActionText) == "string" and type(data.secondaryActionText) == "string")) then data else nil else nil

			if not v31 then
				flaggedMutedError("PlayableUxTreatmentMissingData", `playableUxTreatment data is missing for treatment { PlayableUxTreatmentEnum.ReconfirmLaunchModal } on universeId { p2 }`)
				p3(p5, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s2)
				v26("GameLaunch")

				return
			end

			if FFlagLuaAppPlayButtonUpsellLinking then
				v25(OpenPlayButtonUpsellDialog(v31.titleText, v31.bodyText, v31.primaryActionText, v31.secondaryActionText, function() -- line: 107
					-- upvalues: v25 (copy), CloseCentralOverlay (copy), p3 (copy), p5 (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), s2 (copy)
					v25(CloseCentralOverlay())
					p3(p5, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s2)
				end, function() -- line: 114
					-- upvalues: v25 (copy), CloseCentralOverlay (copy)
					v25(CloseCentralOverlay())
				end, function() -- line: 117
					-- upvalues: v25 (copy), CloseCentralOverlay (copy)
					v25(CloseCentralOverlay())
				end))
			else
				v25(OpenUpsellModal(v31.titleText, v31.bodyText, v31.primaryActionText, v31.secondaryActionText, function() -- line: 129
					-- upvalues: v25 (copy), CloseCentralOverlay (copy), p3 (copy), p5 (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), s2 (copy)
					v25(CloseCentralOverlay())
					p3(p5, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s2)
				end, function() -- line: 136
					-- upvalues: v25 (copy), CloseCentralOverlay (copy)
					v25(CloseCentralOverlay())
				end, function() -- line: 139
					-- upvalues: v25 (copy), CloseCentralOverlay (copy)
					v25(CloseCentralOverlay())
				end))
			end

			v26("ReconfirmLaunchModal")

			return
		end

		flaggedMutedError("PlayableUxTreatmentUnsupported", `playableUxTreatment treatment { p1.playableUxTreatment.treatment } is unsupported for universeId { p2 }`)
		p3(p5, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s2)
		v26("GameLaunch")
	end, {
		p1,
		p2,
		p3,
		v26,
		v25
	})
end
