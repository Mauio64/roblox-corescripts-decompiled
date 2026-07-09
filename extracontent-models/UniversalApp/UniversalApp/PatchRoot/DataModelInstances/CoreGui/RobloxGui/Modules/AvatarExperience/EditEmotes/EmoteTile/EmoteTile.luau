local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useTokens = Foundation.Hooks.useTokens
local CatalogItemCard = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.CatalogItemCard.CatalogItemCard
local ItemCardThumbnail = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail

require(Modules.AvatarExperience.EditEmotes.EmoteTile.useEmoteTileProps)

local function EmoteTile(p1, p2) -- line: 19
	-- upvalues: useTokens (copy), React (copy), CatalogItemCard (copy), RoactGamepad (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ItemCardThumbnail (copy)
	local v13 = useTokens()

	return React.createElement(CatalogItemCard, {
		onActivated = p1.onActivated,
		presentationSlot = React.createElement(RoactGamepad.Focusable.Frame, {
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1)
		}, {
			CornerRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v13.Semantic.Radius.Medium else v13.Radius.Medium)
			}),
			EmoteTileThumbnail = React.createElement(ItemCardThumbnail, {
				url = `rbxthumb://type=Asset&id={ p1.itemId }&w=150&h=150&filters=0`
			})
		}),
		title = p1.item.name,
		isSelected = p1.isSelected,
		Size = UDim2.fromOffset(p1.itemWidth, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = p2,
		LayoutOrder = p1.index,
		tag = p1.impressionsTag,
		gridInformation = p1.gridInformation
	})
end

return React.forwardRef(EmoteTile)
