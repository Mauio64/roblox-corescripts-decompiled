local TweenService = game:GetService("TweenService")

local AvatarSpinPhysics = {}
AvatarSpinPhysics.SNAP_TOLERANCE_DEGREES = 0.5
AvatarSpinPhysics.__index = AvatarSpinPhysics

function AvatarSpinPhysics.normalizeAngle(p: number)
	return p % 360
end

function AvatarSpinPhysics.shortestDelta(p: number, p2: number)
	return (p2 - p + 180) % 360 - 180
end

function AvatarSpinPhysics.new(data)
	return (setmetatable({
		angle = not (data and data.angle) and 0 or data.angle,
		velocity = 0,
		isDragging = false,
		mode = "idle",
		snap = not data or data.snap == nil or data.snap,
		degreesPerPixel = not (data and data.degreesPerPixel) and 0.5 or data.degreesPerPixel,
		_target = 0,
		_tween = nil,
		_samples = {},
		_lastX = 0
	}, AvatarSpinPhysics))
end

function AvatarSpinPhysics:dragStart(lastX: number, time: number)
	self.isDragging = true
	self.mode = "idle"
	self._tween = nil
	self.velocity = 0
	self._lastX = lastX
	self._samples = {
		{ time = time, angle = self.angle }
	}
end

function AvatarSpinPhysics:dragMove(lastX: number, time: number)
	if not self.isDragging then
		return
	end

	self.angle += (lastX - self._lastX) * self.degreesPerPixel
	self._lastX = lastX
	table.insert(self._samples, { time = time, angle = self.angle })

	while #self._samples > 2 and time - self._samples[1].time > 0.1 do
		table.remove(self._samples, 1)
	end
end

function AvatarSpinPhysics:dragEnd(p: number)
	if not self.isDragging then
		return
	end

	self.isDragging = false
	local v = 1

	for i = #self._samples, 2, -1 do
		if self._samples[i].time - self._samples[i - 1].time > 0.05 then
			v = i
			break
		end
	end

	local sample = self._samples[v]
	local sample2 = self._samples[#self._samples]

	self:release((math.clamp(
		not (sample and sample2 and sample2.time - sample.time > 0.008 and p - sample2.time < 0.08) and 0 or (sample2.angle - sample.angle) / (sample2.time - sample.time),
		-1440,
		1440
	)))
end

function AvatarSpinPhysics:release(velocity: number)
	self.velocity = velocity

	if self.snap then
		local v = self.angle + velocity / 4
		local target = math.round(v / 90) * 90

		if math.abs(v - target) <= 30 then
			self.mode = "spring"
			self._target = target
			return
		end
	end

	self.mode = math.abs(velocity) > 1 and "inertia" or "idle"
end

function AvatarSpinPhysics:tweenBy(p: number, p2: number)
	self.isDragging = false
	self.velocity = 0
	self.mode = "tween"
	self._tween = {
		from = self.angle,
		to = self.angle + p,
		elapsed = 0,
		duration = math.max(p2, 0.001)
	}
end

function AvatarSpinPhysics:update(p: number): boolean
	if self.isDragging or self.mode == "idle" then
		return false
	end

	local v = math.min(p, 0.1)
	local angle = self.angle

	if self.mode == "inertia" then
		local v2 = math.exp(v * -4)
		self.angle += self.velocity * (1 - v2) / 4
		self.velocity *= v2

		if math.abs(self.velocity) < 6 then
			self.velocity = 0
			self.mode = "idle"
		end
	elseif self.mode == "spring" then
		while v > 1e-6 do
			local v2 = math.min(v, 1 / 240)
			local v3 = -90 * (self.angle - self._target) - 18.973665961010276 * self.velocity
			self.velocity += v3 * v2
			self.angle += self.velocity * v2
			v -= v2
		end

		if math.abs(self.angle - self._target) < 0.05 and math.abs(self.velocity) < 0.5 then
			self.angle = self._target
			self.velocity = 0
			self.mode = "idle"
		end
	elseif self.mode == "tween" then
		local tween = self._tween
		tween.elapsed += v
		local v2 = math.clamp(tween.elapsed / tween.duration, 0, 1)
		local angle2 = self.angle
		self.angle = tween.from + (tween.to - tween.from) * TweenService:GetValue(
			v2,
			Enum.EasingStyle.Cubic,
			Enum.EasingDirection.InOut
		)
		self.velocity = not (v > 0) and 0 or (self.angle - angle2) / v

		if v2 >= 1 then
			self.angle = tween.to
			self.velocity = 0
			self.mode = "idle"
			self._tween = nil
		end
	end

	return self.angle ~= angle
end

function AvatarSpinPhysics.isSettled(p): boolean
	return not p.isDragging and p.mode == "idle"
end

return AvatarSpinPhysics
