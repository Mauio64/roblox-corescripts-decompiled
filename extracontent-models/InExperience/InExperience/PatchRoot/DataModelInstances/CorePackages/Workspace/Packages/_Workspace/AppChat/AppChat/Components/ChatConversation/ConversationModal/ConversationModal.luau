local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local Cryo = require(parent.Cryo)
local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local useEffect = React.useEffect
local useMemo = React.useMemo
local useStyle = UIBlox.Core.Style.useStyle
local ButtonStack = UIBlox.App.Button.ButtonStack
local enum = UIBlox.App.Button.Enum

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)

local v = {
	bodyText = "Placeholder body",
	onHeightChanged = function(_) end,
	onAccepted = nil,
	onDenied = nil
}

local function ConversationModal(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()
	local style = joined.style or v2
	local v3 = useTokens()
	local v4 = useIsInExperience()

	local size_1000 = style.Tokens.Size.Size_1000
	local v5 = style.Tokens.Size.Size_500
	local v6 = useChatPagePadding()

	useEffect(function()
		return function()
			joined.onHeightChanged(0)
		end
	end, {})

	local buttons = useMemo(function()
		local v7 = {}

		if joined.denyText then
			table.insert(v7, {
				buttonType = enum.ButtonType.Secondary,
				props = {
					onActivated = joined.onDenied,
					text = joined.denyText,
					isDisabled = joined.loading
				}
			})
		end

		if joined.acceptText then
			table.insert(v7, {
				buttonType = enum.ButtonType.PrimarySystem,
				props = {
					onActivated = joined.onAccepted,
					text = joined.acceptText,
					isDisabled = joined.loading
				}
			})
		end

		return v7
	end, { joined.acceptText, joined.denyText, joined.loading, joined.onDenied, joined.onAccepted })

	local createElement = React.createElement
	local backgroundTransparency

	if v4 then
		backgroundTransparency = v3.Color.OverMedia.OverMedia_100.Transparency
	else
		backgroundTransparency = style.Theme.SystemPrimaryContent.Transparency
	end

	local backgroundColor

	if v4 then
		backgroundColor = v3.Color.OverMedia.OverMedia_100.Color3
	else
		backgroundColor = style.Theme.SystemPrimaryContent.Color
	end

	local v7 = {
		Name = "ConversationModal",
		BackgroundTransparency = backgroundTransparency,
		BackgroundColor3 = backgroundColor,
		BorderSizePixel = 0,
		LayoutOrder = joined.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		[React.Change.AbsoluteSize] = function(p2)
			joined.onHeightChanged(p2.AbsoluteSize.Y)
		end
	}

	local createElement2 = React.createElement
	local v8

	if joined.paddingTop == nil then
		v8 = v5
	else
		v8 = joined.paddingTop
	end

	local v9 = {
		PaddingTop = UDim.new(0, v8),
		PaddingBottom = 0,
		PaddingLeft = 0,
		PaddingRight = 0
	}
	local v10

	if joined.paddingBottom == nil then
		v10 = v5
	else
		v10 = joined.paddingBottom
	end

	v9.PaddingBottom = UDim.new(0, v10)
	v9.PaddingLeft = UDim.new(0, v6.left)
	v9.PaddingRight = UDim.new(0, v6.right)
	local children = {
		ContentPadding = createElement2("UIPadding", v9),
		UIListLayout = 0,
		Body = 0,
		Buttons = 0
	}

	local createElement3 = React.createElement
	local v11 = {
		FillDirection = Enum.FillDirection.Vertical,
		Padding = 0,
		SortOrder = 0,
		VerticalAlignment = 0
	}

	if joined.verticalSpacing ~= nil then
		v5 = joined.verticalSpacing
	end

	v11.Padding = UDim.new(0, v5)
	v11.SortOrder = Enum.SortOrder.LayoutOrder
	v11.VerticalAlignment = Enum.VerticalAlignment.Top
	children.UIListLayout = createElement3("UIListLayout", v11)

	local createElement4 = React.createElement
	local v12 = {
		BackgroundTransparency = 1,
		TextSize = style.Tokens.FontSize.FontSize_300,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 1,
		Size = 0,
		AutomaticSize = 0,
		Text = 0,
		TextWrapped = true,
		TextColor3 = 0,
		TextXAlignment = 0,
		TextYAlignment = 0
	}
	local font

	if not FoundationFontFaceMigration then
		font = style.Font.Body.Font
	end

	v12.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v3.Typography.BodyLarge.Font)
	end

	v12.FontFace = fontFace

	v12.Size = UDim2.new(1, 0, 0, 0)
	v12.AutomaticSize = Enum.AutomaticSize.Y
	v12.Text = joined.bodyText

	v12.TextColor3 = style.Theme.TextDefault.Color
	v12.TextXAlignment = Enum.TextXAlignment.Left
	v12.TextYAlignment = Enum.TextYAlignment.Center
	children.Body = createElement4("TextLabel", v12)
	local buttons2

	if #buttons > 0 then
		buttons2 = React.createElement(
			"Frame",
			{ BackgroundTransparency = 1, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, size_1000) },
			{
				ButtonStack = React.createElement(ButtonStack, {
					forcedFillDirection = Enum.FillDirection.Horizontal,
					buttons = buttons
				})
			}
		)
	end

	children.Buttons = buttons2
	return createElement("Frame", v7, children)
end

return ConversationModal
