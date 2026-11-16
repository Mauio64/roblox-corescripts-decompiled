local AggregatedData = {}
AggregatedData.__index = AggregatedData
function AggregatedData.new()
	local v = {}
	setmetatable(v, AggregatedData)
	return v
end

local function isRbxAssetId(value: string) -- 1 equivalent call inferred from this helper
	return value:find("rbxassetid://")
end

function AggregatedData:addPlay(value: string, playtime: number, loopcount: number)
	if not isRbxAssetId(value) then -- inferred equivalent call
		return
	end

	local v = value:sub(14)

	if self[v] == nil then
		self[v] = { playtime = playtime, loopcount = loopcount }
		return
	end

	self[v].playtime += playtime
	self[v].loopcount += loopcount
end

return AggregatedData
