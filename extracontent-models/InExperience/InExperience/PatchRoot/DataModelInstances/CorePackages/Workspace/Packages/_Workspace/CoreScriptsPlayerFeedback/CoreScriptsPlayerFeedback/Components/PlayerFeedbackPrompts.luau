local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local parent = CoreScriptsPlayerFeedback.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)

local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local PromptConnections = require(script.Parent.PromptConnections)
local PlayerFeedbackPrompt = require(CoreScriptsPlayerFeedback.Components.PlayerFeedbackPrompt)
local PlayerSupportPrompt = require(CoreScriptsPlayerFeedback.Components.PlayerSupportPrompt)
local UnavailablePrompt = require(CoreScriptsPlayerFeedback.Components.UnavailablePrompt)
local PlayerSupportUnavailablePrompt = require(CoreScriptsPlayerFeedback.Components.PlayerSupportUnavailablePrompt)
local PlayerSupportToast = require(CoreScriptsPlayerFeedback.Components.PlayerSupportToast)
local GetFFlagEnablePlayerSupportPrompt = require(CoreScriptsPlayerFeedback.Flags.GetFFlagEnablePlayerSupportPrompt)
local FFlagPlayerSupportPromptEventIngest = require(CoreScriptsPlayerFeedback.Flags.FFlagPlayerSupportPromptEventIngest)
local PlayerSupportPromptTelemetry = require(CoreScriptsPlayerFeedback.Telemetry.PlayerSupportPromptTelemetry)
local constants = require(CoreScriptsPlayerFeedback.constants)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local fFlagEnablePlayerSupportPrompt = GetFFlagEnablePlayerSupportPrompt()

local v = { TICKET_CREATION_SUBMITTED = "ToastSubmitted", TICKET_CREATION_FAILED = "ToastFailed" }

local v2 = { TICKET_CREATION_TEXT_FILTER_ERROR = true, TICKET_CREATION_GIBBERISH_ERROR = true }

local _ = {
	PromptFeedback = "PromptFeedback",
	PromptPlayerSupport = "PromptPlayerSupport",
	PromptUnavailable = "PromptUnavailable",
	PromptPlayerSupportUnavailable = "PromptPlayerSupportUnavailable"
}

local memo = React.memo(function(p)
	local state, setState = React.useState({ promptType = nil, promptData = nil, promptQueue = {} })

	local promptData = state.promptData
	local promptType = state.promptType

	local closePrompt = React.useCallback(function()
		setState(function(p2)
			local promptQueue = p2.promptQueue or {}

			if Cryo.isEmpty(promptQueue) then
				return { promptType = nil, promptData = {}, promptQueue = {} }
			end

			local v3 = promptQueue[1]
			return {
				promptType = v3.promptType,
				promptData = v3.promptData,
				promptQueue = Cryo.List.removeIndex(promptQueue, 1)
			}
		end)
	end, {})

	local openFeedbackPrompt = React.useCallback(function()
		setState(function(data)
			if data.promptType == nil then
				return { promptType = "PromptFeedback", promptData = {}, promptQueue = {} }
			end

			local promptQueue = data.promptQueue or {}
			return {
				promptType = data.promptType,
				promptData = data.promptData,
				promptQueue = Cryo.List.join(promptQueue, {
					{ promptType = "PromptFeedback", promptData = {} }
				})
			}
		end)
	end, {})

	local openUnavailablePrompt = React.useCallback(function(reason: string)
		setState(function(data)
			if data.promptType == nil then
				return {
					promptType = "PromptUnavailable",
					promptData = { reason = reason },
					promptQueue = {}
				}
			end

			local promptQueue = data.promptQueue or {}
			return {
				promptType = data.promptType,
				promptData = data.promptData,
				promptQueue = Cryo.List.join(promptQueue, {
					{
						promptType = "PromptUnavailable",
						promptData = { reason = reason }
					}
				})
			}
		end)
	end, {})

	local prompt = nil

	if promptType then
		if promptType == "PromptUnavailable" then
			local createElement = React.createElement
			local v3 = { enableInputDelayed = p.enableInputDelayed, reason = 0, closePrompt = 0 }
			local reason

			if promptData then
				reason = promptData.reason
			end

			v3.reason = reason
			v3.closePrompt = closePrompt
			prompt = createElement(UnavailablePrompt, v3)
		elseif promptType == "PromptFeedback" then
			prompt = React.createElement(PlayerFeedbackPrompt, {
				enableInputDelayed = p.enableInputDelayed,
				promptData = promptData,
				closePrompt = closePrompt
			})
		else
			error(string.format("Unexpected prompt type: %s!", (tostring(promptType))))
		end
	end

	return React.createElement(React.Fragment, {}, {
		PromptConnections = React.createElement(PromptConnections, {
			openFeedbackPrompt = openFeedbackPrompt,
			openPlayerSupportPrompt = nil,
			openUnavailablePrompt = openUnavailablePrompt,
			openPlayerSupportUnavailablePrompt = nil,
			closePrompt = closePrompt
		}),
		FocusNavigationCoreScriptsWrapper = prompt and React.createElement(
			FocusRoot,
			{
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
				isIsolated = true,
				isAutoFocusRoot = true
			},
			{ Prompt = prompt }
		)
	})
end)

local memo2 = React.memo(function(p)
	local v3 = useLocalization({
		ToastSubmitted = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Toast.Submitted",
		ToastFailed = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Toast.Failed"
	})

	local state, setState = React.useState({ promptType = nil, promptData = nil, promptQueue = {} })

	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState("")
	local state4, setState4 = React.useState("")
	local state5, setState5 = React.useState(false)

	local promptData = state.promptData
	local promptType = state.promptType

	local onFormAbandoned = React.useCallback(function()
		setState3("")
		setState4("")
		setState5(false)
	end, {})

	local onDismiss = React.useCallback(function()
		setState2(nil)
	end, {})

	local closePrompt = React.useCallback(function()
		setState(function(p2)
			local promptQueue = p2.promptQueue or {}

			if Cryo.isEmpty(promptQueue) then
				return { promptType = nil, promptData = {}, promptQueue = {} }
			end

			local v4 = promptQueue[1]
			return {
				promptType = v4.promptType,
				promptData = v4.promptData,
				promptQueue = Cryo.List.removeIndex(promptQueue, 1)
			}
		end)
	end, {})

	local openFeedbackPrompt = React.useCallback(function()
		setState(function(data)
			if data.promptType == nil then
				return { promptType = "PromptFeedback", promptData = {}, promptQueue = {} }
			end

			local promptQueue = data.promptQueue or {}
			return {
				promptType = data.promptType,
				promptData = data.promptData,
				promptQueue = Cryo.List.join(promptQueue, {
					{ promptType = "PromptFeedback", promptData = {} }
				})
			}
		end)
	end, {})

	local openPlayerSupportPrompt = React.useCallback(function()
		setState(function(data)
			if data.promptType == nil then
				return { promptType = "PromptPlayerSupport", promptData = {}, promptQueue = {} }
			end

			local promptQueue = data.promptQueue or {}
			return {
				promptType = data.promptType,
				promptData = data.promptData,
				promptQueue = Cryo.List.join(promptQueue, {
					{ promptType = "PromptPlayerSupport", promptData = {} }
				})
			}
		end)
	end, {})

	local openUnavailablePrompt = React.useCallback(function(reason: string)
		setState(function(data)
			if data.promptType == nil then
				return {
					promptType = "PromptUnavailable",
					promptData = { reason = reason },
					promptQueue = {}
				}
			end

			local promptQueue = data.promptQueue or {}
			return {
				promptType = data.promptType,
				promptData = data.promptData,
				promptQueue = Cryo.List.join(promptQueue, {
					{
						promptType = "PromptUnavailable",
						promptData = { reason = reason }
					}
				})
			}
		end)
	end, {})

	local openPlayerSupportUnavailablePrompt = React.useCallback(function(reason: string)
		if FFlagPlayerSupportPromptEventIngest then
			PlayerSupportPromptTelemetry.logTicketResult(reason, {
				category = state4,
				shareUserId = constants.PLAYER_SUPPORT_CATEGORIES_REQUIRING_USER_ID[state4] == true or state5,
				descriptionLength = #state3
			})
		end

		local v4 = v[reason]

		if not v4 then
			setState(function(data)
				if data.promptType == nil then
					return {
						promptType = "PromptPlayerSupportUnavailable",
						promptData = { reason = reason },
						promptQueue = {}
					}
				end

				local promptQueue = data.promptQueue or {}
				return {
					promptType = data.promptType,
					promptData = data.promptData,
					promptQueue = Cryo.List.join(promptQueue, {
						{
							promptType = "PromptPlayerSupportUnavailable",
							promptData = { reason = reason }
						}
					})
				}
			end)

			return
		end

		onFormAbandoned()
		setState2(v3[v4])
	end, FFlagPlayerSupportPromptEventIngest and { v3, onFormAbandoned, state4, state5, state3 } or {
		v3,
		onFormAbandoned
	})

	local prompt = nil

	if promptType then
		if promptType == "PromptUnavailable" then
			local createElement = React.createElement
			local v4 = { enableInputDelayed = p.enableInputDelayed, reason = 0, closePrompt = 0 }
			local reason

			if promptData then
				reason = promptData.reason
			end

			v4.reason = reason
			v4.closePrompt = closePrompt
			prompt = createElement(UnavailablePrompt, v4)
		elseif promptType == "PromptPlayerSupportUnavailable" then
			local reason

			if promptData then
				reason = promptData.reason
			end

			local createElement = React.createElement
			local v4 = {
				enableInputDelayed = p.enableInputDelayed,
				reason = reason,
				closePrompt = closePrompt,
				openPlayerSupportPrompt = 0
			}
			local openPlayerSupportPrompt2

			if v2[reason] then
				openPlayerSupportPrompt2 = openPlayerSupportPrompt
			end

			v4.openPlayerSupportPrompt = openPlayerSupportPrompt2
			prompt = createElement(PlayerSupportUnavailablePrompt, v4)
		elseif promptType == "PromptPlayerSupport" then
			prompt = React.createElement(PlayerSupportPrompt, {
				enableInputDelayed = p.enableInputDelayed,
				promptData = promptData,
				closePrompt = closePrompt,
				description = state3,
				setDescription = setState3,
				category = state4,
				setCategory = setState4,
				shareUserId = state5,
				setShareUserId = setState5,
				onFormAbandoned = onFormAbandoned
			})
		elseif promptType == "PromptFeedback" then
			prompt = React.createElement(PlayerFeedbackPrompt, {
				enableInputDelayed = p.enableInputDelayed,
				promptData = promptData,
				closePrompt = closePrompt
			})
		else
			error(string.format("Unexpected prompt type: %s!", (tostring(promptType))))
		end
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v4 = {
		PromptConnections = React.createElement(PromptConnections, {
			openFeedbackPrompt = openFeedbackPrompt,
			openPlayerSupportPrompt = openPlayerSupportPrompt,
			openUnavailablePrompt = openUnavailablePrompt,
			openPlayerSupportUnavailablePrompt = openPlayerSupportUnavailablePrompt,
			closePrompt = closePrompt
		}),
		FocusNavigationCoreScriptsWrapper = prompt and React.createElement(
			FocusRoot,
			{
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
				isIsolated = true,
				isAutoFocusRoot = true
			},
			{ Prompt = prompt }
		),
		Toast = 0
	}
	local toast

	if state2 then
		toast = React.createElement(PlayerSupportToast, { text = state2, onDismiss = onDismiss })
	end

	v4.Toast = toast
	return createElement(fragment, {}, v4)
end)

return (React.memo(function(p)
	if fFlagEnablePlayerSupportPrompt then
		return React.createElement(memo2, p)
	end

	return React.createElement(memo, p)
end))
