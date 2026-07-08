local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

require(CorePackages.Workspace.Packages.LeaderboardStore)

local useLayoutValues = PlayerList.Common.useLayoutValues
local useStyle = UIBlox.Core.Style.useStyle
local EntryFrameView = PlayerList.Presentation.EntryFrameView
local StatEntryContainer = require(ParentParentParent.Components.Container.StatEntryContainer)
local FFlagPlayerListFixLeaderstatsStacking = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPlayerListFixLeaderstatsStacking
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local CellExtender = require(ParentParent.Presentation.CellExtender)

local function TeamEntryView(t1: {[any]: any}) -- line: 54
	-- upvalues: useLayoutValues (copy), useStyle (copy), FFlagEnableMobilePlayerListOnConsole (copy), React (copy), FFlagPlayerListFixLeaderstatsStacking (copy), SignalsReact (copy), StatEntryContainer (copy), EntryFrameView (copy), CellExtender (copy)
	local v17 = useLayoutValues()
	local v18 = useStyle()
	local v19 = t1.isSmallTouchDevice or false
	local v20 = t1.isDirectionalPreferred or false
	local TextEmphasis = v18.Theme.TextEmphasis
	local v22 = if not FFlagEnableMobilePlayerListOnConsole then v18.Font.CaptionHeader.RelativeSize * v18.Font.BaseSize else v17.TeamNameTextSize
	local CaptionHeaderFont = v18.Font.CaptionHeader.Font

	if v20 then
		TextEmphasis = v17.DefaultTextStyle
		v22 = v17.PlayerNameTextSize
		CaptionHeaderFont = v17.TeamEntryFont
	end

	local v24 = React.useMemo(function() -- line: 75
		-- upvalues: v19 (copy), v18 (copy), t1 (copy), v20 (copy), v17 (copy)
		if v19 then
			local Settings = v18.Settings

			return {
				Color = t1.teamColor,
				Transparency = Settings.PreferredTransparency * 0.5
			}
		end

		if v20 then
			return {
				Color = t1.teamColor,
				Transparency = not v17.BackgroundStyle and 0 or v17.BackgroundStyle.Default.Transparency
			}
		end

		return {
			Color = t1.teamColor,
			Transparency = v17.TeamEntryBackgroundTransparency * v18.Settings.PreferredTransparency
		}
	end, {
		v19,
		v20,
		t1.teamColor,
		v18,
		v17
	})
	local t2 = {
		Transparency = 1,
		Color = Color3.new(1, 1, 1)
	}
	local MaxLeaderstats = v17.MaxLeaderstats
	local v27 = if not FFlagPlayerListFixLeaderstatsStacking then nil else SignalsReact.useSignalState(t1.gameStats.getAllData)

	if v19 then
		local t3 = {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			NameFrame = React.createElement("TextLabel", {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v17.PlayerNameSizeXMobile, 1, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = CaptionHeaderFont,
				TextSize = v22,
				TextColor3 = TextEmphasis.Color,
				TextStrokeTransparency = TextEmphasis.StrokeTransparency,
				TextStrokeColor3 = TextEmphasis.StrokeColor,
				Text = t1.teamName,
				TextTruncate = Enum.TextTruncate.AtEnd
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v17.TeamEntryTextPaddingMobile)
				})
			})
		}

		if FFlagPlayerListFixLeaderstatsStacking then
			for v29, v30 in v27 do
				if not (MaxLeaderstats < v30.order(false)) then
					local v31 = t1.teamStats.getData(v29, false)

					t3["GameStat_" .. v29] = React.createElement(StatEntryContainer, {
						isTeamEntry = true,
						showStatTitle = false,
						statName = v29,
						stat = v31,
						textStyle = TextEmphasis
					})
				end
			end
		elseif t1.gameStatsCount and t1.teamStatsCount and t1.gameStatsCount > 0 and t1.teamStatsCount >= 0 then
			t1.gameStats.iterateData(function(p1, p2) -- line: 159
				-- upvalues: MaxLeaderstats (copy), t1 (copy), t3 (copy), React (copy), StatEntryContainer (copy), TextEmphasis (ref)
				if p2.order(false) > MaxLeaderstats then
					return
				end

				local v40 = t1.teamStats.getData(p1, false)

				t3["GameStat_" .. p1] = React.createElement(StatEntryContainer, {
					isTeamEntry = true,
					showStatTitle = false,
					statName = p1,
					stat = v40,
					textStyle = TextEmphasis
				})
			end, false)
		end

		return React.createElement("Frame", {
			BorderSizePixel = 0,
			GroupTransparency = nil,
			LayoutOrder = t1.layoutOrder,
			Size = t1.size,
			BackgroundColor3 = v24.Color,
			BackgroundTransparency = v24.Transparency
		}, t3)
	end

	local t4 = {}
	local uDim = nil

	if v20 then
		uDim = UDim.new(0, v17.PlayerEntryPadding)
	end

	t4.UIListLayout = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = uDim
	})
	t4.NameFrame = React.createElement("Frame", {
		LayoutOrder = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, t1.entrySizeX, 0, v17.TeamEntrySizeY)
	}, {
		Shadow = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = v17.ShadowImage,
			Position = UDim2.new(0, -v17.ShadowSize, 0, 0),
			Size = UDim2.new(1, v17.ShadowSize * 2, 1, v17.ShadowSize),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = v17.ShadowSliceRect,
			Visible = v20
		}),
		BGFrame = React.createElement(EntryFrameView, {
			isTeamFrame = true,
			doubleOverlay = false,
			size = UDim2.new(0, t1.entrySizeX, 0, v17.TeamEntrySizeY),
			backgroundStyle = v24,
			overlayStyle = t2
		}, {
			TeamName = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = CaptionHeaderFont,
				TextSize = v22,
				TextColor3 = TextEmphasis.Color,
				TextStrokeTransparency = TextEmphasis.StrokeTransparency,
				TextStrokeColor3 = TextEmphasis.StrokeColor,
				Text = t1.teamName,
				TextTruncate = Enum.TextTruncate.AtEnd
			}, { React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v17.TeamEntryTextPadding)
			}) })
		})
	})

	if FFlagPlayerListFixLeaderstatsStacking then
		for v34, v35 in v27 do
			if not (MaxLeaderstats < v35.order(false)) then
				local v36 = t1.teamStats.getData(v34, false)

				t4["GameStat_" .. v34] = React.createElement(StatEntryContainer, {
					isTeamEntry = true,
					showStatTitle = false,
					doubleOverlay = false,
					statName = v34,
					stat = v36,
					backgroundStyle = v24,
					overlayStyle = t2,
					textStyle = TextEmphasis
				})
			end
		end
	elseif t1.gameStatsCount and t1.teamStatsCount and t1.gameStatsCount > 0 and t1.teamStatsCount >= 0 then
		t1.gameStats.iterateData(function(p3, p4) -- line: 264
			-- upvalues: MaxLeaderstats (copy), t1 (copy), t4 (copy), React (copy), StatEntryContainer (copy), v24 (copy), t2 (copy), TextEmphasis (ref)
			if p4.order(false) > MaxLeaderstats then
				return
			end

			local v43 = t1.teamStats.getData(p3, false)

			t4["GameStat_" .. p3] = React.createElement(StatEntryContainer, {
				isTeamEntry = true,
				showStatTitle = false,
				doubleOverlay = false,
				statName = p3,
				stat = v43,
				backgroundStyle = v24,
				overlayStyle = t2,
				textStyle = TextEmphasis
			})
		end, false)
	end

	if not v20 then
		t4.BackgroundExtender = React.createElement(CellExtender, {
			layoutOrder = 100,
			doubleOverlay = false,
			size = UDim2.new(0, v17.ExtraContainerPadding, 1, 0),
			backgroundStyle = v24,
			overlayStyle = t2
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		GroupTransparency = nil,
		Size = t1.size,
		BackgroundColor3 = Color3.new(1, 1, 1),
		LayoutOrder = t1.layoutOrder
	}, t4)
end

return React.memo(TeamEntryView)
