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
local ParentParent = script.Parent.Parent.Parent
local ReactPageSignal = require(ParentParent.ReactPageSignal)
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
local FFlagFixTraversalHistoryMenuFixesV3 = Traversal.Flags.FFlagFixTraversalHistoryMenuFixesV3
local FFlagIntegrateTraversalHistoryInSideSheet = SharedFlags.FFlagIntegrateTraversalHistoryInSideSheet

local function TraversalHistoryPage(_: {[any]: any}, p1) -- line: 37
	-- upvalues: React (copy), FIntMaximumTraversalHistoryItemsFetch (copy), useHistoryItems (copy), Constants (copy), SignalsReact (copy), ReactPageSignal (copy), FFlagFixTraversalHistoryMenuFixesV3 (copy), UserInputService (copy), GetInputModeStore (copy), Input (copy), GuiService (copy), Cryo (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy), default (copy), View (copy), FFlagIntegrateTraversalHistoryInSideSheet (copy), FFlagTraversalExpPagePaddingFixes (copy), HistoryPage (copy), TraversalLeaveConfirmation (copy)
	local v32 = React.useRef(nil)

	React.useImperativeHandle(p1, function() -- line: 39
		-- upvalues: v32 (copy)
		return v32.current
	end, {})

	local v33, v34 = React.useState(FIntMaximumTraversalHistoryItemsFetch)
	local v35 = useHistoryItems(v33)
	local v36, v37 = React.useState(Constants.NO_UNIVERSE_ID)
	local v38 = SignalsReact.useSignalState(ReactPageSignal)

	if FFlagFixTraversalHistoryMenuFixesV3 then
		React.useEffect(function() -- line: 48
			-- upvalues: UserInputService (copy), GetInputModeStore (copy), Input (copy), v32 (copy), GuiService (copy)
			local LastInputType = UserInputService:GetLastInputType()
			local v44 = GetInputModeStore().getLastInputType()

			if (v44 == Input.Directional or v44 == Input.Pointer and LastInputType == Enum.UserInputType.Keyboard) and v32.current then
				GuiService.SelectedCoreObject = v32.current
			end
		end, {})
	end

	local v39 = React.useCallback(function(n1: number) -- line: 58
		-- upvalues: v37 (copy)
		v37(n1)
	end, { v37 })
	local v40 = React.useCallback(function() -- line: 62
		-- upvalues: v37 (copy), Constants (copy), UserInputService (copy), GetInputModeStore (copy), Input (copy), v32 (copy), GuiService (copy)
		v37(Constants.NO_UNIVERSE_ID)

		local LastInputType = UserInputService:GetLastInputType()
		local v47 = GetInputModeStore().getLastInputType()

		if (v47 == Input.Directional or v47 == Input.Pointer and LastInputType == Enum.UserInputType.Keyboard) and v32.current then
			GuiService.SelectedCoreObject = v32.current
		end
	end, {})
	local v41 = React.useMemo(function() -- line: 72
		-- upvalues: Cryo (copy), v35 (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy)
		return (Cryo.List.map(v35, function(p2) -- line: 73
			-- upvalues: getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy)
			return {
				placeId = p2.placeId,
				universeId = p2.universeId,
				name = p2.name,
				image = getRbxThumb(ThumbnailType.GameIcon, p2.universeId, ThumbnailSize.Medium),
				rating = p2.rating
			}
		end))
	end, { v35 })
	local v42 = React.useCallback(function(n2: number) -- line: 85
		-- upvalues: v33 (copy), default (copy), v34 (copy)
		if v33 >= #default:getUniverseHistory() then
			return
		end

		v34(v33 + n2)
	end, { v33 })

	return next(v41) ~= nil and React.createElement(View, {
		tag = "size-full " .. if not FFlagIntegrateTraversalHistoryInSideSheet then not FFlagTraversalExpPagePaddingFixes and "padding-large" or "padding-top-medium" else ""
	}, {
		HistoryPage = React.createElement(HistoryPage, {
			historyItems = v41,
			onHistoryClose = function() -- line: 97
				-- upvalues: v38 (copy)
				v38.setCurrentReactPage(nil)
			end,
			onCardItemActivated = v39,
			onLoadMoreHistory = v42,
			ref = v32
		})
	}, {
		Dialog = React.createElement(TraversalLeaveConfirmation, {
			source = "history_landing_page",
			isDialogOpen = v36 > Constants.NO_UNIVERSE_ID,
			onCancel = v40,
			onClose = v40,
			universeId = v36
		})
	})
end

return React.memo(React.forwardRef(TraversalHistoryPage))
