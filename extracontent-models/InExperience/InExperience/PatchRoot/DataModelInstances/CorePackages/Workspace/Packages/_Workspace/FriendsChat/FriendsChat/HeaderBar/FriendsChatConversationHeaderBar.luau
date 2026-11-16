local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ExpChatShared = require(parent.ExpChatShared)

local useInterpolatedClientSettings = require(parent.ExpChatIntegration.useInterpolatedClientSettings)
local useChatWindowSettings = require(parent.ExpChatIntegration.useChatWindowSettings)
local FFlagFriendsChatAddTopBarDivider = require(script.Parent.Parent.Flags.FFlagFriendsChatAddTopBarDivider)
local FriendsChatFacePile = require(script.Parent.FriendsChatFacePile)
local resolveFade = require(script.Parent.Parent.Utils.resolveFade)

local View = Foundation.View
local Divider = Foundation.Divider
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens

local v = ExpChatShared.Logger:new(script.Name)

local function FriendsChatConversationHeaderBar(props)
	local v2 = useTokens()
	local v3 = useChatWindowSettings()
	local v4 = React.useMemo(function()
		return {
			BackgroundColor3 = v3.ChatWindowBackgroundColor3,
			BackgroundTransparency = v3.ChatWindowBackgroundTransparency
		}
	end, { v3 })

	local chatWindowSettings = props.chatWindowSettings
	local v5 = useInterpolatedClientSettings(chatWindowSettings or v4)
	local fontFace

	if chatWindowSettings then
		fontFace = chatWindowSettings.FontFace
	else
		fontFace = nil
	end

	local v6 = React.useMemo(function()
		if fontFace == nil then
			return nil
		end

		local clone = table.clone(v2.Typography.TitleMedium)
		local font

		if typeof(fontFace) == "Font" then
			font = Font.new(fontFace.Family, Enum.FontWeight.Bold, fontFace.Style)
		else
			font = fontFace
		end

		clone.Font = font

		return { title = clone }
	end, { v2, fontFace })

	local onBack = props.onBack

	local onActivated = React.useCallback(function()
		v:info("Back button activated")

		if onBack then
			onBack()
		end
	end, { onBack })

	local ref = React.useRef(nil)
	React.useEffect(function()
		local current = ref.current

		if current and props.onAbsoluteSizeChanged then
			props.onAbsoluteSizeChanged(current)
		end
	end, { props.onAbsoluteSizeChanged })

	local createElement = React.createElement
	local v7 = {
		Name = "FriendsChatConversationHeaderBar",
		BackgroundColor3 = v5.BackgroundColor3 or v2.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = props.suppressBackground and 1 or resolveFade(
			v5.BackgroundTransparency,
			props.transparencyValue
		),
		Active = props.interactable == nil or props.interactable,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = props.layoutOrder,
		ZIndex = props.zIndex,
		[React.Change.AbsoluteSize] = props.onAbsoluteSizeChanged,
		[React.Event.MouseEnter] = props.onHovered,
		[React.Event.MouseLeave] = props.onUnhovered,
		ref = ref
	}

	local createElement2 = React.createElement
	local v8 = {
		Name = "FriendsChatConversationHeaderContent",
		BackgroundTransparency = 1,
		GroupTransparency = resolveFade(0, props.transparencyValue),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Interactable = props.interactable,
		ZIndex = props.zIndex
	}

	local createElement3 = React.createElement

	local v9 = {
		BackButton = React.createElement(IconButton, {
			icon = IconName.ChevronLargeLeft,
			variant = ButtonVariant.Utility,
			size = ButtonSize.XSmall,
			onActivated = onActivated,
			testId = "friends-chat-back-button",
			LayoutOrder = 1,
			ref = props.backButtonRef
		}),
		FacePileContainer = 0
	}

	local createElement4 = React.createElement

	local createElement5 = React.createElement
	local v10 = {
		participantUserIds = props.participantUserIds,
		localUserId = props.localUserId,
		titleText = props.titleText,
		titleStyle = 0,
		onActivated = 0,
		selectable = 0
	}
	local titleStyle

	if v6 then
		titleStyle = v6.title
	end

	v10.titleStyle = titleStyle
	v10.onActivated = props.onActivated
	v10.selectable = props.onActivated ~= nil or nil
	v9.FacePileContainer = createElement4(View, { tag = "fill size-0-800", LayoutOrder = 2 }, {
		FacePile = createElement5(FriendsChatFacePile, v10)
	})
	local v11 = {
		Row = createElement3(
			View,
			{
				tag = "row align-y-center gap-small size-full-0 auto-y padding-x-small padding-y-small"
			},
			v9
		),
		BottomDivider = 0
	}
	local bottomDivider

	if FFlagFriendsChatAddTopBarDivider then
		bottomDivider = React.createElement(Divider, {
			Position = UDim2.new(0, 0, 1, -1),
			Size = UDim2.new(1, 0, 0, 1),
			ZIndex = props.zIndex
		})
	end

	v11.BottomDivider = bottomDivider
	return createElement("Frame", v7, {
		Content = createElement2("CanvasGroup", v8, v11)
	})
end

return FriendsChatConversationHeaderBar
