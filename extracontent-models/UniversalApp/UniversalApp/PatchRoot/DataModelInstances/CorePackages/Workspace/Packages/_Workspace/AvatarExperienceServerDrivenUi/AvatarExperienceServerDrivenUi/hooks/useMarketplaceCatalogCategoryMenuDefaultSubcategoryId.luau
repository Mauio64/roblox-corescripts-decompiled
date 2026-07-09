local Parent = script:FindFirstAncestor("AvatarExperienceServerDrivenUi").Parent
local React = require(Parent.React)
local DataHydration = require(Parent.DataHydration)
local SharedFlags = require(Parent.SharedFlags)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local FFlagSduiMarketplaceCatalogCategorySupport = SharedFlags.FFlagSduiMarketplaceCatalogCategorySupport

local function useMarketplaceCatalogCategoryMenuDefaultSubcategoryId(s1: string?) -- line: 20
	-- upvalues: React (copy), FFlagSduiMarketplaceCatalogCategorySupport (copy), Signals (copy), DataHydration (copy), SignalsReact (copy)
	local v10 = s1 or ""
	local v11 = React.useMemo(function() -- line: 23
		-- upvalues: FFlagSduiMarketplaceCatalogCategorySupport (copy), v10 (copy), Signals (copy), DataHydration (copy)
		if not FFlagSduiMarketplaceCatalogCategorySupport or v10 == "" then
			return Signals.createComputed(function() -- line: 25
				return nil
			end)
		end

		local v12 = DataHydration.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false)

		return Signals.createComputed(function(p1) -- line: 32
			-- upvalues: v12 (copy), v10 (copy), DataHydration (copy)
			local v14 = v12.getMarketplaceCatalogCategory(v10)

			if v14.status(p1) ~= DataHydration.DataStatus.Ready then
				return nil
			end

			local v15 = v14.data(p1)

			if not v15 then
				return nil
			end

			return v15.defaultSubcategoryId
		end)
	end, { v10 })

	return SignalsReact.useSignalState(v11)
end

return useMarketplaceCatalogCategoryMenuDefaultSubcategoryId
