local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local ChallengeDialogParent = ChallengeDialog.Parent
local React = require(ChallengeDialogParent.React)
local RoactRodux = require(ChallengeDialogParent.RoactRodux)
local Cryo = require(ChallengeDialogParent.Cryo)
local HttpRequest = require(ChallengeDialogParent.HttpRequest)
local NavigateBack = require(ChallengeDialogParent.NavigationRodux).Thunks.NavigateBack
local FFlagSignalsNavP3Dispatch = require(ChallengeDialogParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(ChallengeDialogParent.RobloxAppNavigation).NavigationCommands
local ModalState = require(ChallengeDialog.Enum.ModalState)
local ModalChallengeDialogAlreadyCompleted = require(ChallengeDialog.Components.ModalChallengeDialogAlreadyCompleted)
local ModalChallengeDialogApproval = require(ChallengeDialog.Components.ModalChallengeDialogApproval)
local ModalChallengeDialogDenied = require(ChallengeDialog.Components.ModalChallengeDialogDenied)
local ModalChallengeDialogExpired = require(ChallengeDialog.Components.ModalChallengeDialogExpired)
local FetchDialog = require(ChallengeDialog.Thunks.FetchDialog)
local GetFIntLuaAppChallengeDialogPollingIntervalSeconds = require(ChallengeDialog.Flags.GetFIntLuaAppChallengeDialogPollingIntervalSeconds)
local EventService = require(ChallengeDialog.Analytics.EventService)
local FFlagLuaAppDefaultHttpRetry = require(ChallengeDialogParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local v19 = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.RequestInternal,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("ChallengeDialogModalContainerHttpRetryCount", 4)
})
local t1 = {
	[ModalState.ChallengeDialogApproval] = ModalChallengeDialogApproval,
	[ModalState.ChallengeDialogDenied] = ModalChallengeDialogDenied,
	[ModalState.ChallengeDialogExpired] = ModalChallengeDialogExpired,
	[ModalState.ChallengeDialogAlreadyCompleted] = ModalChallengeDialogAlreadyCompleted
}

return RoactRodux.connect(function(_, _) -- line: 128
	return {}
end, function(p3) -- line: 130
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateBack (copy), FetchDialog (copy)
	return {
		navigateBack = function() -- line: 132
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), p3 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v9.back()
			end

			return p3(NavigateBack())
		end,
		fetchDialog = function(p4) -- line: 139
			-- upvalues: p3 (copy), FetchDialog (copy)
			return p3(FetchDialog(p4))
		end
	}
end)(function(p5) -- line: 41
	-- upvalues: React (copy), ModalState (copy), EventService (copy), v19 (copy), GetFIntLuaAppChallengeDialogPollingIntervalSeconds (copy), t1 (copy), Cryo (copy)
	local v22, v23 = React.useState(p5)

	React.useEffect(function() -- line: 44
		-- upvalues: v22 (copy), ModalState (copy), EventService (copy), p5 (copy)
		if v22.modalState == ModalState.ChallengeDialogApproval or v22.modalState == ModalState.ChallengeDialogExpired then
			EventService.sendDialogOpenedEvent(p5.dialogItem.type, p5.dialogItem.typeInternalId, p5.dialogItem.isExpired)
		end
	end, { v22 })
	React.useEffect(function() -- line: 57
		-- upvalues: v22 (copy), ModalState (copy), p5 (copy), v19 (copy), v23 (copy), GetFIntLuaAppChallengeDialogPollingIntervalSeconds (copy)
		local thread = task.spawn(function() -- line: 58
			-- upvalues: v22 (copy), ModalState (copy), p5 (copy), v19 (copy), v23 (copy), GetFIntLuaAppChallengeDialogPollingIntervalSeconds (copy)
			while v22.modalState == ModalState.ChallengeDialogApproval or v22.modalState == ModalState.ChallengeDialogExpired do
				p5.fetchDialog(v19):andThen(function(p6) -- line: 65
					-- upvalues: v22 (copy), ModalState (copy), v23 (copy), p5 (copy)
					local v36 = p6.dialogs[1]

					if v36 ~= nil then
						if v22.modalState == ModalState.ChallengeDialogApproval and v36.isExpired then
							v23({
								modalState = ModalState.ChallengeDialogExpired,
								dialogItem = v36
							})

							return
						end
					else
						p5.navigateBack()
					end
				end):catch(function(_) -- line: 81
				end):await()

				local v30 = GetFIntLuaAppChallengeDialogPollingIntervalSeconds()

				task.wait(v30)
			end
		end)

		return function() -- line: 90
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, { v22.modalState })

	local v24 = t1[v22.modalState]

	return v24 and React.createElement(v24, Cryo.Dictionary.join(v22, {
		navigateToModalState = v23,
		closeModal = function() -- line: 95
			-- upvalues: p5 (copy), v19 (copy), ModalState (copy), v23 (copy)
			p5.fetchDialog(v19):andThen(function(p8) -- line: 98
				-- upvalues: ModalState (copy), v23 (copy), p5 (copy)
				local v32 = p8.dialogs[1]

				if v32 ~= nil then
					local v33 = v32.isExpired and ModalState.ChallengeDialogExpired or ModalState.ChallengeDialogApproval

					v23({
						modalState = v33,
						dialogItem = v32
					})

					return
				end

				p5.navigateBack()
			end):catch(function(_) -- line: 111
				-- upvalues: p5 (copy)
				p5.navigateBack()
			end):await()
		end
	}))
end)
