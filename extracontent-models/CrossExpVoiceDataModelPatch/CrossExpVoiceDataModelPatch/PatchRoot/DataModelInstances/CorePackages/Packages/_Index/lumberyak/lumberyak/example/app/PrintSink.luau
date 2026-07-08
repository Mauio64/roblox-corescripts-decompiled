local Logger = require(script.Parent.Parent.Parent.Logger)
local t1 = {}

function t1.new(p1) -- line: 5
	-- upvalues: t1 (copy)
	local t2 = {
		maxLevel = p1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.log(_, p3, p4) -- line: 14
	-- upvalues: Logger (copy)
	if p4.level == Logger.Levels.Error then
		error(p3, 5)

		return
	end

	if p4.level == Logger.Levels.Warning then
		warn(p3)

		return
	end

	print(p3)
end

return t1
