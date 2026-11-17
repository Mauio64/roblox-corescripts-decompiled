local GenericChallenges = script:FindFirstAncestor("GenericChallenges")

require(GenericChallenges.Types.ChallengeMetadata)

return {
	getPrompt = function(p)
		local promptUser = p.promptUser
		local prompt

		if typeof(promptUser) == "table" then
			prompt = promptUser.prompt
		end

		return if typeof(prompt) == "string" then prompt else nil
	end,
	DeniedReason = { PromptUser = "DENIED_REASON_PROMPT_USER" },
	DeniedPrompt = {
		WasmGameJoinRedirect = "DENIED_PROMPT_WASM_GAME_JOIN_REDIRECT",
		WasmInExpDeny = "DENIED_PROMPT_WASM_IN_EXP_DENY"
	}
}
