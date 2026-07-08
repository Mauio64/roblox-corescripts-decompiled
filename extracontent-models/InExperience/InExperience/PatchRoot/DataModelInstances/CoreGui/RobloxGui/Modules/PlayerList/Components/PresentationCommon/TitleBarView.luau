local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

require(CorePackages.Workspace.Packages.LeaderboardStore)

local GameTranslator = require(RobloxGui.Modules.GameTranslator)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local useLayoutValues = PlayerList.Common.useLayoutValues
local useStyle = UIBlox.Core.Style.useStyle
local FFlagPlayerListFixLeaderstatsStacking = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPlayerListFixLeaderstatsStacking
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local t1 = {
	showDivider = false,
	showBackground = false,
	backgroundTransparency = 1,
	useCustomTextColor = false,
	headerPaddingLeft = 15,
	customTextColor = Color3.fromRGB(255, 255, 255)
}

local function TitleBarView(t2: {[any]: any}) -- line: 56
	-- upvalues: t1 (copy), useLayoutValues (copy), useStyle (copy), React (copy), RobloxTranslator (copy), FFlagEnableMobilePlayerListOnConsole (copy), FFlagPlayerListFixLeaderstatsStacking (copy), SignalsReact (copy), GameTranslator (copy), CoreGui (copy), CorePackages (copy)
	local t3 = {}

	for k, v in pairs(t1) do
		t3[k] = t2[k] ~= nil and t2[k] or v
	end

	for k, v in pairs(t2) do
		t3[k] = v
	end

	local v22 = useLayoutValues()
	local v23 = useStyle()
	local t4 = {
		layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center
		})
	}
	local entrySizeX = t3.entrySizeX

	if t3.isSmallTouchDevice then
		entrySizeX = v22.PlayerNameSizeXMobile
	end

	local v26 = t3.useCustomTextColor and t3.customTextColor or v23.Theme.TextMuted.Color
	local v27 = if not t3.useCustomTextColor then v23.Theme.TextMuted.Transparency else 0

	t4.playersHeader = React.createElement("TextLabel", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, entrySizeX, 1, 0),
		Text = RobloxTranslator:FormatByKey("InGame.PlayerList.Players"),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Font = v23.Font.Footer.Font,
		TextSize = if not FFlagEnableMobilePlayerListOnConsole then v23.Font.BaseSize * v23.Font.Footer.RelativeSize else v22.TitleBarTextSize,
		TextTransparency = v27,
		TextColor3 = v26
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, t3.headerPaddingLeft)
		})
	})

	local MaxLeaderstats = v22.MaxLeaderstats

	if FFlagPlayerListFixLeaderstatsStacking then
		for v29, v30 in (SignalsReact.useSignalState(t3.gameStats.getAllData)) do
			if not (MaxLeaderstats < v30.order(false)) then
				local v31 = GameTranslator:TranslateGameText(CoreGui, v29)

				t4["stat_" .. v29] = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = v30.order(false) + 1,
					Size = UDim2.new(0, v22.StatEntrySizeX, 1, 0),
					Text = v31,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					Font = v23.Font.Footer.Font,
					TextSize = if not FFlagEnableMobilePlayerListOnConsole then v23.Font.BaseSize * v23.Font.Footer.RelativeSize else v22.TitleBarTextSize,
					TextTransparency = v27,
					TextColor3 = v26,
					TextTruncate = Enum.TextTruncate.AtEnd
				})
			end
		end
	elseif t3.gameStatsCount and t3.gameStatsCount > 0 then
		t3.gameStats.iterateData(function(p1, p2) -- line: 138
			-- upvalues: MaxLeaderstats (copy), GameTranslator (copy), CoreGui (copy), t4 (copy), React (copy), v22 (copy), v23 (copy), FFlagEnableMobilePlayerListOnConsole (copy), v27 (copy), v26 (copy)
			if p2.order(false) > MaxLeaderstats then
				return
			end

			local v36 = GameTranslator:TranslateGameText(CoreGui, p1)

			t4["stat_" .. p1] = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = p2.order(false) + 1,
				Size = UDim2.new(0, v22.StatEntrySizeX, 1, 0),
				Text = v36,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = v23.Font.Footer.Font,
				TextSize = if not FFlagEnableMobilePlayerListOnConsole then v23.Font.BaseSize * v23.Font.Footer.RelativeSize else v22.TitleBarTextSize,
				TextTransparency = v27,
				TextColor3 = v26,
				TextTruncate = Enum.TextTruncate.AtEnd
			})
		end, false)
	end

	local color3 = Color3.fromRGB(0, 0, 0)

	if t3.showBackground then
		color3 = if not require(CorePackages.Workspace.Packages.Chrome).Enabled() then v23.Theme.BackgroundContrast.Color else v23.Theme.BackgroundUIContrast.Color
	end

	local t5 = {}

	if t3.showDivider then
		t5.Divider = React.createElement("Frame", {
			BorderSizePixel = 0,
			Visible = t3.contentsVisible,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = v23.Theme.Divider.Transparency,
			BackgroundColor3 = v23.Theme.Divider.Color
		})
	end

	t5.ChildrenFrame = React.createElement("Frame", {
		BackgroundTransparency = 1,
		Visible = t3.contentsVisible,
		Position = t3.showBackground and UDim2.new(0, 0, 0, -2) or UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0)
	}, t4)

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = t3.size,
		LayoutOrder = t3.layoutOrder,
		BackgroundTransparency = t3.backgroundTransparency,
		BackgroundColor3 = color3
	}, t5)
end

return React.memo(TitleBarView)
