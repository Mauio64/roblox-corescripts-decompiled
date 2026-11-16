local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local createItemSelectionStore = require(AvatarExperienceInspectAndBuy.Stores.createItemSelectionStore)

local context = React.createContext(nil)

local function ItemSelectionStoreProvider(p)
	local v = React.useMemo(function()
		return createItemSelectionStore()
	end, {})

	return React.createElement(context.Provider, { value = v }, p.children)
end

return {
	Provider = ItemSelectionStoreProvider,
	useItemSelectionStore = function()
		local v = React.useContext(context)

		if not v then
			error("useItemSelectionStore must be used within an ItemSelectionStoreProvider")
		end

		return v
	end
}
