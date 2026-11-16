local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Responsive")

local SplitPaneEducationalTourSteps = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/SplitPaneEducationalTourSteps")
local getSplitPaneEducationalTourVideoAssetId = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/getSplitPaneEducationalTourVideoAssetId")

local function getPreloadAssetIds(p2)
	local preloadAssetIds = {}
	local set = {}
	local function add(p3)
		if not set[p3] then
			set[p3] = true
			table.insert(preloadAssetIds, p3)
		end
	end

	for k, v5 in SplitPaneEducationalTourSteps do
		local v6 = getSplitPaneEducationalTourVideoAssetId(v5, p2, false)

		if not set[v6] then
			set[v6] = true
			table.insert(preloadAssetIds, v6)
		end

		if k ~= 1 then
			continue
		end

		local v7 = getSplitPaneEducationalTourVideoAssetId(v5, p2, true)

		if set[v7] then
			continue
		end

		set[v7] = true
		table.insert(preloadAssetIds, v7)
	end

	return preloadAssetIds
end

local function useSplitPaneEducationalTourVideoPreload(p2, p3)
	local v5 = Responsive.usePreferredInput() == Responsive.Input.Directional

	local ref = React.useRef(false)

	React.useEffect(function()
		if not p2 or ref.current then
			return
		end

		ref.current = true

		local v6 = p3 or game:GetService("ContentProvider")
		local preloadAssetIds = getPreloadAssetIds(v5)
		task.spawn(function()
			pcall(function()
				v6:PreloadAsync(preloadAssetIds)
			end)
		end)
	end, { p2, v5, p3 })
end

return useSplitPaneEducationalTourVideoPreload
