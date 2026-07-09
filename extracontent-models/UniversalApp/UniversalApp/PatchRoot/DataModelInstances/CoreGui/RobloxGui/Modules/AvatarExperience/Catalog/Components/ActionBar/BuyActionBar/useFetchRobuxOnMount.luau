local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local ApiFetchEconomyCurrency = require(Modules.LuaApp.Thunks.ApiFetchEconomyCurrency)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals

local function selectRobuxFetchInfo(p1) -- line: 13
	local LocalUserId = p1.LocalUserId
	local v14 = p1.UserRobux[LocalUserId]

	return {
		localUserId = p1.LocalUserId,
		userRobux = v14
	}
end
local function useFetchRobuxOnMount() -- line: 19
	-- upvalues: useSelector (copy), selectRobuxFetchInfo (copy), getUseSelectorDeepEquals (copy), useRoactService (copy), RoactNetworking (copy), useDispatch (copy), React (copy), ApiFetchEconomyCurrency (copy)
	local v15 = useSelector(selectRobuxFetchInfo, getUseSelectorDeepEquals())
	local v16 = useRoactService(RoactNetworking)
	local v17 = useDispatch()

	React.useEffect(function() -- line: 23
		-- upvalues: v15 (copy), v17 (copy), ApiFetchEconomyCurrency (copy), v16 (copy)
		if v15.userRobux == nil then
			v17(ApiFetchEconomyCurrency(v16, v15.localUserId, false))
		end
	end, {})
end

return useFetchRobuxOnMount
