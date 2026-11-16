local parent = script.Parent
local AspectRatioMode = require(parent.Enum.AspectRatioMode)

local v = { [AspectRatioMode.Wide] = 0.5625, [AspectRatioMode.Square] = 1 }

local function getAspectRatio(p)
	local aspectRatio = v[p]

	if not aspectRatio then
		error("Unkown aspect ratio " .. tostring(p))
	end

	return aspectRatio
end

return getAspectRatio
