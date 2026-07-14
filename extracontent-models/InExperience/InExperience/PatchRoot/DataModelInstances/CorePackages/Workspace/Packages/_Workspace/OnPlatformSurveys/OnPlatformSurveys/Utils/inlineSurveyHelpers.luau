local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local FFlagInlineSurveyBranching = require(OnPlatformSurveysParent.SharedFlags).FFlagInlineSurveyBranching
local InlineQuestionType = require(OnPlatformSurveys.Enums.InlineQuestionType)
local InlineSurveyTypes = require(OnPlatformSurveys.Types.InlineSurveyTypes)
local t1 = {}
local t2 = {}

local function trim(s1: string) -- line: 23
	return (s1:gsub("^%s*(.-)%s*$", "%1"))
end
local function buildResponse(p1, p2) -- line: 40
	-- upvalues: InlineQuestionType (copy)
	if p1.type == InlineQuestionType.Text then
		local v19 = (p2.text or ""):gsub("^%s*(.-)%s*$", "%1")

		if v19 == "" then
			return nil
		end

		return {
			text = v19
		}
	end

	local v20 = p2.choiceIds or {}

	if #v20 == 0 then
		return nil
	end

	return {
		choiceIds = v20
	}
end
local function canSubmitAll(t3: {[any]: any}, t4: {[any]: any}) -- line: 85
	-- upvalues: t1 (copy), InlineQuestionType (copy)
	for _, v34 in t3 do
		if v34.required ~= true then
			continue
		end

		local v35 = t4[v34.questionId] or t1

		if v34.type ~= InlineQuestionType.Text and not if v34.type ~= InlineQuestionType.MultipleChoiceSingle then v34.type == InlineQuestionType.MultipleChoiceMulti and (v35.choiceIds ~= nil and #v35.choiceIds >= 1) else v35.choiceIds ~= nil and #v35.choiceIds == 1 then
			return false
		end
	end

	return true
end
local function indexOfQuestion(t5: {[any]: any}, s2: string) -- line: 110
	for v42, v43 in t5 do
		if s2 == v43.questionId then
			return v42
		end
	end

	return nil
end
local function resolveNextQuestionId(p3, p4) -- line: 121
	local choiceIds = p4.choiceIds

	if p3.choices ~= nil and (choiceIds ~= nil and #choiceIds > 0) then
		local v47 = choiceIds[1]

		for _, v49 in p3.choices do
			if v47 == v49.id then
				return v49.next or p3.next
			end
		end
	end

	return p3.next
end
local function getVisitedQuestions(t6: {[any]: any}, t7: {[any]: any}) -- line: 161
	-- upvalues: t1 (copy), resolveNextQuestionId (copy), InlineSurveyTypes (copy)
	local t8 = {}
	local t9 = {}
	local v64 = if not (#t6 > 0) then nil else 1
	local g72 = nil
	local v71 = nil

	while v64 ~= nil and not t9[v64] do
		t9[v64] = true

		local v65 = t6[v64]

		table.insert(t8, v65)

		local v66 = t7[v65.questionId] or t1
		local v67 = t6[v64]

		if v67 == nil then
			v64 = nil

			continue
		end

		local v68 = resolveNextQuestionId(v67, v66)

		if v68 ~= nil then
			if v68 == InlineSurveyTypes.NEXT_END then
				v64 = nil

				continue
			end

			for v69, v70 in t6 do
				if v68 == v70.questionId then
					v71 = v69
					g72 = true
				end

				if g72 then
					break
				end
			end

			if not g72 then
				v71 = nil
			end

			g72 = false

			if v71 ~= nil then
				v64 = v71

				continue
			end
		end

		local v73 = v64 + 1

		v64 = if not (v73 <= #t6) then nil else v73
	end

	return t8
end

return {
	isAnswerComplete = function(p5, p6) -- line: 28
		-- upvalues: InlineQuestionType (copy)
		if p5.type == InlineQuestionType.Text then
			return true
		end

		if p5.type == InlineQuestionType.MultipleChoiceSingle then
			return p6.choiceIds ~= nil and #p6.choiceIds == 1
		end

		if p5.type == InlineQuestionType.MultipleChoiceMulti then
			return p6.choiceIds ~= nil and #p6.choiceIds >= 1
		end

		return false
	end,
	buildSubmitPayload = function(s3: string, t10: {[any]: any}, t11: {[any]: any}, s4: string, t12: {[any]: any}?) -- line: 57
		-- upvalues: t1 (copy), buildResponse (copy)
		local t13 = {}

		for _, v28 in t10 do
			local v29 = t11[v28.questionId] or t1
			local v30 = buildResponse(v28, v29)

			if v30 ~= nil then
				table.insert(t13, {
					questionId = v28.questionId,
					type = v28.type,
					response = v30
				})
			end
		end

		return {
			surveyId = s3,
			idempotencyKey = s4,
			answers = t13,
			finished = if t12 == nil then nil else t12.finished
		}
	end,
	canSubmitAll = canSubmitAll,
	canAdvance = function(t14: {[any]: any}, n1: number, t15: {[any]: any}, p7) -- line: 187
		-- upvalues: FFlagInlineSurveyBranching (copy), resolveNextQuestionId (copy), InlineSurveyTypes (copy), getVisitedQuestions (copy), canSubmitAll (copy), InlineQuestionType (copy)
		local v88 = t14[n1]

		if v88 == nil then
			return false
		end

		local g90 = nil
		local g93 = nil
		local v94 = nil
		local g97 = nil
		local v92 = nil
		local v89 = nil

		if not FFlagInlineSurveyBranching then
			v89 = n1 >= #t14
			g90 = true
		end

		if not g90 then
			local v91 = t14[n1]

			if v91 == nil then
				v92 = nil
				g93 = true
			end

			if not g93 then
				v94 = resolveNextQuestionId(v91, p7)
			end
		end

		repeat
			if g90 or (g93 or (g93 or v94 ~= nil)) then
				if not g90 then
					if not g93 then
						if not g93 then
							if v94 == InlineSurveyTypes.NEXT_END then
								v92 = nil
								g93 = true
							end

							if not g93 then
								for v95, v96 in t14 do
									if v94 == v96.questionId then
										v92 = v95
										g97 = true
									end

									if g97 then
										break
									end
								end

								if not g97 then
									v92 = nil
								end

								g97 = false
							end
						end
					end
				end

				if g90 or (g93 or (g93 or (g93 or v92 ~= nil))) then
					if not g90 then
						g93 = false
						v89 = v92 == nil
					end

					g90 = false

					if v89 then
						local v98 = table.clone(t15)

						if v88 ~= nil then
							v98[v88.questionId] = p7
						end

						local v99 = if not FFlagInlineSurveyBranching then t14 else getVisitedQuestions(t14, v98)

						return (canSubmitAll(v99, v98))
					end

					local v100 = true

					if v88.required == true then
						if v88.type == InlineQuestionType.Text then
							return true
						end

						if v88.type == InlineQuestionType.MultipleChoiceSingle then
							v100 = false

							if p7.choiceIds ~= nil then
								return #p7.choiceIds == 1
							end
						elseif v88.type == InlineQuestionType.MultipleChoiceMulti then
							v100 = false

							if p7.choiceIds ~= nil then
								return #p7.choiceIds >= 1
							end
						else
							v100 = false
						end
					end

					return v100
				end
			end

			local v101 = n1 + 1

			v92 = if not (v101 <= #t14) then nil else v101
			g93 = true
		until not g93
	end,
	resolveNextIndex = function(t16: {[any]: any}, n2: number, p8) -- line: 139
		-- upvalues: resolveNextQuestionId (copy), InlineSurveyTypes (copy)
		local v53 = t16[n2]

		if v53 == nil then
			return nil
		end

		local v54 = resolveNextQuestionId(v53, p8)

		if v54 ~= nil then
			if v54 == InlineSurveyTypes.NEXT_END then
				return nil
			end

			local g58 = nil
			local v57 = nil

			for v55, v56 in t16 do
				if v54 == v56.questionId then
					v57 = v55
					g58 = true
				end

				if g58 then
					break
				end
			end

			if not g58 then
				v57 = nil
			end

			g58 = false

			if v57 ~= nil then
				return v57
			end
		end

		local v59 = n2 + 1

		if v59 <= #t16 then
			return v59
		end

		return nil
	end,
	getVisitedQuestions = getVisitedQuestions,
	isLastQuestion = function(t17: {[any]: any}, n3: number, p9) -- line: 179
		-- upvalues: FFlagInlineSurveyBranching (copy), resolveNextQuestionId (copy), InlineSurveyTypes (copy)
		if not FFlagInlineSurveyBranching then
			return n3 >= #t17
		end

		local v77 = t17[n3]
		local v78

		if v77 == nil then
			v78 = nil

			return v78 == nil
		end

		local v79 = resolveNextQuestionId(v77, p9)

		if v79 ~= nil then
			if v79 == InlineSurveyTypes.NEXT_END then
				v78 = nil

				return v78 == nil
			end

			local g82 = nil

			v78 = nil

			for v80, v81 in t17 do
				if v79 == v81.questionId then
					v78 = v80
					g82 = true
				end

				if g82 then
					break
				end
			end

			if not g82 then
				v78 = nil
			end

			g82 = false

			if v78 ~= nil then
				return v78 == nil
			end
		end

		local v83 = n3 + 1

		v78 = if not (v83 <= #t17) then nil else v83

		return v78 == nil
	end,
	mergeCurrentAnswerIntoBatch = function(t18: {[any]: any}, p10, p11) -- line: 98
		local v39 = table.clone(t18)

		if p10 ~= nil then
			v39[p10.questionId] = p11
		end

		return v39
	end,
	toggleChoice = function(p12, s5: string, b1: boolean) -- line: 206
		-- upvalues: t2 (copy)
		if not b1 then
			return { s5 }
		end

		local t19 = {}
		local v106 = false

		for _, v108 in p12.choiceIds or t2 do
			if v108 == s5 then
				v106 = true
			else
				table.insert(t19, v108)
			end
		end

		if not v106 then
			table.insert(t19, s5)
		end

		return t19
	end
}
