local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module = require("@luauforge/deferred/fvf")

local module2 = require("@luauforge/bundled/fuS")
local module3 = require("@luauforge/bundled/eeH")
local module4 = require("@luauforge/bundled/eda")

local useStyle = UIBlox.Core.Style.useStyle
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local interactable = UIBlox.Core.Control.Interactable
local controlState = UIBlox.Core.Control.Enum.ControlState
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind

local module5 = require("@luauforge/deferred/gks")
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local v5 = {
	[controlState.Default] = "BackgroundUIDefault",
	[controlState.Hover] = "BackgroundOnHover",
	[controlState.Pressed] = "BackgroundOnPress"
}

local v6 = {
	onActivated = function() end
}

return (React.forwardRef(function(p2, ref)
	local joined = Cryo.Dictionary.join(v6, p2)

	local v7 = useStyle()

	local v8 = useDispatch()

	local collectibleItemId = joined.collectibleItemId

	local v9 = useSelector(function(p3)
		if collectibleItemId then
			local collectiblesResellableInstance = p3.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[collectibleItemId]

			if not collectiblesResellableInstance then
				return nil
			end

			local count = 0

			for k, v10 in collectiblesResellableInstance do
				count += 1
			end

			return count
		else
			local availableToSellAsset = p3.AvatarExperience.Catalog.Sell.AvailableToSellAssets[joined.itemId]
			local currentlySellingAsset = p3.AvatarExperience.Catalog.Sell.CurrentlySellingAssets[joined.itemId]

			if availableToSellAsset and currentlySellingAsset then
				return #availableToSellAsset + #currentlySellingAsset
			end

			return nil
		end
	end, getUseSelectorDeepEquals())

	local v10 = useSelector(function(p3)
		return p3.LocalUserId
	end, getUseSelectorDeepEquals())

	local state, setState = React.useState(controlState.Initialize)
	local v11 = React.useCallback(function(p3, p4)
		setState(p4)
	end)

	local v12 = module3(module4)
	React.useEffect(function()
		if not v12 then
			return
		end

		if collectibleItemId then
			v8(module2(v12, collectibleItemId, v10))
		else
			v8(module(v12, joined.itemId, v10))
		end
	end, { joined.itemId, v10, collectibleItemId })

	local v13 = v7.Theme[v5[state] or v5[controlState.Default]]

	local v14 = useLocalization({
		itemOwned = {
			"Feature.Catalog.Label.ItemOwnedCount",
			itemCount = v9 or 0
		}
	})

	local v15 = useSelectionCursor(cursorKind.RoundedRect)

	local createElement = React.createElement
	local v16 = focusable[interactable]
	local onActivatedsByActivated = {}
	onActivatedsByActivated.Size = joined.size
	onActivatedsByActivated.AutomaticSize = joined.automaticSize
	onActivatedsByActivated.BackgroundColor3 = v13.Color
	onActivatedsByActivated.BackgroundTransparency = v13.Transparency
	onActivatedsByActivated.BorderSizePixel = 0
	onActivatedsByActivated.AutoButtonColor = false
	onActivatedsByActivated.LayoutOrder = joined.layoutOrder
	onActivatedsByActivated.onStateChanged = v11

	if not module5() then
		ref = nil
	end

	onActivatedsByActivated.ref = ref

	if not module5() then
		v15 = nil
	end

	onActivatedsByActivated.SelectionImageObject = v15
	local v17 = if module5() then joined.NextSelectionUp else nil
	onActivatedsByActivated.NextSelectionUp = v17
	local v18 = if module5() then joined.NextSelectionDown else nil
	onActivatedsByActivated.NextSelectionDown = v18
	local v19 = if module5() then joined.NextSelectionLeft else nil
	onActivatedsByActivated.NextSelectionLeft = v19
	local v20 = if module5() then joined.NextSelectionRight else nil
	onActivatedsByActivated.NextSelectionRight = v20
	onActivatedsByActivated[React.Event.Activated] = joined.onActivated
	local children = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 14),
			PaddingRight = UDim.new(0, 14),
			PaddingTop = UDim.new(0, 14),
			PaddingBottom = UDim.new(0, 14)
		}),
		ItemOwnedLabelContainer = 0,
		ItemCountLabelContainer = 0
	}

	local createElement2 = React.createElement
	local v22 = { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0 }

	local v23 = {
		Layout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal
		}),
		OwnedIcon = React.createElement(imageSetLabel, {
			Size = UDim2.fromOffset(16, 16),
			Image = images["icons/status/item/owned"],
			ImageColor3 = v7.Theme.IconEmphasis.Color,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1
		}),
		ItemOwnedLabel = 0
	}

	local createElement3 = React.createElement
	local v25 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = v14.itemOwned,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}
	local v26 = if not foundationFontFaceMigration then v7.Font.Body.Font else nil
	v25.Font = v26

	local v27 = if foundationFontFaceMigration then normalizeFontFace(v7.Tokens.Typography.BodyLarge.Font) else nil
	v25.FontFace = v27

	v25.TextSize = v7.Font.BaseSize * v7.Font.Body.RelativeSize
	v25.TextColor3 = v7.Theme.TextDefault.Color
	v23.ItemOwnedLabel = createElement3("TextLabel", v25)
	children.ItemOwnedLabelContainer = createElement2("Frame", v22, v23)

	children.ItemCountLabelContainer = React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(0, 1),
			Position = UDim2.fromScale(1, 0),
			BorderSizePixel = 0
		},
		{
			Layout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				FillDirection = Enum.FillDirection.Horizontal
			}),
			ArrowIcon = React.createElement(imageSetLabel, {
				Size = UDim2.fromOffset(16, 16),
				Image = images["icons/navigation/pushRight_small"],
				ImageColor3 = v7.Theme.IconEmphasis.Color,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2
			})
		}
	)
	return createElement(v16, onActivatedsByActivated, children)
end))
