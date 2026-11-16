local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

local parent = script.Parent.Parent.Parent
local ReactPageSignal = require(parent.ReactPageSignal)
local TraversalLeaveConfirmation = require(script.Parent.TraversalLeaveConfirmation)

local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local ThumbnailType = Foundation.Enums.ThumbnailType
local View = Foundation.View

local Traversal = CoreScriptsRoactCommon.Traversal
local default = Traversal.LocalTraversalHistory.default
local GetInputModeStore = Responsive.GetInputModeStore
local Input = Responsive.Input
local Constants = Traversal.Constants
local HistoryPage = Traversal.HistoryPage
local useHistoryItems = Traversal.useHistoryItems
local FIntMaximumTraversalHistoryItemsFetch = Traversal.Flags.FIntMaximumTraversalHistoryItemsFetch
local FFlagTraversalExpPagePaddingFixes = Traversal.Flags.FFlagTraversalExpPagePaddingFixes
local FFlagIntegrateTraversalHistoryInSideSheet = SharedFlags.FFlagIntegrateTraversalHistoryInSideSheet

local function TraversalHistoryPage(_, p)
	local ref = React.useRef(nil)
	React.useImperativeHandle(p, function()
		return ref.current
	end, {})
	local state, setState = React.useState(FIntMaximumTraversalHistoryItemsFetch)
	local v = useHistoryItems(state)
	local state2, setState2 = React.useState(Constants.NO_UNIVERSE_ID)
	local v2 = SignalsReact.useSignalState(ReactPageSignal)
	React.useEffect(function()
		local lastInputType = UserInputService:GetLastInputType()
		local lastInputType2 = GetInputModeStore().getLastInputType()
		local v3

		if lastInputType2 == Input.Directional then
			v3 = true
		elseif lastInputType2 == Input.Pointer then
			v3 = lastInputType == Enum.UserInputType.Keyboard
		else
			v3 = false
		end

		if v3 and ref.current then
			GuiService.SelectedCoreObject = ref.current
		end
	end, {})

	local onCardItemActivated = React.useCallback(function(p2: number)
		setState2(p2)
	end, { setState2 })

	local v3 = React.useCallback(function()
		setState2(Constants.NO_UNIVERSE_ID)
		local lastInputType = UserInputService:GetLastInputType()
		local lastInputType2 = GetInputModeStore().getLastInputType()
		local v3

		if lastInputType2 == Input.Directional then
			v3 = true
		elseif lastInputType2 == Input.Pointer then
			v3 = lastInputType == Enum.UserInputType.Keyboard
		else
			v3 = false
		end

		if v3 and ref.current then
			GuiService.SelectedCoreObject = ref.current
		end
	end, {})

	local historyItems = React.useMemo(function()
		return (Cryo.List.map(v, function(data)
			return {
				placeId = data.placeId,
				universeId = data.universeId,
				name = data.name,
				image = getRbxThumb(ThumbnailType.GameIcon, data.universeId, ThumbnailSize.Medium),
				rating = data.rating
			}
		end))
	end, { v })

	local onLoadMoreHistory = React.useCallback(function(p2: number)
		if state >= #default:getUniverseHistory() then
			return
		end

		setState(state + p2)
	end, { state })

	if next(historyItems) == nil then
		return false
	end

	return (React.createElement(View, {
		tag = "size-full " .. (FFlagIntegrateTraversalHistoryInSideSheet and "" or FFlagTraversalExpPagePaddingFixes and "padding-top-medium" or "padding-large")
	}, {
		HistoryPage = React.createElement(HistoryPage, {
			historyItems = historyItems,
			onHistoryClose = function()
				v2.setCurrentReactPage(nil)
			end,
			onCardItemActivated = onCardItemActivated,
			onLoadMoreHistory = onLoadMoreHistory,
			ref = ref
		})
	}, {
		Dialog = React.createElement(TraversalLeaveConfirmation, {
			isDialogOpen = Constants.NO_UNIVERSE_ID < state2,
			onCancel = v3,
			onClose = v3,
			universeId = state2,
			source = "history_landing_page"
		})
	}))
end

return React.memo(React.forwardRef(TraversalHistoryPage))
