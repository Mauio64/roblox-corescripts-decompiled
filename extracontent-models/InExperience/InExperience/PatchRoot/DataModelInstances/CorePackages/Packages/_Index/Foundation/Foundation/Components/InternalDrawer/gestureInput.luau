local Foundation = script:FindFirstAncestor("Foundation")

local Connection = require(Foundation.Utility.Wrappers.Connection)
local DragIntent = require(Foundation.Enums.DragIntent)
local Services = require(Foundation.Utility.Wrappers.Services)
local Signal = require(Foundation.Utility.Wrappers.Signal)
local swipeMath = require(script.Parent.swipeMath)

local UserInputService = Services.UserInputService

local function isPointerDown(p): boolean -- 1 equivalent call inferred from this helper
	return p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch
end

local function updateClaim(data, p: number, p2: number, p3: number?): boolean -- 1 equivalent call inferred from this helper
	if data.intent ~= DragIntent.Pending then
		return false
	end

	local classifyDrag = swipeMath.classifyDrag(p, p2, 8, p3)

	if classifyDrag == DragIntent.Claim then
		data.intent = DragIntent.Claim
		return true
	end

	if classifyDrag == DragIntent.Ignore then
		data.intent = DragIntent.Ignore
	end

	return false
end

local function sampleVelocity(state, x: number, now: number) -- 1 equivalent call inferred from this helper
	local v = now - state.lastTime

	if v > 0 then
		state.velocityX = (x - state.lastX) / v
	end

	state.lastX = x
	state.lastTime = now
end

local function isOwnHit(ancestor, instance, ancestor2) -- 2 equivalent calls inferred from this helper
	if instance == ancestor or instance:IsDescendantOf(ancestor) then
		return true
	end

	return ancestor2 ~= nil and (instance == ancestor2 or instance:IsDescendantOf(ancestor2))
end

local GestureInput = {}

function GestureInput.beginGesture(input, lastTime: number)
	return {
		input = input,
		startX = input.Position.X,
		startY = input.Position.Y,
		lastX = input.Position.X,
		lastTime = lastTime,
		velocityX = 0,
		intent = DragIntent.Pending,
		lastProgress = nil
	}
end

function GestureInput.canBegin(p, p2)
	return p == nil and isPointerDown(p2) and UserInputService:GetFocusedTextBox() == nil -- inferred equivalent call
end

function GestureInput.connectPointer(data)
	local v = nil

	local function stopTracking() -- 2 equivalent calls inferred from this helper
		if v ~= nil then
			Connection.Disconnect(v)
			v = nil
		end
	end

	local v2 = Signal.Connect(UserInputService.InputBegan, function(p)
		if data.onBegan(p) and v == nil then
			v = Signal.Connect(UserInputService.InputChanged, data.onChanged)
		end
	end)
	local v3 = Signal.Connect(UserInputService.InputEnded, function(p)
		if data.onEnded(p) then
			stopTracking() -- inferred equivalent call
		end
	end)

	return function()
		Connection.Disconnect(v2)
		Connection.Disconnect(v3)
		stopTracking() -- inferred equivalent call
	end
end

function GestureInput.isForeignHit(ancestor, instance, ancestor2): boolean
	return instance ~= nil and not isOwnHit(ancestor, instance, ancestor2) -- inferred equivalent call
end

function GestureInput.isInside(p, vector3: Vector3): boolean
	local absolutePosition = p.AbsolutePosition
	local absoluteSize = p.AbsoluteSize
	return vector3.X >= absolutePosition.X
		and vector3.Y >= absolutePosition.Y
		and vector3.X <= absolutePosition.X + absoluteSize.X
		and vector3.Y <= absolutePosition.Y + absoluteSize.Y
end

function GestureInput.matchesMove(p, p2): boolean
	if p2.UserInputType == Enum.UserInputType.Touch then
		return p == p2
	end

	return p.UserInputType == Enum.UserInputType.MouseMovement
end

function GestureInput.matchesRelease(p, p2): boolean
	if p2.UserInputType == Enum.UserInputType.Touch then
		return p == p2
	end

	return p.UserInputType == Enum.UserInputType.MouseButton1
end

function GestureInput.move(data, p, p2: number?)
	local position = p.Position
	local x = position.X
	local v = updateClaim(data, x - data.startX, position.Y - data.startY, p2) -- inferred equivalent call

	local v2 = data.intent == DragIntent.Claim

	if v2 then
		sampleVelocity(data, x, os.clock()) -- inferred equivalent call
	end

	return v, v2, x
end

GestureInput.sampleVelocity = sampleVelocity

function GestureInput.setProgressIfChanged(p, callback, lastProgress: number)
	if p.lastProgress == lastProgress then
		return
	end

	p.lastProgress = lastProgress
	callback(lastProgress)
end

function GestureInput.topGuiAt(instance, vector3: Vector3, ancestor)
	local v = instance:FindFirstAncestorWhichIsA("PlayerGui")

	if v == nil then
		v = instance:FindFirstAncestorWhichIsA("CoreGui")
	end

	if v == nil then
		return nil
	end

	for _, guiObject in v:GetGuiObjectsAtPosition(vector3.X, vector3.Y) do
		if typeof(guiObject) == "Instance" and guiObject:IsA("GuiObject") then
			if not guiObject.Active and not isOwnHit(instance, guiObject, ancestor) then -- inferred equivalent call
				continue
			end

			return guiObject
		end
	end

	return nil
end

GestureInput.updateClaim = updateClaim
return GestureInput
