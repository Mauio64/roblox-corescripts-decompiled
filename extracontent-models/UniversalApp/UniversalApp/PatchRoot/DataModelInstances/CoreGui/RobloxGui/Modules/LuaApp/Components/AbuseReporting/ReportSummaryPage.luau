local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ScrollingListTable = UIBlox.App.Table.ScrollingListTable
local CellHeadDetail = UIBlox.App.Table.CellHeadDetail
local Cell = UIBlox.App.Table.Cell
local Dash = require(CorePackages.Packages.Dash)
local Style = require(CorePackages.Workspace.Packages.Style)
local useDesignTokens = Style.useDesignTokens
local mapTypographyVariantToFontEnum = Style.mapTypographyVariantToFontEnum
local useStyle = UIBlox.Core.Style.useStyle
local isSelectedDataDSAIllegalContent = require(CorePackages.Workspace.Packages.DsaIllegalContentReporting).isSelectedDataDSAIllegalContent
local isShowEUDSAIllegalContentReportingLink = require(CorePackages.Workspace.Packages.DsaIllegalContentReporting).isShowEUDSAIllegalContentReportingLink
local GetFFlagDSAIllegalContentReporting = SharedFlags.GetFFlagDSAIllegalContentReporting
local GetFFlagDSAVRSkipFrontendGeoCheck = SharedFlags.GetFFlagDSAVRSkipFrontendGeoCheck

return function(t1: {[any]: any}) -- line: 33
	-- upvalues: useDesignTokens (copy), useStyle (copy), React (copy), isSelectedDataDSAIllegalContent (copy), GetFFlagDSAVRSkipFrontendGeoCheck (copy), GetFFlagDSAIllegalContentReporting (copy), isShowEUDSAIllegalContentReportingLink (copy), mapTypographyVariantToFontEnum (copy), ScrollingListTable (copy), Dash (copy), Cell (copy), CellHeadDetail (copy), StyledTextLabel (copy)
	local v19 = useDesignTokens()
	local selectionData = t1.selectionData
	local v21 = useStyle()

	React.useEffect(function() -- line: 38
		-- upvalues: t1 (copy)
		t1.onSummaryPageMounted()
	end, {})

	local v22 = t1.dsaText ~= nil and isSelectedDataDSAIllegalContent(t1.selectionData)
	local v23 = if not GetFFlagDSAVRSkipFrontendGeoCheck() then v22 and isShowEUDSAIllegalContentReportingLink() else v22 and GetFFlagDSAIllegalContentReporting()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 460)
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Heading = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v19.Size.Size_1200)
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v19.Size.Size_400),
				PaddingBottom = UDim.new(0, v19.Size.Size_400)
			}),
			Prompt = React.createElement("TextLabel", {
				LayoutOrder = 1,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Text = t1.heading,
				Font = mapTypographyVariantToFontEnum(v19.Typography.TitleLarge),
				TextColor3 = v19.Color.Content.Emphasis.Color3,
				TextTransparency = v19.Color.Content.Emphasis.Transparency,
				TextSize = v19.Typography.TitleLarge.FontSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, 0, 0, v19.Typography.TitleLarge.FontSize)
			})
		}),
		SelectionList = React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = if not v23 then UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, 0, 120)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ListTable = React.createElement(ScrollingListTable, {
				cells = Dash.map(selectionData, function(p1) -- line: 95
					-- upvalues: React (copy), Cell (copy), v19 (copy), CellHeadDetail (copy), v21 (copy)
					return React.createElement(Cell, {
						userInteractionEnabled = false,
						size = UDim2.new(1, 0, 0, v19.Size.Size_1600),
						head = React.createElement(CellHeadDetail, {
							labelText = p1.heading,
							labelTextColor = v21.Theme.TextMuted,
							labelTextFont = v21.Font.SubHeader1,
							subLabelText = p1.humanReadableText,
							subLabelTextColor = v21.Theme.TextEmphasis,
							subLabelTextFont = v21.Font.Body
						})
					})
				end)
			})
		}),
		DSANotice = if not v23 then nil else React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 120)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Content = React.createElement(StyledTextLabel, {
				layoutOrder = 2,
				lineHeight = 1,
				fluidSizing = true,
				richText = false,
				size = UDim2.new(1, 0, 0, 60),
				text = t1.dsaText,
				textXAlignment = Enum.TextXAlignment.Center,
				textYAlignment = Enum.TextYAlignment.Top,
				fontStyle = v21.Font.Body,
				colorStyle = v21.Theme.TextEmphasis
			})
		})
	})
end
