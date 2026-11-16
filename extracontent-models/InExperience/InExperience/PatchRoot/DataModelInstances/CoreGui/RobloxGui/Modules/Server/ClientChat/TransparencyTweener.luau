local TransparencyTweener = {}

local RunService = game:GetService("RunService")

local parent = script.Parent

local v = {}
v.__ClassName = "TransparencyTweener"

function v.__tostring(p)
	return p.__ClassName .. ": " .. p.MemoryLocation
end

v.__metatable = "The metatable is locked"

function v:__index(p, _)
	if rawget(self, p) then
		return (rawget(self, p))
	end

	if rawget(v, p) then
		return (rawget(v, p))
	end

	if p == "Transparency" then
		return (rawget(self, "InternalLastTweenPercentage"))
	end

	error(p .. " is not a valid member of " .. self.__ClassName)
end
function v:__newindex(p, internalLastTweenPercentage)
	if p ~= "Transparency" then
		error(p .. " is not a valid member of " .. self.__ClassName)
		return
	end

	self.InternalLastTweenPercentage = internalLastTweenPercentage
	self:SetPropertiesToTweenPercentage(internalLastTweenPercentage)
end

function v:Dump()
	local v2 = tostring(self)

	for k, tweenObject in pairs(self.TweenObjects) do
		local v3 = " | "

		if type(k) == "table" then
			v3 ..= "{{" .. k:Dump() .. "}}"
		elseif type(k) == "userdata" then
			v3 ..= k.Name .. "/" .. k:GetFullName()
		end

		for k2, v4 in pairs(tweenObject) do
			v3 ..= " [" .. k2 .. "=" .. string.sub(tostring(v4), 1, 4) .. "]"
		end

		v2 ..= v3
	end

	return v2
end

function v:OutputTest()
	print("Test Output for {={" .. self:Dump() .. "}=}")

	for k, tweenObject in pairs(self.TweenObjects) do
		print("TweenObject:", k)

		for k2, v2 in pairs(tweenObject) do
			print("\t[" .. k2 .. "=" .. string.sub(tostring(v2), 1, 4) .. "] Actual:" .. k[k2])
		end
	end
end

function v:RegisterTweenObjectProperty(p, p2, p3)
	local v2 = p3 or p[p2]

	if not self.TweenObjects[p] then
		self.TweenObjects[p] = {}
	end

	self.TweenObjects[p][p2] = v2

	self:SetObjectPropertyToPercentValue(p, p2, v2, self.InternalLastTweenPercentage)
end

function v.UnregisterTweenObject(p, p2)
	p.TweenObjects[p2] = nil
end

function v:SetObjectPropertyToPercentValue(p, p2, p3, p4)
	p[p2] = p3 + (1 - p3) * p4
end

function v:SetPropertiesToTweenPercentage(p)
	for k, tweenObject in pairs(self.TweenObjects) do
		for k2, v2 in pairs(tweenObject) do
			self:SetObjectPropertyToPercentValue(k, k2, v2, p)
		end
	end
end

function v:Tween(p, internalLastTweenPercentage, p2)
	if self.Tweening then
		self.QueuedTween = { p, internalLastTweenPercentage, p2 }
		self.TweenIsQueued = true
		self:CancelTween()
	else
		self.Tweening = true

		if p2 then
			self:SetPropertiesToTweenPercentage(p2)
		else
			p2 = self.InternalLastTweenPercentage
		end

		local now = tick()
		local v2 = now + p
		local v3 = internalLastTweenPercentage - p2

		local v4 = 0
		spawn(function()
			local now2 = tick()

			while now2 < v2 and not self.Canceled do
				v4 = math.min(math.max((now2 - now) / p, 0), 1)
				local internalLastTweenPercentage2 = p2 + v3 * v4
				self.InternalLastTweenPercentage = internalLastTweenPercentage2
				self:SetPropertiesToTweenPercentage(internalLastTweenPercentage2)

				RunService.RenderStepped:wait()
				now2 = tick()
			end

			if self.Canceled then
				self.Canceled = false

				if self.TweenIsQueued then
					self.TweenIsQueued = false
					self.Tweening = false
					self:Tween(unpack(self.QueuedTween))
					return
				end
			else
				self.InternalLastTweenPercentage = internalLastTweenPercentage
				self:SetPropertiesToTweenPercentage(internalLastTweenPercentage)
			end

			self.Tweening = false
		end)
	end
end

function v:CancelTween()
	self.Canceled = true
end

function TransparencyTweener.new()
	local v2 = {}
	v2.MemoryLocation = tostring(v2):match("[0123456789ABCDEF]+")

	v2.TweenObjects = setmetatable({}, { __mode = "k" })

	v2.Transparency = nil
	v2.InternalLastTweenPercentage = 0
	v2.Tweening = false
	v2.Canceled = false

	v2.TweenIsQueued = false
	v2.QueuedTween = {}

	return (setmetatable(v2, v))
end

return TransparencyTweener
