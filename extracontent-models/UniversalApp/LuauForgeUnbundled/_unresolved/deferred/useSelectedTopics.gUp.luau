local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module = require("@luauforge/bundled/dSJ")
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local v5 = {}

local function selectSelectedTopics(p2)
	return p2.AvatarExperience.Catalog.SortAndFilters.SelectedTopics or v5
end

local function useSelectedTopics()
	local v6 = useSelector(selectSelectedTopics, getUseSelectorDeepEquals())

	local v7 = useDispatch()
	return v6, (React.useCallback(function(p2)
		v7(module(p2))
	end))
end

return useSelectedTopics
