local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local CurrentlySellingRow = require(Modules.AvatarExperience.Common.Components.ItemDetails.SellPage.CurrentlySellingRow)
local FitTextLabel = RoactFitComponents.FitTextLabel
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local v18 = Roact.PureComponent:extend("CurrentlySellingList")

function v18.init(p1) -- line: 37
	-- upvalues: AvatarScreen (copy), RoactGamepad (copy)
	function p1.removeSoldItem(p2) -- line: 38
		-- upvalues: p1 (copy), AvatarScreen (copy)
		local itemId = p1.props.itemId
		local onOverlayClosed = p1.props.onOverlayClosed

		p1.props.navigation.navigate(AvatarScreen.RemoveCurrentlySellingItemPrompt, {
			itemId = itemId,
			userAssetId = p2,
			onOverlayClosed = onOverlayClosed
		})
		p1:setState({
			restorePreviousChildFocus = false
		})
	end

	p1:setState({
		restorePreviousChildFocus = true
	})

	function p1.onFocusGained() -- line: 56
		-- upvalues: p1 (copy)
		if not p1.state.restorePreviousChildFocus then
			p1:setState({
				restorePreviousChildFocus = true
			})
		end
	end

	p1.focusableRefs = RoactGamepad.createRefCache()
end
function v18.createRemovableList(p3, p4) -- line: 67
	-- upvalues: CatalogConstants (copy), Roact (copy), FitFrameVertical (copy), CurrentlySellingRow (copy)
	local assetInfo = p3.props.assetInfo
	local currentlySellingList = p3.props.currentlySellingList
	local v25 = assetInfo and assetInfo.itemRestrictions
	local v26 = v25 and v25[CatalogConstants.ItemRestrictions.LimitedUnique]

	local function getItemIndexRef(p5) -- line: 74
		-- upvalues: currentlySellingList (copy), p3 (copy)
		return p5 >= 1 and p5 <= #currentlySellingList and p3.focusableRefs[p5] or nil
	end

	local t1 = {}

	if currentlySellingList then
		for v29, v30 in currentlySellingList do
			local v31 = "CurrentlySellingRow" .. v29
			local createElement = Roact.createElement
			local v33 = FitFrameVertical
			local t2 = {
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 8),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				LayoutOrder = v29
			}
			local t3 = {}
			local createElement2 = Roact.createElement
			local v37 = CurrentlySellingRow
			local t4 = {
				isLimitedUnique = v26,
				horizontalPadding = 24,
				LayoutOrder = 1,
				onActivated = function() -- line: 98
					-- upvalues: p3 (copy), v30 (copy)
					p3.removeSoldItem(v30)
				end,
				userAssetId = v30
			}
			local v39 = v29 - 1

			t4.NextSelectionUp = v39 >= 1 and v39 <= #currentlySellingList and p3.focusableRefs[v39] or nil

			local v40 = v29 + 1

			t4.NextSelectionDown = v40 >= 1 and v40 <= #currentlySellingList and p3.focusableRefs[v40] or nil
			t4[Roact.Ref] = v29 >= 1 and v29 <= #currentlySellingList and p3.focusableRefs[v29] or nil
			t4.onFocusGained = p3.onFocusGained
			t3.CurrentlySellingRow = createElement2(v37, t4)
			t3.Divider = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 2,
				BackgroundColor3 = p4.Divider.Color,
				BackgroundTransparency = p4.Divider.Transparency,
				Size = UDim2.new(1, -24, 0, 1)
			})
			t1[v31] = createElement(v33, t2, t3)
		end
	end

	return t1
end
function v18.renderLocalized(p6, p7) -- line: 122
	-- upvalues: withStyle (copy), Roact (copy), Focusable (copy), FitFrameVertical (copy), RoactFitComponents (copy), FitTextLabel (copy)
	local propsLayoutOrder = p6.props.LayoutOrder
	local currentlySellingList = p6.props.currentlySellingList

	return withStyle(function(p8) -- line: 126
		-- upvalues: p6 (copy), Roact (copy), Focusable (copy), FitFrameVertical (copy), propsLayoutOrder (copy), currentlySellingList (copy), RoactFitComponents (copy), FitTextLabel (copy), p7 (copy)
		local p8Font = p8.Font
		local Theme = p8.Theme
		local v58 = p8Font.BaseSize * p8Font.CaptionSubHeader.RelativeSize
		local v59 = p6:createRemovableList(Theme)
		local forwardRef = p6.props.forwardRef

		return Roact.createElement(Focusable[FitFrameVertical], {
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, 6),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			BackgroundTransparency = 1,
			LayoutOrder = propsLayoutOrder,
			NextSelectionLeft = p6.props.NextSelectionLeft,
			NextSelectionRight = p6.props.NextSelectionRight,
			NextSelectionUp = p6.props.NextSelectionUp,
			NextSelectionDown = p6.props.NextSelectionDown,
			[Roact.Ref] = forwardRef,
			defaultChild = currentlySellingList and (#currentlySellingList > 0 and p6.focusableRefs[1]) or nil,
			restorePreviousChildFocus = p6.state.restorePreviousChildFocus
		}, {
			CurrentlySellingLabelContainer = Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				width = UDim.new(1, 0),
				margin = RoactFitComponents.Rect.quad(0, 0, 0, 24)
			}, {
				CurrentlySellingLabel = Roact.createElement(FitTextLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					width = UDim.new(1, 0),
					Font = p8Font.CaptionSubHeader.Font,
					Text = p7.headerText,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextSize = v58,
					TextColor3 = Theme.TextEmphasis.Color
				})
			}),
			CurrentlySellingRowContainer = Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				width = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}, v59)
		})
	end)
end
function v18.render(p9) -- line: 186
	-- upvalues: withLocalization (copy)
	local currentlySellingList = p9.props.currentlySellingList

	if not currentlySellingList or #currentlySellingList == 0 then
		return
	end

	return withLocalization({
		headerText = "Feature.Catalog.Label.OnSale"
	})(function(p10) -- line: 193
		-- upvalues: p9 (copy)
		return p9:renderLocalized(p10)
	end)
end

local u19 = withNavigation((RoactRodux.connect(function(p11, p12) -- line: 199
	return {
		assetInfo = p11.AvatarExperience.Common.AssetInfos[p12.itemId],
		currentlySellingList = p11.AvatarExperience.Catalog.Sell.CurrentlySellingAssets[p12.itemId]
	}
end, nil)(v18)))

return Roact.forwardRef(function(p13, p14) -- line: 208
	-- upvalues: Roact (copy), u19 (ref), Cryo (copy)
	return Roact.createElement(u19, Cryo.Dictionary.join(p13, {
		forwardRef = p14
	}))
end)
