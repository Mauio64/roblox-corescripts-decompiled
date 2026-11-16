local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/edJ")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local module3 = require("@luauforge/bundled/dFR")
local splitPaneContext = module3.SplitPaneContext
local splitL3SessionHelper = module3.SplitL3SessionHelper
local splitPaneStore = module3.SplitPaneStore

local module4 = require("@luauforge/bundled/dCv")
local module5 = require("@luauforge/bundled/ije")

local fFlagSplitPaneFixClassicThemeHeader = SharedFlags.FFlagSplitPaneFixClassicThemeHeader

local module6 = require("@luauforge/bundled/hUI")

local v5 = if module6 then require("@luauforge/bundled/hUK") else nil

local function renderSupportContent(p2, p3)
	return React.createElement(module5, p2, p3)
end

local function onContentRegionRectChanged(p2)
	local mainCollectionLayoutStore = module.getMainCollectionLayoutStore(false)

	if mainCollectionLayoutStore.setDefaultContentRegionWidth then
		mainCollectionLayoutStore.setDefaultContentRegionWidth(p2.AbsoluteSize.X)
	end

	if fFlagSplitPaneFixClassicThemeHeader then
		local store = splitPaneStore.getStore()
		local absolutePosition = p2.AbsolutePosition
		store.setContentRegionRect(Rect.new(absolutePosition, absolutePosition + p2.AbsoluteSize))
	end

	if module6 then
		v5.setFromInstance(p2)
	end
end

local function AppSplitPaneProvider(p2)
	local v7 = {
		renderSupportContent = renderSupportContent,
		supportPaneResizable = false,
		onContentRegionRectChanged = onContentRegionRectChanged,
		resolveEligibility = React.useMemo(function()
			return splitL3SessionHelper.createResolveEligibility(module4.router)
		end, {})
	}

	local join = Cryo.Dictionary.join
	local children = p2.children or {}
	local v9 = if SharedFlags.FFlagEnableSplitPaneSessionL3 then React.createElement(module3.SplitL3SessionManager, {
		connectRouteSignal = p2.connectRouteSignal
	}) else nil
	local v10 = join(children, { SplitL3SessionManager = v9 })

	return React.createElement(
		splitPaneContext.Provider,
		{ value = v7 },
		React.createElement(React.Fragment, nil, v10)
	)
end

return AppSplitPaneProvider
