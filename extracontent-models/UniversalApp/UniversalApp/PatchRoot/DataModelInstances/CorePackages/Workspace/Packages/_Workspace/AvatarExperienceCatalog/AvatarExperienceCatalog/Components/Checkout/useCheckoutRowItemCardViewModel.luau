local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local SharedFlags = require(AvatarExperienceCatalogParent.SharedFlags)

require(AvatarExperienceCatalog.Stores.createAXShoppingCartStore)

local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird

local function useCheckoutRowItemCardViewModel(p1) -- line: 15
	-- upvalues: React (copy), FFlagAXMISWithBlackbird (copy)
	local v8, v9 = React.useState(function() -- line: 16
		-- upvalues: p1 (copy)
		if p1.timedOptions then
			for _, v11 in p1.timedOptions do
				if v11.selected then
					return v11.price
				end
			end
		end

		return nil
	end)

	React.useEffect(function() -- line: 28
		-- upvalues: p1 (copy), v9 (copy), FFlagAXMISWithBlackbird (copy)
		if p1.selectedTimedOptionIndexInReducer ~= nil then
			local v12 = p1.timedOptions and p1.timedOptions[p1.selectedTimedOptionIndexInReducer]

			if v12 then
				v9(v12.price)

				return
			end
		elseif FFlagAXMISWithBlackbird and p1.timedOptions then
			for _, v14 in p1.timedOptions do
				if v14.selected then
					v9(v14.price)

					return
				end
			end
		end
	end, {
		p1.selectedTimedOptionIndexInReducer,
		if not FFlagAXMISWithBlackbird then nil else p1.timedOptions
	})

	return {
		selectedTimedOptionPrice = v8,
		setSelectedTimedOptionPrice = v9
	}
end

return useCheckoutRowItemCardViewModel
