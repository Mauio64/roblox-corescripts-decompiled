local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local InlineQuestionType = require(OnPlatformSurveys.Enums.InlineQuestionType)

require(OnPlatformSurveys.Types.InlineSurveyTypes)

local t1 = {}
local t2 = {}

local function trim(s1: string) -- line: 15
	return (s1:gsub("^%s*(.-)%s*$", "%1"))
end
local function buildResponse(p1, p2) -- line: 32
	-- upvalues: InlineQuestionType (copy)
	if p1.type == InlineQuestionType.Text then
		local v13 = (p2.text or ""):gsub("^%s*(.-)%s*$", "%1")

		if v13 == "" then
			return nil
		end

		return {
			text = v13
		}
	end

	local v14 = p2.choiceIds or {}

	if #v14 == 0 then
		return nil
	end

	return {
		choiceIds = v14
	}
end
local function canSubmitAll(t3: {[any]: any}, t4: {[any]: any}) -- line: 75
	-- upvalues: t1 (copy), InlineQuestionType (copy)
	for _, v27 in t3 do
		if v27.required ~= true then
			continue
		end

		local v28 = t4[v27.questionId] or t1

		if v27.type ~= InlineQuestionType.Text and not if v27.type ~= InlineQuestionType.MultipleChoiceSingle then v27.type == InlineQuestionType.MultipleChoiceMulti and (v28.choiceIds ~= nil and #v28.choiceIds >= 1) else v28.choiceIds ~= nil and #v28.choiceIds == 1 then
			return false
		end
	end

	return true
end

return {
	isAnswerComplete = function(p3, p4) -- line: 20
		-- upvalues: InlineQuestionType (copy)
		if p3.type == InlineQuestionType.Text then
			return true
		end

		if p3.type == InlineQuestionType.MultipleChoiceSingle then
			return p4.choiceIds ~= nil and #p4.choiceIds == 1
		end

		if p3.type == InlineQuestionType.MultipleChoiceMulti then
			return p4.choiceIds ~= nil and #p4.choiceIds >= 1
		end

		return false
	end,
	buildSubmitPayload = function(s2: string, t5: {[any]: any}, t6: {[any]: any}, s3: string) -- line: 49
		-- upvalues: t1 (copy), buildResponse (copy)
		local t7 = {}

		for _, v21 in t5 do
			local v22 = t6[v21.questionId] or t1
			local v23 = buildResponse(v21, v22)

			if v23 ~= nil then
				table.insert(t7, {
					questionId = v21.questionId,
					type = v21.type,
					response = v23
				})
			end
		end

		return {
			surveyId = s2,
			idempotencyKey = s3,
			answers = t7
		}
	end,
	canSubmitAll = canSubmitAll,
	canAdvance = function(t8: {[any]: any}, n1: number, t9: {[any]: any}, p5) -- line: 101
		-- upvalues: canSubmitAll (copy), InlineQuestionType (copy)
		local v37 = t8[n1]

		if v37 == nil then
			return false
		end

		if n1 >= #t8 then
			local v38 = canSubmitAll
			local v39 = table.clone(t9)

			if v37 ~= nil then
				v39[v37.questionId] = p5
			end

			return (v38(t8, v39))
		end

		local v40 = true

		if v37.required == true then
			if v37.type == InlineQuestionType.Text then
				return true
			end

			if v37.type == InlineQuestionType.MultipleChoiceSingle then
				v40 = false

				if p5.choiceIds ~= nil then
					return #p5.choiceIds == 1
				end
			elseif v37.type == InlineQuestionType.MultipleChoiceMulti then
				v40 = false

				if p5.choiceIds ~= nil then
					return #p5.choiceIds >= 1
				end
			else
				v40 = false
			end
		end

		return v40
	end,
	mergeCurrentAnswerIntoBatch = function(t10: {[any]: any}, p6, p7) -- line: 88
		local v32 = table.clone(t10)

		if p6 ~= nil then
			v32[p6.questionId] = p7
		end

		return v32
	end,
	toggleChoice = function(p8, s4: string, b1: boolean) -- line: 118
		-- upvalues: t2 (copy)
		if not b1 then
			return { s4 }
		end

		local t11 = {}
		local v45 = false

		for _, v47 in p8.choiceIds or t2 do
			if v47 == s4 then
				v45 = true
			else
				table.insert(t11, v47)
			end
		end

		if not v45 then
			table.insert(t11, s4)
		end

		return t11
	end
}
