local scriptParent = script.Parent
local AspectRatioMode = require(scriptParent.Enum.AspectRatioMode)
local t1 = {
	[AspectRatioMode.Wide] = 0.5625,
	[AspectRatioMode.Square] = 1
}

local function getAspectRatio(p1) -- line: 14
	-- upvalues: t1 (copy)
	local v6 = t1[p1]

	if not v6 then
		error("Unkown aspect ratio " .. tostring(p1))
	end

	return v6
end

return getAspectRatio
