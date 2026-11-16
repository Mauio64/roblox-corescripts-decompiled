local GuiService = game:GetService("GuiService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization")
local Loggers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Loggers")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/LoggingProtocol")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/ReactFocusNavigation")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServiceTags")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactUtils")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppHooks")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/RobloxAppToastsRodux")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags")
local UserSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UserSignals")

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local useLocalization = Localization.Hooks.useLocalization
local mutedError = Loggers.mutedError
local default = LoggingProtocol.default
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local roactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = RobloxAppHooks.useRoactService
local setNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local postSendUserSignal = UserSignals.PostSendUserSignal
local userSignalTypes = UserSignals.UserSignalTypes

local NotInterestedUserSignalTelemetryEventConfigs = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/NotInterestedUserSignalTelemetryEventConfigs")
local undoGameNotInterested = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/undoGameNotInterested")
local fFlagLuaAppExtractNotInterestedHelper = SharedFlags.FFlagLuaAppExtractNotInterestedHelper

local function HiddenTileContent(props)
	local v5 = useDispatch()
	local ref = React.useRef(nil)
	local v6 = useTokens()
	local v7 = useFocusGuiObject()
	local v8 = useRoactService(roactNetworking)
	local v9 = useLocalization({
		undoLabel = "Feature.GameDetails.Action.Undo",
		hiddenTileMessage = "Feature.GameDetails.Message.SuggestLessOften"
	})

	local v10 = React.useCallback(function()
		if fFlagLuaAppExtractNotInterestedHelper then
			local function onOptimisticUnhide()
				if GuiService.SelectedCoreObject == ref.current then
					task.delay(0, function()
						if props.parentRef then
							v7(props.parentRef.current)
						end
					end)
				end
			end

			undoGameNotInterested({
				appPage = props.appPage,
				collectionId = props.collectionId,
				dispatch = v5,
				isSponsored = props.isSponsored,
				networking = v8,
				onOptimisticUnhide = onOptimisticUnhide,
				setGameHidden = props.setGameHidden,
				universeId = props.universeId
			})
		elseif props.appPage then
			props.setGameHidden(props.universeId, false)

			if GuiService.SelectedCoreObject == ref.current then
				task.delay(0, function()
					if props.parentRef then
						v7(props.parentRef.current)
					end
				end)
			end

			local success, result = pcall(function()
				local v14 = { id = props.universeId, assetType = 0, signalOrigin = 0 }
				local v15 = if props.isSponsored then userSignalTypes.AssetType.SponsoredGame else userSignalTypes.AssetType.Game
				v14.assetType = v15

				v14.signalOrigin = {
					productSurface = props.appPage,
					topicId = props.collectionId or "",
					subIds = { props.collectionId or "" }
				}
				postSendUserSignal(
					v8,
					{ boolValue = false },
					v14,
					userSignalTypes.SignalValueType.Bool,
					userSignalTypes.SignalType.NotInterested
				):catch(function(p2)
					props.setGameHidden(props.universeId, true)
					v5(setNetworkingErrorToast(p2))
					default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
				end)
			end)

			if not success then
				props.setGameHidden(props.universeId, true)
				mutedError(result)
			end
		else
			default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)

			v5(setNetworkingErrorToast())
		end
	end, {
		v8,
		v7,
		props.setGameHidden,
		props.universeId,
		props.collectionId,
		props.appPage,
		props.parentRef,
		v5,
		props.isSponsored
	})

	return React.createElement(
		view,
		{
			tag = "size-full gap-small col align-x-center align-y-center bg-surface-100 radius-medium padding-medium"
		},
		{
			Message = React.createElement(text, {
				AutomaticSize = Enum.AutomaticSize.Y,
				fontStyle = v6.Typography.BodySmall,
				LayoutOrder = 1,
				Size = UDim2.fromScale(1, 0),
				Text = v9.hiddenTileMessage,
				textStyle = v6.Color.Content.Default,
				TextWrapped = true
			}),
			UndoButton = React.createElement(button, {
				LayoutOrder = 2,
				onActivated = v10,
				size = inputSize.XSmall,
				text = v9.undoLabel,
				variant = buttonVariant.Standard,
				ref = ref,
				testId = `--game-tile-hidden-undo-{props.universeId}`
			})
		}
	)
end

return React.memo(HiddenTileContent)
