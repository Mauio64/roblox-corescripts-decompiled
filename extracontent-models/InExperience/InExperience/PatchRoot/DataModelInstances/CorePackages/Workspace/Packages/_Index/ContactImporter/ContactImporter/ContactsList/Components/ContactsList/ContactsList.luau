local ContactImporter = script:FindFirstAncestor("ContactImporter")
local parent = ContactImporter.Parent
local dependencies = require(ContactImporter.dependencies)

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local roact = dependencies.Roact
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local useLocalization = dependencies.useLocalization
local useStyle = dependencies.useStyle

local fullPageModal = uiBlox.App.Dialog.Modal.FullPageModal
local buttonType = uiBlox.App.Button.Enum.ButtonType

local styledTextLabel = uiBlox.App.Text.StyledTextLabel
local horizontalPageMargin = uiBlox.App.Container.HorizontalPageMargin
local sectionList = dependencies.SectionList

local TextKeys = require(ContactImporter.Common.TextKeys)
local ContactsListEntry = require(ContactImporter.ContactsList.Components.ContactsListEntry)
local ContactsListInviteEntry = require(ContactImporter.ContactsList.Components.ContactsListInviteEntry)
local ContactsEmptyList = require(ContactImporter.ContactsList.Components.ContactsEmptyList)
local ContactsUploadErrorModal = require(ContactImporter.ContactsList.Components.ContactsUploadErrorModal)
local ContactsGlimmer = require(ContactImporter.ContactsList.Components.ContactsGlimmer)

local ContactsSyncWarningMessage = require(ContactImporter.ContactsList.Components.ContactsSyncWarningMessage)

local Analytics = require(ContactImporter.Analytics)
local EventNames = Analytics.EventNames
require(ContactImporter.Common.LocalTypes)

local ContactsListSearchBar = require(ContactImporter.ContactsList.Components.ContactsListSearchBar)
local dash = dependencies.Dash

local Foundation = require(parent.Foundation)
local InputLabel = Foundation.InputLabel
local InputLabelSize = Foundation.Enums.InputLabelSize

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local ContactImportButtonsIXP = require(ContactImporter.Flags.ContactImportButtonsIXP)

local defineFastFlag = game:DefineFastFlag("ContactImportButtonsExperimentEnabled", false)

local IXPService = game:GetService("IXPService")
local Utils = require(ContactImporter.Utils)
local uprankContactsWithEmoji = Utils.uprankContactsWithEmoji
local FFlagContactsListEmojiSorting = require(ContactImporter.Flags.FFlagContactsListEmojiSorting)
local defineFastFlag2 = game:DefineFastFlag("ContactsListEmojiSortingIxpEnabled", false)

local defineFastString = game:DefineFastString("ContactsListEmojiSortingIxpLayer", "Social.ContactListEmojiSorting")
local SharedFlags2 = require(parent.SharedFlags)
local FFlagQRCodeCopyUpdates = SharedFlags2.FFlagQRCodeCopyUpdates
local SharedFlags3 = require(parent.SharedFlags)
local FStringCanAccessTrustedContactsAmpFeature = SharedFlags3.FStringCanAccessTrustedContactsAmpFeature
local SharedFlags4 = require(parent.SharedFlags)
local FStringIsUserInTcEligibleCountryAmpFeature = SharedFlags4.FStringIsUserInTcEligibleCountryAmpFeature
local SharedFlags5 = require(parent.SharedFlags)
local FFlagTCPolicyCheckRedirect = SharedFlags5.FFlagTCPolicyCheckRedirect
local SharedFlags6 = require(parent.SharedFlags)
local FStringCanAccessTrustedContactsAmpNameSpace = SharedFlags6.FStringCanAccessTrustedContactsAmpNameSpace
local AmpUpsell = require(parent.AmpUpsell)
local AmpApiProvider = AmpUpsell.AmpApiProvider
local AmpUpsell2 = require(parent.AmpUpsell)
local AmpEnums = AmpUpsell2.AmpEnums

local userInputService = dependencies.UserInputService

local function ContactsList(props)
	local v = useAppPolicy(function(p)
		return p.getWebViewSupport()
	end)

	local v2 = useStyle()
	local v3 = useDispatch()

	local v4 = useLocalization({
		fromContactsText = TextKeys.ON_ROBLOX,
		inviteToRobloxText = TextKeys.INVITE_TO_ROBLOX,
		contactsListBlurb = TextKeys.CONTACTS_LIST_DESCRIPTION,
		contactsListTFEducationBlurb = TextKeys.ADD_CONTACTS_AS_TRUSTED_FRIENDS_DESCRIPTION,
		connectWithFriends = TextKeys.CONTACTS_LIST_TITLE,
		closeModal = TextKeys.CLOSE_MODAL,
		goToAddFriends = TextKeys.GO_TO_ADD_FRIENDS,
		searchContacts = TextKeys.SEARCH_CONTACTS,
		learnMore = "Feature.Chat.Action.LearnMore"
	})
	local v5

	if defineFastFlag then
		v5 = ContactImportButtonsIXP.useIsRemoveCloseButtonExperimentEnabled({
			isExposureEnabled = true
		})
	else
		v5 = false
	end

	local function fn(p, filtered, filtered2)
		local v6 = #filtered ~= 0 and {
			{ isSectionDivider = true }
		} or nil
		dash.append(p, filtered, v6, filtered2)
	end

	local function onActivated()
		props.closeModal(EventNames.CloseContactListButton)
	end

	local function onCloseClicked()
		props.closeModal(EventNames.CloseContactListCross)
	end

	local onActivated2 = react.useCallback(function()
		local v6 = {
			name = AppPage.GenericWebPage,
			detail = "https://en.help.roblox.com/hc/en-us/articles/37725513985812",
			extraProps = { title = "" }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v6))
		else
			v3(NavigateDown(v6, nil))
		end
	end, { v3 })

	local state, setState = react.useState("")
	local v6

	if FFlagContactsListEmojiSorting then
		v6 = react.useMemo(function()
			return uprankContactsWithEmoji(props.matchedContacts)
		end, { props.matchedContacts })
	end

	local v7

	if FFlagContactsListEmojiSorting then
		v7 = react.useMemo(function()
			return uprankContactsWithEmoji(props.deviceContacts)
		end, { props.deviceContacts })
	end

	local filtered

	if FFlagContactsListEmojiSorting then
		filtered = dash.filter(v6, function(p): boolean
			if p.contactName == nil then
				return string.find(string.lower(p.contactName or ""), string.lower(state)) ~= nil
			end

			if p.contactName:match("^%s*$") then
				return false
			end

			return string.find(string.lower(p.contactName or ""), string.lower(state)) ~= nil
		end)
	else
		local matchedContacts = props.matchedContacts
		filtered = dash.filter(matchedContacts, function(p): boolean
			if p.contactName == nil then
				return string.find(string.lower(p.contactName or ""), string.lower(state)) ~= nil
			end

			if p.contactName:match("^%s*$") then
				return false
			end

			return string.find(string.lower(p.contactName or ""), string.lower(state)) ~= nil
		end)
	end

	local filtered2

	if FFlagContactsListEmojiSorting then
		filtered2 = dash.filter(v7, function(p): boolean
			if p.contactName == nil then
				return string.find(string.lower(p.contactName or ""), string.lower(state)) ~= nil
			end

			if p.contactName:match("^%s*$") then
				return false
			end

			return string.find(string.lower(p.contactName or ""), string.lower(state)) ~= nil
		end)
	else
		local deviceContacts = props.deviceContacts
		filtered2 = dash.filter(deviceContacts, function(p): boolean
			if p.contactName == nil then
				return string.find(string.lower(p.contactName or ""), string.lower(state)) ~= nil
			end

			if p.contactName:match("^%s*$") then
				return false
			end

			return string.find(string.lower(p.contactName or ""), string.lower(state)) ~= nil
		end)
	end

	if defineFastFlag2 then
		react.useEffect(function()
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
		end, {})
	end

	local state2, setState2 = react.useState(false)

	if FFlagQRCodeCopyUpdates then
		react.useEffect(function()
			local v8

			if FFlagTCPolicyCheckRedirect then
				v8 = FStringIsUserInTcEligibleCountryAmpFeature
			else
				v8 = FStringCanAccessTrustedContactsAmpFeature
			end

			if AmpApiProvider.upsellFeatureAccess(v8, {}, FStringCanAccessTrustedContactsAmpNameSpace).access == AmpEnums.AccessResponseEnum.Granted then
				setState2(true)
			end
		end)
	end

	local v8 = {}
	fn(v8, filtered, filtered2)

	local sections = {}

	if #filtered > 0 then
		table.insert(sections, {
			data = filtered,
			title = v4.fromContactsText,
			sectionNumber = #sections + 1
		})
	end

	if #filtered2 > 0 then
		table.insert(sections, {
			data = filtered2,
			title = v4.inviteToRobloxText,
			sectionNumber = #sections + 1
		})
	end

	local function fn2(p)
		local item = p.item

		if item.isSectionDivider then
			local _ = p.index ~= 1
			return roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 24)
			}, {
				divider = roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 0.5, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = v2.Theme.Divider.Color,
					BackgroundTransparency = v2.Theme.Divider.Transparency
				})
			})
		elseif item.isMatchedContact then
			return roact.createElement(ContactsListEntry, {
				contactName = item.contactName,
				contactId = item.contactId,
				contextualInfo = v4.fromContactsText,
				hasDivider = true,
				hasSentRequest = item.hasSentRequest,
				requestFriendship = props.requestFriendship,
				openProfilePeekView = props.openProfilePeekView,
				headshotThumbnailUrl = item.headshotThumbnailUrl,
				avatarThumbnailUrl = item.avatarThumbnailUrl
			})
		else
			return roact.createElement(ContactsListInviteEntry, {
				contactName = item.contactName,
				deviceContactId = item.deviceContactId,
				hasDivider = true,
				phoneNumber = item.phoneNumber,
				hasSentRequest = item.hasSentRequest
			})
		end
	end

	local function fn3(p)
		if not p.section then
			return roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 24)
			}, {
				divider = roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 0.5, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = v2.Theme.Divider.Color,
					BackgroundTransparency = v2.Theme.Divider.Transparency
				})
			})
		end

		local createElement = roact.createElement
		local v9 = { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0) }

		local constructorValue = roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		})
		local v10

		if p.section.sectionNumber ~= 1 then
			v10 = roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 24),
				BackgroundTransparency = 1,
				LayoutOrder = 1
			})
		end

		local constructorValue_2 = v10
		local v11 = {
			layout = constructorValue,
			padding = constructorValue_2,
			roact.createElement(
				"Frame",
				{ LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1 },
				{
					sectionHeaderTextLabel = roact.createElement(styledTextLabel, {
						fontStyle = v2.Font.Header2,
						colorStyle = v2.Theme.TextDefault,
						text = p.section.title or ""
					})
				}
			)
		}
		return createElement("Frame", v9, v11)
	end

	local function fn4(): boolean -- 3 equivalent calls inferred from this helper
		return #props.matchedContacts + #props.deviceContacts == 0
	end

	local function fn5(p)
		if props.isFetching then
			return {
				{
					buttonType = buttonType.PrimarySystem,
					props = { isLoading = true, onActivated = dash.noop }
				}
			}
		end

		if props.showAddFriendsButton and fn4() then -- inferred equivalent call
			if v5 then
				return {
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							onActivated = props.onAddFriendsActivated,
							text = p.goToAddFriends
						}
					}
				}
			end

			return {
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = props.onAddFriendsActivated, text = p.goToAddFriends }
				},
				{
					buttonType = buttonType.Secondary,
					props = { onActivated = onActivated, text = p.closeModal }
				}
			}
		elseif v5 then
			return {}
		else
			return {
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = onActivated, text = p.closeModal }
				}
			}
		end
	end

	local y = userInputService.StatusBarSize.Y

	local v9 = ContactsSyncWarningMessage.useIsVisible()

	local children = {
		layout = roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		contactsSyncWarning = 0
	}
	local contactsSyncWarning

	if v9 then
		contactsSyncWarning = react.createElement(ContactsSyncWarningMessage.Component, {
			layoutOrder = -1
		})
	end

	children.contactsSyncWarning = contactsSyncWarning

	local ref = react.createRef()

	local function fn6(p)
		setState(p)
	end

	local contactsList

	if #v8 == 0 then
		contactsList = roact.createElement(ContactsEmptyList, {
			errorTextKey = TextKeys.NO_RESULTS,
			layoutOrder = 8
		})
	else
		local createElement = roact.createElement

		if not (#filtered > 0) then
			fn3 = nil
		end

		contactsList = createElement(sectionList, {
			ref = ref,
			sections = sections,
			renderSectionHeader = fn3,
			renderItem = fn2,
			initialNumToRender = 15,
			CanvasSize = UDim2.new(1, 0, 0, #v8 * 73),
			contentContainerStyle = { BackgroundTransparency = 1, BorderSizePixel = 0 },
			style = {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				LayoutOrder = 8,
				Size = UDim2.new(1, 0, 1, -80 - (v5 and 0 or 48) - 36 - 16),
				ElasticBehavior = Enum.ElasticBehavior.Always
			}
		})
	end

	local children2 = {
		layout = roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		contactsSyncWarning = 0,
		spacer1 = 0,
		descriptionFrame = 0,
		spacer2 = 0,
		searchBarContainer = 0,
		spacer4 = 0,
		contactsList = 0
	}
	local contactsSyncWarning2

	if v9 then
		contactsSyncWarning2 = react.createElement(ContactsSyncWarningMessage.Component, {
			layoutOrder = -1
		})
	end

	children2.contactsSyncWarning = contactsSyncWarning2
	local spacer

	if not v9 then
		spacer = roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		})
	end

	children2.spacer1 = spacer
	local descriptionFrame

	if not v9 then
		local createElement = roact.createElement
		local v10 = { Size = UDim2.new(1, 0, 0, 80), BackgroundTransparency = 1, LayoutOrder = 2 }

		local createElement2 = roact.createElement
		local horizontalAlignment

		if FFlagQRCodeCopyUpdates and state2 then
			horizontalAlignment = Enum.HorizontalAlignment.Left
		else
			horizontalAlignment = Enum.HorizontalAlignment.Center
		end

		local children3 = {
			textLayout = createElement2("UIListLayout", {
				HorizontalAlignment = horizontalAlignment,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			descriptionText = 0,
			LearnMoreWebLink = 0
		}

		local createElement3 = roact.createElement
		local text

		if FFlagQRCodeCopyUpdates and state2 then
			text = v4.contactsListTFEducationBlurb
		else
			text = v4.contactsListBlurb
		end

		local v11 = {
			text = text,
			automaticSize = Enum.AutomaticSize.Y,
			colorStyle = v2.Theme.TextDefault,
			fontStyle = v2.Font.Body,
			lineHeight = 1,
			size = UDim2.new(1, 0, 0, 0),
			maxSize = Vector2.new(0, 80),
			textXAlignment = 0,
			textYAlignment = 0,
			layoutOrder = 1
		}
		local textXAlignment

		if FFlagQRCodeCopyUpdates and state2 then
			textXAlignment = Enum.TextXAlignment.Left
		else
			textXAlignment = Enum.TextXAlignment.Center
		end

		v11.textXAlignment = textXAlignment

		v11.textYAlignment = Enum.TextYAlignment.Center
		children3.descriptionText = createElement3(styledTextLabel, v11)

		children3.LearnMoreWebLink = v and react.createElement(InputLabel, {
			LayoutOrder = 2,
			tag = "auto-y size-full-0",
			RichText = true,
			Text = `<u>{v4.learnMore}</u>`,
			size = InputLabelSize.Large,
			onActivated = onActivated2
		})
		descriptionFrame = createElement("Frame", v10, children3)
	end

	children2.descriptionFrame = descriptionFrame
	local spacer2

	if not v9 then
		spacer2 = roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundTransparency = 1,
			LayoutOrder = 3
		})
	end

	children2.spacer2 = spacer2

	children2.searchBarContainer = roact.createElement(ContactsListSearchBar, {
		height = 36,
		layoutOrder = 4,
		textChangeCallback = fn6
	})

	children2.spacer4 = roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		LayoutOrder = 7
	})

	children2.contactsList = contactsList

	if props.isFetching then
		for _, layoutOrder in { 1, 2, 3 } do
			children["glimmer" .. layoutOrder] = roact.createElement(ContactsGlimmer, {
				layoutOrder = layoutOrder
			})
		end
	elseif props.hasUploadError and fn4() then -- inferred equivalent call
		children.errorModal = roact.createElement(ContactsUploadErrorModal)
	elseif fn4() then -- inferred equivalent call
		children.emptyList = roact.createElement(ContactsEmptyList)
	else
		children = children2
	end

	return roact.createElement(fullPageModal, {
		title = v4.connectWithFriends,
		screenSize = props.screenSize,
		marginSize = 0,
		distanceFromTop = y,
		onCloseClicked = onCloseClicked,
		buttonStackProps = {
			buttons = fn5(v4),
			buttonHeight = v5 and 0 or 48,
			forcedFillDirection = Enum.FillDirection.Vertical
		}
	}, {
		hpm = roact.createElement(
			horizontalPageMargin,
			{
				size = UDim2.new(1, 0, 1, 0),
				position = UDim2.new(0, 0, 0, 0),
				backgroundTransparency = 1
			},
			{
				contentFrame = roact.createElement(
					"Frame",
					{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 },
					children
				),
				gradientFrame = roact.createElement("Frame", {
					Position = UDim2.new(0, 0, 1, v5 and 0 or -24),
					Size = UDim2.new(1, 0, 0, 24),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					ZIndex = 2
				}, {
					gradient = roact.createElement("UIGradient", {
						Rotation = 270,
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, v2.Theme.BackgroundUIDefault.Color),
							ColorSequenceKeypoint.new(1, v2.Theme.BackgroundUIDefault.Color)
						}),
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0),
							NumberSequenceKeypoint.new(1, 1)
						})
					})
				})
			}
		)
	})
end

return ContactsList
