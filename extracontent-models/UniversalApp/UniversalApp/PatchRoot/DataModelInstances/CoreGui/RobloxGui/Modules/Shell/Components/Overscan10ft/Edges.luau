local CorePackages = game:GetService("CorePackages")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local v3 = settings():FindFirstChild("Game Options")
local UserInputService = game:GetService("UserInputService")
local PlatformService = nil

pcall(function() -- line: 8
	-- upvalues: PlatformService (ref)
	PlatformService = game:GetService("PlatformService")
end)

local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Utility = require(Modules.Shell.Utility)
local ContextActionEvent = require(Modules.Shell.Components.ContextActionEvent)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local RenderStep = require(Modules.Shell.Components.RenderStep)
local EngineFeature = game:GetEngineFeature("MigrateOverscanToGameBasicSettings")
local vector2 = Vector2.new(0.85, 0.85)
local vector2_2 = Vector2.new(0.9, 0.9)
local vector2_3 = Vector2.new(1920, 1080)
local vector2_4 = Vector2.new(0, 0)

local function EdgeImage(p1) -- line: 28
	-- upvalues: React (copy)
	return React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Shell/ScreenAdjustment/ScreenAdjustmentArrow.png",
		Size = UDim2.new(0, 95, 0, 95),
		Position = p1.Position,
		AnchorPoint = p1.AnchorPoint,
		Rotation = p1.Rotation
	})
end

local v18 = React.Component:extend("Edges")

function v18.init(p2) -- line: 41
	-- upvalues: Utility (copy), vector2 (copy), vector2_3 (copy), vector2_4 (copy), EngineFeature (copy), UserGameSettings (copy), v3 (copy), vector2_2 (copy), UserInputService (copy)
	local function getCurrentEdgePercent(p3) -- line: 42
		-- upvalues: Utility (copy), vector2 (copy)
		return Utility.ClampVector2(vector2, Vector2.new(1, 1), p3)
	end
	local function getCurrentEdgeSize(p4) -- line: 46
		-- upvalues: vector2_3 (copy), Utility (copy), vector2_4 (copy)
		local v31 = p4 * vector2_3
		local v32 = Vector2.new(Utility.Round(v31.X / 2), Utility.Round(v31.Y / 2)) * 2

		return Utility.ClampVector2(vector2_4, vector2_3, v32)
	end

	function p2.onAdjustThumbstick(_, _, p7) -- line: 52
		-- upvalues: p2 (copy), Utility (copy)
		p2._stickPosition = Utility.GamepadLinearToCurve(Vector2.new(p7.Position.X, -p7.Position.Y), 0.2)
	end
	function p2.onAccept() -- line: 56
		-- upvalues: EngineFeature (copy), UserGameSettings (copy), p2 (copy), v3 (copy)
		local _, _ = pcall(function() -- line: 57
			-- upvalues: EngineFeature (copy), UserGameSettings (copy), p2 (copy), v3 (copy)
			if EngineFeature then
				UserGameSettings.Overscan = Vector2.new(math.min(1, p2._edgePercent.X), (math.min(1, p2._edgePercent.Y)))

				return
			end

			v3.OverscanPX = math.min(1, p2._edgePercent.X)
			v3.OverscanPY = math.min(1, p2._edgePercent.Y)
		end)

		if p2.props.onSetEdges then
			p2.props.onSetEdges()
		end
	end
	function p2.onRenderStep() -- line: 73
		-- upvalues: p2 (copy), vector2_4 (copy), Utility (copy), vector2 (copy), vector2_3 (copy)
		local timestamp = tick()

		if p2._lastUpdate then
			if p2._stickPosition ~= vector2_4 then
				local v39 = timestamp - p2._lastUpdate
				local v40 = p2._stickPosition * p2._acceleration * v39 * 0.05
				local v41 = p2
				local v42 = v40 + p2._edgePercent

				v41._edgePercent = Utility.ClampVector2(vector2, Vector2.new(1, 1), v42)
				p2._acceleration = math.min(p2._acceleration + v39 * 1, 3)

				local v43 = p2
				local t1 = {}
				local v45 = p2._edgePercent * vector2_3
				local v46 = Vector2.new(Utility.Round(v45.X / 2), Utility.Round(v45.Y / 2)) * 2

				t1.currentSize = Utility.ClampVector2(vector2_4, vector2_3, v46)
				v43:setState(t1)
			else
				p2._acceleration = 1
			end
		end

		p2._lastUpdate = timestamp
	end
	function p2.onSuspended() -- line: 92
		-- upvalues: EngineFeature (copy), UserGameSettings (copy), p2 (copy), v3 (copy)
		pcall(function() -- line: 93
			-- upvalues: EngineFeature (copy), UserGameSettings (copy), p2 (copy), v3 (copy)
			if EngineFeature then
				UserGameSettings.Overscan = Vector2.new(p2._lastSavedOverscan.X, p2._lastSavedOverscan.Y)

				return
			end

			v3.OverscanPX = p2._lastSavedOverscan.X
			v3.OverscanPY = p2._lastSavedOverscan.Y
		end)
	end

	local v23 = vector2_2
	local u24 = Utility.ClampVector2(vector2, Vector2.new(1, 1), v23)
	local v25 = u24 * vector2_3
	local v26 = Vector2.new(Utility.Round(v25.X / 2), Utility.Round(v25.Y / 2)) * 2
	local u27 = Utility.ClampVector2(vector2_4, vector2_3, v26)

	if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
		pcall(function() -- line: 106
			-- upvalues: EngineFeature (copy), UserGameSettings (copy), u24 (ref), Utility (copy), vector2 (copy), u27 (ref), vector2_3 (copy), vector2_4 (copy), p2 (copy), v3 (copy)
			if EngineFeature then
				if UserGameSettings.Overscan.x > 0 and UserGameSettings.Overscan.y > 0 then
					u24 = Vector2.new(UserGameSettings.Overscan.x, UserGameSettings.Overscan.y)

					local v47 = u24

					u24 = Utility.ClampVector2(vector2, Vector2.new(1, 1), v47)

					local v48 = u24 * vector2_3
					local v49 = Vector2.new(Utility.Round(v48.X / 2), Utility.Round(v48.Y / 2)) * 2

					u27 = Utility.ClampVector2(vector2_4, vector2_3, v49)
					p2._lastSavedOverscan = Vector2.new(UserGameSettings.Overscan.x, UserGameSettings.Overscan.y)
					UserGameSettings.Overscan = Vector2.new(1, 1)

					return
				end
			elseif v3.OverscanPX > 0 and v3.OverscanPY > 0 then
				u24 = Vector2.new(v3.OverscanPX, v3.OverscanPY)

				local v50 = u24

				u24 = Utility.ClampVector2(vector2, Vector2.new(1, 1), v50)

				local v51 = u24 * vector2_3
				local v52 = Vector2.new(Utility.Round(v51.X / 2), Utility.Round(v51.Y / 2)) * 2

				u27 = Utility.ClampVector2(vector2_4, vector2_3, v52)
				p2._lastSavedOverscan = Vector2.new(v3.OverscanPX, v3.OverscanPY)
				v3.OverscanPX = 1
				v3.OverscanPY = 1
			end
		end)
	end

	p2._stickPosition = vector2_4
	p2._edgePercent = u24
	p2._lastUpdate = nil
	p2._acceleration = 1
	p2._seenAPressed = false
	p2.state = {
		currentSize = u27
	}
end
function v18.render(p8) -- line: 145
	-- upvalues: React (copy), EdgeImage (copy), RenderStep (copy), ContextActionEvent (copy), PlatformService (ref), ExternalEventConnection (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, p8.state.currentSize.X, 0, p8.state.currentSize.Y),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}, {
		SelectionImage = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/Shell/ScreenAdjustment/ScreenRangeOverlay.png",
			Size = UDim2.new(1, 2, 1, 2),
			Position = UDim2.new(0, -1, 0, -1),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(21, 21, 41, 41)
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
			callback = p8.onRenderStep
		}),
		AdjustConnectorThumbstick = React.createElement(ContextActionEvent, {
			name = "ThumbstickAdjustmentScreen",
			callback = p8.onAdjustThumbstick,
			binds = { Enum.KeyCode.Thumbstick2 }
		}),
		SuspendedCn = PlatformService and React.createElement(ExternalEventConnection, {
			event = PlatformService.Suspended,
			callback = p8.onSuspended
		})
	})
end

return v18
