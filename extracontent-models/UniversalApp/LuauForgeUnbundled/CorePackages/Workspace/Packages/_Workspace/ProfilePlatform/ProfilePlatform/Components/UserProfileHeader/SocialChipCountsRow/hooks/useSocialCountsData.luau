local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileJson = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJson")
local useLocalization = Localization.Hooks.useLocalization
local abbreviateCount = Localization.abbreviateCount

local SocialCountsConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/SocialChipCountsRow/config/SocialCountsConfig")
local FFlagProfilePlatformGracefulVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformGracefulVisibility")

local function useSocialCountsData(p2, p3, p4, p5)
	local counts = useProfileJsonComponent(Enums.Components.UserProfileHeader).counts
	local v5

	if FFlagProfilePlatformGracefulVisibility then
		local v6 = useProfileJson()
		v5 = not (v6.components == nil) and v6.components[Enums.Components.Friends] ~= nil
	else
		v5 = true
	end

	local v7 = useLocalization((React.useMemo(function()
		return Cryo.Dictionary.map(SocialCountsConfig.RowConfig, function(p6)
			return p6.textKey
		end)
	end, {})))

	local v9 = useLocalization((React.useMemo(function()
		return Cryo.Dictionary.map(SocialCountsConfig.RowConfig, function(p6)
			return p6.singleTextKey
		end)
	end, {})))

	return React.useMemo(function()
		local result = {}

		for k, count in counts do
			local v10 = SocialCountsConfig.RowConfig[k]

			if not v10 then
				continue
			end

			local count2 = counts[v10.enabledKey]
			local v11 = count2 == nil or count2

			if FFlagProfilePlatformGracefulVisibility and k == "friendsCount" then
				v11 = v11 and v5
			end

			local v12 = v7[k]

			if count == 1 and v9[k] then
				v12 = v9[k]
			end

			local v13 = if v10.getLeading and p5 then v10.getLeading({
				mutualFriendIds = p5
			}) else nil

			table.insert(result, {
				fieldName = k,
				count = abbreviateCount(count),
				text = v12,
				layoutOrder = v10.layoutOrder,
				leading = v13,
				isDisabled = v10.getIsDisabled(p4, p3, v11)
			})
		end

		table.sort(result, function(a, b): boolean
			return a.layoutOrder < b.layoutOrder
		end)

		return result
	end, { counts, v7, v9, p4, p3, p5, v5 })
end

return useSocialCountsData
