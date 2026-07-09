local ContactImporter = script:FindFirstAncestor("ContactImporter")
local ContactImporterParent = ContactImporter.Parent
local dependencies = require(ContactImporter.dependencies)
local useAppPolicy = require(ContactImporterParent.UniversalAppPolicy).useAppPolicy
local useDispatch = require(ContactImporterParent.RoactUtils).Hooks.RoactRodux.useDispatch
local Roact = dependencies.Roact
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local useLocalization = dependencies.useLocalization
local useStyle = dependencies.useStyle
local FullPageModal = UIBlox.App.Dialog.Modal.FullPageModal
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local SectionList = dependencies.SectionList
local TextKeys = require(ContactImporter.Common.TextKeys)
local ContactsListEntry = require(ContactImporter.ContactsList.Components.ContactsListEntry)
local ContactsListInviteEntry = require(ContactImporter.ContactsList.Components.ContactsListInviteEntry)
local ContactsEmptyList = require(ContactImporter.ContactsList.Components.ContactsEmptyList)
local ContactsUploadErrorModal = require(ContactImporter.ContactsList.Components.ContactsUploadErrorModal)
local ContactsGlimmer = require(ContactImporter.ContactsList.Components.ContactsGlimmer)
local ContactsSyncWarningMessage = require(ContactImporter.ContactsList.Components.ContactsSyncWarningMessage)
local EventNames = require(ContactImporter.Analytics).EventNames

require(ContactImporter.Common.LocalTypes)

local ContactsListSearchBar = require(ContactImporter.ContactsList.Components.ContactsListSearchBar)
local Dash = dependencies.Dash
local Foundation = require(ContactImporterParent.Foundation)
local InputLabel = Foundation.InputLabel
local InputLabelSize = Foundation.Enums.InputLabelSize
local AppPage = require(ContactImporterParent.RobloxAppEnums).AppPage
local NavigateDown = require(ContactImporterParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ContactImporterParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v32 = if not FFlagSignalsNavP3Dispatch then nil else require(ContactImporterParent.RobloxAppNavigation).NavigationCommands
local ContactImportButtonsIXP = require(ContactImporter.Flags.ContactImportButtonsIXP)
local v34 = game:DefineFastFlag("ContactImportButtonsExperimentEnabled", false)
local FFlagAddFriendsBannersNewUI_IXP = require(ContactImporterParent.SharedFlags).FFlagAddFriendsBannersNewUI_IXP
local IXPService = game:GetService("IXPService")
local uprankContactsWithEmoji = require(ContactImporter.Utils).uprankContactsWithEmoji
local FFlagContactsListEmojiSorting = require(ContactImporter.Flags.FFlagContactsListEmojiSorting)
local v39 = game:DefineFastFlag("ContactsListEmojiSortingIxpEnabled", false)
local v40 = game:DefineFastString("ContactsListEmojiSortingIxpLayer", "Social.ContactListEmojiSorting")
local FFlagQRCodeCopyUpdates = require(ContactImporterParent.SharedFlags).FFlagQRCodeCopyUpdates
local FFlagConnectionsToFriendsRename = require(ContactImporterParent.SharedFlags).FFlagConnectionsToFriendsRename
local FStringCanAccessTrustedContactsAmpFeature = require(ContactImporterParent.SharedFlags).FStringCanAccessTrustedContactsAmpFeature
local FStringIsUserInTcEligibleCountryAmpFeature = require(ContactImporterParent.SharedFlags).FStringIsUserInTcEligibleCountryAmpFeature
local FFlagTCPolicyCheckRedirect = require(ContactImporterParent.SharedFlags).FFlagTCPolicyCheckRedirect
local FStringCanAccessTrustedContactsAmpNameSpace = require(ContactImporterParent.SharedFlags).FStringCanAccessTrustedContactsAmpNameSpace
local AmpApiProvider = require(ContactImporterParent.AmpUpsell).AmpApiProvider
local AmpEnums = require(ContactImporterParent.AmpUpsell).AmpEnums
local UserInputService = dependencies.UserInputService

local function ContactsList(t1: {[any]: any}) -- line: 98
	-- upvalues: useAppPolicy (copy), useStyle (copy), useDispatch (copy), useLocalization (copy), TextKeys (copy), FFlagQRCodeCopyUpdates (copy), FFlagConnectionsToFriendsRename (copy), v34 (copy), ContactImportButtonsIXP (copy), Dash (copy), EventNames (copy), React (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v32 (copy), NavigateDown (copy), FFlagContactsListEmojiSorting (copy), uprankContactsWithEmoji (copy), v39 (copy), IXPService (copy), v40 (copy), FFlagTCPolicyCheckRedirect (copy), FStringIsUserInTcEligibleCountryAmpFeature (copy), FStringCanAccessTrustedContactsAmpFeature (copy), AmpApiProvider (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), AmpEnums (copy), Roact (copy), ContactsListEntry (copy), ContactsListInviteEntry (copy), StyledTextLabel (copy), ButtonType (copy), UserInputService (copy), FFlagAddFriendsBannersNewUI_IXP (copy), ContactsSyncWarningMessage (copy), SectionList (copy), ContactsEmptyList (copy), InputLabel (copy), InputLabelSize (copy), ContactsListSearchBar (copy), ContactsGlimmer (copy), ContactsUploadErrorModal (copy), FullPageModal (copy), HorizontalPageMargin (copy)
	local v52 = useAppPolicy(function(p1) -- line: 99
		return p1.getWebViewSupport()
	end)
	local v53 = useStyle()
	local v54 = useDispatch()
	local v55 = useLocalization({
		learnMore = "Feature.Chat.Action.LearnMore",
		fromContactsText = TextKeys.ON_ROBLOX,
		inviteToRobloxText = TextKeys.INVITE_TO_ROBLOX,
		contactsListBlurb = TextKeys.CONTACTS_LIST_DESCRIPTION,
		contactsListTCEducationBlurb = if not FFlagQRCodeCopyUpdates then nil else TextKeys.ADD_CONTACTS_AS_TRUSTED_CONNECTION_DESCRIPTION,
		contactsListTFEducationBlurb = if not FFlagConnectionsToFriendsRename then nil else TextKeys.ADD_CONTACTS_AS_TRUSTED_FRIENDS_DESCRIPTION,
		connectWithFriends = TextKeys.CONTACTS_LIST_TITLE,
		closeModal = TextKeys.CLOSE_MODAL,
		goToAddFriends = TextKeys.GO_TO_ADD_FRIENDS,
		searchContacts = TextKeys.SEARCH_CONTACTS
	})
	local v56 = not not v34 and ContactImportButtonsIXP.useIsRemoveCloseButtonExperimentEnabled({
		isExposureEnabled = true
	})

	local function v57() -- line: 131
		-- upvalues: t1 (copy), EventNames (copy)
		t1.closeModal(EventNames.CloseContactListButton)
	end

	local v58 = React.useCallback(function() -- line: 139
		-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v32 (copy), v54 (copy), NavigateDown (copy)
		local t2 = {
			detail = "https://en.help.roblox.com/hc/en-us/articles/37725513985812",
			name = AppPage.GenericWebPage,
			extraProps = {
				title = ""
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v32.down(v32.fromLegacyPage(t2))

			return
		end

		v54(NavigateDown(t2, nil))
	end, { v54 })
	local v59, v60 = React.useState("")
	local v61 = if not FFlagContactsListEmojiSorting then nil else React.useMemo(function() -- line: 171
		-- upvalues: uprankContactsWithEmoji (copy), t1 (copy)
		return uprankContactsWithEmoji(t1.matchedContacts)
	end, { t1.matchedContacts })
	local v62 = if not FFlagContactsListEmojiSorting then nil else React.useMemo(function() -- line: 176
		-- upvalues: uprankContactsWithEmoji (copy), t1 (copy)
		return uprankContactsWithEmoji(t1.deviceContacts)
	end, { t1.deviceContacts })
	local v63

	if FFlagContactsListEmojiSorting then
		v63 = Dash.filter(v61, function(p2) -- line: 157
			-- upvalues: v59 (copy)
			if p2.contactName ~= nil then
				if not p2.contactName:match("^%s*$") then
					return string.find(string.lower(p2.contactName or ""), string.lower(v59)) ~= nil
				end

				return false
			end

			return string.find(string.lower(p2.contactName or ""), string.lower(v59)) ~= nil
		end)
	else
		local matchedContacts = t1.matchedContacts

		v63 = Dash.filter(matchedContacts, function(p3) -- line: 157
			-- upvalues: v59 (copy)
			if p3.contactName ~= nil then
				if not p3.contactName:match("^%s*$") then
					return string.find(string.lower(p3.contactName or ""), string.lower(v59)) ~= nil
				end

				return false
			end

			return string.find(string.lower(p3.contactName or ""), string.lower(v59)) ~= nil
		end)
	end

	local v65

	if FFlagContactsListEmojiSorting then
		v65 = Dash.filter(v62, function(p4) -- line: 157
			-- upvalues: v59 (copy)
			if p4.contactName ~= nil then
				if not p4.contactName:match("^%s*$") then
					return string.find(string.lower(p4.contactName or ""), string.lower(v59)) ~= nil
				end

				return false
			end

			return string.find(string.lower(p4.contactName or ""), string.lower(v59)) ~= nil
		end)
	else
		local deviceContacts = t1.deviceContacts

		v65 = Dash.filter(deviceContacts, function(p5) -- line: 157
			-- upvalues: v59 (copy)
			if p5.contactName ~= nil then
				if not p5.contactName:match("^%s*$") then
					return string.find(string.lower(p5.contactName or ""), string.lower(v59)) ~= nil
				end

				return false
			end

			return string.find(string.lower(p5.contactName or ""), string.lower(v59)) ~= nil
		end)
	end

	if v39 then
		React.useEffect(function() -- line: 191
			-- upvalues: IXPService (copy), v40 (copy)
			IXPService:LogFlagLinkedUserLayerExposure(v40)
		end, {})
	end

	local v67, v68 = React.useState(false)

	if FFlagQRCodeCopyUpdates then
		React.useEffect(function() -- line: 199
			-- upvalues: FFlagTCPolicyCheckRedirect (copy), FStringIsUserInTcEligibleCountryAmpFeature (copy), FStringCanAccessTrustedContactsAmpFeature (copy), AmpApiProvider (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), AmpEnums (copy), v68 (copy)
			local v90 = if not FFlagTCPolicyCheckRedirect then FStringCanAccessTrustedContactsAmpFeature else FStringIsUserInTcEligibleCountryAmpFeature

			if AmpApiProvider.upsellFeatureAccess(v90, {}, FStringCanAccessTrustedContactsAmpNameSpace).access == AmpEnums.AccessResponseEnum.Granted then
				v68(true)
			end
		end)
	end

	local t3 = {};

	(function(p6, p7, p8) -- line: 126
		-- upvalues: Dash (copy)
		local v83 = if #p7 == 0 then nil else {{
			isSectionDivider = true
		}}

		Dash.append(p6, p7, v83, p8)
	end)(t3, v63, v65)

	local t4 = {}

	if #v63 > 0 then
		table.insert(t4, {
			data = v63,
			title = v55.fromContactsText,
			sectionNumber = #t4 + 1
		})
	end

	if #v65 > 0 then
		table.insert(t4, {
			data = v65,
			title = v55.inviteToRobloxText,
			sectionNumber = #t4 + 1
		})
	end

	local StatusBarSizeY = UserInputService.StatusBarSize.Y
	local v72 = if not FFlagAddFriendsBannersNewUI_IXP then nil else ContactsSyncWarningMessage.useIsVisible()
	local t5 = {
		layout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		contactsSyncWarning = if not FFlagAddFriendsBannersNewUI_IXP or not v72 then nil else React.createElement(ContactsSyncWarningMessage.Component, {
			layoutOrder = -1
		})
	}
	local v74 = React.createRef()
	local v75 = if #t3 == 0 then Roact.createElement(ContactsEmptyList, {
		layoutOrder = 8,
		errorTextKey = TextKeys.NO_RESULTS
	}) else Roact.createElement(SectionList, {
		initialNumToRender = 15,
		ref = v74,
		sections = t4,
		renderSectionHeader = if not (#v63 > 0) then nil else function(p9) -- line: 272
			-- upvalues: Roact (copy), StyledTextLabel (copy), v53 (copy)
			if p9.section then
				return Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					layout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical
					}),
					padding = if p9.section.sectionNumber == 1 then nil else Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, 24)
					}),
					Roact.createElement("Frame", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 24)
					}, {
						sectionHeaderTextLabel = Roact.createElement(StyledTextLabel, {
							fontStyle = v53.Font.Header2,
							colorStyle = v53.Theme.TextDefault,
							text = p9.section.title or ""
						})
					})
				})
			end

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 24)
			}, {
				divider = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 0.5, 0),
					BackgroundColor3 = v53.Theme.Divider.Color,
					BackgroundTransparency = v53.Theme.Divider.Transparency
				})
			})
		end,
		renderItem = function(p10) -- line: 233
			-- upvalues: Roact (copy), v53 (copy), ContactsListEntry (copy), v55 (copy), t1 (copy), ContactsListInviteEntry (copy)
			local item = p10.item

			if item.isSectionDivider then
				local v93 = p10.index ~= 1

				return Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 24)
				}, {
					divider = Roact.createElement("Frame", {
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 1),
						Position = UDim2.new(0, 0, not v93 and 0.5 or 0.5, 0),
						BackgroundColor3 = v53.Theme.Divider.Color,
						BackgroundTransparency = v53.Theme.Divider.Transparency
					})
				})
			end

			if item.isMatchedContact then
				return Roact.createElement(ContactsListEntry, {
					hasDivider = true,
					contactName = item.contactName,
					contactId = item.contactId,
					contextualInfo = v55.fromContactsText,
					hasSentRequest = item.hasSentRequest,
					requestFriendship = t1.requestFriendship,
					openProfilePeekView = t1.openProfilePeekView,
					headshotThumbnailUrl = item.headshotThumbnailUrl,
					avatarThumbnailUrl = item.avatarThumbnailUrl
				})
			end

			return Roact.createElement(ContactsListInviteEntry, {
				hasDivider = true,
				contactName = item.contactName,
				deviceContactId = item.deviceContactId,
				phoneNumber = item.phoneNumber,
				hasSentRequest = item.hasSentRequest
			})
		end,
		CanvasSize = UDim2.new(1, 0, 0, #t3 * 73),
		contentContainerStyle = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		style = {
			BackgroundTransparency = 1,
			ScrollBarThickness = 0,
			LayoutOrder = 8,
			Size = UDim2.new(1, 0, 1, -80 - (not v56 and 48 or 0) - 36 - 16),
			ElasticBehavior = Enum.ElasticBehavior.Always
		}
	})
	local t6 = {
		layout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		contactsSyncWarning = if not FFlagAddFriendsBannersNewUI_IXP or not v72 then nil else React.createElement(ContactsSyncWarningMessage.Component, {
			layoutOrder = -1
		}),
		spacer1 = if not FFlagAddFriendsBannersNewUI_IXP or not v72 then Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 24)
		}) else nil,
		descriptionFrame = if not FFlagAddFriendsBannersNewUI_IXP or not v72 then Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 80)
		}, {
			textLayout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = if not FFlagQRCodeCopyUpdates or not v67 then Enum.HorizontalAlignment.Center else Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			descriptionText = Roact.createElement(StyledTextLabel, {
				lineHeight = 1,
				layoutOrder = 1,
				text = if not FFlagQRCodeCopyUpdates or not v67 then v55.contactsListBlurb else if not FFlagConnectionsToFriendsRename then v55.contactsListTCEducationBlurb else v55.contactsListTFEducationBlurb,
				automaticSize = Enum.AutomaticSize.Y,
				colorStyle = v53.Theme.TextDefault,
				fontStyle = v53.Font.Body,
				size = UDim2.new(1, 0, 0, 0),
				maxSize = Vector2.new(0, 80),
				textXAlignment = if not FFlagQRCodeCopyUpdates or not v67 then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center
			}),
			LearnMoreWebLink = v52 and React.createElement(InputLabel, {
				LayoutOrder = 2,
				tag = "auto-y size-full-0",
				RichText = true,
				Text = `<u>{ v55.learnMore }</u>`,
				size = InputLabelSize.Large,
				onActivated = v58
			})
		}) else nil,
		spacer2 = if not FFlagAddFriendsBannersNewUI_IXP or not v72 then Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 24)
		}) else nil,
		searchBarContainer = Roact.createElement(ContactsListSearchBar, {
			height = 36,
			layoutOrder = 4,
			textChangeCallback = function(p11) -- line: 393
				-- upvalues: v60 (copy)
				v60(p11)
			end
		}),
		spacer4 = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 7,
			Size = UDim2.new(1, 0, 0, 16)
		}),
		contactsList = v75
	}

	if t1.isFetching then
		for _, v78 in {
			1,
			2,
			3
		} do
			t5["glimmer" .. v78] = Roact.createElement(ContactsGlimmer, {
				layoutOrder = v78
			})
		end
	elseif t1.hasUploadError and #t1.matchedContacts + #t1.deviceContacts == 0 then
		t5.errorModal = Roact.createElement(ContactsUploadErrorModal)
	elseif #t1.matchedContacts + #t1.deviceContacts == 0 then
		t5.emptyList = Roact.createElement(ContactsEmptyList)
	else
		t5 = t6
	end

	return Roact.createElement(FullPageModal, {
		marginSize = 0,
		title = v55.connectWithFriends,
		screenSize = t1.screenSize,
		distanceFromTop = StatusBarSizeY,
		onCloseClicked = function() -- line: 135
			-- upvalues: t1 (copy), EventNames (copy)
			t1.closeModal(EventNames.CloseContactListCross)
		end,
		buttonStackProps = {
			buttons = (function(p12) -- line: 317
				-- upvalues: t1 (copy), ButtonType (copy), Dash (copy), v56 (copy), v57 (copy)
				if t1.isFetching then
					return {{
						buttonType = ButtonType.PrimarySystem,
						props = {
							isLoading = true,
							onActivated = Dash.noop
						}
					}}
				end

				if t1.showAddFriendsButton and #t1.matchedContacts + #t1.deviceContacts == 0 then
					if v56 then
						return {{
							buttonType = ButtonType.PrimarySystem,
							props = {
								onActivated = t1.onAddFriendsActivated,
								text = p12.goToAddFriends
							}
						}}
					end

					return {
						{
							buttonType = ButtonType.PrimarySystem,
							props = {
								onActivated = t1.onAddFriendsActivated,
								text = p12.goToAddFriends
							}
						},
						{
							buttonType = ButtonType.Secondary,
							props = {
								onActivated = v57,
								text = p12.closeModal
							}
						}
					}
				end

				if v56 then
					return {}
				end

				return {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = v57,
						text = p12.closeModal
					}
				}}
			end)(v55),
			buttonHeight = not v56 and 48 or 0,
			forcedFillDirection = Enum.FillDirection.Vertical
		}
	}, {
		hpm = Roact.createElement(HorizontalPageMargin, {
			backgroundTransparency = 1,
			size = UDim2.new(1, 0, 1, 0),
			position = UDim2.new(0, 0, 0, 0)
		}, {
			contentFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, t5),
			gradientFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ZIndex = 2,
				Position = UDim2.new(0, 0, 1, not v56 and -24 or 0),
				Size = UDim2.new(1, 0, 0, 24),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			}, {
				gradient = Roact.createElement("UIGradient", {
					Rotation = 270,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, v53.Theme.BackgroundUIDefault.Color),
						ColorSequenceKeypoint.new(1, v53.Theme.BackgroundUIDefault.Color)
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			})
		})
	})
end

return ContactsList
