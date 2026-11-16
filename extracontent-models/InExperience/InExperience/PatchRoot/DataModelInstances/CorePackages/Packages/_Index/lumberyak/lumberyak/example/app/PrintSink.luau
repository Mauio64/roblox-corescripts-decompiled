local Logger = require(script.Parent.Parent.Parent.Logger)

local PrintSink = {}

function PrintSink.new(maxLevel)
	local v = { maxLevel = maxLevel }

	setmetatable(v, PrintSink)
	return v
end

function PrintSink.log(_, message, p)
	if p.level == Logger.Levels.Error then
		error(message, 5)
	elseif p.level == Logger.Levels.Warning then
		warn(message)
	else
		print(message)
	end
end

return PrintSink
