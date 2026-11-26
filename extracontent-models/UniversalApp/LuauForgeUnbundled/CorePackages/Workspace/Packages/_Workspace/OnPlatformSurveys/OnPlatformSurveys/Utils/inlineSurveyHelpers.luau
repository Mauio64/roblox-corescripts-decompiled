local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/SharedFlags")
local fFlagInlineSurveyBranching = SharedFlags.FFlagInlineSurveyBranching
local fFlagInlineSurveyChoiceTextEntry = SharedFlags.FFlagInlineSurveyChoiceTextEntry

local InlineQuestionType = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/InlineQuestionType")
local InlineSurveyTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Types/InlineSurveyTypes")

local v5 = {}
local v6 = {}

local function trim(value)
	return (value:gsub("^%s*(.-)%s*$", "%1"))
end

local function buildChoiceTexts(p2)
	local choiceTexts = p2.choiceTexts

	if choiceTexts == nil then
		return nil
	end

	local result = {}
	local flag = false

	for k, v7 in p2.choiceIds or v6 do
		local v8 = (choiceTexts[v7] or ""):gsub("^%s*(.-)%s*$", "%1")

		if v8 == "" then
			continue
		end

		result[v7] = v8
		flag = true
	end

	if flag then
		return result
	end

	return nil
end

local function buildResponse(item, p2)
	if item.type == InlineQuestionType.Text then
		local v7 = (p2.text or ""):gsub("^%s*(.-)%s*$", "%1")

		if v7 == "" then
			return nil
		end

		return { text = v7 }
	else
		local choiceIds = p2.choiceIds or {}

		if #choiceIds == 0 then
			return nil
		end

		local v8 = if fFlagInlineSurveyChoiceTextEntry then buildChoiceTexts(p2) else nil
		return { choiceIds = choiceIds, choiceTexts = v8 }
	end
end

local function canSubmitAll(items, clone): boolean
	for k, item in items do
		if item.required ~= true then
			continue
		end

		local v7 = clone[item.questionId] or v5
		local v8

		if item.type == InlineQuestionType.Text then
			v8 = true
		elseif item.type == InlineQuestionType.MultipleChoiceSingle then
			v8 = not (v7.choiceIds == nil) and #v7.choiceIds == 1
		else
			v8 = item.type == InlineQuestionType.MultipleChoiceMulti and v7.choiceIds ~= nil and #v7.choiceIds >= 1
		end

		if not v8 then
			return false
		end
	end

	return true
end

local function indexOfQuestion(items, p2)
	for k, item in items do
		if item.questionId == p2 then
			return k
		end
	end

	return nil
end

local function resolveNextQuestionId(item, p2)
	local choiceIds = p2.choiceIds

	if item.choices == nil or choiceIds == nil or not (#choiceIds > 0) then
		return item.next
	end

	local choiceId = choiceIds[1]

	for k, choice in item.choices do
		if choice.id == choiceId then
			return choice.next or item.next
		end
	end

	return item.next
end

local function getVisitedQuestions(list, clone)
	local visitedQuestions = {}
	local set = {}
	local v7 = if #list > 0 then 1 else nil

	while v7 ~= nil and not set[v7] do
		set[v7] = true
		local item = list[v7]
		table.insert(visitedQuestions, item)
		local v8 = clone[item.questionId] or v5
		local item2 = list[v7]

		if item2 == nil then
			v7 = nil
		else
			local nextQuestionId = resolveNextQuestionId(item2, v8)

			if nextQuestionId == nil then
				v7 += 1

				if not (v7 <= #list) then
					v7 = nil
				end
			elseif nextQuestionId == InlineSurveyTypes.NEXT_END then
				v7 = nil
			else
				local v9 = nil

				for k, item3 in list do
					if item3.questionId == nextQuestionId then
						v9 = k
						break
					end
				end

				if v9 == nil then
					v7 += 1

					if not (v7 <= #list) then
						v7 = nil
					end
				else
					v7 = v9
				end
			end
		end
	end

	return visitedQuestions
end

return {
	isAnswerComplete = function(p2, p3): boolean
		if p2.type == InlineQuestionType.Text then
			return true
		end

		if p2.type == InlineQuestionType.MultipleChoiceSingle then
			return p3.choiceIds ~= nil and #p3.choiceIds == 1
		end

		if p2.type ~= InlineQuestionType.MultipleChoiceMulti then
			return false
		end

		return p3.choiceIds ~= nil and #p3.choiceIds >= 1
	end,
	buildSubmitPayload = function(p2, items, p3, p4, p5)
		local v7 = {}

		for k, item in items do
			local response = buildResponse(item, p3[item.questionId] or v5)

			if response ~= nil then
				table.insert(v7, {
					questionId = item.questionId,
					type = item.type,
					response = response
				})
			end
		end

		local v8 = if p5 ~= nil then p5.finished else nil
		return { surveyId = p2, idempotencyKey = p4, answers = v7, finished = v8 }
	end,
	canSubmitAll = canSubmitAll,
	canAdvance = function(list, p2, p3, p4)
		local item = list[p2]

		if item == nil then
			return false
		end

		local v7

		if fFlagInlineSurveyBranching then
			local item2 = list[p2]
			local v8

			if item2 ~= nil then
				local nextQuestionId = resolveNextQuestionId(item2, p4)

				if nextQuestionId == nil then
					v8 = p2 + 1

					if not (v8 <= #list) then
						v8 = nil
					end
				elseif nextQuestionId ~= InlineSurveyTypes.NEXT_END then
					for k, item3 in list do
						if item3.questionId == nextQuestionId then
							v8 = k
							break
						end
					end

					if v8 == nil then
						v8 = p2 + 1

						if not (v8 <= #list) then
							v8 = nil
						end
					end
				end
			end

			v7 = v8 == nil
		else
			v7 = #list <= p2
		end

		if v7 then
			local clone = table.clone(p3)

			if item ~= nil then
				clone[item.questionId] = p4
			end

			if fFlagInlineSurveyBranching then
				list = getVisitedQuestions(list, clone)
			end

			return canSubmitAll(list, clone)
		end

		if not (item.required == true and item.type ~= InlineQuestionType.Text) then
			return true
		end

		if item.type == InlineQuestionType.MultipleChoiceSingle then
			if p4.choiceIds ~= nil then
				return #p4.choiceIds == 1
			end
		elseif item.type == InlineQuestionType.MultipleChoiceMulti and p4.choiceIds ~= nil then
			return #p4.choiceIds >= 1
		end

		return false
	end,
	resolveNextIndex = function(list, p2, p3)
		local item = list[p2]

		if item == nil then
			return nil
		end

		local nextQuestionId = resolveNextQuestionId(item, p3)
		local v7

		if nextQuestionId == nil then
			v7 = p2 + 1

			if v7 <= #list then
				return v7
			end

			return nil
		else
			if nextQuestionId == InlineSurveyTypes.NEXT_END then
				return nil
			end

			local v8 = nil

			for k, item2 in list do
				if item2.questionId == nextQuestionId then
					v8 = k
					break
				end
			end

			if v8 ~= nil then
				return v8
			end

			v7 = p2 + 1

			if v7 <= #list then
				return v7
			end

			return nil
		end
	end,
	getVisitedQuestions = getVisitedQuestions,
	isLastQuestion = function(list, p2, p3): boolean
		if not fFlagInlineSurveyBranching then
			return #list <= p2
		end

		local item = list[p2]
		local v7

		if item ~= nil then
			local nextQuestionId = resolveNextQuestionId(item, p3)

			if nextQuestionId == nil then
				v7 = p2 + 1

				if not (v7 <= #list) then
					v7 = nil
				end
			elseif nextQuestionId ~= InlineSurveyTypes.NEXT_END then
				for k, item2 in list do
					if item2.questionId == nextQuestionId then
						v7 = k
						break
					end
				end

				if v7 == nil then
					v7 = p2 + 1

					if not (v7 <= #list) then
						v7 = nil
					end
				end
			end
		end

		return v7 == nil
	end,
	mergeCurrentAnswerIntoBatch = function(p2, p3, p4)
		local clone = table.clone(p2)

		if p3 ~= nil then
			clone[p3.questionId] = p4
		end

		return clone
	end,
	toggleChoice = function(p2, p3, p4)
		if not p4 then
			return { p3 }
		end

		local result = {}
		local v7 = false

		for k, v8 in p2.choiceIds or v6 do
			if v8 == p3 then
				v7 = true
			else
				table.insert(result, v8)
			end
		end

		if not v7 then
			table.insert(result, p3)
		end

		return result
	end
}
