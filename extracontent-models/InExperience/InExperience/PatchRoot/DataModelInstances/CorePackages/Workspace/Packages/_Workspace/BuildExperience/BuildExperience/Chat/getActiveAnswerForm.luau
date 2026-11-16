local BuildExperience = script:FindFirstAncestor("BuildExperience")
local CreatorAgentChat = require(BuildExperience.Parent.DataHydration.CreatorAgentChat)
require(script.Parent.chatTypes)

local function getActiveAnswerForm(data, p, p2)
	if data == nil or data.isDone then
		return nil
	end

	for k, v in p.askUserByToolCallId do
		local toolCall = data.toolCalls[k]

		if not (toolCall ~= nil and p2.onAnswerSelectedByToolCallId[k] ~= nil) then
			continue
		end

		local questionsFromToolCall = CreatorAgentChat.StudioAskUserTool.extractQuestionsFromToolCall(toolCall)

		if questionsFromToolCall ~= nil and questionsFromToolCall[v.currentIndex] ~= nil then
			local selection = v.selections[v.currentIndex]
			local draft

			if v.drafts then
				draft = v.drafts[questionsFromToolCall[v.currentIndex].id]
			end

			assert(draft ~= nil, "Active answer form requires a question draft")
			local result = {
				draft = draft,
				sessionId = data.sessionId,
				question = questionsFromToolCall[v.currentIndex],
				toolCallId = k,
				questionIndex = v.currentIndex,
				questionCount = #questionsFromToolCall,
				selectedOptionId = 0,
				isSubmitting = 0
			}
			local selectedOptionId

			if selection ~= nil then
				selectedOptionId = selection.selectedOptionId
			end

			result.selectedOptionId = selectedOptionId
			result.isSubmitting = v.isSubmitting == true
			return result
		end
	end

	return nil
end

return getActiveAnswerForm
