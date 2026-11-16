local CorePackages = game:GetService("CorePackages")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local gameOptions = settings():FindFirstChild("Game Options")
local UserInputService = game:GetService("UserInputService")
local v = nil
pcall(function()
	local PlatformService = game:GetService("PlatformService")
	v = PlatformService
end)
local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules

local React = require(CorePackages.Packages.React)
local Utility = require(Modules.Shell.Utility)

local ContextActionEvent = require(Modules.Shell.Components.ContextActionEvent)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection
local RenderStep = require(Modules.Shell.Components.RenderStep)

local engineFeature = game:GetEngineFeature("MigrateOverscanToGameBasicSettings")

local vector2 = Vector2.new(0.85, 0.85)
local vector2_2 = Vector2.new(0.9, 0.9)

local vector2_3 = Vector2.new(1920, 1080)
local vector2_4 = Vector2.new(0, 0)

local function EdgeImage(props)
	return React.createElement("ImageLabel", {
		Size = UDim2.new(0, 95, 0, 95),
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		Rotation = props.Rotation,
		Image = "rbxasset://textures/ui/Shell/ScreenAdjustment/ScreenAdjustmentArrow.png"
	})
end

local extended = React.Component:extend("Edges")

function extended:init()
	local function getCurrentEdgePercent(p) -- 4 equivalent calls inferred from this helper
		return Utility.ClampVector2(vector2, Vector2.new(1, 1), p)
	end

	local function getCurrentEdgeSize(p) -- 4 equivalent calls inferred from this helper
		local v2 = p * vector2_3
		local v3 = Vector2.new(Utility.Round(v2.X / 2), Utility.Round(v2.Y / 2)) * 2
		return Utility.ClampVector2(vector2_4, vector2_3, v3)
	end

	function self.onAdjustThumbstick(_, _, p)
		self._stickPosition = Utility.GamepadLinearToCurve(Vector2.new(p.Position.X, -p.Position.Y), 0.2)
	end

	function self.onAccept()
		local _, _ = pcall(function()
			if engineFeature then
				UserGameSettings.Overscan = Vector2.new(
					math.min(1, self._edgePercent.X),
					(math.min(1, self._edgePercent.Y))
				)
				return
			end

			gameOptions.OverscanPX = math.min(1, self._edgePercent.X)
			gameOptions.OverscanPY = math.min(1, self._edgePercent.Y)
		end)

		if self.props.onSetEdges then
			self.props.onSetEdges()
		end
	end

	function self.onRenderStep()
		local now = tick()

		if self._lastUpdate then
			if self._stickPosition == vector2_4 then
				self._acceleration = 1
			else
				local v2 = now - self._lastUpdate
				self._edgePercent = getCurrentEdgePercent(self._stickPosition * self._acceleration * v2 * 0.05 + self._edgePercent) -- inferred equivalent call
				self._acceleration = math.min(self._acceleration + v2 * 1, 3)

				self:setState({
					currentSize = getCurrentEdgeSize(self._edgePercent) -- inferred equivalent call
				})
			end
		end

		self._lastUpdate = now
	end

	function self.onSuspended()
		pcall(function()
			if engineFeature then
				UserGameSettings.Overscan = Vector2.new(self._lastSavedOverscan.X, self._lastSavedOverscan.Y)
				return
			end

			gameOptions.OverscanPX = self._lastSavedOverscan.X
			gameOptions.OverscanPY = self._lastSavedOverscan.Y
		end)
	end

	local edgePercent = getCurrentEdgePercent(vector2_2) -- inferred equivalent call
	local currentSize = getCurrentEdgeSize(edgePercent) -- inferred equivalent call

	if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
		pcall(function()
			if engineFeature then
				if UserGameSettings.Overscan.x > 0 and UserGameSettings.Overscan.y > 0 then
					edgePercent = Vector2.new(UserGameSettings.Overscan.x, UserGameSettings.Overscan.y)
					edgePercent = getCurrentEdgePercent(edgePercent) -- inferred equivalent call
					currentSize = getCurrentEdgeSize(edgePercent) -- inferred equivalent call

					self._lastSavedOverscan = Vector2.new(UserGameSettings.Overscan.x, UserGameSettings.Overscan.y)
					UserGameSettings.Overscan = Vector2.new(1, 1)
				end
			elseif gameOptions.OverscanPX > 0 and gameOptions.OverscanPY > 0 then
				edgePercent = Vector2.new(gameOptions.OverscanPX, gameOptions.OverscanPY)
				edgePercent = getCurrentEdgePercent(edgePercent) -- inferred equivalent call
				currentSize = getCurrentEdgeSize(edgePercent) -- inferred equivalent call

				self._lastSavedOverscan = Vector2.new(gameOptions.OverscanPX, gameOptions.OverscanPY)
				gameOptions.OverscanPX = 1
				gameOptions.OverscanPY = 1
			end
		end)
	end

	self._stickPosition = vector2_4
	self._edgePercent = edgePercent
	self._lastUpdate = nil
	self._acceleration = 1
	self._seenAPressed = false

	self.state = { currentSize = currentSize }
end

function extended.render(props)
	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(0, props.state.currentSize.X, 0, props.state.currentSize.Y),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1
		},
		{
			SelectionImage = React.createElement("ImageLabel", {
				Size = UDim2.new(1, 2, 1, 2),
				Position = UDim2.new(0, -1, 0, -1),
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(21, 21, 41, 41),
				Image = "rbxasset://textures/ui/Shell/ScreenAdjustment/ScreenRangeOverlay.png"
			}),
			TopLeft = React.createElement(EdgeImage, {
				Rotation = 0,
				Position = UDim2.new(0, 0, 0, 0),
				AnchorPoint = Vector2.new(0, 0)
			}),
			TopRight = React.createElement(EdgeImage, {
				Rotation = 90,
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0)
			}),
			BottomRight = React.createElement(EdgeImage, {
				Rotation = 180,
				Position = UDim2.new(1, 0, 1, 0),
				AnchorPoint = Vector2.new(1, 1)
			}),
			BottomLeft = React.createElement(EdgeImage, {
				Rotation = 270,
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1)
			}),
			Render = React.createElement(RenderStep, {
				name = "UpdateAdjustmentScreen",
				priority = Enum.RenderPriority.Input.Value,
				callback = props.onRenderStep
			}),
			AdjustConnectorThumbstick = React.createElement(ContextActionEvent, {
				name = "ThumbstickAdjustmentScreen",
				callback = props.onAdjustThumbstick,
				binds = { Enum.KeyCode.Thumbstick2 }
			}),
			SuspendedCn = v and React.createElement(ExternalEventConnection, {
				event = v.Suspended,
				callback = props.onSuspended
			})
		}
	)
end

return extended
