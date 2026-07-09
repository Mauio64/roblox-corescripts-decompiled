local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local EngineFeature = game:GetEngineFeature("AXMarketplaceCommunityAvatarsTooltipKeys")
local React = require(CorePackages.Packages.React)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local Utils = require(Modules.AvatarExperience.Common.Utils)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local u14 = AppStorageService

local function getMockAppStorageService() -- line: 25
	return {
		storage = {},
		GetItem = function(p1, p2) -- line: 28
			return p1.storage[p2]
		end,
		SetItem = function(p3, p4, p5) -- line: 31
			p3.storage[p4] = p5
		end,
		Flush = function(_) -- line: 34
		end
	}
end

if not EngineFeature then
	u14 = getMockAppStorageService()
end

local function useCommunityAvatarEntryButtonTooltip(t1: {[any]: any}) -- line: 50
	-- upvalues: React (copy), useAvatarRoute (copy), useSelector (copy), Utils (copy), getUseSelectorDeepEquals (copy), AvatarScreen (copy), u14 (ref), useIsSpatial (copy)
	local v18, v19 = React.useState(false)
	local v20 = useAvatarRoute()
	local v21 = useSelector(Utils.isAvatarExperienceRoute, getUseSelectorDeepEquals()) and v20.current.name == AvatarScreen.AvatarEditor
	local v22 = t1.appStorageService or u14
	local v23 = useIsSpatial()

	React.useEffect(function() -- line: 63
		-- upvalues: v23 (copy), v19 (copy), v21 (copy), v22 (copy)
		if v23 then
			v19(false)

			return
		end

		if v21 then
			local Item = v22:GetItem("AXMarketplaceCommunityAvatarsTooltipSeenTimestamp")

			v19(Item == "" or Item == nil)

			return
		end

		v19(false)
	end, {
		v21,
		v23
	})

	return v18, function(t2: {[any]: any}) -- line: 75
		-- upvalues: v22 (copy), v19 (copy)
		if t2.saveDismissTime then
			v22:SetItem("AXMarketplaceCommunityAvatarsTooltipSeenTimestamp", (tostring(os.time())))
			v22:Flush()
		end

		v19(false)
	end
end

return useCommunityAvatarEntryButtonTooltip
