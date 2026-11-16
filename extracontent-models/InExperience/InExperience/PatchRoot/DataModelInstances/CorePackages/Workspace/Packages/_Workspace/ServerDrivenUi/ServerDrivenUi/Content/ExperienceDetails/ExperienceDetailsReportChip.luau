local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SignalsReact = require(parent.SignalsReact)

local DataHydration = require(parent.DataHydration)
local Game = DataHydration.Game
local SduiSharedContent = require(parent.SduiSharedContent)
local RoactUtils = require(parent.RoactUtils)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local SharedFlags = require(parent.SharedFlags)
local CentralOverlay = require(parent.CentralOverlay)
local Localization = require(parent.Localization)

local SduiChip = SduiSharedContent.SduiChip
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local useLocalization = Localization.Hooks.useLocalization
local AbuseVector = require(parent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(parent.GenericAbuseReporting.OpenDynamicAbuseReport)

local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport

local function ExperienceDetailsReportChip(p)
	local layoutOrder = p.layoutOrder
	local universeId = p.universeId
	local v = useDispatch()

	local v2 = useAppPolicy(function(p2)
		return p2.getGameReportingDisabled()
	end)

	local v3 = useLocalization({ report = "Feature.GameDetails.Action.Report" })

	local v4 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local rootPlaceId = v4 and v4.rootPlaceId

	local onActivated = React.useCallback(function()
		if not rootPlaceId then
			return
		end

		v(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.Place,
			targetId = rootPlaceId,
			custom = FFlagAddThumbnailSelectorReport and { universeId = universeId } or nil,
			onClose = function()
				v(CloseCentralOverlay())
			end
		}))
	end, { universeId, rootPlaceId, v })

	if v2 then
		return nil
	end

	return React.createElement(SduiChip, {
		text = v3.report,
		leadingIconName = Foundation.Enums.IconName.Flag,
		onActivated = onActivated,
		layoutOrder = layoutOrder
	})
end

return React.memo(ExperienceDetailsReportChip)
