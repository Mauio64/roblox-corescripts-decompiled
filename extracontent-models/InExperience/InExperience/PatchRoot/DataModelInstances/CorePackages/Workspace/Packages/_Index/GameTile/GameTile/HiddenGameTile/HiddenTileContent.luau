local GuiService = game:GetService("GuiService")
local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local Foundation = require(GameTileParent.Foundation)
local Localization = require(GameTileParent.Localization)
local Loggers = require(GameTileParent.Loggers)
local LoggingProtocol = require(GameTileParent.LoggingProtocol)
local React = require(GameTileParent.React)
local ReactFocusNavigation = require(GameTileParent.ReactFocusNavigation)
local RoactServiceTags = require(GameTileParent.RoactServiceTags)
local RoactUtils = require(GameTileParent.RoactUtils)
local RobloxAppHooks = require(GameTileParent.RobloxAppHooks)
local RobloxAppToastsRodux = require(GameTileParent.RobloxAppToastsRodux)
local SharedFlags = require(GameTileParent.SharedFlags)
local UserSignals = require(GameTileParent.UserSignals)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
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
local FFlagLuaAppEnableSponsoredReportAd = SharedFlags.FFlagLuaAppEnableSponsoredReportAd

local function HiddenTileContent(t1: {[any]: any}) -- line: 49
	-- upvalues: useDispatch (copy), React (copy), useTokens (copy), useFocusGuiObject (copy), useRoactService (copy), RoactNetworking (copy), useLocalization (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), SetNetworkingErrorToast (copy), GuiService (copy), PostSendUserSignal (copy), UserSignalTypes (copy), mutedError (copy), View (copy), FFlagLuaAppEnableSponsoredReportAd (copy), FoundationText (copy), Button (copy), InputSize (copy), ButtonVariant (copy)
	local v36 = useDispatch()
	local v37 = React.useRef(nil)
	local v38 = useTokens()
	local v39 = useFocusGuiObject()
	local v40 = useRoactService(RoactNetworking)
	local v41 = useLocalization({
		undoLabel = "Feature.GameDetails.Action.Undo",
		hiddenTileMessage = "Feature.GameDetails.Message.SuggestLessOften"
	})
	local v42 = React.useCallback(function() -- line: 61
		-- upvalues: t1 (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), v36 (copy), SetNetworkingErrorToast (copy), GuiService (copy), v37 (copy), v39 (copy), PostSendUserSignal (copy), v40 (copy), UserSignalTypes (copy), mutedError (copy)
		if not t1.appPage then
			default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)
			v36(SetNetworkingErrorToast())

			return
		end

		t1.setGameHidden(t1.universeId, false)

		if GuiService.SelectedCoreObject == v37.current then
			task.delay(0, function() -- line: 74
				-- upvalues: t1 (copy), v39 (copy)
				if t1.parentRef then
					v39(t1.parentRef.current)
				end
			end)
		end

		local ok, result = pcall(function() -- line: 81
			-- upvalues: PostSendUserSignal (copy), v40 (copy), t1 (copy), UserSignalTypes (copy), v36 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
			PostSendUserSignal(v40, {
				boolValue = false
			}, {
				id = t1.universeId,
				assetType = if not t1.isSponsored then UserSignalTypes.AssetType.Game else UserSignalTypes.AssetType.SponsoredGame,
				signalOrigin = {
					productSurface = t1.appPage,
					topicId = t1.collectionId or "",
					subIds = { t1.collectionId or "" }
				}
			}, UserSignalTypes.SignalValueType.Bool, UserSignalTypes.SignalType.NotInterested):catch(function(p1) -- line: 95
				-- upvalues: t1 (copy), v36 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
				t1.setGameHidden(t1.universeId, true)
				v36(SetNetworkingErrorToast(p1))
				default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
			end)
		end)

		if not ok then
			t1.setGameHidden(t1.universeId, true)
			mutedError(result)
		end
	end, {
		v40,
		v39,
		t1.setGameHidden,
		t1.universeId,
		t1.collectionId,
		t1.appPage,
		t1.parentRef,
		v36,
		t1.isSponsored
	})

	return React.createElement(View, {
		tag = not FFlagLuaAppEnableSponsoredReportAd and "size-full gap-small col align-x-center align-y-center bg-surface-100 radius-medium" or "size-full gap-small col align-x-center align-y-center bg-surface-100 radius-medium padding-medium"
	}, {
		Message = React.createElement(FoundationText, {
			LayoutOrder = 1,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			fontStyle = v38.Typography.BodySmall,
			Size = UDim2.fromScale(1, 0),
			Text = v41.hiddenTileMessage,
			textStyle = v38.Color.Content.Default
		}),
		UndoButton = React.createElement(Button, {
			LayoutOrder = 2,
			onActivated = v42,
			size = InputSize.XSmall,
			text = v41.undoLabel,
			variant = ButtonVariant.Standard,
			ref = v37
		})
	})
end

return React.memo(HiddenTileContent)
