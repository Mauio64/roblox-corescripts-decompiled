local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local AppStorageService = game:GetService("AppStorageService")
local React = require(ParentParentParent.React)
local UIBlox = require(ParentParentParent.UIBlox)
local v6 = require(ParentParentParent.SocialLibraries).SocialLibraries.config({})
local Localization = require(ParentParentParent.Localization)

require(ParentParentParent.LuauPolyfill)

local Analytics = require(ParentParent.Analytics).Analytics
local EventNames = require(ParentParent.Analytics.EventNames)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local DropdownMenu = UIBlox.App.Menu.DropdownMenu
local IconSize = UIBlox.App.Constant.IconSize
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local UtilityActionIcon = UIBlox.App.Button.UtilityActionIcon
local CallbackInputBox = v6.Components.CallbackInputBox
local getDeepValue = v6.Dictionary.getDeepValue
local useLocalization = Localization.Hooks.useLocalization
local TextKeys = require(ParentParent.Common.TextKeys)
local v23 = game:DefineFastInt("FriendRequestNicknameMinChars", 2)
local v24 = game:DefineFastInt("FriendRequestNicknameMaxChars", 20)
local v25 = game:DefineFastInt("FriendRequestNicknameMaxHistory", 3)
local v26 = game:DefineFastFlag("FriendRequestNicknamesUIBugFixes", false)
local t1 = {
	Invalid = "Invalid",
	Valid = "Valid",
	TooShort = "TooShort",
	TooLong = "TooLong",
	InvalidCharacters = "InvalidCharacters",
	Moderated = "Moderated",
	ModeratedDisplayName = "ModeratedDisplayNameWithNickname",
	UpdateThrottled = "UpdateThrottled"
}
local t2 = {
	TEXTBOX_VERTICAL_PADDING = 8,
	TEXTBOX_HORIZONTAL_PADDING = 12,
	CONTENT_PADDING = 10,
	DROPDOWN_FRAME_HEIGHT_CLOSED = 50,
	DROPDOWN_FRAME_HEIGHT_OPEN_1NICK = 180,
	DROPDOWN_FRAME_HEIGHT_OPEN_2NICKS = 240,
	DROPDOWN_FRAME_HEIGHT_OPEN_3NICKS = 300,
	DROPDOWN_FRAME_POSITION = 300,
	DROPDOWN_HEIGHT = 50,
	MODAL_POSITION = 0.4
}

return function(t3: {[any]: any}) -- line: 77
	-- upvalues: useLocalization (copy), TextKeys (copy), v23 (copy), v24 (copy), useStyle (copy), Analytics (copy), AppStorageService (copy), v25 (copy), React (copy), t2 (copy), v26 (copy), EventNames (copy), t1 (copy), getDeepValue (copy), Images (copy), InteractiveAlert (copy), StyledTextLabel (copy), ImageSetLabel (copy), CallbackInputBox (copy), IconSize (copy), DropdownMenu (copy), UtilityActionIcon (copy), ButtonType (copy)
	local v30 = useLocalization({
		titleText = TextKeys.TitleText,
		bodyText = if not t3.recipientDisplayName then { TextKeys.BodyTextNoDisplayName } else {
			TextKeys.BodyText,
			displayName = "<font weight=\"medium\">" .. t3.recipientDisplayName .. "</font>"
		},
		privacyText = if not t3.recipientDisplayName then { TextKeys.PrivacyTextNoDisplayName } else {
			TextKeys.PrivacyText,
			displayName = t3.recipientDisplayName
		},
		skipButtonText = TextKeys.Skip,
		addNicknameText = TextKeys.AddNickname,
		dropdownEntryText = TextKeys.NicknameDropdownLabel,
		errorInvalidText = TextKeys.ErrorMessageInvalid,
		errorTooShortText = TextKeys.ErrorTooShort,
		errorTooLongText = TextKeys.ErrorTooLong,
		errorInvalidCharactersText = TextKeys.ErrorInvalidCharacters,
		errorModeratedText = TextKeys.ErrorModerated,
		errorThrottledText = TextKeys.ErrorMessageThrottled,
		dropdownPlaceholder = TextKeys.DropdownPlaceholder,
		textboxPlaceholder = TextKeys.TextboxPlaceholder
	})
	local v31 = v23
	local v32 = v24
	local v33 = useStyle()
	local v34 = Analytics()
	local Theme = v33.Theme
	local Font = v33.Font
	local v37 = Font.BaseSize * Font.Body.RelativeSize
	local s1 = ""

	if game:GetEngineFeature("FriendRequestNicknameHistoryStorageKey") then
		local ok, result = pcall(function() -- line: 132
			-- upvalues: AppStorageService (copy)
			return {
				nicknames = AppStorageService:GetItem("FriendRequestNicknameHistory")
			}
		end)

		s1 = (not ok or (not result or result.nicknames == "")) and "" or result.nicknames
	end

	if t3.nicknameHistory then
		s1 = t3.nicknameHistory
	end

	local u41 = if s1 ~= "" then string.split(s1, ",") else {}

	while #u41 > v25 do
		table.remove(u41, 1)
	end

	local v42 = #u41

	if s1 == "" then
		t3.setOnTextInput(true)
	end

	local v43, v44 = React.useState("")
	local v45, v46 = React.useState("")
	local v47, v48 = React.useState(0)
	local v49, v50 = React.useState(t2.DROPDOWN_FRAME_HEIGHT_CLOSED)

	if v26 then
		if t3.onTextInput then
			if t3.screenSize.X > t3.screenSize.Y then
				t2.MODAL_POSITION = 0.28
			else
				t2.MODAL_POSITION = 0.4
			end
		else
			t2.MODAL_POSITION = 0.5
		end
	elseif t3.screenSize.X > t3.screenSize.Y then
		t2.MODAL_POSITION = 0.3
	else
		t2.MODAL_POSITION = 0.4
	end

	local v51 = React.useRef(nil)

	local function v52(p1) -- line: 190
		-- upvalues: u41 (ref), v25 (copy), AppStorageService (copy)
		if game:GetEngineFeature("FriendRequestNicknameHistoryStorageKey") then
			if p1 == "" then
				return
			end

			for i, v in ipairs(u41) do
				if v == p1 then
					table.remove(u41, i)

					break
				end
			end

			table.insert(u41, p1)

			while #u41 > v25 do
				table.remove(u41, 1)
			end

			local v60 = if #u41 ~= 0 then table.concat(u41, ",") else p1

			AppStorageService:SetItem("FriendRequestNicknameHistory", v60)
			AppStorageService:Flush()
		end
	end

	local v53 = React.useCallback(function() -- line: 257
		-- upvalues: t3 (copy), v34 (copy), EventNames (copy), s1 (ref)
		t3.sendFriendRequest()
		v34.fireAnalyticsEvent(EventNames.SetNicknameSkipClicked, {
			friendshipOriginSourceType = t3.friendRequestSource,
			previousNicknames = s1
		})
		t3.navigateBack()
	end, {
		t3.sendFriendRequest,
		t3.navigateBack
	})

	React.useEffect(function() -- line: 266
		-- upvalues: v34 (copy), EventNames (copy), t3 (copy), s1 (ref)
		v34.fireAnalyticsEvent(EventNames.SetNicknameModalOpened, {
			friendshipOriginSourceType = t3.friendRequestSource,
			previousNicknames = s1
		})
	end, {})

	local function v54(s2: string) -- line: 273
		-- upvalues: t3 (copy), v31 (copy), v48 (copy), v46 (copy), v30 (copy), v32 (copy), v47 (copy), v43 (copy), v51 (copy), getDeepValue (copy), t1 (copy), v44 (copy)
		t3.setSaveButtonEnabled(false)

		local v64 = utf8.len(s2)

		if v64 == nil then
			return
		end

		if v64 < v31 then
			v48(v64)
			v46(v30.errorTooShortText)

			return
		end

		if v64 > v32 then
			s2 = if v47 ~= v32 then string.sub(s2, 1, utf8.offset(s2, v32 + 1) - 1) else v43
			v64 = v32

			if v51 and v51.current then
				v51.current.Text = s2
			end
		end

		t3.validateNickname(s2):andThen(function(p2) -- line: 313
			-- upvalues: getDeepValue (copy), v46 (copy), t1 (copy), v30 (copy), t3 (copy), v44 (copy), s2 (ref)
			local v70 = getDeepValue(p2, "responseBody.status")

			if v70 ~= "Valid" then
				v46(if v70 ~= t1.Invalid then if v70 ~= t1.TooShort then if v70 ~= t1.TooLong then if v70 ~= t1.InvalidCharacters then if v70 ~= t1.Moderated then if v70 ~= t1.ModeratedDisplayName then v70 ~= t1.UpdateThrottled and "" or v30.errorThrottledText else v30.errorModeratedText else v30.errorModeratedText else v30.errorInvalidCharactersText else v30.errorTooLongText else v30.errorTooShortText else v30.errorInvalidText)
				t3.setSaveButtonEnabled(false)

				return
			end

			v46("")
			t3.setSaveButtonEnabled(true)
			v44(s2)
		end):catch(function(_) -- line: 325
			-- upvalues: v46 (copy), v30 (copy), t3 (copy)
			v46(v30.errorInvalidText)
			t3.setSaveButtonEnabled(false)
		end)
		v48(v64)
		v44(s2)
	end
	local function v55() -- line: 335
		-- upvalues: Images (copy), v30 (copy), s1 (ref), u41 (ref)
		local t4 = {{
			key = "item0",
			icon = Images["icons/actions/edit/edit"],
			text = v30.dropdownEntryText
		}}

		if s1 ~= "" then
			for i = #u41, 1, -1 do
				local v67 = u41[i]

				table.insert(t4, {
					key = "item" .. i,
					text = v67
				})
			end
		end

		return t4
	end

	return React.createElement(InteractiveAlert, {
		title = v30.titleText,
		titleIcon = Images["icons/status/success_large"],
		position = UDim2.new(0.5, 0, t2.MODAL_POSITION, 0),
		screenSize = t3.screenSize,
		middleContent = function() -- line: 362
			-- upvalues: React (copy), t2 (copy), StyledTextLabel (copy), v30 (copy), Font (copy), Theme (copy), t3 (copy), ImageSetLabel (copy), v37 (copy), Images (copy), v45 (copy), CallbackInputBox (copy), v43 (copy), IconSize (copy), v54 (copy), v51 (copy), s1 (ref), v49 (copy), DropdownMenu (copy), v44 (copy), u41 (ref), v42 (copy), v50 (copy), v55 (copy), UtilityActionIcon (copy), v47 (copy), v32 (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 0, t2.DROPDOWN_FRAME_POSITION),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, t2.CONTENT_PADDING),
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Description = React.createElement(StyledTextLabel, {
					layoutOrder = 1,
					textWrapped = true,
					lineHeight = 1,
					fluidSizing = false,
					text = v30.bodyText,
					size = UDim2.new(1, 0, 0, 0),
					fontStyle = Font.Body,
					colorStyle = Theme.TextEmphasis,
					textXAlignment = Enum.TextXAlignment.Center,
					textYAlignment = Enum.TextYAlignment.Center,
					automaticSize = Enum.AutomaticSize.Y
				}),
				Notice = React.createElement(StyledTextLabel, {
					layoutOrder = 3,
					textWrapped = true,
					lineHeight = 1,
					fluidSizing = false,
					text = v30.privacyText,
					size = UDim2.new(1, 0, 0, 0),
					fontStyle = Font.CaptionBody,
					colorStyle = Theme.TextMuted,
					textXAlignment = Enum.TextXAlignment.Center,
					textYAlignment = Enum.TextYAlignment.Center,
					automaticSize = Enum.AutomaticSize.Y
				}),
				InputBackground = if not t3.onTextInput then nil else React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 6,
					Size = UDim2.new(1, 0, 0, v37 + t2.TEXTBOX_VERTICAL_PADDING * 2),
					Image = Images["component_assets/circle_21"],
					ImageTransparency = Theme.UIMuted.Transparency,
					ScaleType = Enum.ScaleType.Slice,
					ImageColor3 = Theme.UIMuted.Color,
					SliceCenter = Rect.new(8, 8, 9, 9)
				}, {
					InputBorder = React.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, v37 + t2.TEXTBOX_VERTICAL_PADDING * 2),
						Image = Images["component_assets/circle_21_stroke_1"],
						ScaleType = Enum.ScaleType.Slice,
						ImageColor3 = if v45 == "" then Theme.Divider.Color else Theme.Alert.Color,
						SliceCenter = Rect.new(8, 8, 9, 9)
					}, {
						Padding = React.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, t2.TEXTBOX_HORIZONTAL_PADDING),
							PaddingRight = UDim.new(0, t2.TEXTBOX_HORIZONTAL_PADDING)
						}),
						InputTextbox = React.createElement(CallbackInputBox, {
							captureFocusOnMount = true,
							clearButtonDisabled = false,
							inputTextColor3 = Theme.TextDefault.Color,
							inputTextXAlignment = Enum.TextXAlignment.Left,
							inputTextTransparency = Theme.TextDefault.Transparency,
							inputTextSize = v37,
							initialInputText = v43,
							placeholderText = v30.textboxPlaceholder,
							placeholderTextColor3 = Theme.TextDefault.Color,
							clearIcon = Images["icons/actions/edit/clear_small"],
							clearIconColor3 = Theme.IconEmphasis.Color,
							clearButtonSize = IconSize.Small,
							textChangedCallback = v54,
							inputBoxRef = v51
						})
					})
				}),
				Dropdown = if t3.onTextInput or s1 == "" then if s1 == "" then React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 5,
					Size = UDim2.new(1, 0, 0, 10)
				}, {
					Layout = React.createElement("UIListLayout", {
						Padding = UDim.new(0, t2.CONTENT_PADDING),
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					PlaceholderElement = React.createElement(StyledTextLabel, {
						layoutOrder = 5,
						text = "",
						textWrapped = true,
						lineHeight = 1,
						fluidSizing = false,
						fontStyle = Font.Header2,
						colorStyle = Theme.TextMuted,
						textTruncate = Enum.TextTruncate.AtEnd,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Center
					})
				}) else React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 5,
					Size = UDim2.new(1, 0, 0, 30)
				}, {
					TextFrame = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 5,
						Size = UDim2.new(1, 0, 0, 30)
					}, {
						Layout = React.createElement("UIListLayout", {
							Padding = UDim.new(0, t2.CONTENT_PADDING),
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						Padding = React.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, t2.TEXTBOX_HORIZONTAL_PADDING)
						}),
						Text = React.createElement(StyledTextLabel, {
							layoutOrder = 5,
							textWrapped = true,
							lineHeight = 1,
							fluidSizing = false,
							text = v30.dropdownEntryText,
							fontStyle = Font.Header2,
							colorStyle = Theme.TextMuted,
							textTruncate = Enum.TextTruncate.AtEnd,
							textXAlignment = Enum.TextXAlignment.Left,
							textYAlignment = Enum.TextYAlignment.Center
						})
					}),
					CancelFrame = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 5,
						Size = UDim2.new(1, 0, 0, 30)
					}, {
						Layout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Right,
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						Cancel = React.createElement(UtilityActionIcon, {
							layoutOrder = 6,
							iconSize = IconSize.Small,
							icon = Images["icons/actions/edit/clear"],
							onActivated = function() -- line: 532
								-- upvalues: t3 (copy), v50 (copy), t2 (copy)
								t3.setOnTextInput(false)
								v50(t2.DROPDOWN_FRAME_HEIGHT_CLOSED)
							end
						})
					})
				}) else React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 5,
					Size = UDim2.new(1, 0, 0, v49)
				}, {
					DropdownMenu = React.createElement(DropdownMenu, {
						errorState = false,
						showDropShadow = true,
						dropdownMenuListPositionFixed = true,
						placeholder = v30.dropdownPlaceholder,
						height = UDim.new(0, t2.DROPDOWN_HEIGHT),
						onChange = function(p4) -- line: 456
							-- upvalues: t3 (copy), v44 (copy), u41 (ref)
							local num = tonumber(string.gsub(p4, "%D", ""))

							if num then
								if num == 0 then
									t3.setOnTextInput(true)

									return
								end

								v44(u41[num])
								t3.setSaveButtonEnabled(true)
							end
						end,
						onMenuOpenChange = function(p5) -- line: 470
							-- upvalues: v42 (copy), v50 (copy), t2 (copy)
							if p5 then
								if v42 == 3 then
									v50(t2.DROPDOWN_FRAME_HEIGHT_OPEN_3NICKS)

									return
								end

								if v42 == 2 then
									v50(t2.DROPDOWN_FRAME_HEIGHT_OPEN_2NICKS)

									return
								end

								if v42 == 1 then
									v50(t2.DROPDOWN_FRAME_HEIGHT_OPEN_1NICK)

									return
								end

								v50(t2.DROPDOWN_FRAME_HEIGHT_CLOSED)

								return
							end

							v50(t2.DROPDOWN_FRAME_HEIGHT_CLOSED)
						end,
						screenSize = t3.screenSize,
						cellDatas = v55()
					})
				}),
				Counter = if not t3.onTextInput then nil else React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 7,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						Padding = UDim.new(0, t2.CONTENT_PADDING / 2),
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					CountText = React.createElement(StyledTextLabel, {
						layoutOrder = 1,
						fontStyle = Font.CaptionBody,
						text = string.format("%d/%d", v47, v32),
						colorStyle = if v47 ~= v32 then Theme.TextMuted else Theme.Alert,
						textXAlignment = Enum.TextXAlignment.Center,
						textYAlignment = Enum.TextYAlignment.Top
					}),
					ErrorText = if v45 == "" then nil else React.createElement(StyledTextLabel, {
						layoutOrder = 2,
						fontStyle = Font.CaptionBody,
						text = v45,
						colorStyle = Theme.Alert,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Top
					})
				})
			})
		end,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = v53,
						text = v30.skipButtonText
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = function() -- line: 240
							-- upvalues: t3 (copy), v43 (copy), v34 (copy), EventNames (copy), s1 (ref), v52 (copy), v46 (copy), t1 (copy), v30 (copy)
							t3.sendFriendRequestWithNickname(v43):andThen(function(_) -- line: 243
								-- upvalues: v34 (copy), EventNames (copy), t3 (copy), s1 (ref), v43 (copy), v52 (copy)
								v34.fireAnalyticsEvent(EventNames.SetNicknameAddNameClicked, {
									friendshipOriginSourceType = t3.friendRequestSource,
									previousNicknames = s1,
									submittedNickname = v43
								})
								v52(v43)
								t3.navigateBack()
							end):catch(function() -- line: 252
								-- upvalues: v46 (copy), t1 (copy), v30 (copy)
								v46(if t1.Invalid ~= "Invalid" then if t1.TooShort ~= "Invalid" then if t1.TooLong ~= "Invalid" then if t1.InvalidCharacters ~= "Invalid" then if t1.Moderated ~= "Invalid" then if t1.ModeratedDisplayName ~= "Invalid" then t1.UpdateThrottled ~= "Invalid" and "" or v30.errorThrottledText else v30.errorModeratedText else v30.errorModeratedText else v30.errorInvalidCharactersText else v30.errorTooLongText else v30.errorTooShortText else v30.errorInvalidText)
							end)
						end,
						text = v30.addNicknameText,
						isDisabled = not t3.isSaveButtonEnabled
					}
				}
			}
		}
	})
end
