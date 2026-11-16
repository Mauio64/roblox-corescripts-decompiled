local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
require(CorePackages.Workspace.Packages.LeaderboardStore)

local GameTranslator = require(RobloxGui.Modules.GameTranslator)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local useLayoutValues = PlayerList.Common.useLayoutValues
local useStyle = UIBlox.Core.Style.useStyle

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagPlayerListFixLeaderstatsStacking = SharedFlags.FFlagPlayerListFixLeaderstatsStacking
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole

local v = {
	showDivider = false,
	showBackground = false,
	backgroundTransparency = 1,
	useCustomTextColor = false,
	customTextColor = Color3.fromRGB(255, 255, 255),
	headerPaddingLeft = 15
}

local function TitleBarView(items)
	local v2 = {}

	for k, v3 in pairs(v) do
		v3 = items[k] ~= nil and items[k] or v3
		v2[k] = v3
	end

	for k, item in pairs(items) do
		v2[k] = item
	end

	local v3 = useLayoutValues()
	local v4 = useStyle()

	local children = {}

	children.layout = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center
	})

	local v5 = v2.entrySizeX

	if v2.isSmallTouchDevice then
		v5 = v3.PlayerNameSizeXMobile
	end

	local customTextColor = v2.useCustomTextColor and v2.customTextColor or v4.Theme.TextMuted.Color

	local textTransparency = v2.useCustomTextColor and 0 or v4.Theme.TextMuted.Transparency

	local createElement = React.createElement
	local v6 = {
		LayoutOrder = 1,
		Size = UDim2.new(0, v5, 1, 0),
		Text = RobloxTranslator:FormatByKey("InGame.PlayerList.Players"),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextTransparency = 0,
		TextColor3 = 0
	}
	local font

	if not FoundationFontFaceMigration then
		font = v4.Font.Footer.Font
	end

	v6.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v4.Tokens.Typography.CaptionSmall.Font)
	end

	v6.FontFace = fontFace
	local textSize

	if FFlagEnableMobilePlayerListOnConsole then
		textSize = v3.TitleBarTextSize
	else
		textSize = v4.Font.BaseSize * v4.Font.Footer.RelativeSize
	end

	v6.TextSize = textSize
	v6.TextTransparency = textTransparency
	v6.TextColor3 = customTextColor
	children.playersHeader = createElement("TextLabel", v6, {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v2.headerPaddingLeft)
		})
	})

	local maxLeaderstats = v3.MaxLeaderstats

	if FFlagPlayerListFixLeaderstatsStacking then
		local v7 = SignalsReact.useSignalState(v2.gameStats.getAllData)

		for k, v8 in v7 do
			if maxLeaderstats < v8.order(false) then
				continue
			end

			local translateGameText = GameTranslator:TranslateGameText(CoreGui, k)

			local v9 = "stat_" .. k
			local createElement2 = React.createElement
			local v10 = {
				LayoutOrder = v8.order(false) + 1,
				Size = UDim2.new(0, v3.StatEntrySizeX, 1, 0),
				Text = translateGameText,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextTransparency = 0,
				TextColor3 = 0,
				TextTruncate = 0
			}
			local font2

			if not FoundationFontFaceMigration then
				font2 = v4.Font.Footer.Font
			end

			v10.Font = font2
			local fontFace2

			if FoundationFontFaceMigration then
				fontFace2 = normalizeFontFace(v4.Tokens.Typography.CaptionSmall.Font)
			end

			v10.FontFace = fontFace2
			local textSize2

			if FFlagEnableMobilePlayerListOnConsole then
				textSize2 = v3.TitleBarTextSize
			else
				textSize2 = v4.Font.BaseSize * v4.Font.Footer.RelativeSize
			end

			v10.TextSize = textSize2
			v10.TextTransparency = textTransparency
			v10.TextColor3 = customTextColor
			v10.TextTruncate = Enum.TextTruncate.AtEnd
			children[v9] = createElement2("TextLabel", v10)
		end
	elseif v2.gameStatsCount and v2.gameStatsCount > 0 then
		v2.gameStats.iterateData(function(p, p2)
			if maxLeaderstats < p2.order(false) then
				return
			end

			local translateGameText = GameTranslator:TranslateGameText(CoreGui, p)

			local v7 = "stat_" .. p
			local createElement2 = React.createElement
			local v8 = {
				LayoutOrder = p2.order(false) + 1,
				Size = UDim2.new(0, v3.StatEntrySizeX, 1, 0),
				Text = translateGameText,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextTransparency = 0,
				TextColor3 = 0,
				TextTruncate = 0
			}
			local font2

			if not FoundationFontFaceMigration then
				font2 = v4.Font.Footer.Font
			end

			v8.Font = font2
			local fontFace2

			if FoundationFontFaceMigration then
				fontFace2 = normalizeFontFace(v4.Tokens.Typography.CaptionSmall.Font)
			end

			v8.FontFace = fontFace2
			local textSize2

			if FFlagEnableMobilePlayerListOnConsole then
				textSize2 = v3.TitleBarTextSize
			else
				textSize2 = v4.Font.BaseSize * v4.Font.Footer.RelativeSize
			end

			v8.TextSize = textSize2
			v8.TextTransparency = textTransparency
			v8.TextColor3 = customTextColor
			v8.TextTruncate = Enum.TextTruncate.AtEnd
			children[v7] = createElement2("TextLabel", v8)
		end, false)
	end

	local color = Color3.fromRGB(0, 0, 0)

	if v2.showBackground then
		local Chrome = require(CorePackages.Workspace.Packages.Chrome)

		if Chrome.Enabled() then
			color = v4.Theme.BackgroundUIContrast.Color
		else
			color = v4.Theme.BackgroundContrast.Color
		end
	end

	local children2 = {}

	if v2.showDivider then
		children2.Divider = React.createElement("Frame", {
			Visible = v2.contentsVisible,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = v4.Theme.Divider.Transparency,
			BackgroundColor3 = v4.Theme.Divider.Color,
			BorderSizePixel = 0
		})
	end

	children2.ChildrenFrame = React.createElement("Frame", {
		Visible = v2.contentsVisible,
		BackgroundTransparency = 1,
		Position = v2.showBackground and UDim2.new(0, 0, 0, -2) or UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0)
	}, children)

	return React.createElement("Frame", {
		Size = v2.size,
		LayoutOrder = v2.layoutOrder,
		BackgroundTransparency = v2.backgroundTransparency,
		BackgroundColor3 = color,
		BorderSizePixel = 0
	}, children2)
end

return React.memo(TitleBarView)
