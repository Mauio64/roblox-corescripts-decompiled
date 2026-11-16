local parent = script:FindFirstAncestor("MomentsCreation").Parent

local Signals = require(parent.Signals)

local createSignal = Signals.createSignal

local function createDescriptionStore()
	local signal, setDescription = createSignal("")
	local signal2, setGeneratedDescription = createSignal(nil)
	local signal3, setGenerationToken = createSignal(nil)
	local signal4, setGeneratedTextFeedback = createSignal(nil)
	local signal5, setGeneratedSummary = createSignal(nil)
	local signal6, setCommentsEnabled = createSignal(true)

	return {
		getDescription = signal,
		setDescription = setDescription,
		getGeneratedDescription = signal2,
		setGeneratedDescription = setGeneratedDescription,
		getGenerationToken = signal3,
		setGenerationToken = setGenerationToken,
		getGeneratedTextFeedback = signal4,
		setGeneratedTextFeedback = setGeneratedTextFeedback,
		getGeneratedSummary = signal5,
		setGeneratedSummary = setGeneratedSummary,
		getCommentsEnabled = signal6,
		setCommentsEnabled = setCommentsEnabled
	}
end

return createDescriptionStore
