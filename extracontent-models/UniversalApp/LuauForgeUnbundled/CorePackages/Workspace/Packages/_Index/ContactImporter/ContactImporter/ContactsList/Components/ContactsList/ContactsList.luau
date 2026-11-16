local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/UniversalAppPolicy").useAppPolicy
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RoactUtils").Hooks.RoactRodux.useDispatch

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

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/TextKeys")
local ContactsListEntry = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsListEntry")
local ContactsListInviteEntry = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsListInviteEntry")
local ContactsEmptyList = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsEmptyList")
local ContactsUploadErrorModal = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsUploadErrorModal")
local ContactsGlimmer = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsGlimmer")

local ContactsSyncWarningMessage = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsSyncWarningMessage")

local eventNames = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics").EventNames
require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/LocalTypes")

local ContactsListSearchBar = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsListSearchBar")
local dash = dependencies.Dash

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Foundation")
local inputLabel = Foundation.InputLabel
local inputLabelSize = Foundation.Enums.InputLabelSize

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RobloxAppNavigation").NavigationCommands else nil

local ContactImportButtonsIXP = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/ContactImportButtonsIXP")

local defineFastFlag = game:DefineFastFlag("ContactImportButtonsExperimentEnabled", false)
local fFlagAddFriendsBannersNewUI_IXP = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FFlagAddFriendsBannersNewUI_IXP

local IXPService = game:GetService("IXPService")
local uprankContactsWithEmoji = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Utils").uprankContactsWithEmoji
local FFlagContactsListEmojiSorting = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/FFlagContactsListEmojiSorting")
local defineFastFlag2 = game:DefineFastFlag("ContactsListEmojiSortingIxpEnabled", false)

local defineFastString = game:DefineFastString(
	"ContactsListEmojiSortingIxpLayer",
	"Social.ContactListEmojiSorting"
)
local fFlagQRCodeCopyUpdates = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FFlagQRCodeCopyUpdates
local fStringCanAccessTrustedContactsAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FStringCanAccessTrustedContactsAmpFeature
local fStringIsUserInTcEligibleCountryAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FStringIsUserInTcEligibleCountryAmpFeature
local fFlagTCPolicyCheckRedirect = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FFlagTCPolicyCheckRedirect
local fStringCanAccessTrustedContactsAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FStringCanAccessTrustedContactsAmpNameSpace
local ampApiProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/AmpUpsell").AmpApiProvider
local ampEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/AmpUpsell").AmpEnums

local userInputService = dependencies.UserInputService

local function ContactsList(props)
	local v5 = useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)

	local v6 = useStyle()
	local v7 = useDispatch()

	local v8 = useLocalization({
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
	local v9

	if defineFastFlag then
		v9 = ContactImportButtonsIXP.useIsRemoveCloseButtonExperimentEnabled({
			isExposureEnabled = true
		})
	else
		v9 = false
	end

	local function fn(p2, filtered, filtered2)
		local v10 = #filtered ~= 0 and {
			{ isSectionDivider = true }
		} or nil
		dash.append(p2, filtered, v10, filtered2)
	end

	local function onActivated()
		props.closeModal(eventNames.CloseContactListButton)
	end

	local function onCloseClicked()
		props.closeModal(eventNames.CloseContactListCross)
	end

	local v10 = react.useCallback(function()
		local v11 = {
			name = appPage.GenericWebPage,
			detail = "https://en.help.roblox.com/hc/en-us/articles/37725513985812",
			extraProps = { title = "" }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v11))
		else
			v7(navigateDown(v11, nil))
		end
	end, { v7 })

	local state, setState = react.useState("")
	local v11

	if FFlagContactsListEmojiSorting then
		v11 = react.useMemo(function()
			return uprankContactsWithEmoji(props.matchedContacts)
		end, { props.matchedContacts })
	end

	local v12

	if FFlagContactsListEmojiSorting then
		v12 = react.useMemo(function()
			return uprankContactsWithEmoji(props.deviceContacts)
		end, { props.deviceContacts })
	end

	local filtered

	if FFlagContactsListEmojiSorting then
		filtered = dash.filter(v11, function(p2): boolean
			if p2.contactName == nil then
				return string.find(string.lower(p2.contactName or ""), string.lower(state)) ~= nil
			end

			if p2.contactName:match("^%s*$") then
				return false
			end

			return string.find(string.lower(p2.contactName or ""), string.lower(state)) ~= nil
		end)
	else
		local matchedContacts = props.matchedContacts
		filtered = dash.filter(matchedContacts, function(p2): boolean
			if p2.contactName == nil then
				return string.find(string.lower(p2.contactName or ""), string.lower(state)) ~= nil
			end

			if p2.contactName:match("^%s*$") then
				return false
			end

			return string.find(string.lower(p2.contactName or ""), string.lower(state)) ~= nil
		end)
	end

	local filtered2

	if FFlagContactsListEmojiSorting then
		filtered2 = dash.filter(v12, function(p2): boolean
			if p2.contactName == nil then
				return string.find(string.lower(p2.contactName or ""), string.lower(state)) ~= nil
			end

			if p2.contactName:match("^%s*$") then
				return false
			end

			return string.find(string.lower(p2.contactName or ""), string.lower(state)) ~= nil
		end)
	else
		local deviceContacts = props.deviceContacts
		filtered2 = dash.filter(deviceContacts, function(p2): boolean
			if p2.contactName == nil then
				return string.find(string.lower(p2.contactName or ""), string.lower(state)) ~= nil
			end

			if p2.contactName:match("^%s*$") then
				return false
			end

			return string.find(string.lower(p2.contactName or ""), string.lower(state)) ~= nil
		end)
	end

	if defineFastFlag2 then
		react.useEffect(function()
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
		end, {})
	end

	local state2, setState2 = react.useState(false)

	if fFlagQRCodeCopyUpdates then
		react.useEffect(function()
			local v13

			if fFlagTCPolicyCheckRedirect then
				v13 = fStringIsUserInTcEligibleCountryAmpFeature
			else
				v13 = fStringCanAccessTrustedContactsAmpFeature
			end

			if ampApiProvider.upsellFeatureAccess(v13, {}, fStringCanAccessTrustedContactsAmpNameSpace).access == ampEnums.AccessResponseEnum.Granted then
				setState2(true)
			end
		end)
	end

	local v13 = {}
	fn(v13, filtered, filtered2)

	local v14 = {}

	if #filtered > 0 then
		table.insert(v14, {
			data = filtered,
			title = v8.fromContactsText,
			sectionNumber = #v14 + 1
		})
	end

	if #filtered2 > 0 then
		table.insert(v14, {
			data = filtered2,
			title = v8.inviteToRobloxText,
			sectionNumber = #v14 + 1
		})
	end

	local function fn2(p2)
		local item = p2.item

		if item.isSectionDivider then
			local v15 = p2.index ~= 1
			return roact.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24) },
				{
					divider = roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, 1),
						Position = UDim2.new(0, 0, 0.5, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = v6.Theme.Divider.Color,
						BackgroundTransparency = v6.Theme.Divider.Transparency
					})
				}
			)
		elseif item.isMatchedContact then
			return roact.createElement(ContactsListEntry, {
				contactName = item.contactName,
				contactId = item.contactId,
				contextualInfo = v8.fromContactsText,
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

	local function fn3(p2)
		if not p2.section then
			return roact.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24) },
				{
					divider = roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, 1),
						Position = UDim2.new(0, 0, 0.5, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = v6.Theme.Divider.Color,
						BackgroundTransparency = v6.Theme.Divider.Transparency
					})
				}
			)
		end

		local createElement = roact.createElement
		local v16 = { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0) }
		local v17 = {
			[1] = nil,
			nil,
			layout = roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			})
		}

		local v18 = if p2.section.sectionNumber ~= 1 then roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}) else nil
		v17.padding = v18

		-- [TOVEK] unclear table creation
		-- Inserting from loop instead
		do
			local _values = table.pack(roact.createElement(
				"Frame",
				{
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 24),
					BackgroundTransparency = 1
				},
				{
					sectionHeaderTextLabel = roact.createElement(styledTextLabel, {
						fontStyle = v6.Font.Header2,
						colorStyle = v6.Theme.TextDefault,
						text = p2.section.title or ""
					})
				}
			))
			for _k = 1, _values.n do
				v17[_k] = _values[_k]
			end
		end
		return createElement("Frame", v16, v17)
	end

	local function fn4(p2)
		if props.isFetching then
			return {
				{
					buttonType = buttonType.PrimarySystem,
					props = { isLoading = true, onActivated = dash.noop }
				}
			}
		end

		if props.showAddFriendsButton and #props.matchedContacts + #props.deviceContacts == 0 then
			if v9 then
				return {
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							onActivated = props.onAddFriendsActivated,
							text = p2.goToAddFriends
						}
					}
				}
			end

			return {
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = props.onAddFriendsActivated,
						text = p2.goToAddFriends
					}
				},
				{
					buttonType = buttonType.Secondary,
					props = { onActivated = onActivated, text = p2.closeModal }
				}
			}
		elseif v9 then
			return {}
		else
			return {
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = onActivated, text = p2.closeModal }
				}
			}
		end
	end

	local y = userInputService.StatusBarSize.Y

	local v15 = if fFlagAddFriendsBannersNewUI_IXP then ContactsSyncWarningMessage.useIsVisible() else nil

	local children = {
		layout = roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		contactsSyncWarning = 0
	}

	local v16 = if fFlagAddFriendsBannersNewUI_IXP and v15 then react.createElement(ContactsSyncWarningMessage.Component, {
		layoutOrder = -1
	}) else nil
	children.contactsSyncWarning = v16

	local ref = react.createRef()

	local function fn5(p2)
		setState(p2)
	end

	local v17

	if #v13 == 0 then
		v17 = roact.createElement(ContactsEmptyList, {
			errorTextKey = TextKeys.NO_RESULTS,
			layoutOrder = 8
		})
	else
		local createElement = roact.createElement

		if not (#filtered > 0) then
			fn3 = nil
		end

		v17 = createElement(sectionList, {
			ref = ref,
			sections = v14,
			renderSectionHeader = fn3,
			renderItem = fn2,
			initialNumToRender = 15,
			CanvasSize = UDim2.new(1, 0, 0, #v13 * 73),
			contentContainerStyle = { BackgroundTransparency = 1, BorderSizePixel = 0 },
			style = {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				LayoutOrder = 8,
				Size = UDim2.new(1, 0, 1, -80 - (v9 and 0 or 48) - 36 - 16),
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

	local v18 = if fFlagAddFriendsBannersNewUI_IXP and v15 then react.createElement(ContactsSyncWarningMessage.Component, {
		layoutOrder = -1
	}) else nil
	children2.contactsSyncWarning = v18

	local v19 = if not (fFlagAddFriendsBannersNewUI_IXP and v15) then roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}) else nil
	children2.spacer1 = v19
	local v20

	if not (fFlagAddFriendsBannersNewUI_IXP and v15) then
		local createElement = roact.createElement
		local v22 = {
			Size = UDim2.new(1, 0, 0, 80),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}

		local createElement2 = roact.createElement

		local v25 = if fFlagQRCodeCopyUpdates and state2 then Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Center
		local children3 = {
			textLayout = createElement2("UIListLayout", {
				HorizontalAlignment = v25,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			descriptionText = 0,
			LearnMoreWebLink = 0
		}

		local createElement3 = roact.createElement

		local v28 = if fFlagQRCodeCopyUpdates and state2 then v8.contactsListTFEducationBlurb else v8.contactsListBlurb
		local v27 = {
			text = v28,
			automaticSize = Enum.AutomaticSize.Y,
			colorStyle = v6.Theme.TextDefault,
			fontStyle = v6.Font.Body,
			lineHeight = 1,
			size = UDim2.new(1, 0, 0, 0),
			maxSize = Vector2.new(0, 80),
			textXAlignment = 0,
			textYAlignment = 0,
			layoutOrder = 1
		}

		local v29 = if fFlagQRCodeCopyUpdates and state2 then Enum.TextXAlignment.Left else Enum.TextXAlignment.Center
		v27.textXAlignment = v29

		v27.textYAlignment = Enum.TextYAlignment.Center
		children3.descriptionText = createElement3(styledTextLabel, v27)

		children3.LearnMoreWebLink = v5 and react.createElement(inputLabel, {
			LayoutOrder = 2,
			tag = "auto-y size-full-0",
			RichText = true,
			Text = `<u>{v8.learnMore}</u>`,
			size = inputLabelSize.Large,
			onActivated = v10
		})
		v20 = createElement("Frame", v22, children3)
	end

	children2.descriptionFrame = v20

	local v21 = if not (fFlagAddFriendsBannersNewUI_IXP and v15) then roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		LayoutOrder = 3
	}) else nil
	children2.spacer2 = v21

	children2.searchBarContainer = roact.createElement(ContactsListSearchBar, {
		height = 36,
		layoutOrder = 4,
		textChangeCallback = fn5
	})

	children2.spacer4 = roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		LayoutOrder = 7
	})

	children2.contactsList = v17

	if props.isFetching then
		for k, v22 in { 1, 2, 3 } do
			children["glimmer" .. v22] = roact.createElement(ContactsGlimmer, {
				layoutOrder = v22
			})
		end
	elseif props.hasUploadError and #props.matchedContacts + #props.deviceContacts == 0 then
		children.errorModal = roact.createElement(ContactsUploadErrorModal)
	elseif #props.matchedContacts + #props.deviceContacts == 0 then
		children.emptyList = roact.createElement(ContactsEmptyList)
	else
		children = children2
	end

	return roact.createElement(fullPageModal, {
		title = v8.connectWithFriends,
		screenSize = props.screenSize,
		marginSize = 0,
		distanceFromTop = y,
		onCloseClicked = onCloseClicked,
		buttonStackProps = {
			buttons = fn4(v8),
			buttonHeight = v9 and 0 or 48,
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
					Position = UDim2.new(0, 0, 1, v9 and 0 or -24),
					Size = UDim2.new(1, 0, 0, 24),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					ZIndex = 2
				}, {
					gradient = roact.createElement("UIGradient", {
						Rotation = 270,
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, v6.Theme.BackgroundUIDefault.Color),
							ColorSequenceKeypoint.new(1, v6.Theme.BackgroundUIDefault.Color)
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
