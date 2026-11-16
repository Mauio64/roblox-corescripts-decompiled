local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent

local Loggers = require(parent.Loggers)
local LoggingProtocol = require(parent.LoggingProtocol)
local RobloxAppToastsRodux = require(parent.RobloxAppToastsRodux)
local UserSignals = require(parent.UserSignals)

local default = LoggingProtocol.default
local PostSendUserSignal = UserSignals.PostSendUserSignal
local SetNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local UserSignalTypes = UserSignals.UserSignalTypes
local mutedError = Loggers.mutedError

local NotInterestedUserSignalTelemetryEventConfigs = require(GameTile.NotInterestedUserSignalTelemetryEventConfigs)

local function undoGameNotInterested(data): boolean
	if data.appPage then
		data.setGameHidden(data.universeId, false)

		if data.onOptimisticUnhide then
			data.onOptimisticUnhide()
		end

		local success, result = pcall(function()
			local networking = data.networking

			local v = { id = data.universeId, assetType = 0, signalOrigin = 0 }
			local assetType

			if data.isSponsored then
				assetType = UserSignalTypes.AssetType.SponsoredGame
			else
				assetType = UserSignalTypes.AssetType.Game
			end

			v.assetType = assetType

			v.signalOrigin = {
				productSurface = data.appPage,
				topicId = data.collectionId or "",
				subIds = { data.collectionId or "" }
			}
			PostSendUserSignal(
				networking,
				{ boolValue = false },
				v,
				UserSignalTypes.SignalValueType.Bool,
				UserSignalTypes.SignalType.NotInterested
			):catch(function(p)
				data.setGameHidden(data.universeId, true)
				data.dispatch(SetNetworkingErrorToast(p))
				default:logRobloxTelemetryCounter(
					NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed,
					1
				)
			end)
		end)

		if not success then
			data.setGameHidden(data.universeId, true)
			mutedError(result)
		end

		return true
	end

	default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)

	data.dispatch(SetNetworkingErrorToast())
	return false
end

return undoGameNotInterested
