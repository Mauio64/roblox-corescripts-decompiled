local GuiService = game:GetService("GuiService")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Foundation = require(ExpChatParent.Foundation)
local InputType = require(ExpChatParent.InputType)
local React = require(ExpChatParent.React)
local RoactUtils = require(ExpChatParent.RoactUtils)
local SharedFlags = require(ExpChatParent.SharedFlags)
local SignalsReact = require(ExpChatParent.SignalsReact)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FoundationText = Foundation.Text
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local Localization = require(ExpChat.Localization)
local PresetCooldownProvider = require(script.Parent.PresetCooldownProvider)
local PresetMessageButton = require(script.Parent.PresetMessageButton)
local PresetTrayKeyboardSelected = require(ExpChat.Actions.PresetTrayKeyboardSelected)
local Constants = require(ExpChat.PresetChat.Constants)
local setIsPresetTrayOpen = require(script.Parent.Thunks.setIsPresetTrayOpen)
local FFlagExpChatUniverseChatPresetEnabled = require(ExpChat.Flags.FFlagExpChatUniverseChatPresetEnabled)
local FFlagExpChatPresetChatGamepadEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatGamepadEnabled)
local v28 = ExpChatShared.Flags.FIntPresetChatCooldownLuaMs / 1000
local v29 = ExpChatShared.Logger:new("ExpChat/PresetChat/PresetChatContainer")

local function getRBXGeneralChannel() -- line: 40
	-- upvalues: TextChatService (copy)
	local RBXGeneral = TextChatService:FindFirstChild("RBXGeneral", true)

	if RBXGeneral and RBXGeneral:IsA("TextChannel") then
		return RBXGeneral
	end

	return nil
end
local function PresetChatContainer(t1: {[any]: any}) -- line: 48
	-- upvalues: Foundation (copy), GetPresetChatStore (copy), useDispatch (copy), SignalsReact (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), useSelector (copy), Localization (copy), React (copy), setIsPresetTrayOpen (copy), PresetTrayKeyboardSelected (copy), ExpChatShared (copy), Constants (copy), FFlagExpChatPresetChatGamepadEnabled (copy), InputType (copy), UserInputService (copy), GuiService (copy), GetTransparencyStore (copy), TextChatService (copy), v28 (copy), FFlagExpChatUniverseChatPresetEnabled (copy), v29 (copy), PresetMessageButton (copy), FoundationText (copy), PresetCooldownProvider (copy)
	local v34 = Foundation.Hooks.useTokens()
	local v35 = GetPresetChatStore(false)
	local v36 = useDispatch()
	local v37 = SignalsReact.useSignalState(v35.getIsLoading)
	local v38 = SignalsReact.useSignalState(v35.getCategoryGroups)
	local v39 = if not FFlagExpChatUseMessagesStore then useSelector(function(p1) -- line: 61
		return p1.CanLocalUserChat
	end) else SignalsReact.useSignalState(GetMessagesStore(false).getCanLocalUserChat)
	local v40 = Localization.useLocalization({
		footerDescription = "Feature.Chat.PresetChat.Disclaimer"
	})
	local v41 = React.useCallback(function() -- line: 70
		-- upvalues: setIsPresetTrayOpen (copy), v35 (copy)
		setIsPresetTrayOpen(v35, false)
	end, { v35 })
	local v42 = React.useCallback(function() -- line: 74
		-- upvalues: v41 (copy), v36 (copy), PresetTrayKeyboardSelected (copy), ExpChatShared (copy), Constants (copy)
		v41()
		v36(PresetTrayKeyboardSelected())
		ExpChatShared.Analytics:TelemetryLogEvent(ExpChatShared.Analytics.ExpChatPresetActionConfig, {
			event_type = Constants.Analytics.EventTypes.Click,
			component = Constants.Analytics.Components.PresetKeyboardIcon
		}, ExpChatShared.Analytics.DefaultStandardizedFields)
	end, {
		v41,
		v36
	})
	local v43 = React.useRef(nil)
	local v44 = v38 and (#v38 > 0 and v38[1].categoryGroupId) or ""
	local v45, v46 = React.useState(v44)

	React.useEffect(function() -- line: 89
		-- upvalues: v45 (copy), v44 (copy), v46 (copy)
		if v45 == "" and v44 ~= "" then
			v46(v44)
		end
	end, {
		v44,
		v45
	})

	local v47 = if not FFlagExpChatPresetChatGamepadEnabled then nil else SignalsReact.useSignalState(v35.getIsTrayOpen)
	local v48 = React.useRef(nil)

	local function isValidSelection(p2) -- line: 100
		if p2 == nil then
			return false
		end

		local ok, result = pcall(function() -- line: 104
			-- upvalues: p2 (copy)
			return p2:IsDescendantOf(game) and p2:FindFirstAncestorOfClass("ScreenGui") ~= nil
		end)

		return ok and result
	end

	React.useEffect(function() -- line: 111
		-- upvalues: FFlagExpChatPresetChatGamepadEnabled (copy), v47 (copy), v43 (copy), InputType (copy), UserInputService (copy), v48 (copy), GuiService (copy)
		if FFlagExpChatPresetChatGamepadEnabled and not v47 then
			return
		end

		local current = v43.current

		if current == nil then
			return
		end

		if InputType.getInputGroup(UserInputService:GetLastInputType()) ~= InputType.InputTypeConstants.Gamepad then
			return
		end

		if v48.current == nil then
			v48.current = if not FFlagExpChatPresetChatGamepadEnabled then GuiService.SelectedObject else GuiService.SelectedCoreObject
		end

		task.defer(function() -- line: 128
			-- upvalues: current (copy), FFlagExpChatPresetChatGamepadEnabled (copy), GuiService (copy)
			local v81 = current
			local v82

			if v81 == nil then
				v82 = false
			else
				local ok, result = pcall(function() -- line: 104
					-- upvalues: v81 (copy)
					return v81:IsDescendantOf(game) and v81:FindFirstAncestorOfClass("ScreenGui") ~= nil
				end)

				v82 = ok and result
			end

			if v82 then
				pcall(function() -- line: 130
					-- upvalues: FFlagExpChatPresetChatGamepadEnabled (copy), GuiService (copy), current (copy)
					if FFlagExpChatPresetChatGamepadEnabled then
						GuiService.SelectedCoreObject = current

						return
					end

					GuiService.SelectedObject = current
				end)
			end
		end)
	end, if not FFlagExpChatPresetChatGamepadEnabled then { v45 } else {
		v45,
		v47
	})
	React.useEffect(function() -- line: 145
		-- upvalues: GetTransparencyStore (copy), v48 (copy), FFlagExpChatPresetChatGamepadEnabled (copy), GuiService (copy)
		local v77 = GetTransparencyStore(false)

		v77.setContextMenuOpen()

		return function() -- line: 148
			-- upvalues: v77 (copy), v48 (copy), FFlagExpChatPresetChatGamepadEnabled (copy), GuiService (copy)
			v77.clearContextMenuOpen()

			local current = v48.current

			pcall(function() -- line: 151
				-- upvalues: current (copy), FFlagExpChatPresetChatGamepadEnabled (copy), GuiService (copy)
				local v86 = current
				local v87

				if v86 == nil then
					v87 = false
				else
					local ok, result = pcall(function() -- line: 104
						-- upvalues: v86 (copy)
						return v86:IsDescendantOf(game) and v86:FindFirstAncestorOfClass("ScreenGui") ~= nil
					end)

					v87 = ok and result
				end

				if v87 then
					if FFlagExpChatPresetChatGamepadEnabled then
						GuiService.SelectedCoreObject = current

						return
					end

					GuiService.SelectedObject = current

					return
				end

				if FFlagExpChatPresetChatGamepadEnabled then
					GuiService.SelectedCoreObject = nil

					return
				end

				GuiService.SelectedObject = nil
			end)
			v48.current = nil
		end
	end, {})

	local v50 = React.useCallback(function(s1: string) -- line: 170
		-- upvalues: t1 (copy), TextChatService (copy), v35 (copy), v28 (copy), FFlagExpChatUniverseChatPresetEnabled (copy), v29 (copy), v41 (copy)
		local textChannel = t1.textChannel

		if textChannel ~= nil and textChannel.Name ~= "RBXGeneral" then
			local RBXGeneral = TextChatService:FindFirstChild("RBXGeneral", true)

			textChannel = if not RBXGeneral or not RBXGeneral:IsA("TextChannel") then nil else RBXGeneral
		end

		v35.setPresetCooldownEndsAt(os.clock() + v28)

		if not textChannel then
			if not FFlagExpChatUniverseChatPresetEnabled then
				v29:warning("Preset {} activated but no target text channel was provided; skipping send.", s1)
				v35.setPresetCooldownEndsAt(nil)
				v41()

				return
			end

			if not pcall(function() -- line: 192
				-- upvalues: TextChatService (copy), s1 (copy)
				TextChatService:SendUniverseChatPresetAsync(s1)
			end) then
				v35.setPresetCooldownEndsAt(nil)
			end
		elseif not pcall(function() -- line: 199
			-- upvalues: textChannel (ref), s1 (copy)
			textChannel:SendPresetAsync(s1)
		end) then
			v35.setPresetCooldownEndsAt(nil)
		end

		v35.incrementPresetClickCount(s1)
		v41()
	end, {
		t1.textChannel,
		v35,
		v41
	})

	if v37 then
		return React.createElement(Foundation.Text, {
			Text = "Loading presets...",
			tag = "size-full text-body-medium content-muted"
		})
	end

	if not v38 or #v38 == 0 then
		return nil
	end

	local v51 = nil

	for _, v53 in v38 do
		if v45 == v53.categoryGroupId then
			v51 = v53

			break
		end
	end

	local t2 = {
		LineHeight = 1.4,
		Font = Enum.Font.BuilderSansBold,
		FontSize = v34.FontSize.FontSize_300
	}
	local t3 = {}
	local v56 = true

	if v51 then
		for v57, v58 in v51.categories do
			local t4 = {}

			for v60, v61 in v58.messages do
				t4["Msg_" .. v61.presetId] = React.createElement(PresetMessageButton, {
					presetId = v61.presetId,
					text = v61.value,
					layoutOrder = v60,
					onActivated = v50,
					buttonRef = if not v56 then nil else v43
				})
				v56 = false
			end

			t3["Category_" .. v58.categoryId] = React.createElement(Foundation.View, {
				tag = "col gap-small size-full-0 auto-y",
				LayoutOrder = v57
			}, {
				Header = React.createElement(Foundation.Text, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-align-x-left content-default",
					Text = v58.name or v58.categoryId,
					fontStyle = t2
				}),
				Pills = React.createElement(Foundation.View, {
					LayoutOrder = 2,
					tag = "size-full-0 auto-y",
					layout = {
						Wraps = true,
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, v34.Padding.Small)
					}
				}, t4)
			})
		end

		t3.Footer = React.createElement(FoundationText, {
			TextWrapped = true,
			tag = "size-full-0 auto-y text-body-small text-align-x-left content-muted",
			LayoutOrder = #v51.categories + 1,
			Text = v40.footerDescription
		})
	end

	local t5 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v34.Padding.XLarge),
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		})
	}
	local v63 = #v38 > 1

	for v64, v65 in v38 do
		local categoryGroupId = v65.categoryGroupId
		local v67 = categoryGroupId == v45
		local v68 = if not v67 and v63 then v34.Color.Content.Muted else v34.Color.Content.Emphasis
		local t6 = {
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, 36),
			LayoutOrder = v64,
			Text = v65.name or categoryGroupId,
			fontStyle = v34.Typography.LabelMedium,
			textStyle = v68,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		}
		local v70 = if not v67 or not v63 then nil else {
			Indicator = React.createElement("Frame", {
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 2),
				BackgroundColor3 = v34.Color.Content.Emphasis.Color3
			})
		}

		if v63 then
			function t6.onActivated() -- line: 319
				-- upvalues: v46 (copy), categoryGroupId (copy)
				v46(categoryGroupId)
			end
		end

		t5["Tab_" .. categoryGroupId] = React.createElement(FoundationText, t6, v70)
	end

	local t7 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v34.Padding.Large),
			PaddingRight = UDim.new(0, v34.Padding.Large),
			PaddingTop = UDim.new(0, v34.Padding.XSmall)
		}),
		TabsGroup = React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.fromScale(0, 0)
		}, t5),
		KeyboardButton = if not v39 or not t1.shouldShowKeyboardButton then nil else React.createElement(Foundation.IconButton, {
			LayoutOrder = 2,
			isCircular = true,
			isDisabled = false,
			icon = {
				name = "keyboard",
				variant = "Regular"
			},
			variant = Foundation.Enums.ButtonVariant.Utility,
			size = Foundation.Enums.InputSize.Small,
			onActivated = v42
		})
	}

	return React.createElement(PresetCooldownProvider, {}, React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		RootLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		TabRow = React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, t7),
		TabRowBaseline = React.createElement("Frame", {
			LayoutOrder = 2,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = v34.Color.Stroke.Default.Color3,
			BackgroundTransparency = v34.Color.Stroke.Default.Transparency
		}),
		Scroll = React.createElement(Foundation.ScrollView, {
			LayoutOrder = 3,
			tag = "grow size-full-0",
			scroll = {
				scrollBarVisibility = Foundation.Enums.ScrollBarVisibility.Always,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(0, 0, 0, 0)
			}
		}, {
			Categories = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y",
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, v34.Padding.Large)
				},
				padding = {
					top = UDim.new(0, v34.Padding.Large),
					bottom = UDim.new(0, v34.Padding.Large),
					left = UDim.new(0, v34.Padding.Large),
					right = UDim.new(0, v34.Padding.Large)
				}
			}, t3)
		})
	}))
end

return React.memo(PresetChatContainer)
