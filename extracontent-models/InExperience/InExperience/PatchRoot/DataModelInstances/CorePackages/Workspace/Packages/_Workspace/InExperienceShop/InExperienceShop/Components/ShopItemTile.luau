local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local SessionService = game:GetService("SessionService")
local React = require(InExperienceShopParent.React)
local Foundation = require(InExperienceShopParent.Foundation)
local SignalsReact = require(InExperienceShopParent.SignalsReact)
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local ShopItemFooter = require(InExperienceShop.Components.ShopItemFooter)
local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local SHOP_ITEM_MEDIA_HEIGHT_SCALE = require(InExperienceShop.Components.computeShopRowTileWidths).SHOP_ITEM_MEDIA_HEIGHT_SCALE
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)
local FFlagFixThumbnailBackgroundInExperienceShop = require(InExperienceShop.Flags.FFlagFixThumbnailBackgroundInExperienceShop)

require(InExperienceShop.Types)

local Constants = require(InExperienceShop.Constants)

local function ShopItemTile(t1: {[any]: any}) -- line: 47
	-- upvalues: SignalsReact (copy), getInExperienceShopStore (copy), React (copy), FFlagEnableInExperienceShopUnifiedLogging (copy), InExperienceShopParent (copy), InExperienceShop (copy), SessionService (copy), View (copy), FoundationImage (copy), FFlagFixThumbnailBackgroundInExperienceShop (copy), SHOP_ITEM_MEDIA_HEIGHT_SCALE (copy), FoundationText (copy), Icon (copy), Constants (copy), IconSize (copy), ShopItemFooter (copy)
	local v20 = SignalsReact.useSignalState(getInExperienceShopStore)
	local v21 = React.useRef(nil)
	local v22 = SignalsReact.useSignalState(function(p1) -- line: 54
		-- upvalues: v20 (copy), t1 (copy)
		return v20.getOwnership(p1)[t1.itemId]
	end)

	React.useEffect(function() -- line: 62
		-- upvalues: t1 (copy), v20 (copy)
		if t1.itemType == "GamePass" then
			v20.fetchGamePassOwnership(t1.itemId)
		end
	end, {
		t1.itemId,
		t1.itemType,
		v20.fetchGamePassOwnership
	})
	React.useEffect(function() -- line: 69
		-- upvalues: FFlagEnableInExperienceShopUnifiedLogging (copy), InExperienceShopParent (copy), InExperienceShop (copy), t1 (copy), v21 (copy), SessionService (copy)
		if not FFlagEnableInExperienceShopUnifiedLogging then
			return
		end

		task.defer(function() -- line: 74
			-- upvalues: InExperienceShopParent (copy), InExperienceShop (copy), t1 (copy), v21 (copy), SessionService (copy)
			local addUnifiedEventLogging = require(InExperienceShopParent.AvatarExperienceAnalytics).addUnifiedEventLogging
			local v28 = require(InExperienceShop.Utils.mapShopItemTypeToUnifiedItemType)(t1.itemType)

			if v28 == nil then
				return
			end

			local t2 = {
				universeId = if t1.universeId == nil then game.GameId else tonumber(t1.universeId),
				itemId = t1.itemId,
				itemType = v28,
				categoryId = t1.categoryId,
				gridPositionRow = t1.gridPositionRow,
				gridPositionColumn = t1.gridPositionColumn
			}

			addUnifiedEventLogging(v21, t2, {
				sessionTagName = SessionService:GetSessionTag("level2a")
			})
		end)
	end, {
		t1.itemId,
		t1.itemType,
		t1.universeId,
		t1.categoryId,
		t1.gridPositionRow,
		t1.gridPositionColumn
	})

	local onItemActivated = t1.onItemActivated
	local itemType = t1.itemType
	local v25 = React.useCallback(function() -- line: 111
		-- upvalues: onItemActivated (copy), t1 (copy), itemType (copy)
		if onItemActivated then
			onItemActivated(t1.itemId, itemType)
		end
	end, {
		t1.itemId,
		itemType,
		onItemActivated
	})

	return React.createElement(View, {
		tag = "col fill size-full-0 auto-y radius-medium clip bg-shift-200",
		LayoutOrder = t1.LayoutOrder,
		onActivated = if not onItemActivated then nil else v25,
		ref = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v21
	}, {
		Media = React.createElement(FoundationImage, {
			LayoutOrder = 1,
			tag = {
				["radius-medium bg-shift-200"] = FFlagFixThumbnailBackgroundInExperienceShop,
				["radius-medium"] = not FFlagFixThumbnailBackgroundInExperienceShop
			},
			Size = UDim2.fromScale(1, SHOP_ITEM_MEDIA_HEIGHT_SCALE),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			Image = t1.thumbnail,
			ScaleType = Enum.ScaleType.Fit
		}),
		TileContent = React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y padding-medium",
			LayoutOrder = 2
		}, {
			ContentHeader = React.createElement(View, {
				tag = "col size-full-0 auto-y",
				LayoutOrder = 1
			}, {
				Title = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis",
					LayoutOrder = 1,
					Text = t1.name
				}),
				Metadata = if not t1.price then nil else React.createElement(View, {
					tag = "row align-y-center gap-xsmall auto-xy",
					LayoutOrder = 2
				}, {
					RobuxIcon = React.createElement(Icon, {
						LayoutOrder = 1,
						name = Constants.ROBUX_ICON,
						size = IconSize.Small
					}),
					PriceLabel = React.createElement(FoundationText, {
						tag = "auto-xy text-body-medium text-truncate-end content-default",
						LayoutOrder = 2,
						Text = tostring(t1.price)
					})
				})
			}),
			Footer = React.createElement(ShopItemFooter, {
				LayoutOrder = 2,
				itemId = t1.itemId,
				itemType = t1.itemType,
				isOwned = v22,
				price = t1.price
			})
		})
	})
end

return React.memo(ShopItemTile)
