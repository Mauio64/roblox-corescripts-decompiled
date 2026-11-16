local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusOnMount = FocusNavigationUtils.useFocusOnMount
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local InputHandlers = require(parent.InputHandlers)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local useMostRecentOrDefaultFocusBehavior = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior

local Responsive = require(parent.Responsive)
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local Text = Foundation.Text
local Button = Foundation.Button
local View = Foundation.View
local Sheet = Foundation.Sheet
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior

local SocialMetadataSection = require(TrustedContacts.Components.SocialMetadataSection)
local defineFastInt = game:DefineFastInt("TCMountMinLoadingTimeMs", 0)
local FFlagTCLearnMoreLink = require(TrustedContacts.Flags.FFlagTCLearnMoreLink)

local FFlagTrustedContactsModalFixFocusNavigation = require(TrustedContacts.Flags.FFlagTrustedContactsModalFixFocusNavigation)
local FFlagTrustedContactsSheetFocusNavigation = require(TrustedContacts.Flags.FFlagTrustedContactsSheetFocusNavigation)

require(script.Parent.useModalButtonActions)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

return function(props)
	local isVerticallyConstrained = props.isVerticallyConstrained
	local v = Responsive.useOrientation()
	local onCloseModal = props.onCloseModal
	local eventHandlers

	if FFlagTrustedContactsModalFixFocusNavigation then
		eventHandlers = React.useMemo(function()
			local v2 = {}
			v2[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onCloseModal()
					object:cancel()
				end)
			}

			return v2
		end, { onCloseModal })
	end

	local isFocusable = FFlagTrustedContactsSheetFocusNavigation and FFlagTrustedContactsModalFixFocusNavigation
	local v2, ref2

	if FFlagTrustedContactsSheetFocusNavigation then
		v2, ref2 = useMostRecentOrDefaultFocusBehavior((useFocusRoot({
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
			eventMap = navigateBacks,
			eventHandlers = eventHandlers,
			isAutoFocusRoot = true,
			isFocusable = isFocusable,
			shouldRestoreFocus = false
		})))
	end

	local ref3

	if FFlagTrustedContactsModalFixFocusNavigation then
		if not isFocusable then
			v2 = nil
		end

		ref3 = useFocusOnMount(v2)
	end

	local v3 = v == Responsive.DefaultKey
	local state, setState = React.useState(v3)
	local ref = React.useRef(os.clock())
	React.useEffect(function()
		if not v3 then
			local v4 = os.clock() - ref.current
			local v5 = defineFastInt / 1000

			if v4 < v5 then
				delay(v5 - v4, function()
					setState(false)
				end)
			else
				setState(false)
			end
		end
	end, { v3, setState })

	if state then
		return React.createElement(Loading, {
			size = IconSize.Large,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})
	end

	local v4

	if props.modalButtonActions then
		v4 = props.modalButtonActions[1] or nil
	end

	local v5

	if props.modalButtonActions then
		v5 = props.modalButtonActions[2] or nil
	end

	local createElement = React.createElement
	local root = Sheet.Root
	local v6 = { onClose = props.onCloseModal, preferCenterSheet = true, ref = 0 }

	if not isFocusable then
		ref2 = nil
	end

	v6.ref = ref2
	local v7 = {
		Header = React.createElement(Sheet.Header, nil, {
			Title = React.createElement(Text, {
				tag = "auto-xy text-heading-small text-align-x-left content-default",
				Text = props.headerText
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Sheet.Content
	local textIntro

	if FFlagTCLearnMoreLink then
		textIntro = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-small size-full-0 auto-y"
		}, {
			Text = React.createElement(Text, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-wrap text-align-x-left",
				Text = props.descriptionText
			}),
			LearnMore = React.createElement(Text, {
				LayoutOrder = 2,
				tag = "size-0 auto-xy text-wrap text-align-x-left",
				Text = `<u>{props.learnMoreText}</u>`,
				onActivated = props.onLearnMoreClick,
				RichText = true
			})
		})
	else
		textIntro = React.createElement(Text, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-wrap text-align-x-left",
			Text = props.descriptionText
		})
	end

	v7.Content = createElement2(content, { LayoutOrder = 2 }, {
		TextIntro = textIntro,
		Insights = React.createElement(SocialMetadataSection, {
			userId = props.userId,
			layoutOrder = 2,
			isVerticallyConstrained = isVerticallyConstrained
		})
	})
	local actions

	if v4 or v5 then
		actions = React.createElement(Sheet.Actions, nil, {
			First = v4 and React.createElement(Button, {
				LayoutOrder = 1,
				text = v4.text or "",
				onActivated = v4.onActivated,
				icon = v4.icon,
				isLoading = v4.isLoading,
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				width = UDim.new(1, 0),
				ref = ref3,
				isDisabled = v4.isDisabled
			}) or nil,
			Second = v5 and React.createElement(Button, {
				LayoutOrder = 2,
				text = v5.text or "",
				onActivated = v5.onActivated,
				icon = v5.icon,
				isLoading = v5.isLoading,
				variant = ButtonVariant.Standard,
				fillBehavior = FillBehavior.Fill,
				width = UDim.new(1, 0),
				isDisabled = v5.isDisabled
			}) or nil
		})
	end

	v7.Actions = actions
	local element = createElement(root, v6, v7)

	if isFocusable then
		return element
	end

	if FFlagTrustedContactsModalFixFocusNavigation then
		return React.createElement(
			FocusRoot,
			{
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
				isAutoFocusRoot = true,
				isIsolated = true,
				eventHandlers = eventHandlers
			},
			{ Modal = element }
		)
	end

	return element
end
