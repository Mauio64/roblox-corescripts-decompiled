local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagInlineSurveyBranching = SharedFlags.FFlagInlineSurveyBranching
local FFlagInlineSurveyChoiceTextEntry = SharedFlags.FFlagInlineSurveyChoiceTextEntry

local InlineQuestionType = require(OnPlatformSurveys.Enums.InlineQuestionType)
local InlineSurveyTypes = require(OnPlatformSurveys.Types.InlineSurveyTypes)

local v = {}
local v2 = {}

local function trim(value: string) -- 2 equivalent calls inferred from this helper
	return (value:gsub("^%s*(.-)%s*$", "%1"))
end

local function buildChoiceTexts(p)
	local choiceTexts = p.choiceTexts

	if choiceTexts == nil then
		return nil
	end

	local result = {}
	local flag = false

	for _, v3 in p.choiceIds or v2 do
		local v4 = trim(choiceTexts[v3] or "") -- inferred equivalent call

		if v4 == "" then
			continue
		end

		result[v3] = v4
		flag = true
	end

	return if flag then result else nil
end

local function buildResponse(item, p)
	if item.type == InlineQuestionType.Text then
		local text = trim(p.text or "") -- inferred equivalent call

		if text == "" then
			return nil
		end

		return { text = text }
	else
		local choiceIds = p.choiceIds or {}

		if #choiceIds == 0 then
			return nil
		end

		local choiceTexts

		if FFlagInlineSurveyChoiceTextEntry then
			choiceTexts = buildChoiceTexts(p)
		end

		return { choiceIds = choiceIds, choiceTexts = choiceTexts }
	end
end

local function canSubmitAll(items, p): boolean
	for _, item in items do
		if item.required ~= true then
			continue
		end

		local v3 = p[item.questionId] or v
		local v4

		if item.type == InlineQuestionType.Text then
			v4 = true
		elseif item.type == InlineQuestionType.MultipleChoiceSingle then
			if v3.choiceIds == nil then
				v4 = false
			else
				v4 = #v3.choiceIds == 1
			end
		elseif item.type == InlineQuestionType.MultipleChoiceMulti and v3.choiceIds ~= nil then
			v4 = #v3.choiceIds >= 1
		else
			v4 = false
		end

		if not v4 then
			return false
		end
	end

	return true
end

local function mergeCurrentAnswerIntoBatch(p, p2, p3) -- 1 equivalent call inferred from this helper
	local clone = table.clone(p)

	if p2 ~= nil then
		clone[p2.questionId] = p3
	end

	return clone
end

local function indexOfQuestion(items, nextQuestionId: string) -- 2 equivalent calls inferred from this helper
	for k, item in items do
		if item.questionId == nextQuestionId then
			return k
		end
	end

	return nil
end

local function resolveNextQuestionId(item, p)
	local choiceIds = p.choiceIds

	if item.choices == nil or choiceIds == nil or not (#choiceIds > 0) then
		return item.next
	end

	local choiceId = choiceIds[1]

	for _, choice in item.choices do
		if choice.id == choiceId then
			return choice.next or item.next
		end
	end

	return item.next
end

local function getVisitedQuestions(list, p)
	local visitedQuestions = {}
	local set = {}
	local v3

	if #list > 0 then
		v3 = 1
	end

	while v3 ~= nil and not set[v3] do
		set[v3] = true
		local item = list[v3]
		table.insert(visitedQuestions, item)
		local v4 = p[item.questionId] or v
		local item2 = list[v3]

		if item2 == nil then
			v3 = nil
		else
			local nextQuestionId = resolveNextQuestionId(item2, v4)

			if nextQuestionId == nil then
				v3 += 1

				if not (v3 <= #list) then
					v3 = nil
				end
			elseif nextQuestionId == InlineSurveyTypes.NEXT_END then
				v3 = nil
			else
				local k = indexOfQuestion(list, nextQuestionId) -- inferred equivalent call

				if k == nil then
					v3 += 1

					if not (v3 <= #list) then
						v3 = nil
					end
				else
					v3 = k
				end
			end
		end
	end

	return visitedQuestions
end

local function isLastQuestion(list, p: number, p2): boolean -- 1 equivalent call inferred from this helper
	if not FFlagInlineSurveyBranching then
		return #list <= p
	end

	local item = list[p]
	local v3

	if item ~= nil then
		local nextQuestionId = resolveNextQuestionId(item, p2)

		if nextQuestionId == nil then
			v3 = p + 1

			if not (v3 <= #list) then
				v3 = nil
			end
		elseif nextQuestionId ~= InlineSurveyTypes.NEXT_END then
			for k, item2 in list do
				if item2.questionId == nextQuestionId then
					v3 = k
					break
				end
			end

			if v3 == nil then
				v3 = p + 1

				if not (v3 <= #list) then
					v3 = nil
				end
			end
		end
	end

	return v3 == nil
end

local InlineSurveyHelpers = {}

function InlineSurveyHelpers.isAnswerComplete(p, p2): boolean
	if p.type == InlineQuestionType.Text then
		return true
	end

	if p.type == InlineQuestionType.MultipleChoiceSingle then
		return p2.choiceIds ~= nil and #p2.choiceIds == 1
	end

	if p.type ~= InlineQuestionType.MultipleChoiceMulti then
		return false
	end

	return p2.choiceIds ~= nil and #p2.choiceIds >= 1
end

function InlineSurveyHelpers.buildSubmitPayload(surveyId: string, items, p, idempotencyKey: string, p2)
	local answers = {}

	for _, item in items do
		local response = buildResponse(item, p[item.questionId] or v)

		if response ~= nil then
			table.insert(answers, {
				questionId = item.questionId,
				type = item.type,
				response = response
			})
		end
	end

	local finished

	if p2 ~= nil then
		finished = p2.finished
	end

	return {
		surveyId = surveyId,
		idempotencyKey = idempotencyKey,
		answers = answers,
		finished = finished
	}
end

InlineSurveyHelpers.canSubmitAll = canSubmitAll

function InlineSurveyHelpers.canAdvance(p, p2: number, p3, p4)
	local v3 = p[p2]

	if v3 == nil then
		return false
	end

	if isLastQuestion(p, p2, p4) then -- inferred equivalent call
		local clone = mergeCurrentAnswerIntoBatch(p3, v3, p4) -- inferred equivalent call

		if FFlagInlineSurveyBranching then
			p = getVisitedQuestions(p, clone)
		end

		return canSubmitAll(p, clone)
	end

	if not (v3.required == true and v3.type ~= InlineQuestionType.Text) then
		return true
	end

	if v3.type == InlineQuestionType.MultipleChoiceSingle then
		if p4.choiceIds ~= nil then
			return #p4.choiceIds == 1
		end
	elseif v3.type == InlineQuestionType.MultipleChoiceMulti and p4.choiceIds ~= nil then
		return #p4.choiceIds >= 1
	end

	return false
end

function InlineSurveyHelpers.resolveNextIndex(list, p: number, p2)
	local item = list[p]

	if item == nil then
		return nil
	end

	local nextQuestionId = resolveNextQuestionId(item, p2)
	local v3

	if nextQuestionId == nil then
		v3 = p + 1
		return if v3 <= #list then v3 else nil
	else
		if nextQuestionId == InlineSurveyTypes.NEXT_END then
			return nil
		end

		local k = indexOfQuestion(list, nextQuestionId) -- inferred equivalent call

		if k ~= nil then
			return k
		end

		v3 = p + 1
		return if v3 <= #list then v3 else nil
	end
end

InlineSurveyHelpers.getVisitedQuestions = getVisitedQuestions
InlineSurveyHelpers.isLastQuestion = isLastQuestion
InlineSurveyHelpers.mergeCurrentAnswerIntoBatch = mergeCurrentAnswerIntoBatch

function InlineSurveyHelpers.toggleChoice(p, p2: string, flag: boolean)
	if not flag then
		return { p2 }
	end

	local result = {}
	local v3 = false

	for _, v4 in p.choiceIds or v2 do
		if v4 == p2 then
			v3 = true
		else
			table.insert(result, v4)
		end
	end

	if not v3 then
		table.insert(result, p2)
	end

	return result
end

return InlineSurveyHelpers
