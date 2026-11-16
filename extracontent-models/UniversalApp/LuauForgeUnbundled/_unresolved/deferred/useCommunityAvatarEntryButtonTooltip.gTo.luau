local CorePackages = game:GetService("CorePackages")
local v5 = game:GetService("AppStorageService")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")

local engineFeature = game:GetEngineFeature("AXMarketplaceCommunityAvatarsTooltipKeys")

local React = require(CorePackages.Packages.React)

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local module3 = require("@luauforge/bundled/fuD")

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local function getMockAppStorageService()
	return {
		storage = {},
		GetItem = function(self, p3)
			return self.storage[p3]
		end,
		SetItem = function(self, p3, p4)
			self.storage[p3] = p4
		end,
		Flush = function(self) end
	}
end

if not engineFeature then
	v5 = getMockAppStorageService()
end

local function useCommunityAvatarEntryButtonTooltip(p2)
	local state, setState = React.useState(false)

	local v6 = useAvatarRoute()

	local v8 = (if fFlagSignalsNavP3gAvatarExperience then useSignalState(module3.getIsAvatarExperienceRoute()) else useSelector(
			module3.isAvatarExperienceRoute,
			getUseSelectorDeepEquals()
		))
		and v6.current.name == avatarScreen.AvatarEditor

	local appStorageService = p2.appStorageService or v5

	local v9 = useIsSpatial()

	React.useEffect(function()
		if v9 then
			setState(false)
			return
		end

		if not v8 then
			setState(false)

			return
		end

		local item = appStorageService:GetItem("AXMarketplaceCommunityAvatarsTooltipSeenTimestamp")

		setState(item == "" or item == nil)
	end, { v8, v9 })

	return state, function(p3)
		if p3.saveDismissTime then
			appStorageService:SetItem(
				"AXMarketplaceCommunityAvatarsTooltipSeenTimestamp",
				(tostring(os.time()))
			)
			appStorageService:Flush()
		end

		setState(false)
	end
end

return useCommunityAvatarEntryButtonTooltip
