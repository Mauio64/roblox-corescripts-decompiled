require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useEffect = React.useEffect
local useMemo = React.useMemo
local useStyle = UIBlox.Core.Style.useStyle
local buttonStack = UIBlox.App.Button.ButtonStack
local enum = UIBlox.App.Button.Enum

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")

local v5 = {
	bodyText = "Placeholder body",
	onHeightChanged = function(p2) end,
	onAccepted = nil,
	onDenied = nil
}

local function ConversationModal(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useStyle()
	local style = joined.style or v6
	local v7 = useTokens()
	local v8 = useIsInExperience()

	local size_1000 = style.Tokens.Size.Size_1000
	local v9 = style.Tokens.Size.Size_500
	local v10 = useChatPagePadding()

	useEffect(function()
		return function()
			joined.onHeightChanged(0)
		end
	end, {})

	local v11 = useMemo(function()
		local v12 = {}

		if joined.denyText then
			table.insert(v12, {
				buttonType = enum.ButtonType.Secondary,
				props = {
					onActivated = joined.onDenied,
					text = joined.denyText,
					isDisabled = joined.loading
				}
			})
		end

		if joined.acceptText then
			table.insert(v12, {
				buttonType = enum.ButtonType.PrimarySystem,
				props = {
					onActivated = joined.onAccepted,
					text = joined.acceptText,
					isDisabled = joined.loading
				}
			})
		end

		return v12
	end, {
		joined.acceptText,
		joined.denyText,
		joined.loading,
		joined.onDenied,
		joined.onAccepted
	})

	local createElement = React.createElement

	local v14 = if v8 then v7.Color.OverMedia.OverMedia_100.Transparency else style.Theme.SystemPrimaryContent.Transparency

	local v15 = if v8 then v7.Color.OverMedia.OverMedia_100.Color3 else style.Theme.SystemPrimaryContent.Color
	local v13 = {
		Name = "ConversationModal",
		BackgroundTransparency = v14,
		BackgroundColor3 = v15,
		BorderSizePixel = 0,
		LayoutOrder = joined.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		[React.Change.AbsoluteSize] = function(p3)
			joined.onHeightChanged(p3.AbsoluteSize.Y)
		end
	}

	local createElement2 = React.createElement
	local newUDim = UDim.new
	local v19 = if joined.paddingTop == nil then v9 else joined.paddingTop
	local v17 = {
		PaddingTop = newUDim(0, v19),
		PaddingBottom = 0,
		PaddingLeft = 0,
		PaddingRight = 0
	}
	local newUDim2 = UDim.new
	local v21 = if joined.paddingBottom == nil then v9 else joined.paddingBottom
	v17.PaddingBottom = newUDim2(0, v21)
	v17.PaddingLeft = UDim.new(0, v10.left)
	v17.PaddingRight = UDim.new(0, v10.right)
	local children = {
		ContentPadding = createElement2("UIPadding", v17),
		UIListLayout = 0,
		Body = 0,
		Buttons = 0
	}

	local createElement3 = React.createElement
	local v23 = {
		FillDirection = Enum.FillDirection.Vertical,
		Padding = 0,
		SortOrder = 0,
		VerticalAlignment = 0
	}
	local newUDim3 = UDim.new

	if joined.verticalSpacing ~= nil then
		v9 = joined.verticalSpacing
	end

	v23.Padding = newUDim3(0, v9)
	v23.SortOrder = Enum.SortOrder.LayoutOrder
	v23.VerticalAlignment = Enum.VerticalAlignment.Top
	children.UIListLayout = createElement3("UIListLayout", v23)

	local createElement4 = React.createElement
	local v26 = {
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
	local v27 = if not foundationFontFaceMigration then style.Font.Body.Font else nil
	v26.Font = v27

	local v28 = if foundationFontFaceMigration then normalizeFontFace(v7.Typography.BodyLarge.Font) else nil
	v26.FontFace = v28

	v26.Size = UDim2.new(1, 0, 0, 0)
	v26.AutomaticSize = Enum.AutomaticSize.Y
	v26.Text = joined.bodyText

	v26.TextColor3 = style.Theme.TextDefault.Color
	v26.TextXAlignment = Enum.TextXAlignment.Left
	v26.TextYAlignment = Enum.TextYAlignment.Center
	children.Body = createElement4("TextLabel", v26)

	local v29 = if #v11 > 0 then React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, size_1000)
		},
		{
			ButtonStack = React.createElement(buttonStack, {
				forcedFillDirection = Enum.FillDirection.Horizontal,
				buttons = v11
			})
		}
	) else nil
	children.Buttons = v29
	return createElement("Frame", v13, children)
end

return ConversationModal
