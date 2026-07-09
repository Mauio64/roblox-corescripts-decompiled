local Parent = script:FindFirstAncestor("ScrollTelemetry").Parent
local ArgCheck = require(Parent.ArgCheck)
local Cryo = require(Parent.Cryo)
local t = require(Parent.t)
local mutedError = require(Parent.Loggers).mutedError
local v6 = t.strictInterface({
	distance = t.number,
	screenSizeX = t.number,
	screenSizeY = t.number,
	scrollAreaSize = t.number,
	scrollDepth = t.optional(t.number),
	startDepth = t.optional(t.number),
	startPos = t.number,
	scrollDuration = t.number
})
local v7 = t.strictInterface({
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

return function(p1, p2, p3, p4) -- line: 33
	-- upvalues: ArgCheck (copy), v6 (copy), v7 (copy), mutedError (copy), Cryo (copy)
	ArgCheck.isType(p2, "string", "eventContext")

	local s1 = "unknown"
	local v13 = nil

	if p3 == Enum.ScrollingDirection.Y then
		s1 = "vertical"
		v13 = v6
	elseif p3 == Enum.ScrollingDirection.X then
		s1 = "horizontal"
		v13 = v7
	elseif p3 == Enum.ScrollingDirection.XY then
		mutedError(`Direction { p3.Name } is an unsupported option for feedScroll event`)
	end

	if v13 then
		local v14, v15 = v13(p4)

		if not v14 then
			mutedError(v15)
		end
	else
		mutedError(`Missing interface for unknown direction { p3.Name } to type check feedScroll event parameters`)
	end

	p1:sendEventDeferred(p2, "feedScroll", (Cryo.Dictionary.join(p4, {
		direction = s1
	})))
end
