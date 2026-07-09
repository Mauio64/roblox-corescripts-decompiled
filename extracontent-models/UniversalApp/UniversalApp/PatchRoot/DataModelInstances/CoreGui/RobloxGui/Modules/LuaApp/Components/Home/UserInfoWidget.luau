local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local LoadableImage = UIBlox.App.Loading.LoadableImage
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local isPlayerVerified = require(CorePackages.Workspace.Packages.UserLib).Utils.isPlayerVerified
local getStandardSizeAvatarHeadShotRbxthumb = require(CorePackages.Workspace.Packages.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local Foundation = require(CorePackages.Packages.Foundation)
local View = Foundation.View
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaAppMoveProfileIntoTopBar = SharedFlags.FFlagLuaAppMoveProfileIntoTopBar
local FFlagEnableNonFlyoutUncheckedBadge = SharedFlags.FFlagEnableNonFlyoutUncheckedBadge
local v23 = FFlagEnableNonFlyoutUncheckedBadge and game:DefineFastFlag("FixUsernameSelectionStuck", false)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local GetFFlagFixUserInfoWidgetPlusBadge = SharedFlags.GetFFlagFixUserInfoWidgetPlusBadge
local GetFFlagFixUserInfoSelection = require(Modules.LuaApp.Flags.GetFFlagFixUserInfoSelection)
local UncheckedBadge = require(Modules.LuaApp.Components.Common.UncheckedBadge)
local v29 = Roact.PureComponent:extend("UserWidget")
local t1 = {
	[Enum.MembershipType.None] = 0,
	[Enum.MembershipType.BuildersClub] = 24,
	[Enum.MembershipType.TurboBuildersClub] = 24,
	[Enum.MembershipType.OutrageousBuildersClub] = 24,
	[Enum.MembershipType.Premium] = 36
}

function v29.renderUserAvatar(_, p2, p3, p4, p5) -- line: 50
	-- upvalues: getStandardSizeAvatarHeadShotRbxthumb (copy), Roact (copy), LoadableImage (copy)
	local v37 = getStandardSizeAvatarHeadShotRbxthumb(p5.id)

	return Roact.createElement(LoadableImage, {
		LayoutOrder = 1,
		useShimmerAnimationWhileLoading = true,
		shouldHandleReloads = true,
		Size = UDim2.new(0, p2, 0, p2),
		BackgroundColor3 = p3,
		BackgroundTransparency = p4,
		Image = v37,
		cornerRadius = UDim.new(0.5, 0)
	})
end
function v29.render(p6) -- line: 70
	-- upvalues: FFlagLuaAppMoveProfileIntoTopBar (copy), GetFFlagFixUserInfoWidgetPlusBadge (copy), FFlagEnableBlackbirdCheck (copy), FFlagHidePremiumIconography (copy), t1 (copy), Text (copy), Roact (copy), VerifiedBadges (copy), isPlayerVerified (copy), Players (copy), v23 (copy), Icon (copy), IconName (copy), IconSize (copy), FFlagEnableNonFlyoutUncheckedBadge (copy), GetFFlagFixUserInfoSelection (copy), View (copy), UncheckedBadge (copy), withStyle (copy)
	local localUserModel = p6.props.localUserModel
	local onActivated = p6.props.onActivated
	local layoutOrder = p6.props.layoutOrder
	local sideMargin = p6.props.sideMargin
	local v43 = if not FFlagLuaAppMoveProfileIntoTopBar then nil else p6.props.shouldOnlyDisplayAvatarIcon
	local v44 = if not FFlagLuaAppMoveProfileIntoTopBar then nil else p6.props.onlyAvatarButtonRef

	if localUserModel == nil then
		return nil
	end

	local v45 = not p6.props.thumbnailSize and 36 or p6.props.thumbnailSize
	local name = localUserModel.name

	if p6.props.enableDisplayNamePolicy then
		name = localUserModel.displayName
	end

	local membership = localUserModel.membership
	local v48 = if not GetFFlagFixUserInfoWidgetPlusBadge() or not FFlagEnableBlackbirdCheck then nil else localUserModel.hasRobloxSubscription == true
	local v49 = if not GetFFlagFixUserInfoWidgetPlusBadge() then membership == Enum.MembershipType.Premium else not FFlagHidePremiumIconography and (membership == Enum.MembershipType.Premium and not v48)

	return withStyle(function(p7) -- line: 104
		-- upvalues: p6 (copy), GetFFlagFixUserInfoWidgetPlusBadge (copy), v49 (copy), v48 (copy), t1 (copy), membership (copy), Text (copy), name (ref), Roact (copy), VerifiedBadges (copy), isPlayerVerified (copy), Players (copy), onActivated (copy), v23 (copy), Icon (copy), IconName (copy), IconSize (copy), v45 (copy), FFlagEnableNonFlyoutUncheckedBadge (copy), FFlagLuaAppMoveProfileIntoTopBar (copy), v44 (copy), GetFFlagFixUserInfoSelection (copy), v43 (copy), localUserModel (copy), View (copy), layoutOrder (copy), sideMargin (copy), UncheckedBadge (copy)
		local p7Font = p7.Font
		local Theme = p7.Theme
		local v57 = if not p6.props.usernameTextFont then p7Font.Header1 else p6.props.usernameTextFont
		local v58 = if not p6.props.usernameTextStyle then Theme.TextEmphasis else p6.props.usernameTextStyle
		local Font = v57.Font
		local v60 = if not v57.FontSize then p7Font.BaseSize * v57.RelativeSize else v57.FontSize
		local v61 = if not GetFFlagFixUserInfoWidgetPlusBadge() then membership ~= nil and t1[membership] or 0 else not (not v49 and not v48) and t1[Enum.MembershipType.Premium] or 0
		local Color = v58.Color
		local Transparency = v58.Transparency
		local PlaceHolderColor = Theme.PlaceHolder.Color
		local PlaceHolderTransparency = Theme.PlaceHolder.Transparency
		local v66 = Text.GetTextBounds(name, Font, v60, Vector2.new(10000, 10000))
		local v67 = Roact.createElement(VerifiedBadges.EmojiWrapper, {
			layoutOrder = 2,
			size = UDim2.fromScale(0, 0),
			emoji = if not isPlayerVerified(Players.LocalPlayer) then not v49 and "" or VerifiedBadges.emoji.premium else VerifiedBadges.emoji.verified,
			color = if not v49 then nil else Theme.TextEmphasis.Color,
			onActivated = onActivated
		}, {
			UsernameText = Roact.createElement("TextButton", {
				Size = UDim2.new(0, v66.X, 0, v66.Y),
				BackgroundTransparency = 1,
				TextSize = v60,
				TextColor3 = Color,
				TextTransparency = Transparency,
				TextTruncate = Enum.TextTruncate.None,
				Font = Font,
				Text = name,
				TextXAlignment = Enum.TextXAlignment.Left,
				[Roact.Event.Activated] = if v23 then nil else onActivated,
				Selectable = not v23 and onActivated ~= nil
			})
		})
		local v68 = if not GetFFlagFixUserInfoWidgetPlusBadge() or not v48 then nil else Roact.createElement(Icon, {
			LayoutOrder = 3,
			name = IconName.RobloxPlus,
			size = IconSize.Small,
			style = p6.props.foundationTokens.Color.Content.Emphasis
		})
		local v69 = Roact.createElement("TextButton", {
			Size = UDim2.new(0, v45, 0, v45),
			AutomaticSize = if not FFlagEnableNonFlyoutUncheckedBadge then nil else Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Text = "",
			LayoutOrder = 1,
			[Roact.Event.Activated] = onActivated,
			[Roact.Ref] = if not FFlagLuaAppMoveProfileIntoTopBar then nil else v44,
			Selectable = if not GetFFlagFixUserInfoSelection() then nil else p6.props.selectable
		}, if not FFlagLuaAppMoveProfileIntoTopBar or not v43 then {
			HorizontalLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 12)
			}),
			UserAvatar = p6:renderUserAvatar(v45, PlaceHolderColor, PlaceHolderTransparency, localUserModel),
			if not FFlagEnableNonFlyoutUncheckedBadge then Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(0, v66.X + v61 + 4, 0, v66.Y),
				AutomaticSize = Enum.AutomaticSize.None
			}, {
				HorizontalLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 4)
				}),
				Username = v67,
				MembershipIcon = if not GetFFlagFixUserInfoWidgetPlusBadge() then nil else v68
			}) else Roact.createElement(View, {
				tag = "row align-y-center gap-xsmall auto-xy",
				LayoutOrder = 2
			}, {
				Username = v67,
				MembershipIcon = if not GetFFlagFixUserInfoWidgetPlusBadge() then nil else v68
			})
		} else {
			UserAvatar = p6:renderUserAvatar(v45, PlaceHolderColor, PlaceHolderTransparency, localUserModel)
		})

		if FFlagEnableNonFlyoutUncheckedBadge then
			return Roact.createElement(View, {
				tag = "row align-y-center gap-small size-full-0 auto-y",
				LayoutOrder = layoutOrder,
				padding = {
					left = UDim.new(0, sideMargin),
					right = UDim.new(0, sideMargin)
				}
			}, {
				UsernameAvatarFrame = v69,
				UncheckedBadge = Roact.createElement(UncheckedBadge, {
					layoutOrder = 2
				})
			})
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, sideMargin),
				PaddingRight = UDim.new(0, sideMargin)
			}),
			UsernameAvatarFrame = v69
		})
	end)
end

if GetFFlagFixUserInfoWidgetPlusBadge() then
	local v31 = v29

	function v29(p8) -- line: 252
		-- upvalues: useTokens (copy), Roact (copy), v31 (copy), Cryo (copy)
		local v51 = useTokens()

		return Roact.createElement(v31, Cryo.Dictionary.join(p8, {
			foundationTokens = v51
		}))
	end
end

return RoactAppPolicy.connect(function(p9, _) -- line: 264
	return {
		enableDisplayNamePolicy = p9.getShowDisplayName()
	}
end)(v29)
