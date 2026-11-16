local parent = script:FindFirstAncestor("SplitPane").Parent

local React = require(parent.React)
local Responsive = require(parent.Responsive)

local SplitPaneEducationalTourSteps = require(script.Parent.SplitPaneEducationalTourSteps)
local getSplitPaneEducationalTourVideoAssetId = require(script.Parent.getSplitPaneEducationalTourVideoAssetId)

local function getPreloadAssetIds(flag: boolean)
	local preloadAssetIds = {}
	local set = {}
	local function add(p: string) -- 2 equivalent calls inferred from this helper
		if not set[p] then
			set[p] = true
			table.insert(preloadAssetIds, p)
		end
	end

	for k, splitPaneEducationalTourStep in SplitPaneEducationalTourSteps do
		add(getSplitPaneEducationalTourVideoAssetId(splitPaneEducationalTourStep, flag, false)) -- inferred equivalent call

		if k == 1 then
			add(getSplitPaneEducationalTourVideoAssetId(splitPaneEducationalTourStep, flag, true)) -- inferred equivalent call
		end
	end

	return preloadAssetIds
end

local function useSplitPaneEducationalTourVideoPreload(flag: boolean, p)
	local v = Responsive.usePreferredInput() == Responsive.Input.Directional

	local ref = React.useRef(false)

	React.useEffect(function()
		if not flag or ref.current then
			return
		end

		ref.current = true

		local v2 = p or game:GetService("ContentProvider")
		local preloadAssetIds = getPreloadAssetIds(v)
		task.spawn(function()
			pcall(function()
				v2:PreloadAsync(preloadAssetIds)
			end)
		end)
	end, { flag, v, p })
end

return useSplitPaneEducationalTourVideoPreload
