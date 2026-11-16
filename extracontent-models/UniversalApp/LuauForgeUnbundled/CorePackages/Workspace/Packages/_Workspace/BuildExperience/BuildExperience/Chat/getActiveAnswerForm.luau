local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

local function getActiveAnswerForm(data, p2, p3)
	if data == nil or data.isDone then
		return nil
	end

	for k, v5 in p2.askUserByToolCallId do
		local toolCall = data.toolCalls[k]

		if not (toolCall ~= nil and p3.onAnswerSelectedByToolCallId[k] ~= nil) then
			continue
		end

		local questionsFromToolCall = CreatorAgentChat.StudioAskUserTool.extractQuestionsFromToolCall(toolCall)

		if questionsFromToolCall ~= nil and questionsFromToolCall[v5.currentIndex] ~= nil then
			local selection = v5.selections[v5.currentIndex]
			local v6 = if v5.drafts then v5.drafts[questionsFromToolCall[v5.currentIndex].id] else nil
			assert(v6 ~= nil, "Active answer form requires a question draft")
			local result = {
				draft = v6,
				sessionId = data.sessionId,
				question = questionsFromToolCall[v5.currentIndex],
				toolCallId = k,
				questionIndex = v5.currentIndex,
				questionCount = #questionsFromToolCall,
				selectedOptionId = 0,
				isSubmitting = 0
			}
			local v7 = if selection ~= nil then selection.selectedOptionId else nil
			result.selectedOptionId = v7
			result.isSubmitting = v5.isSubmitting == true
			return result
		end
	end

	return nil
end

return getActiveAnswerForm
