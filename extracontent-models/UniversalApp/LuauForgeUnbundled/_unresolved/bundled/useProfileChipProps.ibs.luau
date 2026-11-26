local module = require("@luauforge/bundled/ibe")
local module2 = require("@luauforge/bundled/ibp")
local useDispatch = module2.Hooks.RoactRodux.useDispatch
local useSelector = module2.Hooks.RoactRodux.useSelector

local getStandardSizeAvatarHeadShotRbxthumb = require("@luauforge/bundled/ibt").Utils.getStandardSizeAvatarHeadShotRbxthumb
local useAppPolicy = require("@luauforge/bundled/ibu").useAppPolicy

local avatarScreen = require("@luauforge/bundled/ibv").Enums.AvatarScreen

local supportRegionAvatarOverlayAnalytics = require("@luauforge/bundled/ibw").Surfaces.SupportRegionAvatarOverlayAnalytics

local module3 = require("@luauforge/bundled/ibx")

local module4 = require("@luauforge/bundled/iby")
local fFlagAXEnableProfileTab = module4.FFlagAXEnableProfileTab
local fFlagSplitPaneAvatarMetrics = module4.FFlagSplitPaneAvatarMetrics
local module5 = require("@luauforge/bundled/ibr")

local function selectLocalUserModel(p2)
	if p2.Users then
		return p2.Users[p2.LocalUserId]
	end

	return nil
end

local function useProfileChipProps()
	local v5 = module3()
	local v6 = useDispatch()
	local v7 = useSelector(selectLocalUserModel)
	local v8 = useAppPolicy(function(p2)
		return p2.getShowDisplayName()
	end)

	local v9 = module.useCallback(function()
		if fFlagSplitPaneAvatarMetrics then
			supportRegionAvatarOverlayAnalytics.logProfileChipClick()
		end

		if fFlagAXEnableProfileTab and not module5 then
			v6(v5.NavigateIntoAvatarExperience(avatarScreen.Profile, {
				entryOrigin = { screenName = avatarScreen.AvatarExperienceLandingPage }
			}))
		elseif v7 ~= nil then
			v6(v5.OpenProfilePeekView(v7.id))
		end
	end, { v6, v7, v5 })

	return module.useMemo(function()
		local v10 = {
			isUserLoaded = v7 ~= nil,
			thumbnail = 0,
			name = 0,
			isVerified = 0,
			showSubscriberBadge = 0,
			onActivated = 0
		}

		local v11 = if v7 ~= nil then getStandardSizeAvatarHeadShotRbxthumb(v7.id, module5) else nil
		v10.thumbnail = v11

		local v12 = if v7 ~= nil then (if v8 then v7.displayName else v7.name) else nil
		v10.name = v12

		local v13 = if v7 ~= nil then v7.hasVerifiedBadge else nil
		v10.isVerified = v13
		v10.showSubscriberBadge = v7 ~= nil and v7.hasRobloxSubscription == true
		v10.onActivated = v9
		return v10
	end, { v7, v9, v8 })
end

return useProfileChipProps
