local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module2 = require("@luauforge/deferred/gUA")

local module3 = require("@luauforge/deferred/gUB")

local module4 = require("@luauforge/deferred/gUC")

local module5 = require("@luauforge/deferred/gUD")
local defineFastFlag = game:DefineFastFlag("TurnOffModerationAlert", false)
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local function ResultsListListHeader(p2)
	local v5 = useAvatarRoute()

	local v6 = useSelector(function(p3)
		if defineFastFlag then
			return false
		end

		return module2(p3, v5)
	end, getUseSelectorDeepEquals())
	local v7 = useSelector(function(p3)
		return module3(p3, v5)
	end, getUseSelectorDeepEquals())

	if not v5 or not v5.opaque or v5.opaque.name ~= avatarScreen.MySharedAvatars then
		return nil
	end

	if v6 then
		return React.createElement(module4)
	end

	if v7 then
		return React.createElement(module5)
	end

	return nil
end

return ResultsListListHeader
