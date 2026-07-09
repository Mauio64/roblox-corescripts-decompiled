local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local v10 = Roact.PureComponent:extend("NavOverlayContainer")

v10.validateProps = t.strictInterface({
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

function v10.render(p1) -- line: 42
	-- upvalues: getSafeAreaSize (copy), Constants (copy), Roact (copy), IsVRAppBuild (copy)
	local globalGuiInset = p1.props.globalGuiInset
	local screenSize = p1.props.screenSize
	local v15 = getSafeAreaSize(screenSize, globalGuiInset)
	local uDim2 = UDim2.fromScale(1, 1)
	local uDim2_2 = UDim2.fromOffset(0, 0)

	if not p1.props.isPortrait then
		uDim2 = UDim2.fromScale(Constants.LandscapeNavWidth, 1)
		uDim2_2 = UDim2.fromOffset(0, 0)
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, 0),
		Size = if not IsVRAppBuild() then v15 else UDim2.fromScale(1, 1),
		ZIndex = p1.props.ZIndex
	}, {
		WidthFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = uDim2,
			Position = uDim2_2,
			[Roact.Change.AbsoluteSize] = p1.props.onAbsoluteSizeChanged,
			[Roact.Change.AbsolutePosition] = p1.props.onAbsolutePositionChanged
		}, p1.props[Roact.Children])
	})
end

local function mapStateToProps(p2, _) -- line: 75
	-- upvalues: selectIsPortrait (copy)
	return {
		globalGuiInset = p2.GlobalGuiInset,
		screenSize = p2.ScreenSize,
		isPortrait = selectIsPortrait(p2)
	}
end

return RoactRodux.connect(mapStateToProps, nil)(v10)
