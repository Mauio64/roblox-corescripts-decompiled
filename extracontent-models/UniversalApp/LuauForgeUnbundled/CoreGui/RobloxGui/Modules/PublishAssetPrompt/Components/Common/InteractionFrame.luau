local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local t = require(CorePackages.Packages.t)
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module = require("@luauforge/bundled/gnZ")
local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties
local module2 = require("@luauforge/bundled/goe")
local module3 = require("@luauforge/bundled/goD")

local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.scene")

local module4 = require("@luauforge/bundled/dOc")

local function splitInputType(p2)
	local v5 = p2.UserInputType == Enum.UserInputType.Touch
	local v6 = p2.UserInputType == Enum.UserInputType.MouseButton1
	local v7 = p2.UserInputType == Enum.UserInputType.MouseButton2

	return v5, v6 or v7, v6, v7
end

local function isDoubleTapToZoomEnabled(name)
	return (name == avatarScreen.AvatarEditor or name == avatarScreen.Catalog or name == avatarScreen.ProfilePictureEditorEmotes or name == avatarScreen.CatalogSearch or name == avatarScreen.MySharedAvatars or module4() and name == avatarScreen.AvatarSwitcher)
		and true
		or module4() and name == avatarScreen.EditEmotes
end

local extended = Roact.PureComponent:extend("SharedInteractionFrame")

extended.validateProps = t.interface({
	panByPixels = t.callback,
	rotateByPixels = t.callback,
	setAngularVelocityByPixels = t.callback,
	zoomToPoint = t.callback,
	Size = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	ZIndex = t.optional(t.number),
	fullView = t.optional(t.userdata),
	setFullView = t.callback,
	analytics = t.table
})

function extended:disconnectEvents()
	self.inputChangedConnection:Disconnect()
	self.inputEndedConnection:Disconnect()
	self.renderSteppedConnection:Disconnect()
	self.inputChangedConnection = nil
	self.inputEndedConnection = nil
	self.renderSteppedConnection = nil
end

function extended.getActiveInput(p2, p3)
	local v5 = p3.UserInputType == Enum.UserInputType.Touch
	local v6 = p3.UserInputType == Enum.UserInputType.MouseButton1
	local v7 = p3.UserInputType == Enum.UserInputType.MouseButton2

	local v8 = p3.UserInputType == Enum.UserInputType.MouseMovement or v6 or v7

	if not (v8 or v5) then
		return
	end

	local v9 = nil

	if v8 then
		return p2.activeMouseInput
	end

	if v5 then
		v9 = p2.activeTouchInputs[p3]
	end

	return v9
end

function extended:removeActivePointerInput(p2, p3)
	if p3 then
		if
			UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
			or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
		then
			return
		end

		self.activeMouseInput = nil
	else
		self.activeTouchInputs[p2] = nil
		self.numActiveTouchInputs -= 1
	end

	self.numActiveInputs -= 1

	if self.numActiveInputs == 0 then
		self:disconnectEvents()
	end
end

function extended:doubleTapToggleFullView()
	local name = self.props.avatarRoute.opaque.name

	if not isDoubleTapToZoomEnabled(name) then
		return
	end

	local sceneFullView = self.props.fullView == fullView.None and fullView.SceneFullView or fullView.None
	self.props.setFullView(self.props.analytics, name, sceneFullView)
end

function extended:handleDoubleTap(p2, lastPrimaryPointerInputBeganTime)
	if self.lastPrimaryPointerInputBeganPosition then
		local v5 = self.lastPrimaryPointerInputBeganPosition - p2.Position
		local v6 = lastPrimaryPointerInputBeganTime - self.lastPrimaryPointerInputBeganTime

		if v5.Magnitude < 30 and v6 < 0.25 then
			self:doubleTapToggleFullView()
		end
	end

	self.lastPrimaryPointerInputBeganPosition = p2.Position
	self.lastPrimaryPointerInputBeganTime = lastPrimaryPointerInputBeganTime
end

function extended:addActivePointerInput(p2, p3, p4)
	if self:getActiveInput(p2) then
		return
	end

	local v5 = { lastPosition = p2.Position, lastTime = p4 }

	if p3 then
		self.activeMouseInput = v5
	else
		self.activeTouchInputs[p2] = Cryo.Dictionary.join(v5, {
			lastDeltaTime = 0,
			lastDeltaPosition = Vector3.new(0, 0, 0)
		})

		self.numActiveTouchInputs += 1
	end

	self.numActiveInputs += 1

	if self.numActiveInputs == 1 then
		self.props.setAngularVelocityByPixels(0)
		self.inputChangedConnection = UserInputService.InputChanged:Connect(self.onInputChanged)
		self.inputEndedConnection = UserInputService.InputEnded:Connect(self.onInputEnded)
		self.renderSteppedConnection = RunService.RenderStepped:Connect(self.setInputNotChanged)
	end
end

function extended:init()
	self.inputChangedConnection = nil
	self.inputEndedConnection = nil

	self.lastPinchDistance = 1
	self.lastPanTime = 0
	self.lastPrimaryPointerInputBeganTime = 0
	self.lastPrimaryPointerInputBeganPosition = nil

	self.activeTouchInputs = {}
	self.numActiveTouchInputs = 0
	self.activeMouseInput = nil

	self.numActiveInputs = 0

	function self.handleScroll(p2, p3)
		if p3.UserInputType == Enum.UserInputType.MouseWheel then
			local v5 = -p3.Position.Z
			self.props.zoomToPoint(v5, UserInputService:GetMouseLocation())
		end
	end

	function self.setInputNotChanged(p2)
		for k, activeTouchInput in self.activeTouchInputs do
			activeTouchInput.changedThisFrame = false
		end
	end

	function self.onInputChanged(p2, p3)
		local v5 = p2.UserInputType == Enum.UserInputType.MouseMovement
		local v6 = p2.UserInputType == Enum.UserInputType.Touch

		if not (v5 or v6) then
			return
		end

		local activeInput = self:getActiveInput(p2)

		if not activeInput then
			return
		end

		local now = tick()
		local v7 = now - activeInput.lastTime
		local v8 = p2.Position - activeInput.lastPosition
		local v9 = Vector2.new(v8.X, v8.Y) * Vector2.new(-1, 1)

		local isMouseButtonPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
		local isMouseButtonPressed2 = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)

		local v10 = now - self.lastPanTime > 0.1

		if (v5 and isMouseButtonPressed or v6 and self.numActiveTouchInputs == 1) and v10 then
			self.props.rotateByPixels(-v9.X)
		end

		if v5 and isMouseButtonPressed2 or v6 and self.numActiveTouchInputs == 2 then
			local v11 = v9 / self.numActiveInputs
			self.props.panByPixels(v11)
			self.lastPanTime = now
		end

		activeInput.lastPosition = p2.Position
		activeInput.lastTime = now

		if v6 then
			if activeInput.changedThisFrame then
				activeInput.lastDeltaPosition = v8 + activeInput.lastDeltaPosition
				activeInput.lastDeltaTime = v7 + activeInput.lastDeltaTime
			else
				activeInput.lastDeltaPosition = v8
				activeInput.lastDeltaTime = v7
				activeInput.changedThisFrame = true
			end
		end
	end

	function self.onInputEnded(p2, p3)
		local v5 = p2.UserInputType == Enum.UserInputType.Touch
		local v6 = p2.UserInputType == Enum.UserInputType.MouseButton1
		local v7 = p2.UserInputType == Enum.UserInputType.MouseButton2
		local v8 = v6 or v7

		if not (v5 or v8) then
			return
		end

		local activeInput = self:getActiveInput(p2)

		if not activeInput then
			return
		end

		local now = tick()
		local v9 = now - self.lastPanTime
		local changedThisFrame = v5 and activeInput.changedThisFrame
		local v10 = self.numActiveInputs == 1 and v9 > 0.1

		if (changedThisFrame or v6) and v10 then
			local v11, v12

			if v6 then
				v11 = p2.Position - activeInput.lastPosition
				v12 = now - activeInput.lastTime
			else
				v11 = activeInput.lastDeltaPosition
				v12 = activeInput.lastDeltaTime
			end

			self.props.setAngularVelocityByPixels(v11.X / v12)
		end

		self:removeActivePointerInput(p2, v8)
	end

	function self.onInputBegan(p2, p3)
		self.handleScroll(p2, p3)
		local v5 = p3.UserInputType == Enum.UserInputType.Touch
		local v6 = p3.UserInputType == Enum.UserInputType.MouseButton1
		local v7 = p3.UserInputType == Enum.UserInputType.MouseButton2
		local v8 = v6 or v7

		if not (v5 or v8) then
			return
		end

		local now = tick()

		if v5 or v6 then
			self:handleDoubleTap(p3, now)
		end

		self:addActivePointerInput(p3, v8, now)
	end

	function self.onTouchPinch(p2, list, p3, p4, p5)
		if list[2] == nil then
			return
		end

		if p5 == Enum.UserInputState.Begin then
			self.lastPinchDistance = (list[1] - list[2]).Magnitude
			return
		end

		local magnitude = (list[1] - list[2]).Magnitude
		local v5 = magnitude - self.lastPinchDistance
		self.lastPinchDistance = magnitude
		self.props.zoomToPoint(v5 * -0.05, (list[1] + list[2]) / 2)
	end
end

function extended:willUnmount()
	if self.inputChangedConnection then
		self:disconnectEvents()
	end
end

function extended:shouldBeVisible(): boolean
	local avatarScreenProperty = avatarScreenProperties[self.props.avatarRoute.current.name]

	if
		avatarScreenProperty
		and avatarScreenProperty.coversSceneWhenExpanded
		and self.props.itemDetailsExpanded
	then
		return false
	end

	return true
end

function extended:render()
	local shouldBeVisible = self:shouldBeVisible()
	logger:trace("SharedInteractionFrame visible: {}", shouldBeVisible)

	local size = self.props.Size or UDim2.new(1, 0, 1, 0)
	local position = self.props.Position
	local zIndex = self.props.ZIndex

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		Position = position,
		ZIndex = zIndex,
		Visible = shouldBeVisible,
		Active = true,
		[Roact.Event.InputBegan] = self.onInputBegan,
		[Roact.Event.InputChanged] = self.handleScroll,
		[Roact.Event.TouchPinch] = self.onTouchPinch
	}, self.props[Roact.Children])
end

local v5 = RoactRodux.connect(function(p2, p3)
	return {
		fullView = module2(p2, p3.avatarRoute.opaque.name),
		itemDetailsExpanded = p2.AvatarExperience.Common.ItemDetailsExpanded
	}
end, function(callback)
	return {
		setFullView = function(p2, p3, p4)
			callback(module(p2, p3, p4))
		end
	}
end)(extended)

return (module3((roactServices.connect({ analytics = avatarExperienceAnalyticsService })(v5))))
