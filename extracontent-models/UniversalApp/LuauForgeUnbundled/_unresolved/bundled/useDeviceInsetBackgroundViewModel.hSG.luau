local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/dHu")
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local module4 = require("@luauforge/bundled/dCp")

local module5 = require("@luauforge/bundled/hSH")
local module6 = require("@luauforge/bundled/hRs")

local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local fFlagEnableStickyShortcutBarOnAllPlatforms = SharedFlags.FFlagEnableStickyShortcutBarOnAllPlatforms
local fFlagFixDeviceInsetBackgroundSplitPaneWidth = SharedFlags.FFlagFixDeviceInsetBackgroundSplitPaneWidth

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local module7 = require("@luauforge/bundled/dUd")
local splitPaneStore, v5, v6

if fFlagEnableSplitPane then
	splitPaneStore = require("@luauforge/bundled/dFR").SplitPaneStore
	v5 = require("@luauforge/bundled/dDG")
	v6 = require("@luauforge/bundled/gns")
else
	splitPaneStore = nil
	v5 = nil
	v6 = nil
end

local function useWidthWhenSplitPaneIsActive(navBarSize, left)
	local v7

	if not fFlagEnableSplitPane then
		return v7
	end

	local store = splitPaneStore.getStore()
	local displayStore = module7.GetDisplayStore(false)
	local v8 = React.useCallback(function(p2)
		if store.getSupportPaneModeIfActive(p2) ~= v5.Enums.SupportPaneMode.Normal then
			return nil
		end

		local regionOverrides = v6.getRegionOverrides(v6.RegionName.SupportRegion)
		local x = displayStore.getViewportSize(p2).X
		local v9 = x - navBarSize
		local platformScale = displayStore.getPlatformScale(p2)
		local v10 = not (platformScale > 0) and 1 or platformScale

		if fFlagFixDeviceInsetBackgroundSplitPaneWidth then
			v9 = x
		end

		return left + (x - math.max(v9 * regionOverrides.widthScale, (regionOverrides.minWidth or 0) * v10))
	end, { store, displayStore, navBarSize, left })
	v7 = SignalsReact.useSignalState(v8)

	return v7
end

local function useDeviceInsetBackgroundViewModel(data)
	local v7 = Responsive.useDeviceInsets()
	local v8 = Responsive.usePreferredInput()
	local v9 = useWidthWhenSplitPaneIsActive(data.navBarSize, v7.left)
	local v10

	if module5 then
		v10 = module6(data.currentPage)
	else
		v10 = data.currentPage == module4.AvatarExperienceRoot
	end

	local v11 = data.navBarPlacement == module.Placement.Left
	local v12 = v7.top > 0 or v7.bottom > 0 or v7.left > 0 or v7.right > 0

	local v13 = module7.shouldUseDeviceSafeInsets

	if v13 then
		v13 = if v12 or v8 == Responsive.Input.Touch then not v10 or v11 else false
	end

	if not v13 then
		return nil
	end

	local v14 = if v11 and v10 then v7.left + data.navBarSize else data.screenSize.X + v7.left + v7.right

	local experienceDetailInNavTree = fFlagEnableStickyShortcutBarOnAllPlatforms
		and data.experienceDetailInNavTree

	local v16 = if v11 and not data.bottomBarVisible and not (fFlagEnableStickyShortcutBarOnAllPlatforms and experienceDetailInNavTree) then UDim2.fromOffset(0, 0) else UDim2.fromOffset(
		v9 or v14,
		data.screenSize.Y + v7.top + v7.bottom
	)

	return {
		backgroundColor = data.backgroundColor,
		backgroundTransparency = data.backgroundTransparency,
		position = UDim2.fromOffset(-v7.left, -v7.top),
		size = v16
	}
end

return useDeviceInsetBackgroundViewModel
