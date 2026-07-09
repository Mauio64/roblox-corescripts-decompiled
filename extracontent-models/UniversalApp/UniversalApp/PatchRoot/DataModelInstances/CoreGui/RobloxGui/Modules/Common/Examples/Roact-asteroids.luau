local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local v6 = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagMigrateRoactUtilsToReactUtils()
local ParentParent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local ExternalEventConnection = require(ParentParent.RoactUtilities.ExternalEventConnection)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)

local function playerInputReducer(p1, p2) -- line: 27
	-- upvalues: Cryo (copy)
	local v42 = p1 or {
		left = 0,
		right = 0,
		up = 0,
		pause = 0
	}

	if p2.type == "SetPlayerInput" then
		local t1 = {
			[p2.playerInput] = p2.value
		}

		return Cryo.Dictionary.join(v42, t1)
	end

	return v42
end
local function playerReducer(p3, p4) -- line: 45
	-- upvalues: Cryo (copy)
	local v46 = p3 or {
		angle = 0,
		turnRate = 1.5707963267948966,
		throttleRate = 10,
		position = Vector2.new(0, 0),
		velocity = Vector2.new(0, 0)
	}

	if p4.type == "GameStep" then
		local inputs = p4.inputs
		local delta = p4.delta
		local vector2 = Vector2.new(math.sin(v46.angle), -math.cos(v46.angle))
		local v50 = inputs.right - inputs.left
		local up = inputs.up

		return Cryo.Dictionary.join(v46, {
			position = v46.position + v46.velocity * delta,
			velocity = v46.velocity + up * v46.throttleRate * delta * vector2,
			angle = v46.angle + v50 * v46.turnRate * delta
		})
	end

	if p4.type == "SetPlayerRotation" then
		return Cryo.Dictionary.join(v46, {
			angle = p4.value
		})
	end

	return v46
end
local function timeReducer(p5, p6) -- line: 74
	local v54 = p5 or 0

	if p6.type == "GameStep" then
		return v54 + p6.delta
	end

	return v54
end
local function asteroidsReducer(p7, p8) -- line: 84
	local function initAsteroids() -- line: 85
		return {
			{
				size = 5,
				position = Vector2.new(-5, -5),
				velocity = Vector2.new(1, 0)
			},
			{
				size = 3,
				position = Vector2.new(-5, 5),
				velocity = Vector2.new(1, 0)
			},
			{
				size = 5,
				position = Vector2.new(5, 5),
				velocity = Vector2.new(0, -1)
			},
			{
				size = 3,
				position = Vector2.new(5, -5),
				velocity = Vector2.new(0, 1)
			}
		}
	end

	local v58 = p7 or initAsteroids()

	if p8.type == "GameStep" then
		local delta = p8.delta
		local t2 = {}

		for k, v in pairs(v58) do
			local positionX = v.position.X
			local positionY = v.position.Y
			local velocityX = v.velocity.X
			local velocityY = v.velocity.Y

			t2[k] = {
				position = Vector2.new(positionX + velocityX * delta, positionY + velocityY * delta),
				velocity = Vector2.new(velocityX, velocityY),
				size = v.size
			}
		end

		return t2
	end

	return v58
end
local function pausePressed(p9) -- line: 135
	return p9.playerInput == "pause" and p9.value == 1
end
local function pauseReducer(p10, p11) -- line: 139
	local v70 = p10 or false

	if p11.type == "SetPlayerInput" and (p11.playerInput == "pause" and p11.value == 1) then
		return not v70
	end

	return v70
end
local function reducer(p12, p13) -- line: 149
	-- upvalues: playerInputReducer (copy), playerReducer (copy), asteroidsReducer (copy)
	local v73 = p12 or {}
	local t3 = {
		playerInputs = playerInputReducer(v73.playerInputs, p13)
	}
	local v75 = v73.paused or false

	t3.paused = if p13.type ~= "SetPlayerInput" or not (p13.playerInput == "pause" and p13.value == 1) then v75 else not v75
	t3.player = playerReducer(v73.player, p13)

	local v76 = v73.time or 0

	t3.time = if p13.type ~= "GameStep" then v76 else v76 + p13.delta
	t3.asteroids = asteroidsReducer(v73.asteroids, p13)

	return t3
end

local v20 = Roact.Component:extend("Camera")

function v20.init(p14) -- line: 164
	-- upvalues: Roact (copy)
	p14.cameraRef = Roact.createRef()
end
function v20.render(p15) -- line: 168
	-- upvalues: Roact (copy)
	local focus = p15.props.focus

	return Roact.createElement("Camera", {
		CameraType = Enum.CameraType.Scriptable,
		CFrame = CFrame.new((Vector3.new(focus.x, 20, focus.y))) * CFrame.fromEulerAnglesXYZ(-1.5707963267948966, 0, 0),
		FieldOfView = 90,
		[Roact.Ref] = p15.cameraRef
	})
end
function v20.didMount(p16) -- line: 180
	-- upvalues: Workspace (copy)
	Workspace.CurrentCamera = p16.cameraRef.current
end

local v21 = RoactRodux.connect(function(p17, _) -- line: 185
	return {
		focus = p17.player.position
	}
end, nil)(v20)
local v22 = Roact.Component:extend("Asteroid")

function v22.render(p19) -- line: 194
	-- upvalues: Roact (copy)
	local position = p19.props.position
	local size = p19.props.size

	return Roact.createElement("Part", {
		Anchored = true,
		Shape = Enum.PartType.Ball,
		Size = Vector3.new(size, size, size),
		Color = Color3.fromRGB(170, 170, 170),
		CFrame = CFrame.new((Vector3.new(position.x, 0, position.y))),
		TopSurface = Enum.SurfaceType.Smooth
	})
end

local v23 = Roact.Component:extend("Asteroids")

function v23.render(p20) -- line: 211
	-- upvalues: Roact (copy), v22 (copy)
	local props = p20.props
	local t4 = {}

	for k, v in pairs(props) do
		t4[k] = Roact.createElement(v22, {
			position = v.position,
			size = v.size
		})
	end

	return Roact.createElement("Folder", {
		Name = "Asteroids"
	}, t4)
end

local u24 = RoactRodux.connect(function(p21, _) -- line: 228
	return p21.asteroids
end, nil)(v23)
local v25 = Roact.Component:extend("Ship")

function v25.render(p23) -- line: 235
	-- upvalues: Roact (copy)
	local position = p23.props.position
	local angle = p23.props.angle
	local time = p23.props.time
	local color3 = Color3.fromHSV(time % 5 / 5, 1, 1)

	return Roact.createElement("Part", {
		Anchored = true,
		Size = Vector3.new(2, 2, 6),
		Color = color3,
		CFrame = CFrame.new((Vector3.new(position.x, 0, position.y))) * CFrame.fromEulerAnglesXYZ(0, -angle, 0),
		FrontSurface = Enum.SurfaceType.Hinge
	})
end

local v26 = RoactRodux.connect(function(p24, _) -- line: 252
	return {
		position = p24.player.position,
		angle = p24.player.angle,
		time = p24.time
	}
end, nil)(v25)
local v27 = Roact.Component:extend("GameBackground")

function v27.render(_) -- line: 263
	-- upvalues: Roact (copy)
	return Roact.createElement("Part", {
		Anchored = true,
		Size = Vector3.new(512, 10, 512),
		CFrame = CFrame.new((Vector3.new(0, -5, 0))),
		Color = Color3.new(0, 0, 0)
	})
end

local v28 = Roact.Component:extend("PauseText")

function v28.render(_) -- line: 275
	-- upvalues: Roact (copy)
	return Roact.createElement("TextLabel", {
		Text = "Paused",
		TextSize = 70,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.Arcade,
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
end

local v29 = Roact.Component:extend("InputConnector")

function v29.render(p28) -- line: 288
	-- upvalues: v6 (copy), Roact (copy), ExternalEventConnection (copy), UserInputService (copy)
	local function inputBeganCallback(p29) -- line: 289
		-- upvalues: p28 (copy)
		if p28.props.onInputBegan then
			p28.props.onInputBegan(p29)
		end
	end
	local function inputChangedCallback(p30) -- line: 295
		-- upvalues: p28 (copy)
		if p28.props.onInputChanged then
			p28.props.onInputChanged(p30)
		end
	end
	local function inputEndedCallback(p31) -- line: 301
		-- upvalues: p28 (copy)
		if p28.props.onInputEnded then
			p28.props.onInputEnded(p31)
		end
	end

	if v6 then
		return Roact.createFragment({
			InputBeganConnection = Roact.createElement(ExternalEventConnection, {
				event = UserInputService.InputBegan,
				callback = inputBeganCallback
			}),
			InputChangedConnection = Roact.createElement(ExternalEventConnection, {
				event = UserInputService.InputChanged,
				callback = inputChangedCallback
			}),
			InputEndedConnection = Roact.createElement(ExternalEventConnection, {
				event = UserInputService.InputEnded,
				callback = inputEndedCallback
			})
		})
	end

	return Roact.createElement(ExternalEventConnection, {
		event = UserInputService.InputBegan,
		callback = inputBeganCallback
	}, { Roact.createElement(ExternalEventConnection, {
		event = UserInputService.InputChanged,
		callback = inputChangedCallback
	}, { Roact.createElement(ExternalEventConnection, {
		event = UserInputService.InputEnded,
		callback = inputEndedCallback
	}) }) })
end

local t5 = {
	[Enum.KeyCode.Left] = "left",
	[Enum.KeyCode.A] = "left",
	[Enum.KeyCode.Right] = "right",
	[Enum.KeyCode.D] = "right",
	[Enum.KeyCode.Up] = "up",
	[Enum.KeyCode.W] = "up",
	[Enum.KeyCode.P] = "pause"
}

local function getPlayerInput(p32) -- line: 352
	-- upvalues: t5 (copy)
	if p32.UserInputType ~= Enum.UserInputType.Keyboard then
		return nil
	end

	return t5[p32.KeyCode]
end

local v32 = RoactRodux.connect(nil, function(p33) -- line: 360
	-- upvalues: t5 (copy)
	return {
		onInputBegan = function(p34) -- line: 362
			-- upvalues: t5 (copy), p33 (copy)
			local v129 = if p34.UserInputType == Enum.UserInputType.Keyboard then t5[p34.KeyCode] else nil

			if v129 then
				p33({
					type = "SetPlayerInput",
					value = 1,
					playerInput = v129
				})
			end
		end,
		onInputEnded = function(p35) -- line: 373
			-- upvalues: t5 (copy), p33 (copy)
			local v131 = if p35.UserInputType == Enum.UserInputType.Keyboard then t5[p35.KeyCode] else nil

			if v131 then
				p33({
					type = "SetPlayerInput",
					value = 0,
					playerInput = v131
				})
			end
		end
	}
end)(v29)
local v33 = Roact.Component:extend("RenderSteppedConnector")

function v33.render(p36) -- line: 388
	-- upvalues: Roact (copy), ExternalEventConnection (copy), RunService (copy)
	local playerInputs = p36.props.playerInputs

	local function onStepped(p37) -- line: 391
		-- upvalues: p36 (copy), playerInputs (copy)
		p36.props.onStepped(p37, playerInputs)
	end

	return Roact.createElement(ExternalEventConnection, {
		event = RunService.RenderStepped,
		callback = onStepped
	})
end

local u34 = RoactRodux.connect(function(p38, _) -- line: 402
	return {
		playerInputs = p38.playerInputs
	}
end, function(p40) -- line: 406
	return {
		onStepped = function(p41, p42) -- line: 408
			-- upvalues: p40 (copy)
			p40({
				type = "GameStep",
				delta = p41,
				inputs = p42
			})
		end
	}
end)(v33)

local function PauseRoute(p43) -- line: 424
	-- upvalues: Roact (copy)
	local paused = p43.paused
	local match = p43.match
	local component = p43.component

	if paused == match then
		return Roact.createElement(component)
	end

	return nil
end

local u36 = RoactRodux.connect(function(p44, _) -- line: 438
	return {
		paused = p44.paused
	}
end, nil)(PauseRoute)
local v37 = Roact.Component:extend("App")

function v37.render(_) -- line: 447
	-- upvalues: Roact (copy), v26 (copy), v21 (copy), v27 (copy), u24 (ref), v32 (copy), u36 (ref), u34 (ref)
	return Roact.createElement("Folder", {}, {
		Player = Roact.createElement(v26),
		PlayerCamera = Roact.createElement(v21),
		GameBackground = Roact.createElement(v27),
		Asteroids = Roact.createElement(u24),
		KeyboardInputConnector = Roact.createElement(v32),
		RenderSteppedConnector = Roact.createElement(u36, {
			match = false,
			component = u34
		})
	})
end

local v38 = Roact.Component:extend("Ui")

function v38.render(_) -- line: 464
	-- upvalues: Roact (copy), u36 (ref), v28 (copy)
	return Roact.createElement("ScreenGui", nil, {
		PauseText = Roact.createElement(u36, {
			match = true,
			component = v28
		})
	})
end

local function main() -- line: 473
	-- upvalues: RunService (copy), Rodux (copy), reducer (copy), Roact (copy), RoactRodux (copy), v37 (copy), v38 (copy), Workspace (copy), CoreGui (copy)
	RunService.Stepped:Wait()

	local v122 = Rodux.Store.new(reducer)
	local v123 = Roact.createElement(RoactRodux.StoreProvider, {
		store = v122
	}, {
		App = Roact.createElement(v37)
	})
	local v124 = Roact.createElement(RoactRodux.StoreProvider, {
		store = v122
	}, {
		Ui = Roact.createElement(v38)
	})

	Roact.mount(v123, Workspace, "Roact-asteroids")
	Roact.mount(v124, CoreGui, "Roact-asteroids-ui")
end

return main
