require("@luauforge/deferred/egX")
local module = require("@luauforge/deferred/ehq")

local function decodeGraduationYearOption(data)
	return {
		graduationYear = data.graduationYear,
		roleId = data.roleId,
		activeStudent = data.activeStudent
	}
end

local function decodeSchool(school)
	local v5 = table.create(#school.graduationYearOptions)

	for k, graduationYearOption in school.graduationYearOptions do
		table.insert(v5, {
			graduationYear = graduationYearOption.graduationYear,
			roleId = graduationYearOption.roleId,
			activeStudent = graduationYearOption.activeStudent
		})
	end

	local v6 = {
		countryCode = school.country,
		state = school.state,
		city = school.city
	}

	return {
		schoolId = school.schoolId,
		schoolName = school.name,
		schoolNickname = school.nickname,
		subtype = school.subtype,
		location = v6,
		graduationYearOptions = v5
	}
end

local function decodeRewardItem(data)
	return { type = data.type, assetId = data.assetId, owned = data.owned }
end

return {
	decodeSchoolVerification = function(p2)
		local schools = p2.schools or {}
		local v5 = table.create(#schools)

		for k, school in schools do
			table.insert(v5, decodeSchool(school))
		end

		return { schools = v5, suggestedEmail = p2.suggestedEmail }
	end,
	decodeSchool = decodeSchool,
	decodeVerifyOtp = function(data)
		return {
			groupId = data.groupId,
			name = data.name,
			nickname = data.nickname,
			status = data.status,
			memberCount = data.memberCount,
			membersNeededForNextTier = data.membersNeededForNextTier,
			subtype = data.subtype
		}
	end,
	decodeVerifiedSchool = function(data)
		local v5

		if data.rewards then
			v5 = table.create(#data.rewards)

			for k, reward in data.rewards do
				table.insert(v5, {
					type = reward.type,
					assetId = reward.assetId,
					owned = reward.owned
				})
			end
		end

		local v6 = {
			groupId = data.groupId,
			description = data.description,
			memberCount = data.memberCount,
			membersNeededForNextTier = data.membersNeededForNextTier,
			subtype = data.subtype,
			country = data.country,
			state = data.state,
			city = data.city,
			supportedVerificationMethods = data.supportedVerificationMethods,
			status = data.status,
			rewards = v5,
			name = 0
		}

		local v7 = if module and typeof(data.name) == "string" and data.name ~= "" then data.name else nil
		v6.name = v7
		return v6
	end,
	schoolToListItem = function(data)
		return {
			id = data.schoolId,
			name = data.schoolName,
			city = data.location.city,
			state = data.location.state
		}
	end
}
