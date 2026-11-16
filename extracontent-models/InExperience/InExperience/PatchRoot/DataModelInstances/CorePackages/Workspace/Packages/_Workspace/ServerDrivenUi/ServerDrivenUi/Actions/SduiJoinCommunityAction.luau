local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local DataHydration = require(parent.DataHydration)
local Signals = require(parent.Signals)
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local function SduiJoinCommunityAction(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.JoinCommunity, message = "Missing action params" },
			p2.appPage
		)
		return
	end

	local communityId = actionParams.communityId

	if communityId == nil or typeof(communityId) ~= "string" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.JoinCommunity,
				message = "Missing actionParam: communityId",
				propName = "communityId"
			},
			p2.appPage
		)
		return
	end

	local joinCommunity = DataHydration.CommunityUserMembership.getCommunityUserMembershipStore(false).joinCommunity(communityId)

	local dispatch = p2.dependencies.dispatch
	local v = {}
	v.dispose = Signals.createEffect(function(p3)
		local v2 = joinCommunity(p3)

		if v2 == nil then
			return
		end

		if v2.type == "error" then
			dispatch(SetCurrentToastMessage({
				toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong"
			}))
		end

		local dispose = v.dispose

		if dispose then
			dispose()
			v.dispose = nil
		end
	end)
end

return SduiJoinCommunityAction
