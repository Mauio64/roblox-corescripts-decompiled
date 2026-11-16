local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local parent = AvatarSwitcher.Parent

local SessionService = game:GetService("SessionService")
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums

local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)
require(AvatarSwitcher.types)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherUseAvatarInventoryEndpoint = AvatarExperienceFlags.FFlagAvatarSwitcherUseAvatarInventoryEndpoint
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags2.FFlagAXUnifiedEventStrictPayloads
local SharedFlags = require(parent.SharedFlags)
local FFlagAXBackgroundsInOutfitThumbnails = SharedFlags.FFlagAXBackgroundsInOutfitThumbnails

local function OutfitTile(props)
	local v = SignalsReact.useSignalState(getAvatarSwitcherStore)
	local ref = React.useRef(nil)
	local v2 = useTokens()

	local id = props.outfitInfo.id

	React.useEffect(function()
		task.delay(0, function()
			local v3 = {
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				surface = UnifiedLoggingSurface.IN_EXPERIENCE_AVATAR_SWITCHER,
				gridPositionRow = props.gridPosition.row,
				gridPositionColumn = props.gridPosition.column,
				itemId = 0,
				elementName = "OUTFIT_TILE"
			}
			local itemId

			if FFlagAXUnifiedEventStrictPayloads then
				if id then
					itemId = tostring(id)
				end
			else
				itemId = id
			end

			v3.itemId = itemId
			addUnifiedEventLogging(ref, v3, {
				sessionTagName = SessionService:GetSessionTag("level2a")
			})
		end)
	end, { props.gridPosition, id })

	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p): boolean
			return id ~= nil and v.getSelectedOutfitId(p) == id
		end)
	end, { v, id })
	local strokestandardstrokesystemcontrast = SignalsReact.useSignalState(v3) and not props.disabled

	local onActivated = React.useCallback(function()
		v.selectOutfit(id)
	end, { v, id })

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = {
		tag = "col gap-small auto-y size-full-0",
		GroupTransparency = props.disabled and 0.5 or nil,
		LayoutOrder = props.LayoutOrder
	}
	local thumbnail

	if id then
		local createElement2 = React.createElement
		local image = Foundation.Image
		local v5 = {
			tag = {
				[FFlagAvatarSwitcherUseAvatarInventoryEndpoint and "radius-medium bg-shift-200 padding-small" or "radius-medium bg-shift-200"] = true,
				["stroke-standard stroke-system-contrast"] = strokestandardstrokesystemcontrast
			},
			Size = UDim2.fromScale(1, 1.5),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			Image = 0,
			ScaleType = 0,
			LayoutOrder = 1,
			onActivated = 0,
			ref = 0
		}
		local image2

		if FFlagAXBackgroundsInOutfitThumbnails then
			image2 = `rbxthumb://type=Outfit&id={id}&w=150&h=150&includeBackground=true`
		else
			image2 = `rbxthumb://type=Outfit&id={id}&w=150&h=150`
		end

		v5.Image = image2

		v5.ScaleType = Enum.ScaleType.Crop

		if props.disabled then
			onActivated = nil
		end

		v5.onActivated = onActivated
		v5.ref = ref
		thumbnail = createElement2(image, v5, {
			WarningIcon = FFlagAvatarSwitcherUseAvatarInventoryEndpoint and props.outfitInfo.hasWarning and React.createElement(Foundation.Image, {
				tag = "size-500",
				imageStyle = not strokestandardstrokesystemcontrast and { Transparency = 0.5 } or nil,
				Image = "icons/actions/info"
			})
		})
	else
		thumbnail = id
	end

	return (createElement(view, v4, {
		Thumbnail = thumbnail,
		ThumbnailShimmer = not id and React.createElement(
			Foundation.View,
			{
				Size = UDim2.fromScale(1, 1.5),
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				LayoutOrder = 1
			},
			{
				Shimmer = React.createElement(Foundation.Skeleton, { Size = UDim2.fromScale(1, 1) })
			}
		),
		NameLabel = props.outfitInfo.name and React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-align-x-left text-title-small content-emphasis text-wrap",
			Text = props.outfitInfo.name,
			LayoutOrder = 2
		}),
		NameLabelShimmer = not props.outfitInfo.name and React.createElement(Foundation.Skeleton, {
			Size = UDim2.new(1, 0, 0, v2.FontSize.FontSize_300),
			LayoutOrder = 2
		})
	}))
end

return React.memo(OutfitTile)
