local t1 = {}

t1.__index = t1

function t1.new() -- line: 4
	-- upvalues: t1 (copy)
	local t2 = {}

	setmetatable(t2, t1)

	return t2
end

local function isRbxAssetId(s1: string) -- line: 10
	return s1:find("rbxassetid://")
end

function t1.addPlay(t3: {[any]: any}, s2: string, n1: number, n2: number) -- line: 14
	if not s2:find("rbxassetid://") then
		return
	end

	local v9 = s2:sub(14)

	if t3[v9] == nil then
		t3[v9] = {
			playtime = n1,
			loopcount = n2
		}

		return
	end

	local v10 = t3[v9]

	v10.playtime = v10.playtime + n1

	local v11 = t3[v9]

	v11.loopcount = v11.loopcount + n2
end

return t1
