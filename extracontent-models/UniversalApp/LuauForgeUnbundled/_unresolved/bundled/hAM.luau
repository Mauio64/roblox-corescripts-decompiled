local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Promise = require(CorePackages.Packages.Promise)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/fTV")
local defineFastInt = game:DefineFastInt("FIntDisplayNameMaxLength", 20)
local defineFastInt2 = game:DefineFastInt("FIntDisplayNameMinLength", 3)

local issueCondition = require("@game/CorePackages/Workspace/Packages/AuthCommon").Enums.IssueCondition

local v5 = {
	ContainsInvalidCharacter = "ContainsInvalidCharacter",
	Inappropriate = "Inappropriate",
	LengthTooShortOrTooLong = "LengthTooShortOrTooLong",
	MixedCharactersError = "MixedCharactersError",
	None = "None",
	TooManyCharacterSets = "TooManyCharacterSets",
	ValidationFailed = "ValidationFailed"
}

local v6 = {
	[0] = "None",
	[1] = "LengthTooShortOrTooLong",
	[2] = "LengthTooShortOrTooLong",
	[3] = "ContainsInvalidCharacter",
	[4] = "Inappropriate",
	[5] = "ValidationFailed",
	[8] = "TooManyCharacterSets"
}

local issueMessageList = {
	ContainsInvalidCharacter = "Feature.DisplayName.Label.ValidCharacters",
	LengthTooShortOrTooLong = "Authentication.SignUp.Label.UsernameError2",
	MixedCharactersError = "Feature.DisplayName.Label.MixedCharactersError",
	Inappropriate = "Feature.DisplayName.Label.ModeratedCheck",
	ValidationFailed = "Feature.DisplayName.Label.ValidationFailed"
}

local v7 = { LengthTooShortOrTooLong = true, ContainsInvalidCharacter = true }

local function fn()
	local hiddens = {}

	for k, v8 in issueMessageList do
		if not v7[k] then
			hiddens[k] = issueCondition.Hidden
		end
	end

	return hiddens
end

function LUAUFORGE_MODULE_GLOBALS_hAM_isValidLength(value): boolean
	local v8 = string.len(value)
	return v8 < defineFastInt2 or defineFastInt < v8
end

function LUAUFORGE_MODULE_GLOBALS_hAM_locallyValidateDisplayName(p2)
	local v8 = {}

	local v9 = if LUAUFORGE_MODULE_GLOBALS_hAM_isValidLength(p2) then issueCondition.Problematic else issueCondition.Resolved
	v8.LengthTooShortOrTooLong = v9

	return LUAUFORGE_MODULE_GLOBALS_hAM_isValidLength(p2), v8
end

return {
	validateFunction = function(p2, p3, p4, p5)
		return function(p6)
			local v8 = fn()

			if p3 == "" then
				if p4.ValidationFailed == issueCondition.Problematic then
					return Promise.resolve({
						Input = p3,
						InputValid = false,
						IssueCondition = p4,
						hasRequestFailed = true
					})
				end

				return Promise.resolve({
					Input = p3,
					InputValid = false,
					IssueCondition = v8
				})
			else
				local resolveds = {}

				for k in v7 do
					resolveds[k] = issueCondition.Resolved
				end

				local joined = Cryo.Dictionary.join(v8, resolveds)

				local v9, v10 = LUAUFORGE_MODULE_GLOBALS_hAM_locallyValidateDisplayName(p3)

				if not v9 then
					return module(p2, p3, p5.birthday):andThen(function()
						return Promise.resolve({
							Input = p3,
							InputValid = true,
							IssueCondition = joined,
							hasRequestFailed = false
						})
					end, function(p7)
						if p7 and p7.StatusCode == 400 then
							local v11 = if p7 and p7.Body then HttpService:JSONDecode(p7.Body) else nil

							local v12 = not (v11 and v11.errors) and {} or v11.errors
							local problematics = joined
							Cryo.List.map(v12, function(p8)
								local v13 = v6[p8.code]
								problematics[v13] = issueCondition.Problematic
							end)

							return Promise.resolve({
								Input = p3,
								InputValid = false,
								IssueCondition = problematics,
								hasRequestFailed = false
							})
						else
							local hiddens = {}

							for k in pairs(joined) do
								hiddens[k] = issueCondition.Hidden
							end

							hiddens.ValidationFailed = issueCondition.Problematic

							return Promise.resolve({
								Input = p3,
								InputValid = false,
								IssueCondition = hiddens,
								hasRequestFailed = true
							})
						end
					end)
				end

				if p4.ValidationFailed == issueCondition.Problematic then
					return Promise.resolve({
						Input = p3,
						InputValid = false,
						IssueCondition = p4,
						hasRequestFailed = true
					})
				end

				return Promise.resolve({
					Input = p3,
					InputValid = false,
					IssueCondition = Cryo.Dictionary.join(joined, v10)
				})
			end
		end
	end,
	getIssueMessageList = function()
		return issueMessageList
	end,
	getDefaultIssues = function()
		local defaultIssues = {}

		for k in pairs(issueMessageList) do
			if v7[k] then
				defaultIssues[k] = issueCondition.Problematic
			else
				defaultIssues[k] = issueCondition.Hidden
			end
		end

		return defaultIssues
	end
}
