local parent = script:FindFirstAncestor("BuildExperience").Parent

local GamePermissions = require(parent.DataHydration.GamePermissions)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

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

	local v = React.useMemo(function()
		return Signals.createComputed(function(p)
			if isNewGame or universeId == nil or universeId == 0 then
				return frozen3
			end

			local fetchUniversePermissions = gamePermissionsStore.getAndFetchUniversePermissions(universeId)
			local data2 = fetchUniversePermissions.data(p)

			if data2 ~= nil then
				return { permissions = data2, isLoading = false }
			end

			if fetchUniversePermissions.status(p) == "Failed" then
				return frozen4
			end

			return frozen5
		end)
	end, { gamePermissionsStore, universeId, isNewGame })

	local v2 = SignalsReact.useSignalState(v)
	return v2.permissions, v2.isLoading
end

return useGamePermissions
