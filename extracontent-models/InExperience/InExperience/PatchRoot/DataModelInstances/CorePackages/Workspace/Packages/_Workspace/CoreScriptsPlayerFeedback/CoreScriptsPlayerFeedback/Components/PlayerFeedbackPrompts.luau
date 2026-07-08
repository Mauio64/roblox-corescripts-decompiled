local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local CoreScriptsPlayerFeedbackParent = CoreScriptsPlayerFeedback.Parent
local React = require(CoreScriptsPlayerFeedbackParent.React)
local Cryo = require(CoreScriptsPlayerFeedbackParent.Cryo)
local FocusNavigationUtils = require(CoreScriptsPlayerFeedbackParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local PromptConnections = require(script.Parent.PromptConnections)
local PlayerFeedbackPrompt = require(CoreScriptsPlayerFeedback.Components.PlayerFeedbackPrompt)
local PlayerSupportPrompt = require(CoreScriptsPlayerFeedback.Components.PlayerSupportPrompt)
local UnavailablePrompt = require(CoreScriptsPlayerFeedback.Components.UnavailablePrompt)
local PlayerSupportUnavailablePrompt = require(CoreScriptsPlayerFeedback.Components.PlayerSupportUnavailablePrompt)
local PlayerSupportToast = require(CoreScriptsPlayerFeedback.Components.PlayerSupportToast)
local GetFFlagEnablePlayerSupportPrompt = require(CoreScriptsPlayerFeedback.Flags.GetFFlagEnablePlayerSupportPrompt)
local useLocalization = require(CoreScriptsPlayerFeedbackParent.Localization).Hooks.useLocalization
local v16 = GetFFlagEnablePlayerSupportPrompt()
local t1 = {
	TICKET_CREATION_SUBMITTED = "ToastSubmitted",
	TICKET_CREATION_FAILED = "ToastFailed"
}
local _ = {
	PromptFeedback = "PromptFeedback",
	PromptPlayerSupport = "PromptPlayerSupport",
	PromptUnavailable = "PromptUnavailable",
	PromptPlayerSupportUnavailable = "PromptPlayerSupportUnavailable"
}
local v19 = React.memo(function(t2: {[any]: any}) -- line: 59
	-- upvalues: React (copy), Cryo (copy), UnavailablePrompt (copy), PlayerFeedbackPrompt (copy), PromptConnections (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v22, v23 = React.useState({
		promptType = nil,
		promptData = nil,
		promptQueue = {}
	})
	local promptData = v22.promptData
	local promptType = v22.promptType
	local v26 = React.useCallback(function() -- line: 69
		-- upvalues: v23 (copy), Cryo (copy)
		v23(function(p1) -- line: 70
			-- upvalues: Cryo (copy)
			local v59 = p1.promptQueue or {}

			if not Cryo.isEmpty(v59) then
				local v60 = v59[1]

				return {
					promptType = v60.promptType,
					promptData = v60.promptData,
					promptQueue = Cryo.List.removeIndex(v59, 1)
				}
			end

			return {
				promptType = nil,
				promptData = {},
				promptQueue = {}
			}
		end)
	end, {})
	local v27 = React.useCallback(function() -- line: 88
		-- upvalues: v23 (copy), Cryo (copy)
		v23(function(p2) -- line: 89
			-- upvalues: Cryo (copy)
			if p2.promptType ~= nil then
				local v62 = p2.promptQueue or {}

				return {
					promptType = p2.promptType,
					promptData = p2.promptData,
					promptQueue = Cryo.List.join(v62, {{
						promptType = "PromptFeedback",
						promptData = {}
					}})
				}
			end

			return {
				promptType = "PromptFeedback",
				promptData = {},
				promptQueue = {}
			}
		end)
	end, {})
	local v28 = React.useCallback(function(s1: string) -- line: 111
		-- upvalues: v23 (copy), Cryo (copy)
		v23(function(p3) -- line: 112
			-- upvalues: Cryo (copy), s1 (copy)
			if p3.promptType ~= nil then
				local v64 = p3.promptQueue or {}

				return {
					promptType = p3.promptType,
					promptData = p3.promptData,
					promptQueue = Cryo.List.join(v64, {{
						promptType = "PromptUnavailable",
						promptData = {
							reason = s1
						}
					}})
				}
			end

			return {
				promptType = "PromptUnavailable",
				promptData = {
					reason = s1
				},
				promptQueue = {}
			}
		end)
	end, {})
	local v29 = nil

	if promptType then
		if promptType == "PromptUnavailable" then
			v29 = React.createElement(UnavailablePrompt, {
				enableInputDelayed = t2.enableInputDelayed,
				reason = if not promptData then nil else promptData.reason,
				closePrompt = v26
			})
		elseif promptType == "PromptFeedback" then
			v29 = React.createElement(PlayerFeedbackPrompt, {
				enableInputDelayed = t2.enableInputDelayed,
				promptData = promptData,
				closePrompt = v26
			})
		else
			error(string.format("Unexpected prompt type: %s!", (tostring(promptType))))
		end
	end

	return React.createElement(React.Fragment, {}, {
		PromptConnections = React.createElement(PromptConnections, {
			openPlayerSupportPrompt = nil,
			openPlayerSupportUnavailablePrompt = nil,
			openFeedbackPrompt = v27,
			openUnavailablePrompt = v28,
			closePrompt = v26
		}),
		FocusNavigationCoreScriptsWrapper = v29 and React.createElement(FocusRoot, {
			isIsolated = true,
			isAutoFocusRoot = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
		}, {
			Prompt = v29
		})
	})
end)
local v20 = React.memo(function(t3: {[any]: any}) -- line: 174
	-- upvalues: useLocalization (copy), React (copy), Cryo (copy), t1 (copy), UnavailablePrompt (copy), PlayerSupportUnavailablePrompt (copy), PlayerSupportPrompt (copy), PlayerFeedbackPrompt (copy), PromptConnections (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), PlayerSupportToast (copy)
	local v31 = useLocalization({
		ToastSubmitted = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Toast.Submitted",
		ToastFailed = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Toast.Failed"
	})
	local v32, v33 = React.useState({
		promptType = nil,
		promptData = nil,
		promptQueue = {}
	})
	local v34, v35 = React.useState(nil)
	local v36, v37 = React.useState("")
	local v38, v39 = React.useState("")
	local v40, v41 = React.useState(false)
	local promptData = v32.promptData
	local promptType = v32.promptType
	local v44 = React.useCallback(function() -- line: 193
		-- upvalues: v37 (copy), v39 (copy), v41 (copy)
		v37("")
		v39("")
		v41(false)
	end, {})
	local v45 = React.useCallback(function() -- line: 199
		-- upvalues: v35 (copy)
		v35(nil)
	end, {})
	local v46 = React.useCallback(function() -- line: 203
		-- upvalues: v33 (copy), Cryo (copy)
		v33(function(p4) -- line: 204
			-- upvalues: Cryo (copy)
			local v66 = p4.promptQueue or {}

			if not Cryo.isEmpty(v66) then
				local v67 = v66[1]

				return {
					promptType = v67.promptType,
					promptData = v67.promptData,
					promptQueue = Cryo.List.removeIndex(v66, 1)
				}
			end

			return {
				promptType = nil,
				promptData = {},
				promptQueue = {}
			}
		end)
	end, {})
	local v47 = React.useCallback(function() -- line: 222
		-- upvalues: v33 (copy), Cryo (copy)
		v33(function(p5) -- line: 223
			-- upvalues: Cryo (copy)
			if p5.promptType ~= nil then
				local v69 = p5.promptQueue or {}

				return {
					promptType = p5.promptType,
					promptData = p5.promptData,
					promptQueue = Cryo.List.join(v69, {{
						promptType = "PromptFeedback",
						promptData = {}
					}})
				}
			end

			return {
				promptType = "PromptFeedback",
				promptData = {},
				promptQueue = {}
			}
		end)
	end, {})
	local v48 = React.useCallback(function() -- line: 245
		-- upvalues: v33 (copy), Cryo (copy)
		v33(function(p6) -- line: 246
			-- upvalues: Cryo (copy)
			if p6.promptType ~= nil then
				local v71 = p6.promptQueue or {}

				return {
					promptType = p6.promptType,
					promptData = p6.promptData,
					promptQueue = Cryo.List.join(v71, {{
						promptType = "PromptPlayerSupport",
						promptData = {}
					}})
				}
			end

			return {
				promptType = "PromptPlayerSupport",
				promptData = {},
				promptQueue = {}
			}
		end)
	end, {})
	local v49 = React.useCallback(function(s2: string) -- line: 268
		-- upvalues: v33 (copy), Cryo (copy)
		v33(function(p7) -- line: 269
			-- upvalues: Cryo (copy), s2 (copy)
			if p7.promptType ~= nil then
				local v73 = p7.promptQueue or {}

				return {
					promptType = p7.promptType,
					promptData = p7.promptData,
					promptQueue = Cryo.List.join(v73, {{
						promptType = "PromptUnavailable",
						promptData = {
							reason = s2
						}
					}})
				}
			end

			return {
				promptType = "PromptUnavailable",
				promptData = {
					reason = s2
				},
				promptQueue = {}
			}
		end)
	end, {})
	local v50 = React.useCallback(function(s3: string) -- line: 291
		-- upvalues: t1 (copy), v44 (copy), v35 (copy), v31 (copy), v33 (copy), Cryo (copy)
		local v57 = t1[s3]

		if v57 then
			v44()
			v35(v31[v57])

			return
		end

		v33(function(p8) -- line: 298
			-- upvalues: Cryo (copy), s3 (copy)
			if p8.promptType ~= nil then
				local v75 = p8.promptQueue or {}

				return {
					promptType = p8.promptType,
					promptData = p8.promptData,
					promptQueue = Cryo.List.join(v75, {{
						promptType = "PromptPlayerSupportUnavailable",
						promptData = {
							reason = s3
						}
					}})
				}
			end

			return {
				promptType = "PromptPlayerSupportUnavailable",
				promptData = {
					reason = s3
				},
				promptQueue = {}
			}
		end)
	end, {
		v31,
		v44
	})
	local v51 = nil

	if promptType then
		if promptType == "PromptUnavailable" then
			v51 = React.createElement(UnavailablePrompt, {
				enableInputDelayed = t3.enableInputDelayed,
				reason = if not promptData then nil else promptData.reason,
				closePrompt = v46
			})
		elseif promptType == "PromptPlayerSupportUnavailable" then
			local v52 = if not promptData then nil else promptData.reason

			v51 = React.createElement(PlayerSupportUnavailablePrompt, {
				enableInputDelayed = t3.enableInputDelayed,
				reason = v52,
				closePrompt = v46,
				openPlayerSupportPrompt = if v52 ~= "TICKET_CREATION_TEXT_FILTER_ERROR" then nil else v48
			})
		elseif promptType == "PromptPlayerSupport" then
			v51 = React.createElement(PlayerSupportPrompt, {
				enableInputDelayed = t3.enableInputDelayed,
				promptData = promptData,
				closePrompt = v46,
				description = v36,
				setDescription = v37,
				category = v38,
				setCategory = v39,
				shareUserId = v40,
				setShareUserId = v41,
				onFormAbandoned = v44
			})
		elseif promptType == "PromptFeedback" then
			v51 = React.createElement(PlayerFeedbackPrompt, {
				enableInputDelayed = t3.enableInputDelayed,
				promptData = promptData,
				closePrompt = v46
			})
		else
			error(string.format("Unexpected prompt type: %s!", (tostring(promptType))))
		end
	end

	return React.createElement(React.Fragment, {}, {
		PromptConnections = React.createElement(PromptConnections, {
			openFeedbackPrompt = v47,
			openPlayerSupportPrompt = v48,
			openUnavailablePrompt = v49,
			openPlayerSupportUnavailablePrompt = v50,
			closePrompt = v46
		}),
		FocusNavigationCoreScriptsWrapper = v51 and React.createElement(FocusRoot, {
			isIsolated = true,
			isAutoFocusRoot = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
		}, {
			Prompt = v51
		}),
		Toast = if not v34 then nil else React.createElement(PlayerSupportToast, {
			text = v34,
			onDismiss = v45
		})
	})
end)

return (React.memo(function(t4: {[any]: any}) -- line: 392
	-- upvalues: v16 (copy), React (copy), v20 (copy), v19 (copy)
	if v16 then
		return React.createElement(v20, t4)
	end

	return React.createElement(v19, t4)
end))
