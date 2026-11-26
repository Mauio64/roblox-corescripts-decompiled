local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)

local getSafeAreaSize = require("@luauforge/bundled/fCf").getSafeAreaSize

local module = require("@luauforge/bundled/dPN")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fCo") else nil

require("@luauforge/bundled/dKT")
local module2 = require("@luauforge/bundled/gJS")

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local extended = Roact.PureComponent:extend("NavOverlayContainer")

extended.validateProps = t.strictInterface({
	onAbsoluteSizeChanged = t.optional(t.callback),
	onAbsolutePositionChanged = t.optional(t.callback),
	ZIndex = t.optional(t.integer),
	[Roact.Children] = t.table,
	globalGuiInset = t.strictInterface({
		left = t.integer,
		top = t.integer,
		right = t.integer,
		bottom = t.integer
	}),
	screenSize = t.Vector2,
	isPortrait = t.boolean
})

function extended.render(p2)
	local globalGuiInset = p2.props.globalGuiInset
	local v6 = getSafeAreaSize(p2.props.screenSize, globalGuiInset)

	local udim = UDim2.fromScale(1, 1)
	local udim2 = UDim2.fromOffset(0, 0)

	if not p2.props.isPortrait then
		local fromScale = UDim2.fromScale
		local v7 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module.LandscapeNavWidth
		udim = fromScale(v7, 1)

		udim2 = UDim2.fromOffset(0, 0)
	end

	local createElement = Roact.createElement
	local v8 = {
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, 0),
		Size = 0,
		ZIndex = 0
	}

	if isVRAppBuild() then
		v6 = UDim2.fromScale(1, 1)
	end

	v8.Size = v6
	v8.ZIndex = p2.props.ZIndex
	return createElement("Frame", v8, {
		WidthFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = udim,
			Position = udim2,
			[Roact.Change.AbsoluteSize] = p2.props.onAbsoluteSizeChanged,
			[Roact.Change.AbsolutePosition] = p2.props.onAbsolutePositionChanged
		}, p2.props[Roact.Children])
	})
end

local function mapStateToProps(p2, p3)
	return {
		globalGuiInset = p2.GlobalGuiInset,
		screenSize = p2.ScreenSize,
		isPortrait = module2(p2)
	}
end

return RoactRodux.connect(mapStateToProps, nil)(extended)
