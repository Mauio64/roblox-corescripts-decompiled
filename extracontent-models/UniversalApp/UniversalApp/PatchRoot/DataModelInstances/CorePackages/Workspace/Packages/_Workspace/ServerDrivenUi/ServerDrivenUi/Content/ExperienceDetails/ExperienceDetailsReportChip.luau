local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local SignalsReact = require(Parent.SignalsReact)
local Game = require(Parent.DataHydration).Game
local SduiSharedContent = require(Parent.SduiSharedContent)
local RoactUtils = require(Parent.RoactUtils)
local UniversalAppPolicy = require(Parent.UniversalAppPolicy)
local SharedFlags = require(Parent.SharedFlags)
local CentralOverlay = require(Parent.CentralOverlay)
local Localization = require(Parent.Localization)
local SduiChip = SduiSharedContent.SduiChip
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local useLocalization = Localization.Hooks.useLocalization
local AbuseVector = require(Parent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(Parent.GenericAbuseReporting.OpenDynamicAbuseReport)
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport

local function ExperienceDetailsReportChip(t1: {[any]: any}) -- line: 32
	-- upvalues: useDispatch (copy), useAppPolicy (copy), useLocalization (copy), SignalsReact (copy), Game (copy), React (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), FFlagAddThumbnailSelectorReport (copy), CloseCentralOverlay (copy), SduiChip (copy), Foundation (copy)
	local layoutOrder = t1.layoutOrder
	local universeId = t1.universeId
	local v24 = useDispatch()
	local v25 = useAppPolicy(function(p1) -- line: 37
		return p1.getGameReportingDisabled()
	end)
	local v26 = useLocalization({
		report = "Feature.GameDetails.Action.Report"
	})
	local v27 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local v28 = v27 and v27.rootPlaceId
	local v29 = React.useCallback(function() -- line: 49
		-- upvalues: v28 (copy), v24 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), FFlagAddThumbnailSelectorReport (copy), universeId (copy), CloseCentralOverlay (copy)
		if not v28 then
			return
		end

		v24(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.Place,
			targetId = v28,
			custom = if not FFlagAddThumbnailSelectorReport then nil else {
				universeId = universeId
			},
			onClose = function() -- line: 61
				-- upvalues: v24 (copy), CloseCentralOverlay (copy)
				v24(CloseCentralOverlay())
			end
		}))
	end, {
		universeId,
		v28,
		v24
	})

	if v25 then
		return nil
	end

	return React.createElement(SduiChip, {
		text = v26.report,
		leadingIconName = Foundation.Enums.IconName.Flag,
		onActivated = v29,
		layoutOrder = layoutOrder
	})
end

return React.memo(ExperienceDetailsReportChip)
