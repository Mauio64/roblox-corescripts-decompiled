local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local Text = Foundation.Text
local View = Foundation.View

local DescriptionUpdated = require(MomentsCreationFlow.Actions.DescriptionUpdated)

local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useDispatch = MomentsCommon.Hooks.useDispatch
local useSelector = MomentsCommon.Hooks.useSelector
local useState = React.useState
local useTokens = Foundation.Hooks.useTokens

local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)

local Constants = require(MomentsCreationFlow.Constants)
local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)
local EventNames = require(MomentsCreationFlow.Analytics.EventNames)

return function(props)
	local v = useDispatch()
	local v2 = useDeviceInsets()
	local v3 = useTokens()
	local v4 = React.useContext(CreationFlowContext)

	local state, setState = useState((useSelector(function(p)
		return p[Constants.RoduxKey].CreationFlow.description
	end)))

	local v5 = useCallback(function()
		v(DescriptionUpdated(state))
		v4.fireEvent(EventNames.EditingFlowDescriptionEdited)
	end, { state })

	local v6 = useCallback(function(p)
		local text = p.Text:gsub("[\r\n]+", " ")
		local v6 = utf8.len(text)

		if v6 == nil or not (v6 >= 140) then
			setState(text)
			p.Text = text
		else
			local text2 = string.sub(text, 1, utf8.offset(text, 141) - 1)
			setState(text2)
			p.Text = text2
		end
	end, {})

	return React.createElement(View, {
		LayoutOrder = props.layoutOrder,
		tag = "align-x-center auto-y size-full-0"
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v3.Padding.Large),
			PaddingBottom = UDim.new(0, (math.max(v2.bottom, v3.Padding.Large))),
			PaddingLeft = UDim.new(0, (math.max(v2.left, v3.Padding.XLarge))),
			PaddingRight = UDim.new(0, (math.max(v2.right, v3.Padding.XLarge)))
		}),
		SizeConstraint = React.createElement(View, {
			sizeConstraint = { MaxSize = Constants.BottomBarSizeConstraint },
			tag = "align-x-center auto-y col gap-large size-full-0"
		}, {
			TextBoxContainer = React.createElement(
				View,
				{ tag = "size-full-2100 bg-surface-100 padding-medium radius-medium" },
				{
					TextBox = React.createElement("TextBox", {
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						ClearTextOnFocus = false,
						ClipsDescendants = true,
						Font = Enum.Font.BuilderSans,
						MaxVisibleGraphemes = 140,
						MultiLine = false,
						PlaceholderColor3 = v3.Color.Content.Muted.Color3,
						PlaceholderText = v4.getLocalization(CreationFlowLocalization.PublishingDescription),
						ShowNativeInput = true,
						Text = state,
						TextColor3 = v3.Color.ActionStandard.Foreground.Color3,
						TextSize = v3.FontSize.FontSize_400,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						[React.Change.Text] = v6,
						[React.Event.FocusLost] = v5
					})
				}
			),
			CTAs = React.createElement(
				View,
				{
					LayoutOrder = 2,
					tag = "align-x-center auto-y align-y-bottom anchor-bottom-center gap-small position-bottom-center row size-full-0"
				},
				{
					PostButton = React.createElement(Button, {
						fillBehavior = Foundation.Enums.FillBehavior.Fill,
						LayoutOrder = 1,
						onActivated = props.onPublish,
						size = InputSize.Medium,
						text = v4.getLocalization(CreationFlowLocalization.PublishingCtaPrimary),
						variant = ButtonVariant.Emphasis,
						width = UDim.new(0.5, 0)
					}),
					ReturnToEditingButton = React.createElement(Button, {
						fillBehavior = Foundation.Enums.FillBehavior.Fill,
						LayoutOrder = 2,
						text = v4.getLocalization(CreationFlowLocalization.PublishingCtaSecondary),
						variant = ButtonVariant.Standard,
						width = UDim.new(0.5, 0),
						onActivated = props.onReturnToEditing,
						size = InputSize.Medium
					})
				}
			),
			Disclaimer = React.createElement(Text, {
				LayoutOrder = 3,
				tag = "auto-xy text-body-small content-neutral text-align-x-center text-align-y-top",
				Text = v4.getLocalization(CreationFlowLocalization.CreationTooltip)
			})
		})
	})
end
