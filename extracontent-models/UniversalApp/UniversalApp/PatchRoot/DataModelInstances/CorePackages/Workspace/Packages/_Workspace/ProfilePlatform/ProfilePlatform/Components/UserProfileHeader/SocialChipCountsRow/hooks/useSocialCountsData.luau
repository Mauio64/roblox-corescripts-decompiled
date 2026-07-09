local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Cryo = require(ProfilePlatformParent.Cryo)
local Localization = require(ProfilePlatformParent.Localization)
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useLocalization = Localization.Hooks.useLocalization
local abbreviateCount = Localization.abbreviateCount
local SocialCountsConfig = require(script.Parent.Parent.config.SocialCountsConfig)

local function useSocialCountsData(_: string, b1: boolean, b2: boolean, t1: {[any]: any}?) -- line: 25
	-- upvalues: useProfileJsonComponent (copy), Enums (copy), React (copy), Cryo (copy), SocialCountsConfig (copy), useLocalization (copy), abbreviateCount (copy)
	local counts = useProfileJsonComponent(Enums.Components.UserProfileHeader).counts
	local v17 = React.useMemo(function() -- line: 33
		-- upvalues: Cryo (copy), SocialCountsConfig (copy)
		return Cryo.Dictionary.map(SocialCountsConfig.RowConfig, function(p1) -- line: 34
			return p1.textKey
		end)
	end, {})
	local v18 = useLocalization(v17)
	local v19 = React.useMemo(function() -- line: 41
		-- upvalues: Cryo (copy), SocialCountsConfig (copy)
		return Cryo.Dictionary.map(SocialCountsConfig.RowConfig, function(p2) -- line: 42
			return p2.singleTextKey
		end)
	end, {})
	local v20 = useLocalization(v19)

	return React.useMemo(function() -- line: 49
		-- upvalues: counts (copy), SocialCountsConfig (copy), v18 (copy), v20 (copy), t1 (copy), abbreviateCount (copy), b2 (copy), b1 (copy)
		local t2 = {}

		for v22, v23 in counts do
			local v24 = SocialCountsConfig.RowConfig[v22]

			if v24 then
				local v25 = counts[v24.enabledKey]

				if v25 == nil then
					v25 = true
				end

				local v26 = v18[v22]

				if v23 == 1 and v20[v22] then
					v26 = v20[v22]
				end

				local v27 = nil

				if v24.getLeading and t1 then
					v27 = v24.getLeading({
						mutualFriendIds = t1
					})
				end

				table.insert(t2, {
					fieldName = v22,
					count = abbreviateCount(v23),
					text = v26,
					layoutOrder = v24.layoutOrder,
					leading = v27,
					isDisabled = v24.getIsDisabled(b2, b1, v25)
				})
			end
		end

		table.sort(t2, function(p3, p4) -- line: 89
			return p3.layoutOrder < p4.layoutOrder
		end)

		return t2
	end, {
		counts,
		v18,
		v20,
		b2,
		b1,
		t1
	})
end

return useSocialCountsData
