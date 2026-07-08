local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local React = require(GroupsParent.React)
local useLocalization = require(GroupsParent.Localization).Hooks.useLocalization
local TextKeys = require(Groups.Common.TextKeys)

local function useMembersFollowersLabel(t1: {[any]: any}) -- line: 31
	-- upvalues: React (copy), TextKeys (copy), useLocalization (copy)
	local hasSocialModules = t1.hasSocialModules
	local count = t1.count
	local truncatedCount = t1.truncatedCount
	local v11 = t1.capitalize or false
	local v12 = React.useMemo(function() -- line: 38
		-- upvalues: count (copy), hasSocialModules (copy), v11 (copy), TextKeys (copy)
		local v14 = count == 1

		if hasSocialModules then
			if v14 then
				if v11 then
					return TextKeys.LabelMember
				end

				return TextKeys.LabelMemberLowerCase
			end

			if v11 then
				return TextKeys.LabelMemberCapitalPlural
			end

			return TextKeys.LabelMemberLowerCasePlural
		end

		if v14 then
			if v11 then
				return TextKeys.LabelFollowerCapital
			end

			return TextKeys.LabelFollower
		end

		if v11 then
			return TextKeys.LabelFollowerCapitalPlural
		end

		return TextKeys.LabelFollowerPlural
	end, {
		count,
		v11,
		hasSocialModules
	})
	local v13 = useLocalization({
		noun = v12
	})

	return (React.useMemo(function() -- line: 61
		-- upvalues: truncatedCount (copy), count (copy), v13 (copy)
		return `{ (if not truncatedCount or truncatedCount == "" then tostring(count) else truncatedCount) } { v13.noun }`
	end, {
		truncatedCount,
		count,
		v13.noun
	}))
end

return useMembersFollowersLabel
