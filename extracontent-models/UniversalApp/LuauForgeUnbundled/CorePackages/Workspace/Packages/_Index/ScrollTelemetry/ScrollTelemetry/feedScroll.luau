local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/ScrollTelemetry/ArgCheck")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ScrollTelemetry/Cryo")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/ScrollTelemetry/t")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/ScrollTelemetry/Loggers").mutedError

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

return function(object, p2, p3, p4)
	ArgCheck.isType(p2, "string", "eventContext")

	local v5 = "unknown"

	local v6 = nil

	if p3 == Enum.ScrollingDirection.Y then
		v6 = strictInterface
		v5 = "vertical"
	elseif p3 == Enum.ScrollingDirection.X then
		v6 = strictInterface2
		v5 = "horizontal"
	elseif p3 == Enum.ScrollingDirection.XY then
		mutedError(`Direction {p3.Name} is an unsupported option for feedScroll event`)
	end

	if v6 then
		local v7, v8 = v6(p4)

		if not v7 then
			mutedError(v8)
		end
	else
		mutedError(`Missing interface for unknown direction {p3.Name} to type check feedScroll event parameters`)
	end

	object:sendEventDeferred(p2, "feedScroll", (Cryo.Dictionary.join(p4, {
		direction = v5
	})))
end
