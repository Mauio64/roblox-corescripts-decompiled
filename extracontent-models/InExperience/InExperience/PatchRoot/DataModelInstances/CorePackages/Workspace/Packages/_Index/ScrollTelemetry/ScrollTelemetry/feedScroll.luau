local parent = script:FindFirstAncestor("ScrollTelemetry").Parent
local ArgCheck = require(parent.ArgCheck)
local Cryo = require(parent.Cryo)
local t = require(parent.t)
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError

local strictInterface = t.strictInterface({
	distance = t.number,
	screenSizeX = t.number,
	screenSizeY = t.number,
	scrollAreaSize = t.number,
	scrollDepth = t.optional(t.number),
	startDepth = t.optional(t.number),
	startPos = t.number,
	scrollDuration = t.number
})

local strictInterface2 = t.strictInterface({
	distance = t.number,
	screenSizeX = t.number,
	screenSizeY = t.number,
	scrollAreaSize = t.number,
	scrollDepth = t.optional(t.number),
	startDepth = t.optional(t.number),
	startPos = t.number,
	scrollDuration = t.number,
	sortPos = t.number,
	gameSetTypeId = t.string,
	gameSetTargetId = t.optional(t.number)
})

return function(object, p, p2, p3)
	ArgCheck.isType(p, "string", "eventContext")

	local direction = "unknown"

	local v = nil

	if p2 == Enum.ScrollingDirection.Y then
		v = strictInterface
		direction = "vertical"
	elseif p2 == Enum.ScrollingDirection.X then
		v = strictInterface2
		direction = "horizontal"
	elseif p2 == Enum.ScrollingDirection.XY then
		mutedError(`Direction {p2.Name} is an unsupported option for feedScroll event`)
	end

	if v then
		local v2, v3 = v(p3)

		if not v2 then
			mutedError(v3)
		end
	else
		mutedError(`Missing interface for unknown direction {p2.Name} to type check feedScroll event parameters`)
	end

	object:sendEventDeferred(p, "feedScroll", (Cryo.Dictionary.join(p3, { direction = direction })))
end
