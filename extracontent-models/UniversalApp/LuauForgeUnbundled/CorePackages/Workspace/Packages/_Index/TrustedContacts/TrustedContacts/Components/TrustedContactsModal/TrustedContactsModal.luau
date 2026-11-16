local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/FocusNavigationUtils")
local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusOnMount = FocusNavigationUtils.useFocusOnMount
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/InputHandlers")
local useMostRecentOrDefaultFocusBehavior = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/ReactFocusNavigation").useMostRecentOrDefaultFocusBehavior

local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Responsive")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local text = Foundation.Text
local button = Foundation.Button
local view = Foundation.View
local sheet = Foundation.Sheet
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior

local SocialMetadataSection = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Components/SocialMetadataSection")
local defineFastInt = game:DefineFastInt("TCMountMinLoadingTimeMs", 0)
local FFlagTCLearnMoreLink = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTCLearnMoreLink")

local FFlagTrustedContactsModalFixFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTrustedContactsModalFixFocusNavigation")
local FFlagTrustedContactsSheetFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTrustedContactsSheetFocusNavigation")

require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Components/TrustedContactsModal/useModalButtonActions")

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

return function(props)
	local isVerticallyConstrained = props.isVerticallyConstrained
	local v5 = Responsive.useOrientation()
	local onCloseModal = props.onCloseModal
	local v6

	if FFlagTrustedContactsModalFixFocusNavigation then
		v6 = React.useMemo(function()
			local v7 = {}
			v7[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onCloseModal()
					object:cancel()
				end)
			}

			return v7
		end, { onCloseModal })
	end

	local v7 = FFlagTrustedContactsSheetFocusNavigation and FFlagTrustedContactsModalFixFocusNavigation
	local v8, v9

	if FFlagTrustedContactsSheetFocusNavigation then
		v8, v9 = useMostRecentOrDefaultFocusBehavior((useFocusRoot({
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
			eventMap = navigateBacks,
			eventHandlers = v6,
			isAutoFocusRoot = true,
			isFocusable = v7,
			shouldRestoreFocus = false
		})))
	end

	local v10

	if FFlagTrustedContactsModalFixFocusNavigation then
		if not v7 then
			v8 = nil
		end

		v10 = useFocusOnMount(v8)
	end

	local v11 = v5 == Responsive.DefaultKey
	local state, setState = React.useState(v11)
	local ref = React.useRef(os.clock())
	React.useEffect(function()
		if not v11 then
			local v12 = os.clock() - ref.current
			local v13 = defineFastInt / 1000

			if v12 < v13 then
				delay(v13 - v12, function()
					setState(false)
				end)
			else
				setState(false)
			end
		end
	end, { v11, setState })

	if state then
		return React.createElement(loading, {
			size = iconSize.Large,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})
	end

	local v12 = if props.modalButtonActions then props.modalButtonActions[1] or nil else nil
	local v13 = if props.modalButtonActions then props.modalButtonActions[2] or nil else nil

	local createElement = React.createElement
	local root = sheet.Root
	local v14 = { onClose = props.onCloseModal, preferCenterSheet = true, ref = 0 }

	if not v7 then
		v9 = nil
	end

	v14.ref = v9
	local v15 = {
		Header = React.createElement(sheet.Header, nil, {
			Title = React.createElement(text, {
				tag = "auto-xy text-heading-small text-align-x-left content-default",
				Text = props.headerText
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = sheet.Content

	local v18 = if FFlagTCLearnMoreLink then React.createElement(
		view,
		{ LayoutOrder = 1, tag = "col gap-small size-full-0 auto-y" },
		{
			Text = React.createElement(text, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-wrap text-align-x-left",
				Text = props.descriptionText
			}),
			LearnMore = React.createElement(text, {
				LayoutOrder = 2,
				tag = "size-0 auto-xy text-wrap text-align-x-left",
				Text = `<u>{props.learnMoreText}</u>`,
				onActivated = props.onLearnMoreClick,
				RichText = true
			})
		}
	) else React.createElement(text, {
		LayoutOrder = 1,
		tag = "size-full-0 auto-y text-wrap text-align-x-left",
		Text = props.descriptionText
	})
	v15.Content = createElement2(content, { LayoutOrder = 2 }, {
		TextIntro = v18,
		Insights = React.createElement(SocialMetadataSection, {
			userId = props.userId,
			layoutOrder = 2,
			isVerticallyConstrained = isVerticallyConstrained
		})
	})

	local v19 = if v12 or v13 then React.createElement(sheet.Actions, nil, {
		First = v12 and React.createElement(button, {
			LayoutOrder = 1,
			text = v12.text or "",
			onActivated = v12.onActivated,
			icon = v12.icon,
			isLoading = v12.isLoading,
			variant = buttonVariant.Emphasis,
			fillBehavior = fillBehavior.Fill,
			width = UDim.new(1, 0),
			ref = v10,
			isDisabled = v12.isDisabled
		}) or nil,
		Second = v13 and React.createElement(button, {
			LayoutOrder = 2,
			text = v13.text or "",
			onActivated = v13.onActivated,
			icon = v13.icon,
			isLoading = v13.isLoading,
			variant = buttonVariant.Standard,
			fillBehavior = fillBehavior.Fill,
			width = UDim.new(1, 0),
			isDisabled = v13.isDisabled
		}) or nil
	}) else nil
	v15.Actions = v19
	local element = createElement(root, v14, v15)

	if v7 then
		return element
	end

	if FFlagTrustedContactsModalFixFocusNavigation then
		return React.createElement(
			focusRoot,
			{
				surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
				isAutoFocusRoot = true,
				isIsolated = true,
				eventHandlers = v6
			},
			{ Modal = element }
		)
	end

	return element
end
