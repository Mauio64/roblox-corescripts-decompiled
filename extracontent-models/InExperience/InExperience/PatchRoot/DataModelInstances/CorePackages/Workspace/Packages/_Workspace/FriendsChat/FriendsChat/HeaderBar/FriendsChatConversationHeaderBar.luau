local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local ExpChatShared = require(Parent.ExpChatShared)
local useInterpolatedClientSettings = require(Parent.ExpChatIntegration.useInterpolatedClientSettings)
local useChatWindowSettings = require(Parent.ExpChatIntegration.useChatWindowSettings)
local FriendsChatFacePile = require(script.Parent.FriendsChatFacePile)
local View = Foundation.View
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local v14 = ExpChatShared.Logger:new(script.Name)

local function resolveFade(n1: number, p1) -- line: 76
	if type(p1) == "number" then
		return n1 + p1 * (1 - n1)
	end

	if p1 ~= nil then
		return p1:map(function(n2: number) -- line: 80
			-- upvalues: n1 (copy)
			return n1 + n2 * (1 - n1)
		end)
	end

	return n1
end
local function FriendsChatConversationHeaderBar(t1: {[any]: any}) -- line: 87
	-- upvalues: useTokens (copy), useChatWindowSettings (copy), React (copy), useInterpolatedClientSettings (copy), v14 (copy), View (copy), IconButton (copy), IconName (copy), ButtonVariant (copy), ButtonSize (copy), FriendsChatFacePile (copy)
	local v20 = useTokens()
	local v21 = useChatWindowSettings()
	local v22 = React.useMemo(function() -- line: 90
		-- upvalues: v21 (copy)
		return {
			BackgroundColor3 = v21.ChatWindowBackgroundColor3,
			BackgroundTransparency = v21.ChatWindowBackgroundTransparency
		}
	end, { v21 })
	local chatWindowSettings = t1.chatWindowSettings
	local v24 = useInterpolatedClientSettings(chatWindowSettings or v22)
	local v25 = if not chatWindowSettings then nil else chatWindowSettings.FontFace
	local v26 = React.useMemo(function() -- line: 108
		-- upvalues: v25 (copy), v20 (copy)
		if v25 == nil then
			return nil
		end

		local v42 = table.clone(v20.Typography.TitleMedium)

		v42.Font = if typeof(v25) ~= "Font" then v25 else Font.new(v25.Family, Enum.FontWeight.Bold, v25.Style)

		return {
			title = v42
		}
	end, {
		v20,
		v25
	})
	local onBack = t1.onBack
	local v28 = React.useCallback(function() -- line: 126
		-- upvalues: v14 (copy), onBack (copy)
		v14:info("Back button activated")

		if onBack then
			onBack()
		end
	end, { onBack })
	local v29 = React.useRef(nil)

	React.useEffect(function() -- line: 134
		-- upvalues: v29 (copy), t1 (copy)
		local current = v29.current

		if current and t1.onAbsoluteSizeChanged then
			t1.onAbsoluteSizeChanged(current)
		end
	end, { t1.onAbsoluteSizeChanged })

	local createElement = React.createElement
	local t2 = {
		Name = "FriendsChatConversationHeaderBar",
		BackgroundColor3 = v24.BackgroundColor3 or v20.Color.Surface.Surface_0.Color3
	}
	local n3

	if t1.suppressBackground then
		n3 = 1
	else
		local BackgroundTransparency = v24.BackgroundTransparency
		local transparencyValue = t1.transparencyValue

		n3 = if type(transparencyValue) ~= "number" then if transparencyValue == nil then BackgroundTransparency else transparencyValue:map(function(n4: number) -- line: 80
			-- upvalues: BackgroundTransparency (copy)
			return BackgroundTransparency + n4 * (1 - BackgroundTransparency)
		end) else BackgroundTransparency + transparencyValue * (1 - BackgroundTransparency)
	end

	t2.BackgroundTransparency = n3
	t2.Active = t1.interactable == nil or t1.interactable
	t2.BorderSizePixel = 0
	t2.AutomaticSize = Enum.AutomaticSize.Y
	t2.Size = UDim2.new(1, 0, 0, 0)
	t2.LayoutOrder = t1.layoutOrder
	t2.ZIndex = t1.zIndex
	t2[React.Change.AbsoluteSize] = t1.onAbsoluteSizeChanged
	t2[React.Event.MouseEnter] = t1.onHovered
	t2[React.Event.MouseLeave] = t1.onUnhovered
	t2.ref = v29

	local t3 = {}
	local createElement2 = React.createElement
	local t4 = {
		Name = "FriendsChatConversationHeaderContent",
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}
	local transparencyValue = t1.transparencyValue
	local v39

	if type(transparencyValue) == "number" then
		v39 = 0 + transparencyValue * 1
	elseif transparencyValue ~= nil then
		local n5 = 0

		v39 = transparencyValue:map(function(n6: number) -- line: 80
			-- upvalues: n5 (copy)
			return n5 + n6 * (1 - n5)
		end)
	else
		v39 = 0
	end

	t4.GroupTransparency = v39
	t4.AutomaticSize = Enum.AutomaticSize.Y
	t4.Size = UDim2.new(1, 0, 0, 0)
	t4.Interactable = t1.interactable
	t4.ZIndex = t1.zIndex
	t3.Content = createElement2("CanvasGroup", t4, {
		Row = React.createElement(View, {
			tag = "row align-y-center gap-small size-full-0 auto-y padding-x-small padding-y-small"
		}, {
			BackButton = React.createElement(IconButton, {
				testId = "friends-chat-back-button",
				LayoutOrder = 1,
				icon = IconName.ChevronLargeLeft,
				variant = ButtonVariant.Utility,
				size = ButtonSize.XSmall,
				onActivated = v28
			}),
			FacePileContainer = React.createElement(View, {
				tag = "fill size-0-800",
				LayoutOrder = 2
			}, {
				FacePile = React.createElement(FriendsChatFacePile, {
					participantUserIds = t1.participantUserIds,
					localUserId = t1.localUserId,
					titleText = t1.titleText,
					titleStyle = if not v26 then nil else v26.title,
					onActivated = t1.onActivated,
					selectable = t1.onActivated ~= nil or nil
				})
			})
		})
	})

	return createElement("Frame", t2, t3)
end

return FriendsChatConversationHeaderBar
