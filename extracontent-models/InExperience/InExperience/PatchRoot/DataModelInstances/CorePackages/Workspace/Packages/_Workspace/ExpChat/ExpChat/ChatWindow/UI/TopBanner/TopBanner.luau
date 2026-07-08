local GuiService = game:GetService("GuiService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local Localization = require(ExpChatParent.RobloxAppLocales).Localization
local LocalizationService = game:GetService("LocalizationService")
local LocalizationProvider = require(ExpChatParent.Localization).LocalizationProvider
local ChatBoxContextMenu = require(ExpChatParent.ChatLineReporting).ChatBoxContextMenu
local Constants = require(ExpChatParent.ChatLineReporting).Constants
local FocusNavigationUtils = require(ExpChatParent.FocusNavigationUtils)
local GetFFlagMemoizeChatReportingMenu = require(ExpChatParent.SharedFlags).GetFFlagMemoizeChatReportingMenu
local ReactFocusNavigation = require(ExpChatParent.ReactFocusNavigation)
local Signals = require(ExpChatParent.Signals)
local SignalsReact = require(ExpChatParent.SignalsReact)
local UIBlox = require(ExpChatParent.UIBlox)
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local Foundation = require(ExpChatParent.Foundation)
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local View = Foundation.View
local FFlagExpChatFocusViaLastModeFix = require(ExpChat.Flags.FFlagExpChatFocusViaLastModeFix)
local getFFlagChatWindowUseCallbackOptimizations = require(ExpChat.Flags.getFFlagChatWindowUseCallbackOptimizations)
local v25 = game:DefineFastFlag("ReplaceChatLineReportingIcon", false)
local v26 = game:DefineFastFlag("ExpChatTopBannerZIndexFix", false)
local v27 = require(ExpChat.Stores.GetFocusNavigationStore)(false)

local function v28(p1) -- line: 38
	-- upvalues: React (copy), Localization (copy), LocalizationService (copy), ReactFocusNavigation (copy), FFlagExpChatFocusViaLastModeFix (copy), FocusNavigationUtils (copy), SignalsReact (copy), v27 (copy), GuiService (copy), Signals (copy), Constants (copy), v26 (copy), v25 (copy), View (copy), getFFlagChatWindowUseCallbackOptimizations (copy), Icon (copy), IconName (copy), IconSize (copy), IconButton (copy), Images (copy), LocalizationProvider (copy), ChatBoxContextMenu (copy), GetFFlagMemoizeChatReportingMenu (copy)
	local v30 = React.useRef(nil)
	local v31, v32 = React.useState(false)
	local v33 = Localization.new(LocalizationService.RobloxLocaleId)
	local v34 = ReactFocusNavigation.useFocusGuiObject()
	local v35 = if not FFlagExpChatFocusViaLastModeFix then FocusNavigationUtils.useLastInputMode() else nil
	local v36 = if not FFlagExpChatFocusViaLastModeFix then nil else SignalsReact.useSignalState(v27.getChatInputBarFocused)
	local v37 = React.useCallback(function() -- line: 50
		-- upvalues: p1 (copy), FFlagExpChatFocusViaLastModeFix (copy), v36 (copy), v35 (copy), v30 (copy), v34 (copy), GuiService (copy)
		p1.onUnfocus()

		if (FFlagExpChatFocusViaLastModeFix and v36 or not FFlagExpChatFocusViaLastModeFix and v35 == "Focus") and v30.current then
			v34(v30.current)
			GuiService.SelectedCoreObject = nil
		end
	end, {
		if not FFlagExpChatFocusViaLastModeFix then nil else v36,
		v34,
		if not FFlagExpChatFocusViaLastModeFix then v35 else nil,
		p1.onUnfocus
	})
	local v38 = React.useRef(v37)

	React.useEffect(function() -- line: 74
		-- upvalues: v38 (copy), v37 (copy)
		v38.current = v37
	end, { v37 })
	React.useEffect(function() -- line: 78
		-- upvalues: v31 (copy), v38 (copy)
		return function() -- line: 79
			-- upvalues: v31 (copy), v38 (copy)
			if v31 and v38.current then
				v38.current()
			end
		end
	end, { v31 })
	React.useEffect(function() -- line: 87
		-- upvalues: FFlagExpChatFocusViaLastModeFix (copy), v36 (copy), v31 (copy), v32 (copy), v35 (copy), Signals (copy), v27 (copy)
		if FFlagExpChatFocusViaLastModeFix then
			if v36 and v31 then
				return function() -- line: 91
					-- upvalues: v32 (copy)
					v32(false)
				end
			end

			return nil
		end

		if v35 == "Focus" and v31 then
			return Signals.createEffect(function(p2) -- line: 99
				-- upvalues: v27 (copy), v32 (copy)
				if not v27.getChatInputBarFocused(p2) then
					v32(false)
				end
			end)
		end

		return nil
	end, {
		if not FFlagExpChatFocusViaLastModeFix then nil else v36,
		v31,
		if not FFlagExpChatFocusViaLastModeFix then v35 else nil
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, Constants.TopBannerSize),
		ZIndex = if not v26 then nil else 2
	}, {
		DotMenu = if not v25 then React.createElement(IconButton, {
			showBackground = true,
			backgroundTransparency = 1,
			size = UDim2.new(0, Constants.IconButtonSize, 0, Constants.IconButtonSize),
			position = UDim2.new(1, Constants.IconButtonPositionXOffset, 0, Constants.IconButtonPositionYOffset),
			icon = Images["icons/menu/more_off"],
			iconTransparency = p1.iconTransparency,
			buttonRef = v30,
			onActivated = not getFFlagChatWindowUseCallbackOptimizations() and function() -- line: 170
				-- upvalues: v32 (copy), p1 (copy)
				v32(true)
				p1.onFocus()
			end or React.useCallback(function() -- line: 166
				-- upvalues: v32 (copy), p1 (copy)
				v32(true)
				p1.onFocus()
			end, {
				v32,
				p1.onFocus
			})
		}) else React.createElement(View, {
			tag = "auto-xy padding-small radius-medium align-x-center align-y-center",
			Size = UDim2.new(0, Constants.IconButtonSize, 0, Constants.IconButtonSize),
			Position = UDim2.new(1, Constants.IconButtonPositionXOffset, 0, Constants.IconButtonPositionYOffset),
			onActivated = not getFFlagChatWindowUseCallbackOptimizations() and function() -- line: 137
				-- upvalues: v32 (copy), p1 (copy)
				v32(true)
				p1.onFocus()
			end or React.useCallback(function() -- line: 133
				-- upvalues: v32 (copy), p1 (copy)
				v32(true)
				p1.onFocus()
			end, {
				v32,
				p1.onFocus
			}),
			ref = v30
		}, React.createElement(Icon, {
			name = IconName.ThreeDotsHorizontal,
			size = IconSize.Large,
			style = {
				Transparency = p1.iconTransparency
			}
		})),
		LocalizationProvider = React.createElement(LocalizationProvider, {
			localization = v33
		}, {
			ContextMenu = if not v31 then nil else React.createElement(ChatBoxContextMenu, {
				setContextMenuOpen = v32,
				backgroundColor3 = p1.backgroundColor3,
				backgroundTransparency = p1.backgroundTransparency,
				getMessages = if not GetFFlagMemoizeChatReportingMenu() then nil else p1.getMessages,
				messages = if GetFFlagMemoizeChatReportingMenu() then nil else p1.messages
			})
		})
	})
end

if GetFFlagMemoizeChatReportingMenu() then
	return (React.memo(v28))
end

return v28
