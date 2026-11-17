local Foundation = script:FindFirstAncestor("Foundation")

local DragIntent = require(Foundation.Enums.DragIntent)
local InternalDrawerSide = require(Foundation.Enums.InternalDrawerSide)

local function openSign(p): number -- 1 equivalent call inferred from this helper
	return if p == InternalDrawerSide.Start then 1 else -1
end

local function distanceAlong(p: number, startX: number, lastX: number) -- 1 equivalent call inferred from this helper
	return (math.max(0, (lastX - startX) * p))
end

local function velocityAlong(p: number, p2: number) -- 1 equivalent call inferred from this helper
	return p2 * p
end

local function freshVelocity(velocityX: number, lastTime: number, p: number) -- 1 equivalent call inferred from this helper
	return if p - lastTime > 0.1 then 0 else velocityX
end

local function passedThreshold(p: number, p2: number, p3: number, p4: number, p5: number): boolean -- 1 equivalent arithmetic call inferred from this helper
	return not (p2 <= 0) and (p5 <= p3 or p > 0 and p4 * p2 <= p)
end

local function resolveThreshold(p: number?, p2: number)
	return if p == nil then p2 else p
end

local SwipeMath = {}
SwipeMath.DEFAULT_DISTANCE_FRACTION = 0.3
SwipeMath.DEFAULT_VELOCITY_THRESHOLD = 400

function SwipeMath.classifyDrag(p: number, p2: number, p3: number, p4: number?)
	local v = math.abs(p)
	local v2 = math.abs(p2)

	if p3 < v2 and v <= v2 then
		return DragIntent.Ignore
	end

	if v <= p3 then
		return DragIntent.Pending
	end

	if p4 == nil or not (p * p4 <= 0) then
		return DragIntent.Claim
	end

	return DragIntent.Ignore
end

function SwipeMath.closeSign(p)
	return -openSign(p) -- inferred equivalent call
end

SwipeMath.distanceAlong = distanceAlong
SwipeMath.freshVelocity = freshVelocity
SwipeMath.openSign = openSign
SwipeMath.passedThreshold = passedThreshold

function SwipeMath.progress(p: number, p2: number)
	if p2 <= 0 then
		return 0
	end

	return (math.clamp(p / p2, 0, 1))
end

function SwipeMath.resolveThresholds(p)
	local distanceFraction = p.distanceFraction
	local selected = distanceFraction == nil and 0.3 or distanceFraction

	local velocityThreshold = p.velocityThreshold

	if velocityThreshold == nil then
		return selected, 400
	end

	return selected, velocityThreshold
end

function SwipeMath.shouldCommit(data, p: number, p2: number, p3: number, p4: number, p5: number)
	local v = distanceAlong(p, data.startX, data.lastX) -- inferred equivalent call
	local v2 = velocityAlong(p, freshVelocity(data.velocityX, data.lastTime, p5)) -- inferred equivalent call
	return passedThreshold(v, p2, v2, p3, p4) -- inferred equivalent call
end

SwipeMath.velocityAlong = velocityAlong
return SwipeMath
