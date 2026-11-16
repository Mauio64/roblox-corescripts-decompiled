local Loggers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Loggers")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/LoggingProtocol")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/RobloxAppToastsRodux")
local UserSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UserSignals")

local default = LoggingProtocol.default
local postSendUserSignal = UserSignals.PostSendUserSignal
local setNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local userSignalTypes = UserSignals.UserSignalTypes
local mutedError = Loggers.mutedError

local NotInterestedUserSignalTelemetryEventConfigs = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/NotInterestedUserSignalTelemetryEventConfigs")

local function undoGameNotInterested(data): boolean
	if data.appPage then
		data.setGameHidden(data.universeId, false)

		if data.onOptimisticUnhide then
			data.onOptimisticUnhide()
		end

		local success, result = pcall(function()
			local networking = data.networking

			local v7 = { id = data.universeId, assetType = 0, signalOrigin = 0 }
			local v8 = if data.isSponsored then userSignalTypes.AssetType.SponsoredGame else userSignalTypes.AssetType.Game
			v7.assetType = v8

			v7.signalOrigin = {
				productSurface = data.appPage,
				topicId = data.collectionId or "",
				subIds = { data.collectionId or "" }
			}
			postSendUserSignal(
				networking,
				{ boolValue = false },
				v7,
				userSignalTypes.SignalValueType.Bool,
				userSignalTypes.SignalType.NotInterested
			):catch(function(p2)
				data.setGameHidden(data.universeId, true)
				data.dispatch(setNetworkingErrorToast(p2))
				default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
			end)
		end)

		if not success then
			data.setGameHidden(data.universeId, true)
			mutedError(result)
		end

		return true
	end

	default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)

	data.dispatch(setNetworkingErrorToast())
	return false
end

return undoGameNotInterested
