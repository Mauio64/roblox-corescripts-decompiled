local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local useAppPolicy = require(DiscoveryMonolithParent.UniversalAppPolicy).useAppPolicy
local useUserExperiment = require(DiscoveryMonolithParent.RoactAppExperiment).useUserExperiment
local AppUserLayers = require(DiscoveryMonolithParent.ExperimentLayers).AppUserLayers

require(DiscoveryMonolithParent.GameTile)

local Modules = DiscoveryMonolith.Modules
local GameGrid = require(Modules.LuaApp.Components.Games.GameGrid)
local GameGridTable = require(Modules.LuaApp.Components.Games.GameGridTable)
local FFlagLuaAppEnableGameGridTable = require(Modules.LuaApp.Flags.FFlagLuaAppEnableGameGridTable)
local t1 = { AppUserLayers.GridUILayer }

local function v12(p1) -- line: 61
	-- upvalues: AppUserLayers (copy)
	return (p1[AppUserLayers.GridUILayer] or {}).IsGameGridDesktopRefreshEnabled or false
end

return function(t2: {[any]: any}) -- line: 66
	-- upvalues: useAppPolicy (copy), FFlagLuaAppEnableGameGridTable (copy), useUserExperiment (copy), t1 (copy), v12 (copy), React (copy), GameGridTable (copy), GameGrid (copy)
	local v15 = t2.currentSidePadding or 0
	local v16 = useAppPolicy(function(p2) -- line: 69
		return p2.useGridPageLayout()
	end)
	local v17 = not not FFlagLuaAppEnableGameGridTable or useUserExperiment(t1, v12)

	if v16 and v17 then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(-v15, 0),
			Size = UDim2.new(1, v15 * 2, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = t2.LayoutOrder
		}, {
			Layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			GridTable = React.createElement(GameGridTable, t2)
		})
	end

	return React.createElement(GameGrid, t2)
end
