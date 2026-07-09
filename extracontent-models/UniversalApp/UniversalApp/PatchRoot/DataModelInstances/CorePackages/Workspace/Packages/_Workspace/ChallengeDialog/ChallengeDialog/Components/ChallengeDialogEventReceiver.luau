local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local ChallengeDialogParent = ChallengeDialog.Parent
local React = require(ChallengeDialogParent.React)
local RoactRodux = require(ChallengeDialogParent.RoactRodux)
local HttpRequest = require(ChallengeDialogParent.HttpRequest)
local NavigateSideways = require(ChallengeDialogParent.NavigationRodux).Thunks.NavigateSideways
local FFlagSignalsNavP3Dispatch = require(ChallengeDialogParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v8 = if not FFlagSignalsNavP3Dispatch then nil else require(ChallengeDialogParent.RobloxAppNavigation).NavigationCommands
local AppPage = require(ChallengeDialogParent.RobloxAppEnums).AppPage
local ModalState = require(ChallengeDialog.Enum.ModalState)
local FetchDialog = require(ChallengeDialog.Thunks.FetchDialog)
local GetFIntLuaAppChallengeDialogEventReceiverRetryIntervalSeconds = require(ChallengeDialog.Flags.GetFIntLuaAppChallengeDialogEventReceiverRetryIntervalSeconds)
local GetFIntLuaAppChallengeDialogEventReceiverRetryTimes = require(ChallengeDialog.Flags.GetFIntLuaAppChallengeDialogEventReceiverRetryTimes)
local GetFFlagLuaAppChallengeDialogFetchDialogConditionally = require(ChallengeDialog.Flags.GetFFlagLuaAppChallengeDialogFetchDialogConditionally)
local FFlagLuaAppDefaultHttpRetry = require(ChallengeDialogParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local v16 = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.RequestInternal,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("ChallengeDialogEventReceiverHttpRetryCount", 4)
})

return RoactRodux.connect(function(_, _) -- line: 129
	return {}
end, function(p3) -- line: 131
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v8 (copy), NavigateSideways (copy), FetchDialog (copy)
	return {
		navigateToPage = function(p4, b1: boolean?) -- line: 135
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v8 (copy), p3 (copy), NavigateSideways (copy)
			if FFlagSignalsNavP3Dispatch then
				return v8.sideways(v8.fromLegacyPage(p4), b1)
			end

			return p3(NavigateSideways(p4, b1))
		end,
		fetchDialog = function(p5) -- line: 142
			-- upvalues: p3 (copy), FetchDialog (copy)
			return p3(FetchDialog(p5))
		end
	}
end)(function(t1: {[any]: any}) -- line: 39
	-- upvalues: v16 (copy), ModalState (copy), AppPage (copy), React (copy), GetFFlagLuaAppChallengeDialogFetchDialogConditionally (copy), GetFIntLuaAppChallengeDialogEventReceiverRetryIntervalSeconds (copy), GetFIntLuaAppChallengeDialogEventReceiverRetryTimes (copy)
	local RobloxEventReceiver = t1.RobloxEventReceiver
	local n1 = 0
	local u20 = false

	local function v21() -- line: 44
		-- upvalues: t1 (copy), v16 (copy), ModalState (copy), AppPage (copy)
		t1.fetchDialog(v16):andThen(function(p6) -- line: 47
			-- upvalues: ModalState (copy), t1 (copy), AppPage (copy)
			local v30 = p6.dialogs[1]

			if v30 ~= nil then
				local v31 = v30.isExpired and ModalState.ChallengeDialogExpired or ModalState.ChallengeDialogApproval

				t1.navigateToPage({
					name = AppPage.ChallengeDialogModalContainer,
					extraProps = {
						modalState = v31,
						dialogItem = v30
					}
				})
			end
		end):catch(function(_) -- line: 61
		end):await()
	end

	React.useEffect(function() -- line: 67
		-- upvalues: RobloxEventReceiver (copy), GetFFlagLuaAppChallengeDialogFetchDialogConditionally (copy), v21 (copy), n1 (ref), u20 (ref), GetFIntLuaAppChallengeDialogEventReceiverRetryIntervalSeconds (copy), GetFIntLuaAppChallengeDialogEventReceiverRetryTimes (copy)
		local t2 = {
			RobloxEventReceiver:observeEvent("signalR", function(p8, _, p10) -- line: 70
				-- upvalues: GetFFlagLuaAppChallengeDialogFetchDialogConditionally (copy), v21 (copy), n1 (ref), u20 (ref)
				if p8 == Enum.ConnectionState.Connected then
					if not GetFFlagLuaAppChallengeDialogFetchDialogConditionally() then
						v21()

						return
					end

					if p10 and p10.ChallengeDialogNotification then
						if n1 ~= p10.ChallengeDialogNotification and not u20 then
							v21()
						end

						n1 = p10.ChallengeDialogNotification
					end
				end
			end),
			RobloxEventReceiver:observeEvent("ChallengeDialogNotification", function(p11) -- line: 87
				-- upvalues: n1 (ref), u20 (ref), v21 (copy)
				n1 = p11.SequenceNumber

				if not u20 then
					v21()
				end
			end),
			RobloxEventReceiver:observeEvent("AppInput", function(_, p13) -- line: 98
				-- upvalues: u20 (ref), GetFIntLuaAppChallengeDialogEventReceiverRetryIntervalSeconds (copy), GetFIntLuaAppChallengeDialogEventReceiverRetryTimes (copy), v21 (copy)
				if p13 == "Focused" then
					u20 = false

					local v39 = GetFIntLuaAppChallengeDialogEventReceiverRetryIntervalSeconds()

					for i = 1, GetFIntLuaAppChallengeDialogEventReceiverRetryTimes() + 1 do
						task.delay(i * v39, v21)
					end

					return
				end

				if p13 == "Unfocused" then
					u20 = true

					return
				end

				u20 = false
			end)
		}

		return function() -- line: 119
			-- upvalues: t2 (copy)
			for _, v in pairs(t2) do
				v:disconnect()
			end
		end
	end, {})

	return nil
end)
