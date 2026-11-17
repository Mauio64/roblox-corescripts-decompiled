local GuiService = game:GetService("GuiService")

local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppHooks = require(parent.RobloxAppHooks)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local useLocalization = Localization.Hooks.useLocalization
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local RoactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = RobloxAppHooks.useRoactService

local undoGameNotInterested = require(GameTile.undoGameNotInterested)

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
