require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/ChallengeMetadata")

return {
	getPrompt = function(p2)
		local promptUser = p2.promptUser
		local prompt = if typeof(promptUser) == "table" then promptUser.prompt else nil

		if typeof(prompt) == "string" then
			return prompt
		end

		return nil
	end,
	DeniedReason = { PromptUser = "DENIED_REASON_PROMPT_USER" },
	DeniedPrompt = {
		WasmGameJoinRedirect = "DENIED_PROMPT_WASM_GAME_JOIN_REDIRECT",
		WasmInExpDeny = "DENIED_PROMPT_WASM_IN_EXP_DENY"
	}
}
