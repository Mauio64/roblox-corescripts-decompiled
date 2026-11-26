local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Otter = require(CorePackages.Packages.Otter)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local isGamepadInput = require("@game/CorePackages/Workspace/Packages/RoactUtils").isGamepadInput

local fFlagMigrateRoactUtilsToReactUtils = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagMigrateRoactUtilsToReactUtils()

local images = UIBlox.App.ImageSet.Images

local withStyle = UIBlox.Style.withStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local module2 = require("@luauforge/bundled/dPN")
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection
local gamepadUtils = require("@luauforge/bundled/fCf").Gamepad.GamepadUtils

local module3 = require("@luauforge/bundled/fCe")
local module4 = require("@luauforge/bundled/gTh")

local iconsactionszoomIn = images["icons/actions/zoomIn"]
local vector2 = Vector2.new(36, 36)
local iconscontrolskeysxboxRS = images["icons/controls/keys/xboxRS"]
local vector2_2 = Vector2.new(36, 36)
local component_assetscircle_49 = images["component_assets/circle_49"]

local vector2_3 = Vector2.new(49 + vector2_2.X, (math.max(49, vector2_2.Y)))

local v5 = { dampingRatio = 1, frequency = 4 }

local function isGamepad(p2)
	return isGamepadInput(p2.UserInputType)
end

local function keyBindingHasToggleMeta(p2, p3): boolean
	local v6 = p3[p2]
	return typeof(v6) == "table" and v6.tag == module2.SceneGamepad.FullViewIndicatorTag
end

local function getMotorGoal(p2): number
	if p2 then
		return 0
	end

	return 1
end

local extended = Roact.PureComponent:extend("FullViewIndicator")

extended.validateProps = t.strictInterface({
	AnchorPoint = t.Vector2,
	Position = t.UDim2,
	LayoutOrder = t.optional(t.number),
	boundInputs = t.table,
	isSceneFullView = t.boolean,
	avatarRoute = avatarRoute.Interface
})

function extended.getDerivedStateFromProps(p2, p3)
	local boundInputs = p2.boundInputs
	local lastGamepadKeyCode = p3.lastGamepadKeyCode
	local boundInput = boundInputs[Enum.KeyCode.Thumbstick2]
	local v6

	if typeof(boundInput) == "table" then
		v6 = boundInput.tag == module2.SceneGamepad.FullViewIndicatorTag
	else
		v6 = false
	end

	local boundInput2 = boundInputs[Enum.KeyCode.ButtonR3]
	local v8 = typeof(boundInput2) == "table"
		and boundInput2.tag == module2.SceneGamepad.FullViewIndicatorTag

	local v9 = not p2.isSceneFullView
		and (not not v6 and lastGamepadKeyCode == Enum.KeyCode.Thumbstick2 or v8 and lastGamepadKeyCode == Enum.KeyCode.ButtonR3)
		and true
		or false

	if v9 == p3.isVisible then
		return nil
	end

	return { isVisible = v9 }
end

function extended:setStateIfChanged(items)
	local v6 = {}

	for k, item in items do
		if self.state[k] ~= item then
			v6[k] = item
		end
	end

	if next(v6) then
		self:setState(v6)
	end
end

function extended:init()
	self:setState({ lastGamepadKeyCode = nil })

	local binding, v6 = Roact.createBinding(self.state.isVisible and 0 or 1)
	self.transparencyBinding = binding
	self.updateTransparencyBinding = v6

	function self.onInputBegan(p2)
		if not isGamepadInput(p2.UserInputType) then
			return
		end

		local v7

		if p2.KeyCode == Enum.KeyCode.ButtonR3 then
			v7 = not (self.props.isSceneFullView or self.state.isR3BindingOverridden)
		else
			v7 = false
		end

		if v7 then
			return
		end

		self:setStateIfChanged({ lastGamepadKeyCode = p2.KeyCode })
	end

	function self.onInputChanged(data)
		if not isGamepadInput(data.UserInputType) then
			return
		end

		if
			data.KeyCode ~= Enum.KeyCode.Thumbstick1 and data.KeyCode ~= Enum.KeyCode.Thumbstick2
			or gamepadUtils.normalizeStickByDeadzone(data.Position) == Vector2.new(0, 0)
		then
			return
		end

		self:setStateIfChanged({ lastGamepadKeyCode = data.KeyCode })
	end
end

function extended:didMount()
	self.transparencyMotor = Otter.createSingleMotor(self.state.isVisible and 0 or 1)

	self.transparencyMotor:onStep(function(p2)
		self.updateTransparencyBinding(p2)
	end)

	self.transparencyMotor:start()
end

function extended.willUpdate(p2, p3, p4)
	local isVisible = p4.isVisible

	if isVisible ~= p2.state.isVisible then
		p2.transparencyMotor:setGoal(Otter.spring(isVisible and 0 or 1, v5))
	end
end

function extended.render(props)
	if props.props.avatarRoute.opaque.name == avatarScreen.AvatarExperienceLandingPage then
		return nil
	end

	local createFragment = Roact.createFragment
	local createElement = Roact.createElement
	local v8 = { event = UserInputService.InputBegan, callback = props.onInputBegan }

	local v10 = if not fFlagMigrateRoactUtilsToReactUtils then Roact.createElement(externalEventConnection, {
		event = UserInputService.InputChanged,
		callback = props.onInputChanged
	}) else nil
	local v6 = {
		InputBeganConnection = createElement(externalEventConnection, v8, {
			InputChangedConnection = v10
		}),
		InputChangedConnection = 0,
		Indicator = 0
	}

	local v11 = if fFlagMigrateRoactUtilsToReactUtils then Roact.createElement(externalEventConnection, {
		event = UserInputService.InputChanged,
		callback = props.onInputChanged
	}) else nil
	v6.InputChangedConnection = v11

	v6.Indicator = withStyle(function(p2)
		local theme = p2.Theme

		return Roact.createElement(
			"Frame",
			{
				AnchorPoint = props.props.AnchorPoint,
				Position = props.props.Position,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, vector2_3.X, 0, vector2_3.Y)
			},
			{
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 5)
				}),
				ControllerButtonImage = Roact.createElement(imageSetLabel, {
					Size = UDim2.new(0, vector2_2.X, 0, vector2_2.Y),
					BackgroundTransparency = 1,
					Image = iconscontrolskeysxboxRS,
					ImageColor3 = theme.TextEmphasis.Color,
					ImageTransparency = props.transparencyBinding,
					LayoutOrder = 1
				}),
				CircleBackground = Roact.createElement(imageSetLabel, {
					Size = UDim2.new(0, 49, 0, 49),
					BackgroundTransparency = 1,
					Image = component_assetscircle_49,
					ImageColor3 = theme.BackgroundUIDefault.Color,
					ImageTransparency = props.transparencyBinding,
					LayoutOrder = 2
				}, {
					IndicatorImage = Roact.createElement(imageSetLabel, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, vector2.X, 0, vector2.Y),
						BackgroundTransparency = 1,
						Image = iconsactionszoomIn,
						ImageColor3 = theme.TextEmphasis.Color,
						ImageTransparency = props.transparencyBinding
					})
				})
			}
		)
	end)
	return createFragment(v6)
end

function extended.willUnmount(p2)
	p2.transparencyMotor:destroy()
end

return (module4((RoactRodux.connect(function(p2, p3)
	return {
		boundInputs = p2.GamepadBottomBar.boundInputs,
		isSceneFullView = module3.getIsSceneFullViewFromState(p2, p3.avatarRoute)
	}
end)(extended))))
