local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Modules = CoreGui.RobloxGui.Modules
local Otter = require(CorePackages.Packages.Otter)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local isGamepadInput = require(CorePackages.Workspace.Packages.RoactUtils).isGamepadInput
local v11 = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagMigrateRoactUtilsToReactUtils()
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local GamepadUtils = require(CorePackages.Workspace.Packages.InputUi).Gamepad.GamepadUtils
local Utils = require(Modules.AvatarExperience.Common.Utils)
local withAppRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAppRoute)
local v23 = Images["icons/actions/zoomIn"]
local vector2 = Vector2.new(36, 36)
local v25 = Images["icons/controls/keys/xboxRS"]
local vector2_2 = Vector2.new(36, 36)
local v27 = Images["component_assets/circle_49"]
local vector2_3 = Vector2.new(49 + vector2_2.X, (math.max(49, vector2_2.Y)))
local t1 = {
	dampingRatio = 1,
	frequency = 4
}

local function isGamepad(p1) -- line: 51
	-- upvalues: isGamepadInput (copy)
	return isGamepadInput(p1.UserInputType)
end
local function keyBindingHasToggleMeta(p2, p3) -- line: 55
	-- upvalues: Constants (copy)
	local v37 = p3[p2]

	return typeof(v37) == "table" and v37.tag == Constants.SceneGamepad.FullViewIndicatorTag
end
local function getMotorGoal(p4) -- line: 60
	if p4 then
		return 0
	end

	return 1
end

local v33 = Roact.PureComponent:extend("FullViewIndicator")

v33.validateProps = t.strictInterface({
	AnchorPoint = t.Vector2,
	Position = t.UDim2,
	LayoutOrder = t.optional(t.number),
	boundInputs = t.table,
	isSceneFullView = t.boolean,
	avatarRoute = AvatarRoute.Interface
})

function v33.getDerivedStateFromProps(p5, p6) -- line: 80
	-- upvalues: Constants (copy)
	local boundInputs = p5.boundInputs
	local lastGamepadKeyCode = p6.lastGamepadKeyCode
	local v43 = boundInputs[Enum.KeyCode.Thumbstick2]
	local v44 = typeof(v43) == "table" and v43.tag == Constants.SceneGamepad.FullViewIndicatorTag
	local v45 = boundInputs[Enum.KeyCode.ButtonR3]
	local v46 = typeof(v45) == "table" and v45.tag == Constants.SceneGamepad.FullViewIndicatorTag
	local v47 = not p5.isSceneFullView and (v44 and lastGamepadKeyCode == Enum.KeyCode.Thumbstick2 or not not v46 and lastGamepadKeyCode == Enum.KeyCode.ButtonR3)

	if v47 ~= p6.isVisible then
		return {
			isVisible = v47
		}
	end

	return nil
end
function v33.setStateIfChanged(p7, p8) -- line: 108
	local t2 = {}

	for v51, v52 in p8 do
		if v52 ~= p7.state[v51] then
			t2[v51] = v52
		end
	end

	if next(t2) then
		p7:setState(t2)
	end
end
function v33.init(p9) -- line: 121
	-- upvalues: Roact (copy), isGamepadInput (copy), GamepadUtils (copy)
	p9:setState({
		lastGamepadKeyCode = nil
	})

	local v54, v55 = Roact.createBinding(not p9.state.isVisible and 1 or 0)

	p9.transparencyBinding = v54
	p9.updateTransparencyBinding = v55

	function p9.onInputBegan(p10) -- line: 128
		-- upvalues: isGamepadInput (copy), p9 (copy)
		if not isGamepadInput(p10.UserInputType) then
			return
		end

		if p10.KeyCode == Enum.KeyCode.ButtonR3 and (not p9.props.isSceneFullView and not p9.state.isR3BindingOverridden) then
			return
		end

		p9:setStateIfChanged({
			lastGamepadKeyCode = p10.KeyCode
		})
	end
	function p9.onInputChanged(p11) -- line: 148
		-- upvalues: isGamepadInput (copy), GamepadUtils (copy), p9 (copy)
		if not isGamepadInput(p11.UserInputType) then
			return
		end

		if p11.KeyCode ~= Enum.KeyCode.Thumbstick1 and p11.KeyCode ~= Enum.KeyCode.Thumbstick2 or GamepadUtils.normalizeStickByDeadzone(p11.Position) == Vector2.new(0, 0) then
			return
		end

		p9:setStateIfChanged({
			lastGamepadKeyCode = p11.KeyCode
		})
	end
end
function v33.didMount(p12) -- line: 168
	-- upvalues: Otter (copy)
	p12.transparencyMotor = Otter.createSingleMotor(not p12.state.isVisible and 1 or 0)
	p12.transparencyMotor:onStep(function(p13) -- line: 171
		-- upvalues: p12 (copy)
		p12.updateTransparencyBinding(p13)
	end)
	p12.transparencyMotor:start()
end
function v33.willUpdate(p14, _, p16) -- line: 178
	-- upvalues: Otter (copy), t1 (copy)
	local isVisible = p16.isVisible

	if isVisible ~= p14.state.isVisible then
		p14.transparencyMotor:setGoal(Otter.spring(not isVisible and 1 or 0, t1))
	end
end
function v33.render(p17) -- line: 186
	-- upvalues: AvatarScreen (copy), Roact (copy), ExternalEventConnection (copy), UserInputService (copy), v11 (copy), withStyle (copy), vector2_3 (copy), ImageSetLabel (copy), vector2_2 (copy), v25 (copy), v27 (copy), vector2 (copy), v23 (copy)
	if p17.props.avatarRoute.opaque.name == AvatarScreen.AvatarExperienceLandingPage then
		return nil
	end

	return Roact.createFragment({
		InputBeganConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.InputBegan,
			callback = p17.onInputBegan
		}, {
			InputChangedConnection = if not v11 then Roact.createElement(ExternalEventConnection, {
				event = UserInputService.InputChanged,
				callback = p17.onInputChanged
			}) else nil
		}),
		InputChangedConnection = if not v11 then nil else Roact.createElement(ExternalEventConnection, {
			event = UserInputService.InputChanged,
			callback = p17.onInputChanged
		}),
		Indicator = withStyle(function(p18) -- line: 213
			-- upvalues: Roact (copy), p17 (copy), vector2_3 (copy), ImageSetLabel (copy), vector2_2 (copy), v25 (copy), v27 (copy), vector2 (copy), v23 (copy)
			local Theme = p18.Theme

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = p17.props.AnchorPoint,
				Position = p17.props.Position,
				Size = UDim2.new(0, vector2_3.X, 0, vector2_3.Y)
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 5)
				}),
				ControllerButtonImage = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(0, vector2_2.X, 0, vector2_2.Y),
					Image = v25,
					ImageColor3 = Theme.TextEmphasis.Color,
					ImageTransparency = p17.transparencyBinding
				}),
				CircleBackground = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(0, 49, 0, 49),
					Image = v27,
					ImageColor3 = Theme.BackgroundUIDefault.Color,
					ImageTransparency = p17.transparencyBinding
				}, {
					IndicatorImage = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, vector2.X, 0, vector2.Y),
						Image = v23,
						ImageColor3 = Theme.TextEmphasis.Color,
						ImageTransparency = p17.transparencyBinding
					})
				})
			})
		end)
	})
end
function v33.willUnmount(p19) -- line: 261
	p19.transparencyMotor:destroy()
end

return (withAppRoute((RoactRodux.connect(function(p20, p21) -- line: 265
	-- upvalues: Utils (copy)
	return {
		boundInputs = p20.GamepadBottomBar.boundInputs,
		isSceneFullView = Utils.getIsSceneFullViewFromState(p20, p21.avatarRoute)
	}
end)(v33))))
