local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local FetchTopics = require(Modules.AvatarExperience.Catalog.Thunks.FetchTopics)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)

require(CorePackages.Workspace.Packages.Http)

local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local v12 = game:DefineFastInt("AXGetTopicsExpirationSeconds", 600)
local t1 = {
	"____",
	"______",
	"_____",
	"___",
	"_________"
}

local function useCachedTopics(t2: {[any]: any}, p1, p2) -- line: 39
	-- upvalues: CatalogUtils (copy), React (copy), v12 (copy), useSelector (copy), getUseSelectorDeepEquals (copy)
	local v19 = CatalogUtils.getTopicRequestKey(t2, p1, p2)
	local v20 = React.useCallback(function(p3) -- line: 42
		-- upvalues: v19 (copy), v12 (copy)
		if (p3.AvatarExperience.Catalog.TopicsFetchTimes[v19] or 0) + v12 <= tick() then
			return nil
		end

		return p3.AvatarExperience.Catalog.Topics[v19]
	end, { v19 })

	return useSelector(v20, getUseSelectorDeepEquals())
end
local function useCatalogTopics(p4, p5, p6) -- line: 57
	-- upvalues: useRoactService (copy), RoactNetworking (copy), useDispatch (copy), React (copy), t1 (copy), useCachedTopics (copy), FetchTopics (copy)
	local v24 = useRoactService(RoactNetworking)
	local v25 = useDispatch()
	local v26, v27 = React.useState(t1)
	local v28 = useCachedTopics(p4, p5, p6)
	local v29 = v28 == nil

	if v28 ~= nil and v28 ~= v26 then
		v27(v28)
	end

	React.useEffect(function() -- line: 71
		-- upvalues: v28 (copy), v25 (copy), FetchTopics (copy), v24 (copy), p4 (copy), p5 (copy), p6 (copy)
		if v28 == nil then
			v25(FetchTopics(v24, p4, p5, p6))
		end
	end, {
		v28,
		p4,
		p5,
		p6
	})

	return v28 or v26, v29
end

return useCatalogTopics
