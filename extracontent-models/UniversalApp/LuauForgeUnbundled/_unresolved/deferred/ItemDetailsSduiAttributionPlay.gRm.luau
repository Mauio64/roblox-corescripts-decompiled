local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/React")

local module2 = require("@luauforge/deferred/gRn")
require("@luauforge/bundled/dTH")

local function ItemDetailsSduiAttributionPlay(data): nil
	local v5 = module2(data.universeId, data.itemId, data.itemType, data.itemSubType)

	React.useImperativeHandle(data.attributionPlayRef, function()
		return v5
	end, { v5 })

	return nil
end

return ItemDetailsSduiAttributionPlay
