local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local Text = require(AppChatParent.AppCommonLib).Text
local memo = React.memo
local useMemo = React.useMemo
local UIBlox = require(AppChatParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local LinkButton = UIBlox.App.Button.LinkButton
local useTokens = require(AppChatParent.Foundation).Hooks.useTokens
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local t1 = {
	actionText = "PLACEHOLDER Action",
	bodyText = "PLACEHOLDER Body",
	height = 40,
	onActivated = function() -- line: 36
	end
}

local function ConversationBanner(t2: {[any]: any}) -- line: 39
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useTokens (copy), useIsInExperience (copy), useChatPagePadding (copy), useMemo (copy), Text (copy), React (copy), LinkButton (copy)
	local v17 = Cryo.Dictionary.union(t1, t2)
	local v18 = useStyle()
	local v19 = v17.style or v18
	local v20 = useTokens()
	local v21 = useIsInExperience()
	local Size_400 = v19.Tokens.Size.Size_400
	local CaptionBodyFont = v19.Font.CaptionBody.Font
	local v24 = v19.Font.CaptionBody.RelativeSize * v19.Font.BaseSize
	local v25 = useChatPagePadding()
	local v26 = useMemo(function() -- line: 51
		-- upvalues: Text (copy), v17 (copy), CaptionBodyFont (copy), v24 (copy)
		return Text.GetTextBounds(v17.actionText, CaptionBodyFont, v24 + 2, Vector2.new(250, v17.height)).X
	end, {
		v17.actionText,
		CaptionBodyFont,
		v24,
		v17.height
	})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = if not v21 then v19.Theme.BackgroundUIDefault.Color else v20.Color.OverMedia.OverMedia_100.Color3,
		BackgroundTransparency = if not v21 then v19.Theme.BackgroundUIDefault.Transparency else v20.Color.OverMedia.OverMedia_100.Transparency,
		Size = UDim2.new(1, 0, 0, v17.height)
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, Size_400),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v25.left),
			PaddingRight = UDim.new(0, v25.right)
		}),
		BodyText = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Font = CaptionBodyFont,
			Size = UDim2.new(1, -v26 - Size_400, 1, 0),
			Text = v17.bodyText,
			TextColor3 = v19.Theme.TextEmphasis.Color,
			TextSize = v24,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		ActionText = React.createElement(LinkButton, {
			fontStyle = "CaptionBody",
			layoutOrder = 2,
			size = UDim2.new(0, v26, 1, 0),
			text = `<b>{ v17.actionText }</b>`,
			onActivated = v17.onActivated
		})
	})
end

return memo(ConversationBanner)
