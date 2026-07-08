local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local createItemSelectionStore = require(AvatarExperienceInspectAndBuy.Stores.createItemSelectionStore)
local v5 = React.createContext(nil)

local function ItemSelectionStoreProvider(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy), createItemSelectionStore (copy), v5 (copy)
	local v8 = React.useMemo(function() -- line: 22
		-- upvalues: createItemSelectionStore (copy)
		return createItemSelectionStore()
	end, {})

	return React.createElement(v5.Provider, {
		value = v8
	}, t1.children)
end

return {
	Provider = ItemSelectionStoreProvider,
	useItemSelectionStore = function() -- line: 29
		-- upvalues: React (copy), v5 (copy)
		local v9 = React.useContext(v5)

		if not v9 then
			error("useItemSelectionStore must be used within an ItemSelectionStoreProvider")
		end

		return v9
	end
}
