local CorePackages = game:GetService("CorePackages")

local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local icon = Foundation.Icon
local view = Foundation.View
local iconSize = Foundation.Enums.IconSize
local iconName = Foundation.Enums.IconName
local emoji = UIBlox.App.Emoji.Enum.Emoji
local emojiTextLabel = UIBlox.Core.Text.EmojiTextLabel
local getIconSize = UIBlox.App.ImageSet.getIconSize
local iconSize2 = UIBlox.App.ImageSet.Enum.IconSize
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local loadableImage = UIBlox.App.Loading.LoadableImage
local withStyle = UIBlox.Core.Style.withStyle

local module = require("@luauforge/bundled/fAB")

local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagLuaAppEnableChartsPageProfileLink = SharedFlags.FFlagLuaAppEnableChartsPageProfileLink
local fFlagLuaAppEnableMorePageProfileLink = SharedFlags.FFlagLuaAppEnableMorePageProfileLink
local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local fFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local fFlagEnableNonFlyoutUncheckedBadge = SharedFlags.FFlagEnableNonFlyoutUncheckedBadge

local iconSize3 = getIconSize(iconSize2.Small)

local iconsstatuspremium_small = images["icons/status/premium_small"]

local function applyTokenScaling(p2, p3)
	return p2 * p3.Config.UI.Scale
end

return function(data)
	local displayName = data.displayName or "..."
	local thumbnail = data.thumbnail
	local v5 = data.isPremium
	local isVerified = data.isVerified
	local localUserId = data.localUserId
	local function fn()
		local openLuaProfile = data.openLuaProfile

		local v9 = if fFlagLuaAppEnableChartsPageProfileLink or fFlagLuaAppEnableMorePageProfileLink then data.source else nil
		openLuaProfile(localUserId, {
			profilePeekViewProps = { resetPeekView = true, source = v9 }
		})
	end
	local v6 = not isTenFootInterface()

	local v7 = useTokens()
	local v8 = 36 * v7.Config.UI.Scale
	local v9 = 8 * v7.Config.UI.Scale
	local v10 = iconSize3 * v7.Config.UI.Scale
	local v11 = 4 * v7.Config.UI.Scale

	local scale = v7.Config.UI.Scale
	local v12 = math.max(240, 288 / (scale == 0 and 1 or scale))

	local v13 = if fFlagEnableBlackbirdCheck then data.isRobloxSubscriber == true else nil

	if fFlagHidePremiumIconography then
		v5 = false
	elseif fFlagEnableBlackbirdCheck and v5 then
		v5 = not v13
	end

	local v14 = v8 + v9

	local v15 = not (v5 or fFlagEnableBlackbirdCheck and v13) and 0 or v10 + v11

	return withStyle(function(p2)
		local font = p2.Font.Header2.Font
		local v16 = p2.Font.BaseSize * p2.Font.Header2.RelativeSize
		local color = p2.Theme.TextEmphasis.Color
		local transparency = p2.Theme.TextEmphasis.Transparency
		local color2 = p2.Theme.PlaceHolder.Color
		local transparency2 = p2.Theme.PlaceHolder.Transparency

		local v17 = v12 - v14 - v15
		local textSize = getTextSize(displayName, v16, font, Vector2.new(v17, v8))
		local v18 = v14 + textSize.X + v15 + (not isVerified and 0 or v16)

		local createElement = Roact.createElement
		local v20 = {
			["BackgroundTransparency"] = nil,
			BackgroundTransparency = 1,
			Text = "",
			Size = UDim2.new(0, v18, 0, v8),
			LayoutOrder = fFlagEnableNonFlyoutUncheckedBadge and 1 or nil
		}

		local activated = Roact.Event.Activated
		v20[activated] = if v6 then fn else nil
		local v22 = {
			Thumbnail = Roact.createElement(loadableImage, {
				BackgroundColor3 = color2,
				BackgroundTransparency = transparency2,
				Image = thumbnail,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.fromOffset(v8, v8),
				cornerRadius = UDim.new(0.5, 0),
				showFailedStateWhenLoadingFailed = true,
				useShimmerAnimationWhileLoading = true
			}),
			DisplayName = isVerified and Roact.createElement(emojiTextLabel, {
				Text = displayName,
				TextTransparency = transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, v14, 0.5, 0),
				BackgroundTransparency = 1,
				fontStyle = p2.Font.Header2,
				colorStyle = p2.Theme.TextEmphasis,
				fluidSizing = false,
				emoji = emoji.Verified,
				maxSize = Vector2.new(textSize.X + v16, textSize.Y)
			}) or Roact.createElement("TextLabel", {
				Text = displayName,
				Font = font,
				TextSize = v16,
				TextColor3 = color,
				TextTransparency = transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, v14, 0.5, 0),
				Size = UDim2.fromOffset(textSize.X, textSize.Y),
				BackgroundTransparency = 1
			}),
			MembershipIcon = 0
		}
		local v23

		if v5 then
			v23 = Roact.createElement(imageSetLabel, {
				BackgroundTransparency = 1,
				Image = iconsstatuspremium_small,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.fromScale(1, 0.5),
				Size = UDim2.fromOffset(v10, v10),
				ImageColor3 = color,
				ImageTransparency = transparency
			})
		elseif fFlagEnableBlackbirdCheck and v13 then
			v23 = Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.fromScale(1, 0.5),
					Size = UDim2.fromOffset(v10, v10)
				},
				{
					Icon = Roact.createElement(icon, {
						name = iconName.RobloxPlus,
						size = iconSize.Small,
						style = v7.Color.Content.Emphasis
					})
				}
			)
		end

		v22.MembershipIcon = v23
		local element = createElement("TextButton", v20, v22)

		if fFlagEnableNonFlyoutUncheckedBadge then
			return Roact.createElement(view, {
				tag = "row align-y-center gap-small auto-xy"
			}, {
				NameButton = element,
				UncheckedBadge = Roact.createElement(module, { layoutOrder = 2 })
			})
		end

		return element
	end)
end
