local frozen = table.freeze({
	wave = table.freeze({ r6 = 128777973, r15 = 507770239 }),
	point = table.freeze({ r6 = 128853357, r15 = 507770453 }),
	dance = table.freeze({ r6 = 182435998, r15 = 507771019 }),
	dance2 = table.freeze({ r6 = 182436842, r15 = 507776043 }),
	dance3 = table.freeze({ r6 = 182436935, r15 = 507777268 }),
	laugh = table.freeze({ r6 = 129423131, r15 = 507770818 }),
	cheer = table.freeze({ r6 = 129423030, r15 = 507770677 })
})

local set = {}

for k in frozen do
	set[k] = true
end

table.freeze(set)
local Emotes = {}

function Emotes.resolve(p: string, p2)
	local v = frozen[p]
	return if p2 == Enum.HumanoidRigType.R6 then v.r6 else v.r15
end

function Emotes.isName(value): boolean
	return typeof(value) == "string" and set[value] == true
end

return Emotes
