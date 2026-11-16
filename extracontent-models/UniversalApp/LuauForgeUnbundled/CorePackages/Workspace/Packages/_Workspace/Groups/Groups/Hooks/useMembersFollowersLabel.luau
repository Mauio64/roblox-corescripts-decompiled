local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Localization").Hooks.useLocalization

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/TextKeys")

local function useMembersFollowersLabel(data)
	local hasSocialModules = data.hasSocialModules
	local count = data.count
	local truncatedCount = data.truncatedCount
	local capitalize = data.capitalize or false

	local v6 = useLocalization({
		noun = React.useMemo(function()
			local v6 = count == 1

			if hasSocialModules then
				if v6 then
					if capitalize then
						return TextKeys.LabelMember
					end

					return TextKeys.LabelMemberLowerCase
				elseif capitalize then
					return TextKeys.LabelMemberCapitalPlural
				else
					return TextKeys.LabelMemberLowerCasePlural
				end
			elseif v6 then
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
		local v7 = if truncatedCount and truncatedCount ~= "" then truncatedCount else tostring(count)
		return `{v7} {v6.noun}`
	end, { truncatedCount, count, v6.noun }))
end

return useMembersFollowersLabel
