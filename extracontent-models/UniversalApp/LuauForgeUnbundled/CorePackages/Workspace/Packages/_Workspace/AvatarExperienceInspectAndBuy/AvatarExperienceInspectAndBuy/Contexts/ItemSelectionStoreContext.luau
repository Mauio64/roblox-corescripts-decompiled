local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local createItemSelectionStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Stores/createItemSelectionStore")

local context = React.createContext(nil)

local function ItemSelectionStoreProvider(p2)
	local v5 = React.useMemo(function()
		return createItemSelectionStore()
	end, {})

	return React.createElement(context.Provider, { value = v5 }, p2.children)
end

return {
	Provider = ItemSelectionStoreProvider,
	useItemSelectionStore = function()
		local v5 = React.useContext(context)

		if not v5 then
			error("useItemSelectionStore must be used within an ItemSelectionStoreProvider")
		end

		return v5
	end
}
