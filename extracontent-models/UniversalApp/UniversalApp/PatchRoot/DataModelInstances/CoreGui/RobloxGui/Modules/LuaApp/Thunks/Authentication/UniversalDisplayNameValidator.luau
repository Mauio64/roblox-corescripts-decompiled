local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Promise = require(CorePackages.Packages.Promise)
local Cryo = require(CorePackages.Packages.Cryo)
local GetDisplayNamesValid = require(Modules.LuaApp.Http.Requests.GetDisplayNamesValid)
local v7 = game:DefineFastInt("FIntDisplayNameMaxLength", 20)
local v8 = game:DefineFastInt("FIntDisplayNameMinLength", 3)
local IssueCondition = require(CorePackages.Workspace.Packages.AuthCommon).Enums.IssueCondition
local _ = {
	ContainsInvalidCharacter = "ContainsInvalidCharacter",
	Inappropriate = "Inappropriate",
	LengthTooShortOrTooLong = "LengthTooShortOrTooLong",
	MixedCharactersError = "MixedCharactersError",
	None = "None",
	TooManyCharacterSets = "TooManyCharacterSets",
	ValidationFailed = "ValidationFailed"
}
local t1 = {
	[0] = "None",
	[1] = "LengthTooShortOrTooLong",
	[2] = "LengthTooShortOrTooLong",
	[3] = "ContainsInvalidCharacter",
	[4] = "Inappropriate",
	[5] = "ValidationFailed",
	[8] = "TooManyCharacterSets"
}
local t2 = {
	ContainsInvalidCharacter = "Feature.DisplayName.Label.ValidCharacters",
	LengthTooShortOrTooLong = "Authentication.SignUp.Label.UsernameError2",
	MixedCharactersError = "Feature.DisplayName.Label.MixedCharactersError",
	Inappropriate = "Feature.DisplayName.Label.ModeratedCheck",
	ValidationFailed = "Feature.DisplayName.Label.ValidationFailed"
}
local t3 = {
	LengthTooShortOrTooLong = true,
	ContainsInvalidCharacter = true
}

local function v14() -- line: 48
	-- upvalues: t2 (copy), t3 (copy), IssueCondition (copy)
	local t4 = {}

	for v16, _ in t2 do
		if not t3[v16] then
			t4[v16] = IssueCondition.Hidden
		end
	end

	return t4
end

function isValidLength(s1: string) -- line: 59
	-- upvalues: v8 (copy), v7 (copy)
	local v19 = string.len(s1)

	return v19 < v8 or v19 > v7
end
function locallyValidateDisplayName(s2: string) -- line: 64
	-- upvalues: IssueCondition (copy)
	local t5 = {
		LengthTooShortOrTooLong = if not isValidLength(s2) then IssueCondition.Resolved else IssueCondition.Problematic
	}

	return isValidLength(s2), t5
end

return {
	validateFunction = function(p1, s3: string, p2, t6: {[any]: any}) -- line: 91
		-- upvalues: v14 (copy), IssueCondition (copy), Promise (copy), t3 (copy), Cryo (copy), GetDisplayNamesValid (copy), HttpService (copy), t1 (copy)
		return function(_) -- line: 100
			-- upvalues: v14 (copy), s3 (copy), p2 (copy), IssueCondition (copy), Promise (copy), t3 (copy), Cryo (copy), GetDisplayNamesValid (copy), p1 (copy), t6 (copy), HttpService (copy), t1 (copy)
			local v29 = v14()

			if s3 == "" then
				if p2.ValidationFailed == IssueCondition.Problematic then
					return Promise.resolve({
						InputValid = false,
						hasRequestFailed = true,
						Input = s3,
						IssueCondition = p2
					})
				end

				return Promise.resolve({
					InputValid = false,
					Input = s3,
					IssueCondition = v29
				})
			end

			local t7 = {}

			for v31 in t3 do
				t7[v31] = IssueCondition.Resolved
			end

			local v32 = Cryo.Dictionary.join(v29, t7)
			local v33, v34 = locallyValidateDisplayName(s3)

			if v33 then
				if p2.ValidationFailed == IssueCondition.Problematic then
					return Promise.resolve({
						InputValid = false,
						hasRequestFailed = true,
						Input = s3,
						IssueCondition = p2
					})
				end

				return Promise.resolve({
					InputValid = false,
					Input = s3,
					IssueCondition = Cryo.Dictionary.join(v32, v34)
				})
			end

			return GetDisplayNamesValid(p1, s3, t6.birthday):andThen(function() -- line: 143
				-- upvalues: Promise (copy), s3 (copy), v32 (copy)
				return Promise.resolve({
					InputValid = true,
					hasRequestFailed = false,
					Input = s3,
					IssueCondition = v32
				})
			end, function(p4) -- line: 150
				-- upvalues: HttpService (copy), v32 (copy), Cryo (copy), t1 (copy), IssueCondition (copy), Promise (copy), s3 (copy)
				if p4 and p4.StatusCode == 400 then
					local v36 = if not p4 or not p4.Body then nil else HttpService:JSONDecode(p4.Body)
					local v37 = if not v36 or not v36.errors then {} else v36.errors
					local v38 = v32

					Cryo.List.map(v37, function(p5) -- line: 157
						-- upvalues: t1 (copy), v38 (copy), IssueCondition (copy)
						v38[t1[p5.code]] = IssueCondition.Problematic
					end)

					return Promise.resolve({
						InputValid = false,
						hasRequestFailed = false,
						Input = s3,
						IssueCondition = v38
					})
				end

				local t8 = {}

				for k in pairs(v32) do
					t8[k] = IssueCondition.Hidden
				end

				t8.ValidationFailed = IssueCondition.Problematic

				return Promise.resolve({
					InputValid = false,
					hasRequestFailed = true,
					Input = s3,
					IssueCondition = t8
				})
			end)
		end
	end,
	getIssueMessageList = function() -- line: 74
		-- upvalues: t2 (copy)
		return t2
	end,
	getDefaultIssues = function() -- line: 78
		-- upvalues: t2 (copy), t3 (copy), IssueCondition (copy)
		local t9 = {}

		for k in pairs(t2) do
			if t3[k] then
				t9[k] = IssueCondition.Problematic
			else
				t9[k] = IssueCondition.Hidden
			end
		end

		return t9
	end
}
