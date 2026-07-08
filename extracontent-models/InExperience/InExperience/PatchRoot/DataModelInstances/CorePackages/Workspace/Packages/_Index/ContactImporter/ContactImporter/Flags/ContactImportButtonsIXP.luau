local Parent = script:FindFirstAncestor("ContactImporter").Parent
local RoactAppExperiment = require(Parent.RoactAppExperiment)
local v3 = game:DefineFastString("ContactImportLayer", "Social.ContactList")
local v4 = game:DefineFastString("ContactImportGreenFindFriendsButtonExperimentVariable", "green_find_friends_button")
local v5 = game:DefineFastString("ContactImportRemoveCloseButtonExperimentVariable", "remove_close_button")
local useUserExperiment = RoactAppExperiment.useUserExperiment

local function v7(p1) -- line: 12
	-- upvalues: v3 (copy), v4 (copy)
	return ((p1 or {})[v3] or {})[v4] == true
end
local function v8(p2) -- line: 18
	-- upvalues: v3 (copy), v5 (copy)
	return ((p2 or {})[v3] or {})[v5] == true
end

return {
	isGreenFindFriendsButtonExperimentEnabled = v7,
	isRemoveCloseButtonExperimentEnabled = v8,
	useIsGreenFindFriendsButtonExperimentEnabled = function(t1: {[any]: any}) -- line: 27
		-- upvalues: useUserExperiment (copy), v3 (copy), v7 (copy)
		return useUserExperiment({ v3 }, v7, t1.isExposureEnabled)
	end,
	useIsRemoveCloseButtonExperimentEnabled = function(t2: {[any]: any}) -- line: 34
		-- upvalues: useUserExperiment (copy), v3 (copy), v8 (copy)
		return useUserExperiment({ v3 }, v8, t2.isExposureEnabled)
	end
}
