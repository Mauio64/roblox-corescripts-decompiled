local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local TextKeys = require(Groups.Common.TextKeys)

local function useMembersFollowersLabel(data)
	local hasSocialModules = data.hasSocialModules
	local count = data.count
	local truncatedCount = data.truncatedCount
	local capitalize = data.capitalize or false

	local v = useLocalization({
		noun = React.useMemo(function()
			local v = count == 1

			if hasSocialModules then
				if v then
					if capitalize then
						return TextKeys.LabelMember
					end

					return TextKeys.LabelMemberLowerCase
				elseif capitalize then
					return TextKeys.LabelMemberCapitalPlural
				else
					return TextKeys.LabelMemberLowerCasePlural
				end
			elseif v then
				if capitalize then
					return TextKeys.LabelFollowerCapital
				end

				return TextKeys.LabelFollower
			elseif capitalize then
				return TextKeys.LabelFollowerCapitalPlural
			else
				return TextKeys.LabelFollowerPlural
			end
		end, { count, capitalize, hasSocialModules })
	})

	return (React.useMemo(function()
		local v2

		if truncatedCount and truncatedCount ~= "" then
			v2 = truncatedCount
		else
			v2 = tostring(count)
		end

		return `{v2} {v.noun}`
	end, { truncatedCount, count, v.noun }))
end

return useMembersFollowersLabel
