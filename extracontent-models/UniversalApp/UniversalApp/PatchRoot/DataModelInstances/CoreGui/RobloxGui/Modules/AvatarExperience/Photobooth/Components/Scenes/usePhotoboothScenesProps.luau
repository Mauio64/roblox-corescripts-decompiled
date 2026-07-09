local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local NotificationService = game:GetService("NotificationService")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local GridMetrics = require(CorePackages.Packages.UIBlox).App.Grid.GridMetrics
local useTokens = Foundation.Hooks.useTokens
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization

require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)

local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local PhotoboothSceneData = require(Modules.AvatarExperience.Photobooth.Components.Scenes.PhotoboothSceneData)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXPhotoboothBugBashFixes = AvatarExperienceFlags.FFlagAXPhotoboothBugBashFixes
local FFlagAXPhotoboothAnalytics = AvatarExperienceFlags.FFlagAXPhotoboothAnalytics
local addUnifiedEventLogging = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).addUnifiedEventLogging
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local UnifiedEventLogConstants = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogConstants
local usePhotoboothContext = require(CorePackages.Workspace.Packages.AvatarExperiencePhotobooth).Context.usePhotoboothContext
local PHOTOBOOTH_SCENES = PhotoboothSceneData.PHOTOBOOTH_SCENES

local function usePhotoboothScenesProps(uDim2: UDim2, p1: ((...any) -> ...any)?) -- line: 55
	-- upvalues: useTokens (copy), useSelector (copy), selectIsPortrait (copy), usePhotoboothContext (copy), React (copy), GridMetrics (copy), useLocalization (copy), NotificationService (copy), FFlagAXPhotoboothAnalytics (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), UnifiedEventLogConstants (copy), CatalogItemCard (copy), FFlagAXPhotoboothBugBashFixes (copy), Foundation (copy), PHOTOBOOTH_SCENES (copy)
	local v26 = useTokens()
	local v27 = useSelector(selectIsPortrait)
	local v28 = usePhotoboothContext()

	if not v28 then
		error("PhotoboothContext not found - make sure PhotoboothContextProvider is mounted")
	end

	local photoboothStore = v28.photoboothStore
	local v30, v31 = React.useState(v26.Size.Size_3000)
	local v32, v33 = React.useState(photoboothStore.getSelectedSceneId(false))

	React.useEffect(function() -- line: 72
		-- upvalues: photoboothStore (copy), v32 (copy)
		photoboothStore.selectScene(v32)
	end, { v32 })

	local v34 = React.useCallback(function(p2) -- line: 76
		-- upvalues: v31 (copy)
		v31(p2.AbsoluteSize.X)
	end, {})
	local v35 = React.useMemo(function() -- line: 81
		-- upvalues: GridMetrics (copy), v30 (copy), v26 (copy)
		return GridMetrics.getSmallMetrics(math.max(v30 - v26.Size.Size_400 * 2, 0), v26.Size.Size_300)
	end, {
		v30,
		v26
	})
	local v36 = React.useMemo(function() -- line: 86
		-- upvalues: v35 (copy), v26 (copy)
		return math.floor(v35.itemWidth * 1.6) + v26.Size.Size_1000
	end, {
		v35.itemWidth,
		v26
	})
	local v37 = React.useCallback(function(p3) -- line: 92
		-- upvalues: v32 (copy), v26 (copy), useLocalization (copy), NotificationService (copy), FFlagAXPhotoboothAnalytics (copy), React (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), UnifiedEventLogConstants (copy), CatalogItemCard (copy), v35 (copy), v36 (copy), v33 (copy), FFlagAXPhotoboothBugBashFixes (copy), p1 (copy), Foundation (copy)
		local item = p3.item
		local v42 = v32 == item.id
		local Size_50 = v26.Size.Size_50
		local v44 = useLocalization({
			title = item.name
		})
		local v45 = (NotificationService.SelectedTheme or "Light"):lower() == "dark"
		local thumbnail = item.thumbnail

		if v45 and (item.dark and item.dark.thumbnail) then
			thumbnail = item.dark.thumbnail
		end

		local v47 = nil

		if FFlagAXPhotoboothAnalytics then
			v47 = React.useRef(nil)
			addUnifiedEventLogging(v47, {
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				elementName = if item.id ~= "" then "Photobooth_Scene_Selected_" .. item.id else "Photobooth_Scene_Selected_Blocky"
			}, {
				sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
			})
		end

		return React.createElement(CatalogItemCard, {
			headerAspectRatio = 0.625,
			Size = UDim2.fromOffset(v35.itemWidth, v36),
			isSelected = v42,
			title = v44.title,
			ref = if not FFlagAXPhotoboothAnalytics then nil else v47,
			onActivated = function() -- line: 127
				-- upvalues: v42 (copy), v33 (copy), item (copy), FFlagAXPhotoboothBugBashFixes (copy), p1 (copy)
				if v42 then
					v33("")
				else
					v33(item.id)
				end

				if FFlagAXPhotoboothBugBashFixes and p1 then
					p1()
				end
			end,
			presentationSlot = React.createElement(Foundation.View, {
				Size = UDim2.fromScale(1, 1),
				backgroundStyle = {
					Transparency = 1
				}
			}, {
				UIPadding = v42 and React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, Size_50),
					PaddingBottom = UDim.new(0, Size_50),
					PaddingLeft = UDim.new(0, Size_50),
					PaddingRight = UDim.new(0, Size_50)
				}) or nil,
				InnerContent = React.createElement(Foundation.View, {
					tag = "radius-medium",
					Size = UDim2.fromScale(1, 1),
					backgroundStyle = {
						Transparency = 0,
						Color3 = item.color
					}
				}, {
					UIStroke = v42 and React.createElement("UIStroke", {
						Transparency = 0,
						Thickness = Size_50,
						Color = v26.Color.ActionSubEmphasis.Background.Color3
					}) or nil,
					Thumbnail = if not thumbnail or thumbnail == "" then nil else React.createElement(Foundation.Image, {
						tag = "size-full-full radius-medium",
						Image = thumbnail,
						ScaleType = Enum.ScaleType.Crop
					})
				})
			})
		})
	end, {
		v35,
		v36,
		v32,
		photoboothStore
	})
	local v38 = React.useCallback(function(p4) -- line: 179
		return p4.id
	end, {})

	return {
		tokens = v26,
		isPortrait = v27,
		gridMetrics = v35,
		itemsPerRow = v35.itemsPerRow,
		scenes = PHOTOBOOTH_SCENES,
		renderSceneItem = v37,
		getSceneId = v38,
		onContainerSizeChanged = v34,
		selectedScene = v32,
		position = uDim2
	}
end

return usePhotoboothScenesProps
