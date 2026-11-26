local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagUseSignalsForModeration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForModeration

local module = require("@luauforge/bundled/dzP")
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Actions.SetCentralOverlay
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").CentralOverlayType
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local module2 = require("@luauforge/bundled/ggi")
local module3 = require("@luauforge/bundled/dKv")

local setModerationStatus = require("@luauforge/bundled/guU").SetModerationStatus
local constants = require("@luauforge/bundled/guU").Constants

local getModerationStore = if fFlagUseSignalsForModeration then require("@luauforge/bundled/guU").GetModerationStore else nil

local function ModerationEventReceiver(): nil
	local v5 = useDispatch()
	local v6

	if fFlagUseSignalsForModeration then
		local moderationStore = getModerationStore(false)
		local v7 = useSignalState(moderationStore.getUserModerated)
		local v8 = useSignalState(moderationStore.getModerationDetail)
		v6 = React.useMemo(function()
			return { userModerated = v7, moderationDetail = v8 }
		end, { v7, v8 })
	else
		v6 = useSelector(function(p2)
			return p2.Moderation
		end)
	end

	React.useEffect(function()
		if not (v6 and v6.userModerated and v6.moderationDetail) then
			return
		end

		local moderationDetail = v6.moderationDetail
		local punishmentTypeDescription = moderationDetail.punishmentTypeDescription
		local v7 = constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP[punishmentTypeDescription]

		module.isNotNil(v7, "interventionType should not be nil")

		if v7 == nil then
			mutedError("ModerationEventReceiver Got Invalid Moderation Type: `" .. tostring(punishmentTypeDescription) .. "`")
			v7 = constants.INTERVENTION_TYPES.None
		end

		if v7 == constants.INTERVENTION_TYPES.None then
			if fFlagUseSignalsForModeration then
				getModerationStore(false).setModerationStatus(false)
			else
				v5(setModerationStatus(false))
			end
		elseif moderationDetail.selfServiceDeactivated == true then
			v5(setCentralOverlay(centralOverlayType.AccountReactivationPrompt, {
				moderationDetail = moderationDetail,
				interventionType = v7,
				LogoutThunk = module2
			}))
		else
			v5(module3({
				{
					name = appPage.NotApprovedPage,
					extraProps = {
						moderationDetail = moderationDetail,
						interventionType = v7,
						LogoutThunk = module2
					}
				}
			}))
		end
	end, { v6 })

	return nil
end

return ModerationEventReceiver
