local GuiService = game:GetService("GuiService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/ReactFocusNavigation")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServiceTags")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactUtils")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppHooks")

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local useLocalization = Localization.Hooks.useLocalization
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local roactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = RobloxAppHooks.useRoactService

local undoGameNotInterested = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/undoGameNotInterested")

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
