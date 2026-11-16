local UserInputService = game:GetService("UserInputService")

local v = {}

local function update() -- 2 equivalent calls inferred from this helper
	local v2 = v[#v]

	if v2 then
		UserInputService.OverrideMouseIconBehavior = v2[2]
	else
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
	end
end

local MouseIconOverrideService = {}

function MouseIconOverrideService.push(value: string, p)
	assert(type(value) == "userdata" or type(value) == "string", "key")
	assert(typeof(p) == "EnumItem", "behavior")
	assert(p.EnumType == Enum.OverrideMouseIconBehavior, "behavior.EnumType")

	for i, v2 in ipairs(v) do
		if v2[1] == value then
			table.remove(v, i)
			break
		end
	end

	table.insert(v, { value, p })
	update() -- inferred equivalent call
end
function MouseIconOverrideService.pop(value)
	assert(type(value) == "userdata" or type(value) == "string", "key")
	local v2 = nil

	for i, v3 in ipairs(v) do
		if v3[1] == value then
			v2 = i
			break
		end
	end

	if v2 then
		table.remove(v, v2)
	end

	update() -- inferred equivalent call
end

return MouseIconOverrideService
