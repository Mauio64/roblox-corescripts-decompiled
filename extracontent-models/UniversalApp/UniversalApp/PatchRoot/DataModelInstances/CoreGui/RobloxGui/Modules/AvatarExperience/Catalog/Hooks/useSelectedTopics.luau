local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local SetSelectedTopics = require(Modules.AvatarExperience.Catalog.Actions.SetSelectedTopics)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local t1 = {}

local function selectSelectedTopics(p1) -- line: 26
	-- upvalues: t1 (copy)
	return p1.AvatarExperience.Catalog.SortAndFilters.SelectedTopics or t1
end
local function useSelectedTopics() -- line: 33
	-- upvalues: useSelector (copy), selectSelectedTopics (copy), getUseSelectorDeepEquals (copy), useDispatch (copy), React (copy), SetSelectedTopics (copy)
	local v13 = useSelector(selectSelectedTopics, getUseSelectorDeepEquals())
	local v14 = useDispatch()

	return v13, (React.useCallback(function(t2: {[any]: any}) -- line: 37
		-- upvalues: v14 (copy), SetSelectedTopics (copy)
		v14(SetSelectedTopics(t2))
	end))
end

return useSelectedTopics
