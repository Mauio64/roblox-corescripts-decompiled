local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local CatalogTilesLatencyTracker = require(Modules.AvatarExperience.Catalog.Actions.CatalogTilesLatencyTracker)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useGetCurrentCategoryNames = require(Modules.AvatarExperience.Catalog.Hooks.useGetCurrentCategoryNames)

local function useHandleThumbnailsLoaded() -- line: 16
	-- upvalues: React (copy), useDispatch (copy), useGetCurrentCategoryNames (copy), Cryo (copy), CatalogTilesLatencyTracker (copy)
	local v9, v10 = React.useState({})
	local v11 = useDispatch()
	local v12 = React.useRef(false)
	local v13 = useGetCurrentCategoryNames()
	local v14 = React.useCallback(function(s1: string, s2: string) -- line: 26
		-- upvalues: v12 (copy), v10 (copy)
		if not s1 or not s2 then
			return
		end

		if v12.current then
			return
		end

		v10(function(p1) -- line: 37
			-- upvalues: s1 (copy), s2 (copy)
			local v19 = table.clone(p1)
			local v20 = table.clone(p1[s1] or {})

			table.insert(v20, s2)
			v19[s1] = v20

			return v19
		end)
	end, {})

	React.useEffect(function() -- line: 46
		-- upvalues: v12 (copy)
		if v12.current then
			v12.current = false
		end
	end, { v13 })
	React.useEffect(function() -- line: 53
		-- upvalues: v9 (copy), Cryo (copy), v11 (copy), CatalogTilesLatencyTracker (copy), v12 (copy), v10 (copy)
		if next(v9) == nil then
			return
		end

		local v17 = Cryo.Dictionary.filter(v9, function(_, p3) -- line: 59
			return #p3 > 0
		end)

		if next(v17) ~= nil then
			v11(CatalogTilesLatencyTracker.AppendThumbnails(v17))
			v12.current = true
			v10({})
		end
	end, {
		v9,
		v11
	})

	return v14
end

return useHandleThumbnailsLoaded
