local module = require("@luauforge/bundled/fPo")
local react = module.React
local uiBlox = module.UIBlox

local partialPageModal = uiBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = uiBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local useStyle = uiBlox.Core.Style.useStyle
local useState = react.useState
local useEffect = react.useEffect
local useLocalization = module.Localization.Hooks.useLocalization
local useDesignTokens = module.Style.useDesignTokens

local module2 = require("@luauforge/bundled/fPM")
require("@luauforge/bundled/fPN")

local module3 = require("@luauforge/bundled/fPP")

local function AccountSelectorPage(props)
	local v5 = useStyle()
	local v6 = useDesignTokens()
	local state, setState = useState(false)
	local baseSize = v5.Font.BaseSize

	local size_1600 = v6.Size.Size_1600
	local v7 = size_1600 * 7.5
	v7 = #props.users < 7 and size_1600 * #props.users or v7

	local v8 = useLocalization({
		titleText = props.titleTextKey,
		helpText = props.helpTextKey
	})

	local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(props.screenSize.X)

	local ref = react.useRef(false)

	useEffect(function()
		local v9 = ""

		for k, user in props.users do
			v9 ..= tostring(user.id) .. ","
		end

		local v10 = v9:sub(1, -2)
		module3.sendPageLoadEvent(props.context, props.origin, v10)
		return function()
			if not ref.current then
				props.onAccountSelectionAbandoned()
			end
		end
	end, {})

	local function handleAccountSelection(p2)
		setState(true)
		props.onAccountSelection(p2)
		module3.sendSelectEvent(props.context, props.origin, (tostring(p2)))
		ref.current = true
	end

	return react.createElement(
		partialPageModal,
		{
			screenSize = props.screenSize,
			title = v8.titleText,
			onCloseClicked = props.onAccountSelectionAbandoned
		},
		{
			ViewContainer = react.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y
				},
				{
					ContentPadding = react.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 12),
						PaddingBottom = UDim.new(0, 24)
					}),
					UIListLayout = react.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 6),
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					HelpText = react.createElement("TextLabel", {
						LayoutOrder = 0,
						BackgroundTransparency = 1,
						Text = v8.helpText,
						TextSize = baseSize,
						TextColor3 = v5.Theme.TextDefault.Color,
						TextTransparency = v5.Theme.TextDefault.Transparency,
						Font = v5.Font.Body.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,
						Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}),
					AccountSelectionContent = react.createElement(
						"Frame",
						{
							Size = UDim2.new(1, 0, 0, v7),
							BackgroundTransparency = 1,
							LayoutOrder = 1
						},
						{
							AccountSelectionList = react.createElement(module2, {
								users = props.users,
								onAccountSelection = handleAccountSelection,
								height = v7,
								isDisabled = state,
								isScrollable = true
							})
						}
					)
				}
			)
		}
	)
end

return AccountSelectorPage
