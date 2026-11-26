local engineFeature = game:GetEngineFeature("AXMarketplaceHeadTooltipKeys")
local v5 = game:GetService("AppStorageService")

local defineFastInt = game:DefineFastInt("AXHeadCategoryCombineTooltipExpirationDurationDays", 7)

local function getMockAppStorageService()
	return {
		storage = {},
		GetItem = function(self, p3)
			return self.storage[p3]
		end,
		SetItem = function(self, p3, p4)
			self.storage[p3] = p4
		end,
		Flush = function(self) end
	}
end

if not engineFeature then
	v5 = getMockAppStorageService()
end

local function getStoredState()
	local item = nil
	pcall(function()
		item = v5:GetItem("AXMarketplaceCombinedHeadCategoriesTooltipSeenTimestamp") or nil
	end)
	return item
end

local v6 = {
	__mockAppStorageService = function(p2)
		v5 = p2 or getMockAppStorageService()
	end,
	getSeenTimestamp = function()
		local item = nil
		pcall(function()
			item = v5:GetItem("AXMarketplaceCombinedHeadCategoriesTooltipSeenTimestamp") or nil
		end)
		local v7 = item

		if v7 then
			return (tonumber(v7))
		end

		return nil
	end,
	setSeenTimestamp = function()
		pcall(function()
			v5:SetItem("AXMarketplaceCombinedHeadCategoriesTooltipSeenTimestamp", (tostring(os.time())))
			v5:Flush()
		end)
	end
}

function v6.shouldShowTooltip(): boolean
	local seenTimestamp = v6.getSeenTimestamp()

	if not seenTimestamp then
		return true
	end

	local v7 = os.difftime(os.time(), seenTimestamp)
	return defineFastInt * 86400 <= v7
end

return v6
