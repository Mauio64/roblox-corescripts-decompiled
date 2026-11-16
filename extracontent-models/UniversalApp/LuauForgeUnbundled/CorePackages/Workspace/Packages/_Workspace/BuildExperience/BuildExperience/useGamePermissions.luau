local GamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/GamePermissions")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local frozen = table.freeze({
	canEdit = true,
	canEditOnBuild = true,
	canPublish = true,
	canMonetize = true,
	canViewAnalytics = true,
	canPreview = true,
	canAdvertise = true,
	canViewOnCreatorHub = true
})

local frozen2 = table.freeze({
	canEdit = false,
	canEditOnBuild = false,
	canPublish = false,
	canMonetize = false,
	canViewAnalytics = false,
	canPreview = true,
	canAdvertise = false,
	canViewOnCreatorHub = true
})

local frozen3 = table.freeze({ permissions = frozen, isLoading = false })
local frozen4 = table.freeze({ permissions = frozen2, isLoading = false })
local frozen5 = table.freeze({ permissions = frozen2, isLoading = true })

local function useGamePermissions(data)
	local gamePermissionsStore = data.gamePermissionsStore or GamePermissions.getGamePermissionsStore()
	local universeId = data.universeId
	local isNewGame = data.isNewGame == true

	local v5 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			if isNewGame or universeId == nil or universeId == 0 then
				return frozen3
			end

			local fetchUniversePermissions = gamePermissionsStore.getAndFetchUniversePermissions(universeId)
			local data2 = fetchUniversePermissions.data(p2)

			if data2 ~= nil then
				return { permissions = data2, isLoading = false }
			end

			if fetchUniversePermissions.status(p2) == "Failed" then
				return frozen4
			end

			return frozen5
		end)
	end, { gamePermissionsStore, universeId, isNewGame })

	local v6 = SignalsReact.useSignalState(v5)
	return v6.permissions, v6.isLoading
end

return useGamePermissions
