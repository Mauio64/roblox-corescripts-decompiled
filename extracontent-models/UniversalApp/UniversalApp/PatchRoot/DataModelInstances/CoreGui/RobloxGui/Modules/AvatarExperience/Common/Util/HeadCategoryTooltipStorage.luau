local EngineFeature = game:GetEngineFeature("AXMarketplaceHeadTooltipKeys")
local AppStorageService = game:GetService("AppStorageService")
local v3 = game:DefineFastInt("AXHeadCategoryCombineTooltipExpirationDurationDays", 7)
local u4 = AppStorageService

local function getMockAppStorageService() -- line: 15
	return {
		storage = {},
		GetItem = function(p1, p2) -- line: 18
			return p1.storage[p2]
		end,
		SetItem = function(p3, p4, p5) -- line: 21
			p3.storage[p4] = p5
		end,
		Flush = function(_) -- line: 24
		end
	}
end

if not EngineFeature then
	u4 = getMockAppStorageService()
end

local function getStoredState() -- line: 37
	-- upvalues: u4 (ref)
	local u8 = nil

	pcall(function() -- line: 39
		-- upvalues: u8 (ref), u4 (ref)
		u8 = u4:GetItem("AXMarketplaceCombinedHeadCategoriesTooltipSeenTimestamp") or nil
	end)

	return u8
end

local t1 = {
	__mockAppStorageService = function(p7) -- line: 51
		-- upvalues: u4 (ref), getMockAppStorageService (copy)
		u4 = p7 or getMockAppStorageService()
	end,
	getSeenTimestamp = function() -- line: 55
		-- upvalues: u4 (ref)
		local u10 = nil

		pcall(function() -- line: 39
			-- upvalues: u10 (ref), u4 (ref)
			u10 = u4:GetItem("AXMarketplaceCombinedHeadCategoriesTooltipSeenTimestamp") or nil
		end)

		local v11 = u10

		if v11 then
			return (tonumber(v11))
		end

		return nil
	end,
	setSeenTimestamp = function() -- line: 60
		-- upvalues: u4 (ref)
		pcall(function() -- line: 61
			-- upvalues: u4 (ref)
			u4:SetItem("AXMarketplaceCombinedHeadCategoriesTooltipSeenTimestamp", (tostring(os.time())))
			u4:Flush()
		end)
	end
}

function t1.shouldShowTooltip() -- line: 67
	-- upvalues: t1 (copy), v3 (copy)
	local v12 = t1.getSeenTimestamp()

	if not v12 then
		return true
	end

	return os.difftime(os.time(), v12) >= v3 * 86400
end

return t1
