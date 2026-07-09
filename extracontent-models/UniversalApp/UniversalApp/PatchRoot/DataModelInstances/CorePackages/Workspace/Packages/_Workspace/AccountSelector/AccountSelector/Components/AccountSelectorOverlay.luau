local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local useStyle = UIBlox.Core.Style.useStyle
local useState = React.useState
local useEffect = React.useEffect
local useLocalization = dependencies.Localization.Hooks.useLocalization
local useDesignTokens = dependencies.Style.useDesignTokens
local AccountSelectionList = require(script.Parent.AccountSelectionList)

require(script.Parent.AccountSelection)

local AnalyticsEvents = require(ParentParent.Analytics.AnalyticsEvents)

local function AccountSelectorPage(t1: {[any]: any}) -- line: 35
	-- upvalues: useStyle (copy), useDesignTokens (copy), useState (copy), useLocalization (copy), getPartialPageModalMiddleContentWidth (copy), React (copy), useEffect (copy), AnalyticsEvents (copy), PartialPageModal (copy), AccountSelectionList (copy)
	local v16 = useStyle()
	local v17 = useDesignTokens()
	local v18, v19 = useState(false)
	local BaseSize = v16.Font.BaseSize
	local Size_1600 = v17.Size.Size_1600
	local v22 = Size_1600 * 7.5
	local v23 = #t1.users < 7 and Size_1600 * #t1.users or v22
	local v24 = useLocalization({
		titleText = t1.titleTextKey,
		helpText = t1.helpTextKey
	})
	local v25 = getPartialPageModalMiddleContentWidth(t1.screenSize.X)
	local v26 = React.useRef(false)

	useEffect(function() -- line: 54
		-- upvalues: t1 (copy), AnalyticsEvents (copy), v26 (copy)
		local s1 = ""

		for _, v30 in t1.users do
			s1 ..= tostring(v30.id) .. ","
		end

		local v31 = s1:sub(1, -2)

		AnalyticsEvents.sendPageLoadEvent(t1.context, t1.origin, v31)

		return function() -- line: 63
			-- upvalues: v26 (copy), t1 (copy)
			if not v26.current then
				t1.onAccountSelectionAbandoned()
			end
		end
	end, {})

	local function handleAccountSelection(p1) -- line: 72
		-- upvalues: v19 (copy), t1 (copy), AnalyticsEvents (copy), v26 (copy)
		v19(true)
		t1.onAccountSelection(p1)
		AnalyticsEvents.sendSelectEvent(t1.context, t1.origin, (tostring(p1)))
		v26.current = true
	end

	return React.createElement(PartialPageModal, {
		screenSize = t1.screenSize,
		title = v24.titleText,
		onCloseClicked = t1.onAccountSelectionAbandoned
	}, {
		ViewContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ContentPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 24)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 6),
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			HelpText = React.createElement("TextLabel", {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				TextWrapped = true,
				Text = v24.helpText,
				TextSize = BaseSize,
				TextColor3 = v16.Theme.TextDefault.Color,
				TextTransparency = v16.Theme.TextDefault.Transparency,
				Font = v16.Font.Body.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(0, v25, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}),
			AccountSelectionContent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v23)
			}, {
				AccountSelectionList = React.createElement(AccountSelectionList, {
					isScrollable = true,
					users = t1.users,
					onAccountSelection = handleAccountSelection,
					height = v23,
					isDisabled = v18
				})
			})
		})
	})
end

return AccountSelectorPage
