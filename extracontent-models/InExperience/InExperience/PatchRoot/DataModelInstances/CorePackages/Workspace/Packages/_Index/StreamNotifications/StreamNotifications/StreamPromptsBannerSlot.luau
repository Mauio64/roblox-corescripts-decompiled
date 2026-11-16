local function EmptyBanner(): nil
	return nil
end

local v = EmptyBanner
local StreamPromptsBannerSlot = {}

function StreamPromptsBannerSlot.set(p)
	v = p or EmptyBanner
end
function StreamPromptsBannerSlot.get()
	return v
end

return StreamPromptsBannerSlot
