local GuiService = game:GetService("GuiService")

local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local Loggers = require(parent.Loggers)
local LoggingProtocol = require(parent.LoggingProtocol)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RobloxAppToastsRodux = require(parent.RobloxAppToastsRodux)
local SharedFlags = require(parent.SharedFlags)
local UserSignals = require(parent.UserSignals)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local useLocalization = Localization.Hooks.useLocalization
local mutedError = Loggers.mutedError
local default = LoggingProtocol.default
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local RoactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = RobloxAppHooks.useRoactService
local SetNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local PostSendUserSignal = UserSignals.PostSendUserSignal
local UserSignalTypes = UserSignals.UserSignalTypes

local NotInterestedUserSignalTelemetryEventConfigs = require(GameTile.NotInterestedUserSignalTelemetryEventConfigs)
local undoGameNotInterested = require(GameTile.undoGameNotInterested)
local FFlagLuaAppExtractNotInterestedHelper = SharedFlags.FFlagLuaAppExtractNotInterestedHelper

local function HiddenTileContent(props)
	local dispatch = useDispatch()
	local ref = React.useRef(nil)
	local v = useTokens()
	local v2 = useFocusGuiObject()
	local networking = useRoactService(RoactNetworking)
	local v3 = useLocalization({
		undoLabel = "Feature.GameDetails.Action.Undo",
		hiddenTileMessage = "Feature.GameDetails.Message.SuggestLessOften"
	})

	local onActivated = React.useCallback(function()
		if FFlagLuaAppExtractNotInterestedHelper then
			local function onOptimisticUnhide()
				if GuiService.SelectedCoreObject == ref.current then
					task.delay(0, function()
						if props.parentRef then
							v2(props.parentRef.current)
						end
					end)
				end
			end

			undoGameNotInterested({
				appPage = props.appPage,
				collectionId = props.collectionId,
				dispatch = dispatch,
				isSponsored = props.isSponsored,
				networking = networking,
				onOptimisticUnhide = onOptimisticUnhide,
				setGameHidden = props.setGameHidden,
				universeId = props.universeId
			})
		elseif props.appPage then
			props.setGameHidden(props.universeId, false)

			if GuiService.SelectedCoreObject == ref.current then
				task.delay(0, function()
					if props.parentRef then
						v2(props.parentRef.current)
					end
				end)
			end

			local success, result = pcall(function()
				local v4 = { id = props.universeId, assetType = 0, signalOrigin = 0 }
				local assetType

				if props.isSponsored then
					assetType = UserSignalTypes.AssetType.SponsoredGame
				else
					assetType = UserSignalTypes.AssetType.Game
				end

				v4.assetType = assetType

				v4.signalOrigin = {
					productSurface = props.appPage,
					topicId = props.collectionId or "",
					subIds = { props.collectionId or "" }
				}
				PostSendUserSignal(
					networking,
					{ boolValue = false },
					v4,
					UserSignalTypes.SignalValueType.Bool,
					UserSignalTypes.SignalType.NotInterested
				):catch(function(p)
					props.setGameHidden(props.universeId, true)
					dispatch(SetNetworkingErrorToast(p))
					default:logRobloxTelemetryCounter(
						NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed,
						1
					)
				end)
			end)

			if not success then
				props.setGameHidden(props.universeId, true)
				mutedError(result)
			end
		else
			default:logRobloxTelemetryCounter(
				NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage,
				1
			)

			dispatch(SetNetworkingErrorToast())
		end
	end, {
		networking,
		v2,
		props.setGameHidden,
		props.universeId,
		props.collectionId,
		props.appPage,
		props.parentRef,
		dispatch,
		props.isSponsored
	})

	return React.createElement(
		View,
		{
			tag = "size-full gap-small col align-x-center align-y-center bg-surface-100 radius-medium padding-medium"
		},
		{
			Message = React.createElement(Text, {
				AutomaticSize = Enum.AutomaticSize.Y,
				fontStyle = v.Typography.BodySmall,
				LayoutOrder = 1,
				Size = UDim2.fromScale(1, 0),
				Text = v3.hiddenTileMessage,
				textStyle = v.Color.Content.Default,
				TextWrapped = true
			}),
			UndoButton = React.createElement(Button, {
				LayoutOrder = 2,
				onActivated = onActivated,
				size = InputSize.XSmall,
				text = v3.undoLabel,
				variant = ButtonVariant.Standard,
				ref = ref,
				testId = `--game-tile-hidden-undo-{props.universeId}`
			})
		}
	)
end

return React.memo(HiddenTileContent)
