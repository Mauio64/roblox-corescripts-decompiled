local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Modules = CoreGui.RobloxGui.Modules
local FetchSellPageData = require(Modules.AvatarExperience.Catalog.Thunks.FetchSellPageData)
local FetchCollectibleResellableInstances = require(Modules.AvatarExperience.Catalog.Thunks.FetchCollectibleResellableInstances)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable
local ControlState = UIBlox.Core.Control.Enum.ControlState
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local GetFFlagL2ControllerSupport = require(Modules.AvatarExperience.Flags.GetFFlagL2ControllerSupport)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local t1 = {
	[ControlState.Default] = "BackgroundUIDefault",
	[ControlState.Hover] = "BackgroundOnHover",
	[ControlState.Pressed] = "BackgroundOnPress"
}
local t2 = {
	onActivated = function() -- line: 56
	end
}

return (React.forwardRef(function(t3: {[any]: any}, p1) -- line: 59
	-- upvalues: Cryo (copy), t2 (copy), useStyle (copy), useDispatch (copy), useSelector (copy), getUseSelectorDeepEquals (copy), React (copy), ControlState (copy), useRoactService (copy), RoactNetworking (copy), FetchCollectibleResellableInstances (copy), FetchSellPageData (copy), t1 (copy), useLocalization (copy), useSelectionCursor (copy), CursorKind (copy), Focusable (copy), Interactable (copy), GetFFlagL2ControllerSupport (copy), ImageSetLabel (copy), Images (copy)
	local u28 = Cryo.Dictionary.join(t2, t3)
	local v29 = useStyle()
	local v30 = useDispatch()
	local collectibleItemId = u28.collectibleItemId
	local v32 = useSelector(function(p2) -- line: 68
		-- upvalues: collectibleItemId (copy), u28 (ref)
		if collectibleItemId then
			local v42 = p2.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[collectibleItemId]

			if not v42 then
				return nil
			end

			local n1 = 0

			for _, _ in v42 do
				n1 += 1
			end

			return n1
		end

		local v46 = p2.AvatarExperience.Catalog.Sell.AvailableToSellAssets[u28.itemId]
		local v47 = p2.AvatarExperience.Catalog.Sell.CurrentlySellingAssets[u28.itemId]

		if not v46 or not v47 then
			return nil
		end

		return #v46 + #v47
	end, getUseSelectorDeepEquals())
	local v33 = useSelector(function(p3) -- line: 90
		return p3.LocalUserId
	end, getUseSelectorDeepEquals())
	local v34, v35 = React.useState(ControlState.Initialize)
	local v36 = React.useCallback(function(_, p5) -- line: 95
		-- upvalues: v35 (copy)
		v35(p5)
	end)
	local v37 = useRoactService(RoactNetworking)

	React.useEffect(function() -- line: 101
		-- upvalues: v37 (copy), collectibleItemId (copy), v30 (copy), FetchCollectibleResellableInstances (copy), v33 (copy), FetchSellPageData (copy), u28 (ref)
		if not v37 then
			return
		end

		if collectibleItemId then
			v30(FetchCollectibleResellableInstances(v37, collectibleItemId, v33))

			return
		end

		v30(FetchSellPageData(v37, u28.itemId, v33))
	end, {
		u28.itemId,
		v33,
		collectibleItemId
	})

	local v38 = v29.Theme[t1[v34] or t1[ControlState.Default]]
	local v39 = useLocalization({
		itemOwned = {
			"Feature.Catalog.Label.ItemOwnedCount",
			itemCount = v32 or 0
		}
	})
	local v40 = useSelectionCursor(CursorKind.RoundedRect)

	return React.createElement(Focusable[Interactable], {
		Size = u28.size,
		AutomaticSize = u28.automaticSize,
		BackgroundColor3 = v38.Color,
		BackgroundTransparency = v38.Transparency,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		LayoutOrder = u28.layoutOrder,
		onStateChanged = v36,
		ref = if not GetFFlagL2ControllerSupport() then nil else p1,
		SelectionImageObject = if not GetFFlagL2ControllerSupport() then nil else v40,
		NextSelectionUp = if not GetFFlagL2ControllerSupport() then nil else u28.NextSelectionUp,
		NextSelectionDown = if not GetFFlagL2ControllerSupport() then nil else u28.NextSelectionDown,
		NextSelectionLeft = if not GetFFlagL2ControllerSupport() then nil else u28.NextSelectionLeft,
		NextSelectionRight = if not GetFFlagL2ControllerSupport() then nil else u28.NextSelectionRight,
		[React.Event.Activated] = u28.onActivated
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 14),
			PaddingRight = UDim.new(0, 14),
			PaddingTop = UDim.new(0, 14),
			PaddingBottom = UDim.new(0, 14)
		}),
		ItemOwnedLabelContainer = React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.fromScale(0, 1)
		}, {
			Layout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal
			}),
			OwnedIcon = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.fromOffset(16, 16),
				Image = Images["icons/status/item/owned"],
				ImageColor3 = v29.Theme.IconEmphasis.Color
			}),
			ItemOwnedLabel = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = v39.itemOwned,
				Font = v29.Font.Body.Font,
				TextSize = v29.Font.BaseSize * v29.Font.Body.RelativeSize,
				TextColor3 = v29.Theme.TextDefault.Color
			})
		}),
		ItemCountLabelContainer = React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.fromScale(0, 1),
			Position = UDim2.fromScale(1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				FillDirection = Enum.FillDirection.Horizontal
			}),
			ArrowIcon = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Size = UDim2.fromOffset(16, 16),
				Image = Images["icons/navigation/pushRight_small"],
				ImageColor3 = v29.Theme.IconEmphasis.Color
			})
		})
	})
end))
