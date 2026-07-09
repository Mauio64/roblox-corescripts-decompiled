local SocialTab = script:FindFirstAncestor("SocialTab")
local SocialTabParent = SocialTab.Parent
local dependencies = require(SocialTab.dependencies)
local llama = dependencies.llama
local Roact = dependencies.Roact
local t = dependencies.t
local UIBlox = dependencies.UIBlox
local VerifiedBadges = dependencies.VerifiedBadges
local Foundation = dependencies.Foundation
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local SharedFlags = require(SocialTabParent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local GetFFlagFixUserInfoWidgetPlusBadge = SharedFlags.GetFFlagFixUserInfoWidgetPlusBadge
local StyledTextLabel = require(SocialTab.Components.StyledTextLabel)
local StyledImageSetLabel = require(SocialTab.Components.StyledImageSetLabel)
local EnumScreens = require(SocialTab.EnumScreens)
local v21 = t.interface({
	userText = t.string,
	avatarImage = t.optional(t.string),
	onActivated = t.optional(t.callback),
	isPremium = t.optional(t.boolean),
	isRobloxSubscriber = t.optional(t.boolean),
	navigateToLuaAppPages = t.optional(t.table),
	hasVerifiedBadge = t.optional(t.boolean)
})
local t1 = {
	userText = "",
	avatarImage = "",
	isPremium = false,
	isRobloxSubscriber = false,
	hasVerifiedBadge = false,
	onActivated = function() -- line: 40
	end
}

local function MembershipIcon(p1) -- line: 55
	-- upvalues: useTokens (copy), Roact (copy), Icon (copy), IconName (copy), IconSize (copy)
	local v25 = useTokens()

	return Roact.createElement(Icon, {
		name = IconName.RobloxPlus,
		size = IconSize.Small,
		style = v25.Color.Content.Emphasis,
		LayoutOrder = p1.LayoutOrder
	})
end

return function(p2) -- line: 65
	-- upvalues: llama (copy), t1 (copy), v21 (copy), GetFFlagFixUserInfoWidgetPlusBadge (copy), FFlagEnableBlackbirdCheck (copy), FFlagHidePremiumIconography (copy), VerifiedBadges (copy), UIBlox (copy), Roact (copy), StyledImageSetLabel (copy), EnumScreens (copy), StyledTextLabel (copy), MembershipIcon (copy)
	local u27 = llama.Dictionary.join(t1, p2)

	assert(v21(u27))

	local v28 = GetFFlagFixUserInfoWidgetPlusBadge()
	local v29 = v28 and (FFlagEnableBlackbirdCheck and u27.isRobloxSubscriber)
	local v30 = v28 and FFlagHidePremiumIconography
	local v31 = u27.isPremium and (not v29 and not v30)
	local u32 = if not u27.hasVerifiedBadge then not v31 and "" or VerifiedBadges.emoji.premium else VerifiedBadges.emoji.verified

	return UIBlox.Style.withStyle(function(p3) -- line: 86
		-- upvalues: Roact (copy), u27 (ref), StyledImageSetLabel (copy), VerifiedBadges (copy), u32 (ref), v31 (copy), EnumScreens (copy), StyledTextLabel (copy), v29 (copy), MembershipIcon (copy)
		local Theme = p3.Theme
		local p3Font = p3.Font

		return Roact.createElement("ImageButton", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, 36),
			[Roact.Event.Activated] = u27.onActivated,
			LayoutOrder = u27.layoutOrder
		}, {
			layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			avatarImage = Roact.createElement(StyledImageSetLabel, {
				LayoutOrder = 1,
				Image = u27.avatarImage,
				BackgroundStyle = p3.Theme.PlaceHolder,
				Size = UDim2.fromOffset(36, 36)
			}, {
				corner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				})
			}),
			spacer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.fromOffset(4, 0)
			}),
			userTextWrapper = Roact.createElement(VerifiedBadges.EmojiWrapper, {
				layoutOrder = 3,
				size = UDim2.fromScale(0, 0),
				emoji = u32,
				color = if not v31 then nil else Theme.TextEmphasis.Color,
				onActivated = if u32 ~= VerifiedBadges.emoji.verified then nil else function() -- line: 123
					-- upvalues: u27 (ref), EnumScreens (copy)
					u27.navigateToLuaAppPages[EnumScreens.VerifiedBadgeModal]()
				end
			}, {
				userText = Roact.createElement(StyledTextLabel, {
					TextStyle = Theme.TextEmphasis,
					FontStyle = p3Font.Header1,
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = u27.userText,
					AutomaticSize = Enum.AutomaticSize.XY
				})
			}),
			MembershipIcon = if not v29 then nil else Roact.createElement(MembershipIcon, {
				LayoutOrder = 4
			})
		})
	end)
end
