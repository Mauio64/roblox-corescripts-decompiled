local module = require("@luauforge/deferred/gNV")
local module2 = require("@luauforge/deferred/gNX")
require("@luauforge/deferred/gNI")

local module3 = require("@luauforge/deferred/gNU")
local module4 = require("@luauforge/deferred/gOc")
require("@luauforge/deferred/gND")

local function useFolderSettingsActions()
	local v5 = module3.useFoldersStore()

	local v6 = module2.useSignalState(v5.getSelectedFolder)
	local v7 = module2.useSignalState(v5.getFolders)

	local v8 = module.useMemo(function()
		return module4(v7)
	end, { v7 })

	local name = if v6 then v6.name else nil

	local v9 = module.useCallback(function(p2): boolean
		return p2 ~= name and v8[p2] == true
	end, { v8, name })

	return module.useMemo(function()
		if v6 == nil then
			return nil
		end

		local id = v6.id
		return {
			folderId = id,
			folderName = v6.name,
			checkIsDuplicateFolderName = v9,
			renameFolder = function(p2)
				return v5.renameFolder(id, p2)
			end,
			deleteFolder = function()
				return v5.deleteFolder(id)
			end
		}
	end, { v5, v6, v9 })
end

return useFolderSettingsActions
