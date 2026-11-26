local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Signals")
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ToastRodux").Actions.SetCurrentToastMessage

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

local function SduiJoinCommunityAction(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.JoinCommunity, message = "Missing action params" },
			p4.appPage
		)
		return
	end

	local communityId = actionParams.communityId

	if communityId == nil or typeof(communityId) ~= "string" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.JoinCommunity,
				message = "Missing actionParam: communityId",
				propName = "communityId"
			},
			p4.appPage
		)
		return
	end

	local joinCommunity = DataHydration.CommunityUserMembership.getCommunityUserMembershipStore(false).joinCommunity(communityId)

	local dispatch = p4.dependencies.dispatch
	local v5 = {}
	v5.dispose = Signals.createEffect(function(p6)
		local v6 = joinCommunity(p6)

		if v6 == nil then
			return
		end

		if v6.type == "error" then
			dispatch(setCurrentToastMessage({
				toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong"
			}))
		end

		local dispose = v5.dispose

		if dispose then
			dispose()
			v5.dispose = nil
		end
	end)
end

return SduiJoinCommunityAction
