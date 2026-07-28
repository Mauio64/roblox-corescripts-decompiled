local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Navigation = require(ProfilePlatformParent.Navigation)
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local SocialLuaAnalytics = require(ProfilePlatformParent.SocialLuaAnalytics)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Common.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useNavigation = Navigation.useNavigation
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local function truncateLabel(s1: string) -- line: 24
	local v15 = utf8.len(s1)

	if v15 == nil or v15 <= 8 then
		return s1
	end

	local v16 = utf8.offset(s1, 9)

	if v16 == nil then
		return s1
	end

	return string.sub(s1, 1, v16 - 1) .. "…"
end
local function useSchoolChip(p1) -- line: 36
	-- upvalues: useNavigation (copy), useProfileJsonComponent (copy), Enums (copy), React (copy), EventNames (copy), AppPage (copy), Contexts (copy)
	local v18 = useNavigation()
	local school = useProfileJsonComponent(Enums.Components.UserProfileHeader).school
	local v20 = React.useMemo(function() -- line: 40
		-- upvalues: school (copy)
		local v22 = if not school then nil else school.name

		if v22 == nil or v22 == "" then
			return nil
		end

		local v23 = utf8.len(v22)

		if v23 == nil or v23 <= 8 then
			return v22
		end

		local v24 = utf8.offset(v22, 9)

		if v24 == nil then
			return v22
		end

		return string.sub(v22, 1, v24 - 1) .. "…"
	end, { school })
	local v21 = React.useCallback(function() -- line: 48
		-- upvalues: p1 (copy), EventNames (copy), v18 (copy), AppPage (copy), Contexts (copy)
		p1.fireAnalyticsEvent(EventNames.SchoolButton)
		v18.navigate(AppPage.Schools, {
			extraProps = {
				source = Contexts.PlayerProfile
			}
		})
	end, {
		p1,
		v18
	})

	return React.useMemo(function() -- line: 57
		-- upvalues: v20 (copy), v21 (copy)
		if v20 == nil then
			return nil
		end

		return {
			layoutOrder = 0,
			isDisabled = false,
			text = v20,
			onActivated = v21
		}
	end, {
		v20,
		v21
	})
end

return useSchoolChip
