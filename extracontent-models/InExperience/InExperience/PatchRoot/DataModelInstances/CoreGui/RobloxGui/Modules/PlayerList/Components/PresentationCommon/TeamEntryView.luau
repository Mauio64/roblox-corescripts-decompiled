local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
require(CorePackages.Workspace.Packages.LeaderboardStore)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useTokens = Foundation.Hooks.useTokens

local useLayoutValues = PlayerList.Common.useLayoutValues
local useStyle = UIBlox.Core.Style.useStyle

local EntryFrameView = PlayerList.Presentation.EntryFrameView
local StatEntryContainer = require(parent2.Components.Container.StatEntryContainer)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagPlayerListFixLeaderstatsStacking = SharedFlags.FFlagPlayerListFixLeaderstatsStacking
local foundationFontFaceMigration = SharedFlags.FFlagFontFacePlayerList
	and Foundation.Utility.Flags.FoundationFontFaceMigration
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole

local CellExtender = require(parent.Presentation.CellExtender)

local function TeamEntryView(props)
	local v = useLayoutValues()
	local v2 = useStyle()
	local v3

	if foundationFontFaceMigration then
		v3 = useTokens()
	end

	local isSmallTouchDevice = props.isSmallTouchDevice or false
	local isDirectionalPreferred = props.isDirectionalPreferred or false

	local textStyle = v2.Theme.TextEmphasis
	local textSize

	if FFlagEnableMobilePlayerListOnConsole then
		textSize = v.TeamNameTextSize
	else
		textSize = v2.Font.CaptionHeader.RelativeSize * v2.Font.BaseSize
	end

	local fontFace

	if foundationFontFaceMigration then
		fontFace = normalizeFontFace(v3.Typography.CaptionLarge.Font)
	else
		fontFace = v2.Font.CaptionHeader.Font
	end

	if isDirectionalPreferred then
		textStyle = v.DefaultTextStyle
		textSize = v.PlayerNameTextSize

		if foundationFontFaceMigration then
			fontFace = normalizeFontFace(v.TeamEntryFont)
		else
			fontFace = v.TeamEntryFont
		end
	end

	local backgroundStyle = React.useMemo(function()
		if isSmallTouchDevice then
			local settings = v2.Settings
			return {
				Color = props.teamColor,
				Transparency = settings.PreferredTransparency * 0.5
			}
		end

		if isDirectionalPreferred then
			return {
				Color = props.teamColor,
				Transparency = not v.BackgroundStyle and 0 or v.BackgroundStyle.Default.Transparency
			}
		end

		return {
			Color = props.teamColor,
			Transparency = v.TeamEntryBackgroundTransparency * v2.Settings.PreferredTransparency
		}
	end, { isSmallTouchDevice, isDirectionalPreferred, props.teamColor, v2, v })

	local overlayStyle = { Color = Color3.new(1, 1, 1), Transparency = 1 }

	local maxLeaderstats = v.MaxLeaderstats
	local v4

	if FFlagPlayerListFixLeaderstatsStacking then
		v4 = SignalsReact.useSignalState(props.gameStats.getAllData)
	end

	if isSmallTouchDevice then
		local children = {}

		children.UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center
		})

		local createElement = React.createElement
		local v5 = {
			Size = UDim2.new(0, v.PlayerNameSizeXMobile, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			LayoutOrder = 0,
			TextColor3 = 0,
			TextStrokeTransparency = 0,
			TextStrokeColor3 = 0,
			BackgroundTransparency = 1,
			Text = 0,
			TextTruncate = 0
		}
		local font

		if not foundationFontFaceMigration then
			font = fontFace
		end

		v5.Font = font

		if not foundationFontFaceMigration then
			fontFace = nil
		end

		v5.FontFace = fontFace
		v5.TextSize = textSize

		v5.TextColor3 = textStyle.Color
		v5.TextStrokeTransparency = textStyle.StrokeTransparency
		v5.TextStrokeColor3 = textStyle.StrokeColor

		v5.Text = props.teamName
		v5.TextTruncate = Enum.TextTruncate.AtEnd
		children.NameFrame = createElement("TextLabel", v5, {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v.TeamEntryTextPaddingMobile)
			})
		})

		if FFlagPlayerListFixLeaderstatsStacking then
			for k, v6 in v4 do
				if maxLeaderstats < v6.order(false) then
					continue
				end

				local data = props.teamStats.getData(k, false)
				children["GameStat_" .. k] = React.createElement(StatEntryContainer, {
					statName = k,
					stat = data,
					isTeamEntry = true,
					showStatTitle = false,
					textStyle = textStyle
				})
			end
		elseif
			props.gameStatsCount
			and props.teamStatsCount
			and props.gameStatsCount > 0
			and props.teamStatsCount >= 0
		then
			props.gameStats.iterateData(function(statName, p)
				if maxLeaderstats < p.order(false) then
					return
				end

				local data = props.teamStats.getData(statName, false)
				children["GameStat_" .. statName] = React.createElement(StatEntryContainer, {
					statName = statName,
					stat = data,
					isTeamEntry = true,
					showStatTitle = false,
					textStyle = textStyle
				})
			end, false)
		end

		return React.createElement("Frame", {
			LayoutOrder = props.layoutOrder,
			Size = props.size,
			BackgroundColor3 = backgroundStyle.Color,
			BackgroundTransparency = backgroundStyle.Transparency,
			BorderSizePixel = 0,
			GroupTransparency = nil
		}, children)
	else
		local children = {}
		local padding

		if isDirectionalPreferred then
			padding = UDim.new(0, v.PlayerEntryPadding)
		end

		children.UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = padding
		})

		local createElement = React.createElement
		local v5 = {
			LayoutOrder = 0,
			Size = UDim2.new(0, props.entrySizeX, 0, v.TeamEntrySizeY),
			BackgroundTransparency = 1
		}

		local v6 = {
			Shadow = React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = v.ShadowImage,
				Position = UDim2.new(0, -v.ShadowSize, 0, 0),
				Size = UDim2.new(1, v.ShadowSize * 2, 1, v.ShadowSize),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = v.ShadowSliceRect,
				Visible = isDirectionalPreferred
			}),
			BGFrame = 0
		}

		local createElement2 = React.createElement
		local v7 = {
			size = UDim2.new(0, props.entrySizeX, 0, v.TeamEntrySizeY),
			isTeamFrame = true,
			backgroundStyle = backgroundStyle,
			overlayStyle = overlayStyle,
			doubleOverlay = false
		}

		local createElement3 = React.createElement
		local v8 = {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextStrokeTransparency = 0,
			TextStrokeColor3 = 0,
			BackgroundTransparency = 1,
			Text = 0,
			TextTruncate = 0
		}
		local font

		if not foundationFontFaceMigration then
			font = fontFace
		end

		v8.Font = font

		if not foundationFontFaceMigration then
			fontFace = nil
		end

		v8.FontFace = fontFace
		v8.TextSize = textSize
		v8.TextColor3 = textStyle.Color
		v8.TextStrokeTransparency = textStyle.StrokeTransparency
		v8.TextStrokeColor3 = textStyle.StrokeColor

		v8.Text = props.teamName
		v8.TextTruncate = Enum.TextTruncate.AtEnd
		v6.BGFrame = createElement2(EntryFrameView, v7, {
			TeamName = createElement3("TextLabel", v8, {
				React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v.TeamEntryTextPadding)
				})
			})
		})
		children.NameFrame = createElement("Frame", v5, v6)

		if FFlagPlayerListFixLeaderstatsStacking then
			for k, v9 in v4 do
				if maxLeaderstats < v9.order(false) then
					continue
				end

				local data = props.teamStats.getData(k, false)
				children["GameStat_" .. k] = React.createElement(StatEntryContainer, {
					statName = k,
					stat = data,
					isTeamEntry = true,
					showStatTitle = false,
					backgroundStyle = backgroundStyle,
					overlayStyle = overlayStyle,
					doubleOverlay = false,
					textStyle = textStyle
				})
			end
		elseif
			props.gameStatsCount
			and props.teamStatsCount
			and props.gameStatsCount > 0
			and props.teamStatsCount >= 0
		then
			props.gameStats.iterateData(function(statName, p)
				if maxLeaderstats < p.order(false) then
					return
				end

				local data = props.teamStats.getData(statName, false)
				children["GameStat_" .. statName] = React.createElement(StatEntryContainer, {
					statName = statName,
					stat = data,
					isTeamEntry = true,
					showStatTitle = false,
					backgroundStyle = backgroundStyle,
					overlayStyle = overlayStyle,
					doubleOverlay = false,
					textStyle = textStyle
				})
			end, false)
		end

		if not isDirectionalPreferred then
			children.BackgroundExtender = React.createElement(CellExtender, {
				layoutOrder = 100,
				size = UDim2.new(0, v.ExtraContainerPadding, 1, 0),
				backgroundStyle = backgroundStyle,
				overlayStyle = overlayStyle,
				doubleOverlay = false
			})
		end

		return React.createElement("Frame", {
			Size = props.size,
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = props.layoutOrder,
			GroupTransparency = nil
		}, children)
	end
end

return React.memo(TeamEntryView)
