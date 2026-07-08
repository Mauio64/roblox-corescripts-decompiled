local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local Foundation = require(MomentsCreationFlowParent.Foundation)
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
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

return function(t1: {[any]: any}) -- line: 37
	-- upvalues: useDispatch (copy), useDeviceInsets (copy), useTokens (copy), React (copy), CreationFlowContext (copy), useSelector (copy), Constants (copy), useState (copy), useCallback (copy), DescriptionUpdated (copy), EventNames (copy), View (copy), CreationFlowLocalization (copy), Button (copy), Foundation (copy), InputSize (copy), ButtonVariant (copy), FoundationText (copy)
	local v23 = useDispatch()
	local v24 = useDeviceInsets()
	local v25 = useTokens()
	local v26 = React.useContext(CreationFlowContext)
	local v27 = useSelector(function(p1) -- line: 43
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].CreationFlow.description
	end)
	local v28, v29 = useState(v27)
	local v30 = useCallback(function() -- line: 49
		-- upvalues: v23 (copy), DescriptionUpdated (copy), v28 (copy), v26 (copy), EventNames (copy)
		v23(DescriptionUpdated(v28))
		v26.fireEvent(EventNames.EditingFlowDescriptionEdited)
	end, { v28 })
	local v31 = useCallback(function(p2) -- line: 54
		-- upvalues: v29 (copy)
		local v34 = p2.Text:gsub("[\r\n]+", " ")
		local v35 = utf8.len(v34)

		if v35 ~= nil and v35 >= 140 then
			local v36 = string.sub(v34, 1, utf8.offset(v34, 141) - 1)

			v29(v36)
			p2.Text = v36

			return
		end

		v29(v34)
		p2.Text = v34
	end, {})

	return React.createElement(View, {
		tag = "align-x-center auto-y size-full-0",
		LayoutOrder = t1.layoutOrder
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v25.Padding.Large),
			PaddingBottom = UDim.new(0, (math.max(v24.bottom, v25.Padding.Large))),
			PaddingLeft = UDim.new(0, (math.max(v24.left, v25.Padding.XLarge))),
			PaddingRight = UDim.new(0, (math.max(v24.right, v25.Padding.XLarge)))
		}),
		SizeConstraint = React.createElement(View, {
			tag = "align-x-center auto-y col gap-large size-full-0",
			sizeConstraint = {
				MaxSize = Constants.BottomBarSizeConstraint
			}
		}, {
			TextBoxContainer = React.createElement(View, {
				tag = "size-full-2100 bg-surface-100 padding-medium radius-medium"
			}, {
				TextBox = React.createElement("TextBox", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					ClipsDescendants = true,
					Font = Enum.Font.BuilderSans,
					MaxVisibleGraphemes = 140,
					MultiLine = false,
					PlaceholderColor3 = v25.Color.Content.Muted.Color3,
					PlaceholderText = v26.getLocalization(CreationFlowLocalization.PublishingDescription),
					ShowNativeInput = true,
					Text = v28,
					TextColor3 = v25.Color.ActionStandard.Foreground.Color3,
					TextSize = v25.FontSize.FontSize_400,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					[React.Change.Text] = v31,
					[React.Event.FocusLost] = v30
				})
			}),
			CTAs = React.createElement(View, {
				LayoutOrder = 2,
				tag = "align-x-center auto-y align-y-bottom anchor-bottom-center gap-small position-bottom-center row size-full-0"
			}, {
				PostButton = React.createElement(Button, {
					LayoutOrder = 1,
					fillBehavior = Foundation.Enums.FillBehavior.Fill,
					onActivated = t1.onPublish,
					size = InputSize.Medium,
					text = v26.getLocalization(CreationFlowLocalization.PublishingCtaPrimary),
					variant = ButtonVariant.Emphasis,
					width = UDim.new(0.5, 0)
				}),
				ReturnToEditingButton = React.createElement(Button, {
					LayoutOrder = 2,
					fillBehavior = Foundation.Enums.FillBehavior.Fill,
					text = v26.getLocalization(CreationFlowLocalization.PublishingCtaSecondary),
					variant = ButtonVariant.Standard,
					width = UDim.new(0.5, 0),
					onActivated = t1.onReturnToEditing,
					size = InputSize.Medium
				})
			}),
			Disclaimer = React.createElement(FoundationText, {
				LayoutOrder = 3,
				tag = "auto-xy text-body-small content-neutral text-align-x-center text-align-y-top",
				Text = v26.getLocalization(CreationFlowLocalization.CreationTooltip)
			})
		})
	})
end
