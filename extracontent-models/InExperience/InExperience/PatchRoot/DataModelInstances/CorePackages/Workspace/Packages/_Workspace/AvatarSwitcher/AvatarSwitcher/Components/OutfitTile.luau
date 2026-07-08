local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local SessionService = game:GetService("SessionService")
local React = require(AvatarSwitcherParent.React)
local Foundation = require(AvatarSwitcherParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Signals = require(AvatarSwitcherParent.Signals)
local SignalsReact = require(AvatarSwitcherParent.SignalsReact)
local AvatarExperienceAnalytics = require(AvatarSwitcherParent.AvatarExperienceAnalytics)
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local UnifiedLoggingSurface = require(AvatarSwitcherParent.AvatarExperienceNavigation).Enums.UnifiedLoggingSurface
local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)

require(AvatarSwitcher.types)

local FFlagAvatarSwitcherUseAvatarInventoryEndpoint = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherUseAvatarInventoryEndpoint
local FFlagAXBackgroundsInOutfitThumbnails = require(AvatarSwitcherParent.SharedFlags).FFlagAXBackgroundsInOutfitThumbnails

local function OutfitTile(t1: {[any]: any}) -- line: 39
	-- upvalues: SignalsReact (copy), getAvatarSwitcherStore (copy), React (copy), useTokens (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), SessionService (copy), Signals (copy), Foundation (copy), FFlagAvatarSwitcherUseAvatarInventoryEndpoint (copy), FFlagAXBackgroundsInOutfitThumbnails (copy)
	local v18 = SignalsReact.useSignalState(getAvatarSwitcherStore)
	local v19 = React.useRef(nil)
	local v20 = useTokens()
	local id = t1.outfitInfo.id

	React.useEffect(function() -- line: 46
		-- upvalues: addUnifiedEventLogging (copy), v19 (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), t1 (copy), id (copy), SessionService (copy)
		task.delay(0, function() -- line: 49
			-- upvalues: addUnifiedEventLogging (copy), v19 (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), t1 (copy), id (copy), SessionService (copy)
			addUnifiedEventLogging(v19, {
				elementName = "OUTFIT_TILE",
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				surface = UnifiedLoggingSurface.IN_EXPERIENCE_AVATAR_SWITCHER,
				gridPositionRow = t1.gridPosition.row,
				gridPositionColumn = t1.gridPosition.column,
				itemId = id
			}, {
				sessionTagName = SessionService:GetSessionTag("level2a")
			})
		end)
	end, {
		t1.gridPosition,
		id
	})

	local v22 = React.useMemo(function() -- line: 63
		-- upvalues: Signals (copy), id (copy), v18 (copy)
		return Signals.createComputed(function(p1) -- line: 64
			-- upvalues: id (copy), v18 (copy)
			return id ~= nil and v18.getSelectedOutfitId(p1) == id
		end)
	end, {
		v18,
		id
	})
	local v23 = SignalsReact.useSignalState(v22) and not t1.disabled
	local v24 = React.useCallback(function() -- line: 70
		-- upvalues: v18 (copy), id (copy)
		v18.selectOutfit(id)
	end, {
		v18,
		id
	})

	return (React.createElement(Foundation.View, {
		tag = "col gap-small auto-y size-full-0",
		GroupTransparency = if not t1.disabled then nil else 0.5,
		LayoutOrder = t1.LayoutOrder
	}, {
		Thumbnail = id and React.createElement(Foundation.Image, {
			LayoutOrder = 1,
			tag = {
				[not FFlagAvatarSwitcherUseAvatarInventoryEndpoint and "radius-medium bg-shift-200" or "radius-medium bg-shift-200 padding-small"] = true,
				["stroke-standard stroke-system-contrast"] = v23
			},
			Size = UDim2.fromScale(1, 1.5),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			Image = if not FFlagAXBackgroundsInOutfitThumbnails then `rbxthumb://type=Outfit&id={ id }&w=150&h=150` else `rbxthumb://type=Outfit&id={ id }&w=150&h=150&includeBackground=true`,
			ScaleType = Enum.ScaleType.Crop,
			onActivated = if not t1.disabled then v24 else nil,
			ref = v19
		}, {
			WarningIcon = FFlagAvatarSwitcherUseAvatarInventoryEndpoint and (t1.outfitInfo.hasWarning and React.createElement(Foundation.Image, {
				tag = "size-500",
				Image = "icons/actions/info",
				imageStyle = if v23 then nil else {
					Transparency = 0.5
				}
			}))
		}),
		ThumbnailShimmer = not id and React.createElement(Foundation.View, {
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 1.5),
			SizeConstraint = Enum.SizeConstraint.RelativeXX
		}, {
			Shimmer = React.createElement(Foundation.Skeleton, {
				Size = UDim2.fromScale(1, 1)
			})
		}),
		NameLabel = t1.outfitInfo.name and React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-align-x-left text-title-small content-emphasis text-wrap",
			LayoutOrder = 2,
			Text = t1.outfitInfo.name
		}),
		NameLabelShimmer = not t1.outfitInfo.name and React.createElement(Foundation.Skeleton, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v20.FontSize.FontSize_300)
		})
	}))
end

return React.memo(OutfitTile)
