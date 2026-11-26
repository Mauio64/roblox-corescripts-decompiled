local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")

local Game = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration").Game
local SduiSharedContent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UniversalAppPolicy")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags")
local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization")

local sduiChip = SduiSharedContent.SduiChip
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local useLocalization = Localization.Hooks.useLocalization
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GenericAbuseReporting/AbuseVector")
local OpenDynamicAbuseReport = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GenericAbuseReporting/OpenDynamicAbuseReport")

local fFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport

local function ExperienceDetailsReportChip(p2)
	local layoutOrder = p2.layoutOrder
	local universeId = p2.universeId
	local v5 = useDispatch()

	local v6 = useAppPolicy(function(p3)
		return p3.getGameReportingDisabled()
	end)

	local v7 = useLocalization({ report = "Feature.GameDetails.Action.Report" })

	local v8 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local rootPlaceId = v8 and v8.rootPlaceId

	local v9 = React.useCallback(function()
		if not rootPlaceId then
			return
		end

		v5(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.Place,
			targetId = rootPlaceId,
			custom = fFlagAddThumbnailSelectorReport and { universeId = universeId } or nil,
			onClose = function()
				v5(closeCentralOverlay())
			end
		}))
	end, { universeId, rootPlaceId, v5 })

	if v6 then
		return nil
	end

	return React.createElement(sduiChip, {
		text = v7.report,
		leadingIconName = Foundation.Enums.IconName.Flag,
		onActivated = v9,
		layoutOrder = layoutOrder
	})
end

return React.memo(ExperienceDetailsReportChip)
