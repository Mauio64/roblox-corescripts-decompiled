local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local UIBlox = require(AppChatParent.UIBlox)
local useEffect = React.useEffect
local useMemo = React.useMemo
local useStyle = UIBlox.Core.Style.useStyle
local ButtonStack = UIBlox.App.Button.ButtonStack
local Enum2 = UIBlox.App.Button.Enum
local useTokens = require(AppChatParent.Foundation).Hooks.useTokens
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local t1 = {
	bodyText = "Placeholder body",
	onAccepted = nil,
	onDenied = nil,
	onHeightChanged = function(_) -- line: 43
	end
}

local function ConversationModal(t2: {[any]: any}) -- line: 51
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useTokens (copy), useIsInExperience (copy), useChatPagePadding (copy), useEffect (copy), useMemo (copy), Enum2 (copy), React (copy), ButtonStack (copy)
	local v18 = Cryo.Dictionary.join(t1, t2)
	local v19 = useStyle()
	local v20 = v18.style or v19
	local v21 = useTokens()
	local v22 = useIsInExperience()
	local Size_1000 = v20.Tokens.Size.Size_1000
	local Size_500 = v20.Tokens.Size.Size_500
	local v25 = useChatPagePadding()

	useEffect(function() -- line: 62
		-- upvalues: v18 (copy)
		return function() -- line: 63
			-- upvalues: v18 (copy)
			v18.onHeightChanged(0)
		end
	end, {})

	local v26 = useMemo(function() -- line: 68
		-- upvalues: v18 (copy), Enum2 (copy)
		local t3 = {}

		if v18.denyText then
			table.insert(t3, {
				buttonType = Enum2.ButtonType.Secondary,
				props = {
					onActivated = v18.onDenied,
					text = v18.denyText,
					isDisabled = v18.loading
				}
			})
		end

		if v18.acceptText then
			table.insert(t3, {
				buttonType = Enum2.ButtonType.PrimarySystem,
				props = {
					onActivated = v18.onAccepted,
					text = v18.acceptText,
					isDisabled = v18.loading
				}
			})
		end

		return t3
	end, {
		v18.acceptText,
		v18.denyText,
		v18.loading,
		v18.onDenied,
		v18.onAccepted
	})

	return React.createElement("Frame", {
		Name = "ConversationModal",
		BackgroundTransparency = if not v22 then v20.Theme.SystemPrimaryContent.Transparency else v21.Color.OverMedia.OverMedia_100.Transparency,
		BackgroundColor3 = if not v22 then v20.Theme.SystemPrimaryContent.Color else v21.Color.OverMedia.OverMedia_100.Color3,
		BorderSizePixel = 0,
		LayoutOrder = v18.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		[React.Change.AbsoluteSize] = function(p2) -- line: 105
			-- upvalues: v18 (copy)
			v18.onHeightChanged(p2.AbsoluteSize.Y)
		end
	}, {
		ContentPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, if v18.paddingTop == nil then Size_500 else v18.paddingTop),
			PaddingBottom = UDim.new(0, if v18.paddingBottom == nil then Size_500 else v18.paddingBottom),
			PaddingLeft = UDim.new(0, v25.left),
			PaddingRight = UDim.new(0, v25.right)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, if v18.verticalSpacing == nil then Size_500 else v18.verticalSpacing),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		Body = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			TextWrapped = true,
			TextSize = v20.Tokens.FontSize.FontSize_300,
			Font = v20.Font.Body.Font,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = v18.bodyText,
			TextColor3 = v20.Theme.TextDefault.Color,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		Buttons = if not (#v26 > 0) then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, Size_1000)
		}, {
			ButtonStack = React.createElement(ButtonStack, {
				forcedFillDirection = Enum.FillDirection.Horizontal,
				buttons = v26
			})
		})
	})
end

return ConversationModal
