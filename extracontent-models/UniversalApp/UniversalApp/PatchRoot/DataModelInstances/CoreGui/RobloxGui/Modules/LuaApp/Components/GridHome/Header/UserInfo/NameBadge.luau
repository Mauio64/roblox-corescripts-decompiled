local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Icon = Foundation.Icon
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local IconName = Foundation.Enums.IconName
local Emoji = UIBlox.App.Emoji.Enum.Emoji
local EmojiTextLabel = UIBlox.Core.Text.EmojiTextLabel
local getIconSize = UIBlox.App.ImageSet.getIconSize
local IconSize2 = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local LoadableImage = UIBlox.App.Loading.LoadableImage
local withStyle = UIBlox.Core.Style.withStyle
local UncheckedBadge = require(Modules.LuaApp.Components.Common.UncheckedBadge)
local GetTextSize = require(CorePackages.Workspace.Packages.Style).GetTextSize
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaAppEnableChartsPageProfileLink = SharedFlags.FFlagLuaAppEnableChartsPageProfileLink
local FFlagLuaAppEnableMorePageProfileLink = SharedFlags.FFlagLuaAppEnableMorePageProfileLink
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local FFlagEnableLeftNavOnConsole = SharedFlags.FFlagEnableLeftNavOnConsole
local FFlagEnableNonFlyoutUncheckedBadge = SharedFlags.FFlagEnableNonFlyoutUncheckedBadge
local v29 = getIconSize(IconSize2.Small)
local v30 = Images["icons/status/premium_small"]

local function applyTokenScaling(n1: number, p1) -- line: 49
	return n1 * p1.Config.UI.Scale
end

return function(p2) -- line: 54
	-- upvalues: FFlagLuaAppEnableChartsPageProfileLink (copy), FFlagLuaAppEnableMorePageProfileLink (copy), FFlagEnableLeftNavOnConsole (copy), GuiService (copy), useTokens (copy), v29 (copy), FFlagEnableBlackbirdCheck (copy), FFlagHidePremiumIconography (copy), withStyle (copy), GetTextSize (copy), Roact (copy), FFlagEnableNonFlyoutUncheckedBadge (copy), LoadableImage (copy), EmojiTextLabel (copy), Emoji (copy), ImageSetLabel (copy), v30 (copy), Icon (copy), IconName (copy), IconSize (copy), View (copy), UncheckedBadge (copy)
	local v35 = p2.displayName or "..."
	local thumbnail = p2.thumbnail
	local isPremium = p2.isPremium
	local isVerified = p2.isVerified
	local localUserId = p2.localUserId

	local function v40() -- line: 60
		-- upvalues: p2 (copy), localUserId (copy), FFlagLuaAppEnableChartsPageProfileLink (copy), FFlagLuaAppEnableMorePageProfileLink (copy)
		p2.openLuaProfile(localUserId, {
			profilePeekViewProps = {
				resetPeekView = true,
				source = if not FFlagLuaAppEnableChartsPageProfileLink and not FFlagLuaAppEnableMorePageProfileLink then nil else p2.source
			}
		})
	end

	local v41 = FFlagEnableLeftNavOnConsole and not GuiService:IsTenFootInterface()
	local v42 = useTokens()
	local v43 = 36 * v42.Config.UI.Scale
	local v44 = 8 * v42.Config.UI.Scale
	local v45 = v29 * v42.Config.UI.Scale
	local v46 = 4 * v42.Config.UI.Scale
	local UIScale = v42.Config.UI.Scale
	local v48 = math.max(240, 288 / if UIScale ~= 0 then UIScale else 1)
	local v49 = if not FFlagEnableBlackbirdCheck then nil else p2.isRobloxSubscriber == true
	local v50 = not FFlagHidePremiumIconography and if not FFlagEnableBlackbirdCheck then isPremium else isPremium and not v49
	local v51 = v43 + v44
	local v52 = not v50 and (not FFlagEnableBlackbirdCheck or not v49) and 0 or v45 + v46

	return withStyle(function(p3) -- line: 93
		-- upvalues: v48 (copy), v51 (copy), v52 (copy), GetTextSize (copy), v35 (copy), v43 (copy), isVerified (copy), Roact (copy), FFlagEnableNonFlyoutUncheckedBadge (copy), FFlagEnableLeftNavOnConsole (copy), v41 (copy), v40 (copy), LoadableImage (copy), thumbnail (copy), EmojiTextLabel (copy), v51 (copy), Emoji (copy), v50 (copy), ImageSetLabel (copy), v30 (copy), v45 (copy), FFlagEnableBlackbirdCheck (copy), v49 (copy), Icon (copy), IconName (copy), IconSize (copy), v42 (copy), View (copy), UncheckedBadge (copy)
		local Header2Font = p3.Font.Header2.Font
		local v55 = p3.Font.BaseSize * p3.Font.Header2.RelativeSize
		local TextEmphasisColor = p3.Theme.TextEmphasis.Color
		local TextEmphasisTransparency = p3.Theme.TextEmphasis.Transparency
		local PlaceHolderColor = p3.Theme.PlaceHolder.Color
		local PlaceHolderTransparency = p3.Theme.PlaceHolder.Transparency
		local v60 = v48 - v51 - v52
		local v61 = GetTextSize(v35, v55, Header2Font, Vector2.new(v60, v43))
		local v62 = v51 + v61.X + v52 + (not isVerified and 0 or v55)
		local v63 = Roact.createElement("TextButton", {
			BackgroundTransparency = 1,
			Text = "",
			Size = UDim2.new(0, v62, 0, v43),
			LayoutOrder = if not FFlagEnableNonFlyoutUncheckedBadge then nil else 1,
			[Roact.Event.Activated] = if not FFlagEnableLeftNavOnConsole then v40 else if not v41 then nil else v40
		}, {
			Thumbnail = Roact.createElement(LoadableImage, {
				showFailedStateWhenLoadingFailed = true,
				useShimmerAnimationWhileLoading = true,
				BackgroundColor3 = PlaceHolderColor,
				BackgroundTransparency = PlaceHolderTransparency,
				Image = thumbnail,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.fromOffset(v43, v43),
				cornerRadius = UDim.new(0.5, 0)
			}),
			DisplayName = isVerified and Roact.createElement(EmojiTextLabel, {
				BackgroundTransparency = 1,
				fluidSizing = false,
				Text = v35,
				TextTransparency = TextEmphasisTransparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, v51, 0.5, 0),
				fontStyle = p3.Font.Header2,
				colorStyle = p3.Theme.TextEmphasis,
				emoji = Emoji.Verified,
				maxSize = Vector2.new(v61.X + v55, v61.Y)
			}) or Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Text = v35,
				Font = Header2Font,
				TextSize = v55,
				TextColor3 = TextEmphasisColor,
				TextTransparency = TextEmphasisTransparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, v51, 0.5, 0),
				Size = UDim2.fromOffset(v61.X, v61.Y)
			}),
			MembershipIcon = if not v50 then if not FFlagEnableBlackbirdCheck or not v49 then nil else Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.fromScale(1, 0.5),
				Size = UDim2.fromOffset(v45, v45)
			}, {
				Icon = Roact.createElement(Icon, {
					name = IconName.RobloxPlus,
					size = IconSize.Small,
					style = v42.Color.Content.Emphasis
				})
			}) else Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = v30,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.fromScale(1, 0.5),
				Size = UDim2.fromOffset(v45, v45),
				ImageColor3 = TextEmphasisColor,
				ImageTransparency = TextEmphasisTransparency
			})
		})

		if FFlagEnableNonFlyoutUncheckedBadge then
			return Roact.createElement(View, {
				tag = "row align-y-center gap-small auto-xy"
			}, {
				NameButton = v63,
				UncheckedBadge = Roact.createElement(UncheckedBadge, {
					layoutOrder = 2
				})
			})
		end

		return v63
	end)
end
