local t1 = {}
local RunService = game:GetService("RunService")
local _ = script.Parent
local t2 = {
	__ClassName = "TransparencyTweener",
	__tostring = function(p1) -- line: 21
		return p1.__ClassName .. ": " .. p1.MemoryLocation
	end,
	__metatable = "The metatable is locked"
}

function t2.__index(p2, p3, _) -- line: 26
	-- upvalues: t2 (copy)
	if rawget(p2, p3) then
		return (rawget(p2, p3))
	end

	if rawget(t2, p3) then
		return (rawget(t2, p3))
	end

	if p3 == "Transparency" then
		return (rawget(p2, "InternalLastTweenPercentage"))
	end

	error(p3 .. " is not a valid member of " .. p2.__ClassName)
end
function t2.__newindex(p5, p6, p7) -- line: 36
	if p6 == "Transparency" then
		p5.InternalLastTweenPercentage = p7
		p5:SetPropertiesToTweenPercentage(p7)

		return
	end

	error(p6 .. " is not a valid member of " .. p5.__ClassName)
end
function t2.Dump(p8) -- line: 49
	local str = tostring(p8)

	for k, v in pairs(p8.TweenObjects) do
		local s1 = " | "

		if type(k) == "table" then
			s1 ..= "{{" .. k:Dump() .. "}}"
		elseif type(k) == "userdata" then
			s1 ..= k.Name .. "/" .. k:GetFullName()
		end

		for k2, v2 in pairs(v) do
			s1 ..= " [" .. k2 .. "=" .. string.sub(tostring(v2), 1, 4) .. "]"
		end

		str ..= s1
	end

	return str
end
function t2.OutputTest(p9) -- line: 70
	print("Test Output for {={" .. p9:Dump() .. "}=}")

	for k, v in pairs(p9.TweenObjects) do
		print("TweenObject:", k)

		for k3, v3 in pairs(v) do
			print("\t[" .. k3 .. "=" .. string.sub(tostring(v3), 1, 4) .. "] Actual:" .. k[k3])
		end
	end
end
function t2.RegisterTweenObjectProperty(p10, p11, p12, p13) -- line: 80
	local v28 = p13 or p11[p12]

	if not p10.TweenObjects[p11] then
		p10.TweenObjects[p11] = {}
	end

	p10.TweenObjects[p11][p12] = v28
	p10:SetObjectPropertyToPercentValue(p11, p12, v28, p10.InternalLastTweenPercentage)
end
function t2.UnregisterTweenObject(p14, p15) -- line: 92
	p14.TweenObjects[p15] = nil
end
function t2.SetObjectPropertyToPercentValue(_, p17, p18, p19, p20) -- line: 96
	p17[p18] = p19 + (1 - p19) * p20
end
function t2.SetPropertiesToTweenPercentage(p21, p22) -- line: 102
	for k, v in pairs(p21.TweenObjects) do
		for k4, v4 in pairs(v) do
			p21:SetObjectPropertyToPercentValue(k, k4, v4, p22)
		end
	end
end
function t2.Tween(p23, p24, p25, p26) -- line: 110
	-- upvalues: RunService (copy)
	if p23.Tweening then
		p23.QueuedTween = {
			p24,
			p25,
			p26
		}
		p23.TweenIsQueued = true
		p23:CancelTween()

		return
	end

	p23.Tweening = true

	local u46 = p26

	if u46 then
		p23:SetPropertiesToTweenPercentage(u46)
	else
		u46 = p23.InternalLastTweenPercentage
	end

	local timestamp = tick()
	local v48 = timestamp + p24
	local v49 = p25 - u46
	local n1 = 0

	spawn(function() -- line: 132
		-- upvalues: v48 (copy), p23 (copy), n1 (ref), timestamp (copy), p24 (copy), u46 (ref), v49 (copy), RunService (copy), p25 (copy)
		local timestamp2 = tick()

		while timestamp2 < v48 and not p23.Canceled do
			n1 = math.min(math.max((timestamp2 - timestamp) / p24, 0), 1)

			local v54 = u46 + v49 * n1

			p23.InternalLastTweenPercentage = v54
			p23:SetPropertiesToTweenPercentage(v54)
			RunService.RenderStepped:wait()
			timestamp2 = tick()
		end

		if not p23.Canceled then
			p23.InternalLastTweenPercentage = p25
			p23:SetPropertiesToTweenPercentage(p25)
		else
			p23.Canceled = false

			if p23.TweenIsQueued then
				p23.TweenIsQueued = false
				p23.Tweening = false
				p23:Tween(unpack(p23.QueuedTween))

				return
			end
		end

		p23.Tweening = false
	end)
end
function t2.CancelTween(p27) -- line: 163
	p27.Canceled = true
end
function t1.new() -- line: 169
	-- upvalues: t2 (copy)
	local t3 = {}

	t3.MemoryLocation = tostring(t3):match("[0123456789ABCDEF]+")
	t3.TweenObjects = setmetatable({}, {
		__mode = "k"
	})
	t3.Transparency = nil
	t3.InternalLastTweenPercentage = 0
	t3.Tweening = false
	t3.Canceled = false
	t3.TweenIsQueued = false
	t3.QueuedTween = {}

	return (setmetatable(t3, t2))
end

return t1
