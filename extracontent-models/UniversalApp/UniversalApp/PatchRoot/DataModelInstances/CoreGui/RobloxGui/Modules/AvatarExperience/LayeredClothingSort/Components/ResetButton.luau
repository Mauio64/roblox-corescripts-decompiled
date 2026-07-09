local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withNavigation = RoactNavigation.withNavigation
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local useStyle = UIBlox.Core.Style.useStyle
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.AvatarRefinement.Constants)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Analytics = require(Modules.AvatarExperience.LayeredClothingSort.Services.Analytics)
local SendRefinementAnalytics = require(Modules.AvatarExperience.LayeredClothingSort.Thunks.SendRefinementAnalytics)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local v19 = Images["icons/actions/reset"]
local uDim = UDim.new(0, 10)

local function ResetButtonDefault(p1) -- line: 27
	-- upvalues: useStyle (copy), Roact (copy), Constants (copy), ImageSetButton (copy), v19 (copy)
	local Theme = useStyle().Theme

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -Constants.RightMargin, 0, -9),
		Size = UDim2.fromOffset(34, 34),
		Visible = not p1.lastInputIsGamepad
	}, {
		Button = Roact.createElement(ImageSetButton, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromScale(1, 1),
			Image = v19,
			ImageColor3 = Theme.IconEmphasis.Color,
			ImageTransparency = Theme.IconEmphasis.Transparency,
			[Roact.Event.Activated] = p1.onActivated
		})
	})
end
local function ResetButtonVR(p2) -- line: 53
	-- upvalues: useStyle (copy), Roact (copy), Constants (copy), uDim (copy), ImageSetButton (copy), v19 (copy)
	local Theme = useStyle().Theme

	return Roact.createElement("Frame", {
		LayoutOrder = 1,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(1, -Constants.VerticalList.Width / 2, 0, 0),
		Size = UDim2.fromOffset(Constants.Tile.MoreIconSize, Constants.Tile.MoreIconSize),
		Visible = not p2.lastInputIsGamepad,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = uDim
		}),
		Button = Roact.createElement(ImageSetButton, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromScale(1, 1),
			Image = v19,
			ImageColor3 = Theme.IconEmphasis.Color,
			ImageTransparency = Theme.IconEmphasis.Transparency,
			[Roact.Event.Activated] = p2.onActivated
		})
	})
end

local v23 = Roact.PureComponent:extend("ResetButton")

v23.validateProps = t.strictInterface({
	lastInputIsGamepad = t.boolean,
	isDragging = t.boolean,
	navigation = t.table,
	analytics = t.table,
	sendAnalytics = t.callback
})
v23.defaultProps = {
	lastInputIsGamepad = false,
	isDragging = false
}

function v23.init(p3) -- line: 104
	-- upvalues: AvatarScreen (copy)
	function p3.openResetConfirmation() -- line: 105
		-- upvalues: p3 (copy), AvatarScreen (copy)
		if p3.props.isDragging then
			return
		end

		p3.props.sendAnalytics(p3.props.analytics.avatarRefineLayersResetTap)
		p3.props.navigation.navigate(AvatarScreen.ResetLayeredItemsSortPrompt)
	end
end
function v23.render(p4) -- line: 117
	-- upvalues: IsVRAppBuild (copy), Roact (copy), ResetButtonVR (copy), ResetButtonDefault (copy)
	if IsVRAppBuild() then
		return Roact.createElement(ResetButtonVR, {
			onActivated = p4.openResetConfirmation,
			lastInputIsGamepad = p4.props.lastInputIsGamepad
		})
	end

	return Roact.createElement(ResetButtonDefault, {
		onActivated = p4.openResetConfirmation,
		lastInputIsGamepad = p4.props.lastInputIsGamepad
	})
end

local v24 = withNavigation(v23, nil)
local v25 = RoactServices.connect({
	analytics = Analytics
})(v24)

return (RoactRodux.connect(nil, function(p5) -- line: 137
	-- upvalues: SendRefinementAnalytics (copy)
	return {
		sendAnalytics = function(p6) -- line: 139
			-- upvalues: p5 (copy), SendRefinementAnalytics (copy)
			p5(SendRefinementAnalytics(p6))
		end
	}
end)(v25))
