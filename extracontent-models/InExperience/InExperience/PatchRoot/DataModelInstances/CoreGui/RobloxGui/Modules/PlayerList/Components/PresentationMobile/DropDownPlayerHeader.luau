local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local useLayoutValues = PlayerList.Common.useLayoutValues
local withStyle = UIBlox.Style.withStyle
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text
local Connection = script.Parent.Parent.Connection
local WithLayoutValues = require(Connection.LayoutValues).WithLayoutValues
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local useVerifiedBadge = UserProfiles.Hooks.useVerifiedBadge
local EmojiTextLabel = UIBlox.Core.Text.EmojiTextLabel
local Emoji = UIBlox.App.Emoji.Enum.Emoji
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local FFlagEnableVerifiedBadgeStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableVerifiedBadgeStore
local FFlagPlayerListDropDownShowPlatformName = PlayerList.Flags.FFlagPlayerListDropDownShowPlatformName
local _, result = pcall(function() -- line: 35
	return game:GetService("PlatformFriendsService")
end)
local v26 = Roact.PureComponent:extend("DropDownPlayerHeader")

v26.validateProps = t.strictInterface({
	player = t.instanceIsA("Player"),
	transparency = t.any,
	contentVisible = t.boolean,
	layoutValues = t.optional(t.table),
	tokens = t.optional(t.table),
	showVerifiedBadge = t.optional(t.boolean),
	platformName = t.optional(t.string),
	platformProfileId = t.optional(t.string),
	canShowPlatformProfile = t.optional(t.boolean)
})

function v26.render(p1) -- line: 54
	-- upvalues: WithLayoutValues (copy), withStyle (copy), FFlagEnableVerifiedBadgeStore (copy), UserLib (copy), FFlagPlayerListDropDownShowPlatformName (copy), Roact (copy), EmojiTextLabel (copy), Emoji (copy), FFlagEnableMobilePlayerListOnConsole (copy), View (copy), result (copy), FoundationImage (copy), FoundationText (copy)
	return WithLayoutValues(function(p2) -- line: 55
		-- upvalues: withStyle (copy), p1 (copy), FFlagEnableVerifiedBadgeStore (copy), UserLib (copy), FFlagPlayerListDropDownShowPlatformName (copy), Roact (copy), EmojiTextLabel (copy), Emoji (copy), FFlagEnableMobilePlayerListOnConsole (copy), View (copy), result (copy), FoundationImage (copy), FoundationText (copy)
		return withStyle(function(p3) -- line: 56
			-- upvalues: p2 (ref), p1 (copy), FFlagEnableVerifiedBadgeStore (copy), UserLib (copy), FFlagPlayerListDropDownShowPlatformName (copy), Roact (copy), EmojiTextLabel (copy), Emoji (copy), FFlagEnableMobilePlayerListOnConsole (copy), View (copy), result (copy), FoundationImage (copy), FoundationText (copy)
			p2 = p1.props.layoutValues

			local tokens = p1.props.tokens
			local Size_3000 = tokens.Size.Size_3000
			local Size_500 = tokens.Size.Size_500
			local player = p1.props.player
			local v44 = if not FFlagEnableVerifiedBadgeStore then UserLib.Utils.isPlayerVerified(player) else p1.props.showVerifiedBadge
			local v45 = if not FFlagPlayerListDropDownShowPlatformName then nil else p1.props.platformName and p1.props.platformName ~= ""
			local v46 = if not FFlagPlayerListDropDownShowPlatformName then nil else p1.props.canShowPlatformProfile

			return Roact.createElement("TextButton", {
				BackgroundTransparency = 1,
				Text = "",
				LayoutOrder = 0,
				Selectable = false,
				Size = UDim2.new(1, 0, 0, p2.DropDownHeaderSizeY)
			}, {
				Background = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Image = "rbxasset://textures/ui/PlayerList/NewAvatarBackground.png",
					ImageTransparency = p1.props.transparency,
					Size = UDim2.new(1, 0, 0, p2.DropDownHeaderBackgroundSize),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1)
				}, {
					TextContainerFrame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Visible = p1.props.contentVisible,
						Size = UDim2.new(1, -Size_3000, 1, 0),
						Position = UDim2.new(0, tokens.Size.Size_2700, 0, 0)
					}, {
						Layout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							Padding = UDim.new(0, 0),
							VerticalAlignment = Enum.VerticalAlignment.Center
						}),
						DisplayName = v44 and Roact.createElement(EmojiTextLabel, {
							fluidSizing = false,
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							fontStyle = p3.Font.Header2,
							colorStyle = p3.Theme.TextEmphasis,
							emoji = Emoji.Verified,
							maxSize = Vector2.new(p2.PlayerDropDownSizeXMobile - Size_3000, Size_500),
							TextSize = if not FFlagEnableMobilePlayerListOnConsole then p3.Font.BaseSize * p3.Font.Header2.RelativeSize else p2.DropDownHeaderDisplayNameTextSize,
							AutomaticSize = if not FFlagEnableMobilePlayerListOnConsole then nil else Enum.AutomaticSize.X,
							Text = player.DisplayName,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTruncate = Enum.TextTruncate.AtEnd,
							TextScaled = not FFlagEnableMobilePlayerListOnConsole or nil
						}) or Roact.createElement("TextLabel", {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, Size_500),
							Text = player.DisplayName,
							Font = p3.Font.Header2.Font,
							TextSize = if not FFlagEnableMobilePlayerListOnConsole then p3.Font.BaseSize * p3.Font.Header2.RelativeSize else p2.DropDownHeaderDisplayNameTextSize,
							TextColor3 = p3.Theme.TextEmphasis.Color,
							TextTransparency = p3.Theme.TextEmphasis.Transparency,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTruncate = Enum.TextTruncate.AtEnd,
							TextScaled = not FFlagEnableMobilePlayerListOnConsole or nil
						}, {
							SizeConstraint = if not FFlagEnableMobilePlayerListOnConsole then Roact.createElement("UITextSizeConstraint", {
								MaxTextSize = p3.Font.BaseSize * p3.Font.Header2.RelativeSize,
								MinTextSize = p3.Font.BaseSize * p3.Font.Footer.RelativeSize
							}) else nil
						}),
						PlayerName = Roact.createElement("TextLabel", {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, Size_500),
							Text = "@" .. player.Name,
							Font = p3.Font.CaptionHeader.Font,
							TextSize = if not FFlagEnableMobilePlayerListOnConsole then p3.Font.BaseSize * p3.Font.CaptionHeader.RelativeSize else p2.DropDownHeaderPlayerNameTextSize,
							TextColor3 = p3.Theme.TextMuted.Color,
							TextTransparency = p3.Theme.TextMuted.Transparency,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTruncate = Enum.TextTruncate.AtEnd,
							TextScaled = not FFlagEnableMobilePlayerListOnConsole or nil
						}, {
							SizeConstraint = if not FFlagEnableMobilePlayerListOnConsole then Roact.createElement("UITextSizeConstraint", {
								MaxTextSize = p3.Font.BaseSize * p3.Font.CaptionHeader.RelativeSize,
								MinTextSize = p3.Font.BaseSize * p3.Font.Footer.RelativeSize
							}) else nil
						}),
						PlatformName = FFlagPlayerListDropDownShowPlatformName and (v45 and Roact.createElement(View, {
							LayoutOrder = 3,
							tag = "row align-y-center gap-xsmall radius-small",
							Size = UDim2.new(1, 0, 0, Size_500),
							onActivated = if not v46 then nil else function() -- line: 163
								-- upvalues: p1 (copy), result (copy)
								local platformProfileId = p1.props.platformProfileId

								if result and (platformProfileId and platformProfileId ~= "") then
									result:ShowProfile(platformProfileId)
								end
							end
						}, {
							PlatformIcon = Roact.createElement(FoundationImage, {
								LayoutOrder = 1,
								Image = "rbxasset://textures/ui/Shell/Icons/PlatformLogo@3x.png",
								tag = "size-400",
								imageStyle = {
									Color3 = p3.Theme.TextMuted.Color,
									Transparency = not v46 and 0.4 or 0
								}
							}),
							PlatformNameButton = Roact.createElement(FoundationText, {
								LayoutOrder = 2,
								tag = "auto-y fill text-align-x-left text-truncate-end",
								Text = p1.props.platformName,
								fontStyle = {
									Font = p3.Font.CaptionHeader.Font,
									FontSize = p2.DropDownHeaderPlayerNameTextSize
								},
								textStyle = {
									Color3 = p3.Theme.TextMuted.Color,
									Transparency = if not v46 then math.clamp(p3.Theme.TextMuted.Transparency + 0.3, 0, 1) else p3.Theme.TextMuted.Transparency
								}
							})
						}))
					})
				}),
				AvatarImage = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Position = UDim2.new(0, tokens.Size.Size_1400, 0, 0),
					Size = UDim2.new(0, p2.DropDownHeaderSizeY, 0, p2.DropDownHeaderSizeY),
					AnchorPoint = Vector2.new(0.5, 0),
					ImageTransparency = p1.props.transparency,
					Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(player.UserId)
				}),
				Divider = not p1.props.lastButton and Roact.createElement("Frame", {
					BorderSizePixel = 0,
					ZIndex = 3,
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1),
					Visible = p1.props.contentVisible,
					BackgroundTransparency = p3.Theme.Divider.Transparency,
					BackgroundColor3 = p3.Theme.Divider.Color
				})
			})
		end)
	end)
end

return function(p4) -- line: 226
	-- upvalues: useLayoutValues (copy), useTokens (copy), FFlagEnableVerifiedBadgeStore (copy), useVerifiedBadge (copy), FFlagPlayerListDropDownShowPlatformName (copy), UserProfiles (copy), result (copy), Roact (copy), v26 (copy), Cryo (copy)
	local v29 = useLayoutValues()
	local v30 = useTokens()
	local v31 = if not FFlagEnableVerifiedBadgeStore then nil else useVerifiedBadge(p4.player)
	local v32 = nil
	local v33 = nil
	local v34 = nil

	if FFlagPlayerListDropDownShowPlatformName then
		local str = tostring(p4.player.UserId)
		local v36 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { str },
			query = UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
		})

		if v36.data then
			v32 = UserProfiles.Selectors.getPlatformNameFromId(v36.data, str)
			v33 = UserProfiles.Selectors.getPlatformProfileIdFromId(v36.data, str)
		end

		v34 = game:GetEngineFeature("PlatformFriendsService") and (game:GetEngineFeature("PlatformFriendsProfile") and (result and (result:IsProfileEnabled() and (v33 and v33 ~= ""))))
	end

	return Roact.createElement(v26, Cryo.Dictionary.join(p4, {
		layoutValues = v29,
		tokens = v30,
		showVerifiedBadge = if not FFlagEnableVerifiedBadgeStore then nil else v31,
		platformName = if not FFlagPlayerListDropDownShowPlatformName then nil else v32,
		platformProfileId = if not FFlagPlayerListDropDownShowPlatformName then nil else v33,
		canShowPlatformProfile = if not FFlagPlayerListDropDownShowPlatformName then nil else v34
	}))
end
