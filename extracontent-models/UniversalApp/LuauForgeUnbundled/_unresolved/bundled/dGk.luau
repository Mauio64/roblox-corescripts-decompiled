local module = require("@luauforge/bundled/dFV")
local module2 = require("@luauforge/bundled/dFW")
local module3 = require("@luauforge/bundled/dGl")
local module4 = require("@luauforge/bundled/dFX")
local navigateBack = require("@luauforge/bundled/dFY").Thunks.NavigateBack
local fFlagSignalsNavP3Dispatch = require("@luauforge/bundled/dFZ").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dGa").NavigationCommands else nil

local module5 = require("@luauforge/bundled/dGc")
local module6 = require("@luauforge/bundled/dGm")
local module7 = require("@luauforge/bundled/dGB")
local module8 = require("@luauforge/bundled/dGP")
local module9 = require("@luauforge/bundled/dGQ")
local module10 = require("@luauforge/bundled/dGe")

local module11 = require("@luauforge/bundled/dGR")
local module12 = require("@luauforge/bundled/dGL")
local fFlagLuaAppDefaultHttpRetry = require("@luauforge/bundled/dFZ").FFlagLuaAppDefaultHttpRetry

local config = module4.config
local v5 = {
	requestFunction = module4.requestFunctions.RequestInternal,
	maxRetryCount = 0
}

local v6 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt(
	"ChallengeDialogModalContainerHttpRetryCount",
	4
) else nil
v5.maxRetryCount = v6
local v7 = config(v5)

local modules = {
	[module5.ChallengeDialogApproval] = module7,
	[module5.ChallengeDialogDenied] = module8,
	[module5.ChallengeDialogExpired] = module9,
	[module5.ChallengeDialogAlreadyCompleted] = module6
}

return module2.connect(function(p2, p3)
	return {}
end, function(callback)
	return {
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back()
			end

			return callback(navigateBack())
		end,
		fetchDialog = function(p2)
			return callback(module10(p2))
		end
	}
end)(function(props)
	local state, setState = module.useState(props)

	module.useEffect(function()
		if
			state.modalState == module5.ChallengeDialogApproval
			or state.modalState == module5.ChallengeDialogExpired
		then
			module12.sendDialogOpenedEvent(
				props.dialogItem.type,
				props.dialogItem.typeInternalId,
				props.dialogItem.isExpired
			)
		end
	end, { state })

	module.useEffect(function()
		local thread = task.spawn(function()
			while
				state.modalState == module5.ChallengeDialogApproval
				or state.modalState == module5.ChallengeDialogExpired
			do
				props.fetchDialog(v7):andThen(function(p2)
					local dialog = p2.dialogs[1]

					if dialog == nil then
						props.navigateBack()
					elseif state.modalState == module5.ChallengeDialogApproval and dialog.isExpired then
						setState({
							modalState = module5.ChallengeDialogExpired,
							dialogItem = dialog
						})
					end
				end):catch(function(p2) end):await()
				local v8 = module11()
				task.wait(v8)
			end
		end)

		return function()
			task.cancel(thread)
		end
	end, { state.modalState })

	local function fn()
		props.fetchDialog(v7):andThen(function(p2)
			local dialog = p2.dialogs[1]

			if dialog == nil then
				props.navigateBack()

				return
			end

			local challengeDialogExpired = dialog.isExpired and module5.ChallengeDialogExpired
				or module5.ChallengeDialogApproval
			setState({ modalState = challengeDialogExpired, dialogItem = dialog })
		end):catch(function(p2)
			props.navigateBack()
		end):await()
	end

	local v8 = modules[state.modalState]

	return v8
		and module.createElement(
			v8,
			module3.Dictionary.join(state, {
				navigateToModalState = setState,
				closeModal = fn
			})
		)
end)
