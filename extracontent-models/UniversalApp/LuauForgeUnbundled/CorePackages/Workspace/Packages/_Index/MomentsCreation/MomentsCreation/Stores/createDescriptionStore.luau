local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals").createSignal

local function createDescriptionStore()
	local signal, v5 = createSignal("")
	local signal2, v6 = createSignal(nil)
	local signal3, v7 = createSignal(nil)
	local signal4, v8 = createSignal(nil)
	local signal5, v9 = createSignal(nil)
	local signal6, v10 = createSignal(true)

	return {
		getDescription = signal,
		setDescription = v5,
		getGeneratedDescription = signal2,
		setGeneratedDescription = v6,
		getGenerationToken = signal3,
		setGenerationToken = v7,
		getGeneratedTextFeedback = signal4,
		setGeneratedTextFeedback = v8,
		getGeneratedSummary = signal5,
		setGeneratedSummary = v9,
		getCommentsEnabled = signal6,
		setCommentsEnabled = v10
	}
end

return createDescriptionStore
