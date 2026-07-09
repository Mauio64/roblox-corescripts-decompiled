local Parent = script:FindFirstAncestor("ExpChat").Parent
local createSignal = require(Parent.Signals).createSignal

local function findFirstChildByNameAndClass(p1, s1: string, s2: string) -- line: 20
	if not p1 then
		return nil
	end

	for _, child in ipairs(p1:GetChildren()) do
		if s1 == child.Name and child:IsA(s2) then
			return child
		end
	end

	return nil
end
local function createAdorneeStore() -- line: 32
	-- upvalues: createSignal (copy), findFirstChildByNameAndClass (copy)
	local t1 = {}

	local function getKey(p2) -- line: 37
		return (tostring(p2))
	end

	return {
		getAdornee = function(p3) -- line: 41
			-- upvalues: t1 (copy), createSignal (copy)
			local str = tostring(p3)

			if not t1[str] then
				local v15, v16 = createSignal(nil)

				t1[str] = {
					getter = v15,
					setter = v16
				}
			end

			return t1[str].getter
		end,
		handleAdorneeAdded = function(p4, p5, p6) -- line: 50
			-- upvalues: findFirstChildByNameAndClass (copy), t1 (copy), createSignal (copy)
			local str = tostring(p4)
			local v21 = findFirstChildByNameAndClass(p5, "Head", "BasePart")
			local v22 = if p6.Health ~= 0 then p5 else v21

			if not t1[str] then
				local str2 = tostring(p4)

				if not t1[str2] then
					local v24, v25 = createSignal(nil)

					t1[str2] = {
						getter = v24,
						setter = v25
					}
				end

				local _ = t1[str2].getter
			end

			t1[str].setter(v22)
		end,
		handleHumanoidDied = function(p7) -- line: 61
			-- upvalues: t1 (copy), findFirstChildByNameAndClass (copy)
			local str = tostring(p7)

			if t1[str] then
				local v29 = t1[str].getter(false)
				local v30 = if not v29 then nil else findFirstChildByNameAndClass(v29, "Head", "BasePart") or v29

				t1[str].setter(v30)
			end
		end,
		handlePlayerRemoved = function(p8) -- line: 77
			-- upvalues: t1 (copy)
			local str = tostring(p8)

			if t1[str] then
				t1[str].setter(nil)
			end

			t1[str] = nil
		end
	}
end

return createAdorneeStore
