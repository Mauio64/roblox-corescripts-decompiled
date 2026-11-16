local module = require("@luauforge/deferred/gjp")
local module2 = require("@luauforge/deferred/gjr")

local useFoldersStore = require("@luauforge/deferred/gjo").useFoldersStore
local module3 = require("@luauforge/deferred/gjs")
local module4 = require("@luauforge/deferred/gjt")

local frozen = table.freeze({})

local function useFolderItemIdsFilter()
	local v5 = useFoldersStore()

	local v6 = module2.useSignalState(v5.getSelectedFolderId)
	local v7 = module2.useSignalState(v5.getSelectedFolder)

	return module.useMemo(function()
		local v8 = if v6 ~= nil then (if v7 == nil then frozen else module3(v7)) else nil

		return {
			itemIdsFilter = function(p2)
				return module4(p2, v8)
			end,
			selectedFolderId = v6
		}
	end, { v6, v7 })
end

return useFolderItemIdsFilter
