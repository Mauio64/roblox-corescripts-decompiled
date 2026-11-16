local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Localization = require(parent.Localization)

local Enums = require(ProfilePlatform.Common.Enums)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileJson = require(ProfilePlatform.Hooks.useProfileJson)
local useLocalization = Localization.Hooks.useLocalization
local abbreviateCount = Localization.abbreviateCount

local SocialCountsConfig = require(script.Parent.Parent.config.SocialCountsConfig)
local FFlagProfilePlatformGracefulVisibility = require(ProfilePlatform.Flags.FFlagProfilePlatformGracefulVisibility)

local function useSocialCountsData(_: string, flag: boolean, flag2: boolean, mutualFriendIds)
	local counts = useProfileJsonComponent(Enums.Components.UserProfileHeader).counts
	local v

	if FFlagProfilePlatformGracefulVisibility then
		local v2 = useProfileJson()

		if v2.components == nil then
			v = false
		else
			v = v2.components[Enums.Components.Friends] ~= nil
		end
	else
		v = true
	end

	local v2 = useLocalization((React.useMemo(function()
		return Cryo.Dictionary.map(SocialCountsConfig.RowConfig, function(p)
			return p.textKey
		end)
	end, {})))

	local v3 = useLocalization((React.useMemo(function()
		return Cryo.Dictionary.map(SocialCountsConfig.RowConfig, function(p)
			return p.singleTextKey
		end)
	end, {})))

	return React.useMemo(function()
		local result = {}

		for k, count in counts do
			local v4 = SocialCountsConfig.RowConfig[k]

			if not v4 then
				continue
			end

			local count2 = counts[v4.enabledKey]
			local v5 = count2 == nil or count2

			if FFlagProfilePlatformGracefulVisibility and k == "friendsCount" then
				v5 = v5 and v
			end

			local text = v2[k]

			if count == 1 and v3[k] then
				text = v3[k]
			end

			local leading

			if v4.getLeading and mutualFriendIds then
				leading = v4.getLeading({ mutualFriendIds = mutualFriendIds })
			end

			table.insert(result, {
				fieldName = k,
				count = abbreviateCount(count),
				text = text,
				layoutOrder = v4.layoutOrder,
				leading = leading,
				isDisabled = v4.getIsDisabled(flag2, flag, v5)
			})
		end

		table.sort(result, function(a, b): boolean
			return a.layoutOrder < b.layoutOrder
		end)

		return result
	end, { counts, v2, v3, flag2, flag, mutualFriendIds, v })
end

return useSocialCountsData
