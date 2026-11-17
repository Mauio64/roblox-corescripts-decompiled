local frozen = table.freeze({
	jumpDistance = 1e999,
	frequency = 2.5,
	approachDistance = 1,
	landingDistance = 1
})

local v = {}
v.defaults = frozen

function v.isAtRest(p: number, p2: number, p3: number): boolean
	return math.abs(p2 - p) < 0.5 and math.abs(p3) < 10
end

local function isFar(jumpDistance: number, p: number, p2: number): boolean -- 2 equivalent calls inferred from this helper
	local v2 = math.abs(p)
	return jumpDistance * p2 < v2
end

local function assertPositive(value: number?, p: string, p2: string, flag: boolean?)
	local v2

	if value == nil then
		v2 = true
	elseif type(value) == "number" and value > 0 then
		v2 = flag or value < 1e999
	else
		v2 = false
	end

	assert(v2, `{p2}: {p} must be a positive number`)
end

local function assertNonNegative(value: number?, p: string, p2: string) -- 2 equivalent calls inferred from this helper
	local v2

	if value == nil then
		v2 = true
	elseif type(value) == "number" and value >= 0 then
		v2 = value < 1e999
	else
		v2 = false
	end

	assert(v2, `{p2}: {p} must be a finite non-negative number`)
end

function v.validate(data, p: string)
	if data == nil then
		return
	end

	local jumpDistance = data.jumpDistance
	assert(
		jumpDistance == nil or type(jumpDistance) == "number" and jumpDistance > 0,
		`{p}: jumpDistance must be a positive number`
	)

	local frequency = data.frequency
	local v2

	if frequency == nil then
		v2 = true
	elseif type(frequency) == "number" and frequency > 0 then
		v2 = frequency < 1e999
	else
		v2 = false
	end

	assert(v2, `{p}: frequency must be a positive number`)

	local cruiseSpeed = data.cruiseSpeed
	local v3

	if cruiseSpeed == nil then
		v3 = true
	elseif type(cruiseSpeed) == "number" and cruiseSpeed > 0 then
		v3 = cruiseSpeed < 1e999
	else
		v3 = false
	end

	assert(v3, `{p}: cruiseSpeed must be a positive number`)

	assertNonNegative(data.approachDistance, "approachDistance", p) -- inferred equivalent call
	assertNonNegative(data.landingDistance, "landingDistance", p) -- inferred equivalent call
end

function v.resolve(options, options2)
	local v2 = options or {}
	local v3 = options2 or {}
	local frequency = v2.frequency or v3.frequency or 2.5
	return (table.freeze({
		jumpDistance = v2.jumpDistance or v3.jumpDistance or frozen.jumpDistance,
		frequency = frequency,
		approachDistance = v2.approachDistance or v3.approachDistance or frozen.approachDistance,
		cruiseSpeed = v2.cruiseSpeed or v3.cruiseSpeed or 6.283185307179586 * frequency,
		landingDistance = v2.landingDistance or v3.landingDistance or frozen.landingDistance
	}))
end

function v.start(p: number, p2: number, p3: number, velocity: number, profile)
	return {
		phase = isFar(profile.jumpDistance, p2 - p, p3) and "approach" or "land", -- inferred equivalent call
		velocity = velocity,
		approached = 0,
		profile = profile,
		angularFrequency = 6.283185307179586 * profile.frequency
	}
end

local function land(state, p: number, p2: number, p3: number) -- 1 equivalent call inferred from this helper
	local angularFrequency = state.angularFrequency
	local v2 = p - p2
	local velocity = state.velocity
	local v3 = velocity + angularFrequency * v2
	local v4 = math.exp(-angularFrequency * p3)
	state.velocity = (velocity - angularFrequency * v3 * p3) * v4
	return p2 + (v2 + v3 * p3) * v4
end

local function approach(state, p: number, p2: number, p3: number, p4: number) -- 1 equivalent call inferred from this helper
	local angularFrequency = state.angularFrequency
	local v2 = p2 * state.profile.cruiseSpeed * p3
	local velocity = state.velocity
	local v3 = math.exp(angularFrequency * -2 * p4)
	state.velocity = v2 + (velocity - v2) * v3
	local v4 = v2 * p4 + (velocity - v2) * (1 - v3) / (angularFrequency * 2)
	state.approached += math.abs(v4)
	return p + v4
end

function v:step(p: number, p2: number, p3: number, p4: number)
	local v2 = p4 >= 0 and p4 < 1e999
	assert(v2, "ScrollMotion: dt must be a finite non-negative number")
	local v3 = p2 - p
	local profile = self.profile

	if self.phase == "approach" then
		if isFar(profile.jumpDistance, v3, p3) then -- inferred equivalent call
			if self.approached >= profile.approachDistance * p3 then
				p = p2 - math.sign(v3) * math.min(
					math.abs(v3),
					(math.max(profile.landingDistance * p3, math.abs(self.velocity) / self.angularFrequency))
				)
				self.phase = "land"
			else
				return approach(self, p, math.sign(v3), p3, p4), false -- inferred equivalent call
			end
		else
			self.phase = "land"
		end
	end

	local v4 = land(self, p, p2, p4) -- inferred equivalent call

	if not v.isAtRest(v4, p2, self.velocity) then
		return v4, false
	end

	self.velocity = 0
	return p2, true
end

return table.freeze(v)
