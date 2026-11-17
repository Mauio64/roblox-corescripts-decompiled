local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

local useLayoutValues = PlayerList.Common.useLayoutValues

local withStyle = UIBlox.Style.withStyle

local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local Image = Foundation.Image
local Text = Foundation.Text

local Connection = script.Parent.Parent.Connection
local LayoutValues = require(Connection.LayoutValues)
local WithLayoutValues = LayoutValues.WithLayoutValues
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local useVerifiedBadge = UserProfiles.Hooks.useVerifiedBadge

local EmojiTextLabel = UIBlox.Core.Text.EmojiTextLabel
local Emoji = UIBlox.App.Emoji.Enum.Emoji

local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore
local FFlagPlayerListDropDownShowPlatformName = PlayerList.Flags.FFlagPlayerListDropDownShowPlatformName

local _, result = pcall(function()
	return game:GetService("PlatformFriendsService")
end)

local extended = Roact.PureComponent:extend("DropDownPlayerHeader")

extended.validateProps = t.strictInterface({
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

function extended.render(p)
	return WithLayoutValues(function(data)
		return withStyle(function(props)
			data = p.props.layoutValues
			local tokens = p.props.tokens
			local size_3000 = tokens.Size.Size_3000
			local size_500 = tokens.Size.Size_500

			local player = p.props.player
			local v

			if FFlagEnableVerifiedBadgeStore then
				v = p.props.showVerifiedBadge
			else
				v = UserLib.Utils.isPlayerVerified(player)
			end

			local v2

			if FFlagPlayerListDropDownShowPlatformName then
				v2 = p.props.platformName and p.props.platformName ~= ""
			end

			local canShowPlatformProfile

			if FFlagPlayerListDropDownShowPlatformName then
				canShowPlatformProfile = p.props.canShowPlatformProfile
			end

			local createElement = Roact.createElement
			local v3 = {
				BackgroundTransparency = 1,
				Text = "",
				Size = UDim2.new(1, 0, 0, data.DropDownHeaderSizeY),
				LayoutOrder = 0,
				Selectable = false
			}

			local createElement2 = Roact.createElement
			local v4 = {
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/PlayerList/NewAvatarBackground.png",
				ImageTransparency = p.props.transparency,
				Size = UDim2.new(1, 0, 0, data.DropDownHeaderBackgroundSize),
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1)
			}

			local createElement3 = Roact.createElement
			local v5 = {
				Visible = p.props.contentVisible,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -size_3000, 1, 0),
				Position = UDim2.new(0, tokens.Size.Size_2700, 0, 0)
			}
			local v6 = {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 0),
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				DisplayName = 0,
				PlayerName = 0,
				PlatformName = 0
			}
			local displayName, createElement4, v7, v8, textSize, v9, sizeConstraint

			if v then
				local createElement5 = Roact.createElement
				local v10 = {
					fontStyle = Cryo.Dictionary.join(props.Font.Header2, {
						Font = props.Tokens.Typography.TitleLarge.Font
					}),
					colorStyle = props.Theme.TextEmphasis,
					fluidSizing = false,
					emoji = Emoji.Verified,
					maxSize = Vector2.new(data.PlayerDropDownSizeXMobile - size_3000, size_500),
					TextSize = 0,
					AutomaticSize = 0,
					LayoutOrder = 1,
					Text = 0,
					TextXAlignment = 0,
					TextTruncate = 0,
					BackgroundTransparency = 1,
					TextScaled = 0
				}
				local textSize2

				if FFlagEnableMobilePlayerListOnConsole then
					textSize2 = data.DropDownHeaderDisplayNameTextSize
				else
					textSize2 = props.Font.BaseSize * props.Font.Header2.RelativeSize
				end

				v10.TextSize = textSize2
				local automaticSize

				if FFlagEnableMobilePlayerListOnConsole then
					automaticSize = Enum.AutomaticSize.X
				end

				v10.AutomaticSize = automaticSize

				v10.Text = player.DisplayName
				v10.TextXAlignment = Enum.TextXAlignment.Left
				v10.TextTruncate = Enum.TextTruncate.AtEnd

				v10.TextScaled = not FFlagEnableMobilePlayerListOnConsole or nil
				displayName = createElement5(EmojiTextLabel, v10)

				if not displayName then
					createElement4 = Roact.createElement
					v7 = "TextLabel"
					v8 = {
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, size_500),
						Text = player.DisplayName,
						FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
						TextSize = 0,
						TextColor3 = 0,
						TextTransparency = 0,
						TextXAlignment = 0,
						TextTruncate = 0,
						BackgroundTransparency = 1,
						TextScaled = 0
					}

					if FFlagEnableMobilePlayerListOnConsole then
						textSize = data.DropDownHeaderDisplayNameTextSize
					else
						textSize = props.Font.BaseSize * props.Font.Header2.RelativeSize
					end

					v8.TextSize = textSize
					v8.TextColor3 = props.Theme.TextEmphasis.Color
					v8.TextTransparency = props.Theme.TextEmphasis.Transparency
					v8.TextXAlignment = Enum.TextXAlignment.Left
					v8.TextTruncate = Enum.TextTruncate.AtEnd

					v8.TextScaled = not FFlagEnableMobilePlayerListOnConsole or nil
					v9 = { SizeConstraint = 0 }

					if not FFlagEnableMobilePlayerListOnConsole then
						sizeConstraint = Roact.createElement("UITextSizeConstraint", {
							MaxTextSize = props.Font.BaseSize * props.Font.Header2.RelativeSize,
							MinTextSize = props.Font.BaseSize * props.Font.Footer.RelativeSize
						})
					end

					v9.SizeConstraint = sizeConstraint
					displayName = createElement4(v7, v8, v9)
				end
			else
				createElement4 = Roact.createElement
				v7 = "TextLabel"
				v8 = {
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, size_500),
					Text = player.DisplayName,
					FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					TextXAlignment = 0,
					TextTruncate = 0,
					BackgroundTransparency = 1,
					TextScaled = 0
				}

				if FFlagEnableMobilePlayerListOnConsole then
					textSize = data.DropDownHeaderDisplayNameTextSize
				else
					textSize = props.Font.BaseSize * props.Font.Header2.RelativeSize
				end

				v8.TextSize = textSize
				v8.TextColor3 = props.Theme.TextEmphasis.Color
				v8.TextTransparency = props.Theme.TextEmphasis.Transparency
				v8.TextXAlignment = Enum.TextXAlignment.Left
				v8.TextTruncate = Enum.TextTruncate.AtEnd

				v8.TextScaled = not FFlagEnableMobilePlayerListOnConsole or nil
				v9 = { SizeConstraint = 0 }

				if not FFlagEnableMobilePlayerListOnConsole then
					sizeConstraint = Roact.createElement("UITextSizeConstraint", {
						MaxTextSize = props.Font.BaseSize * props.Font.Header2.RelativeSize,
						MinTextSize = props.Font.BaseSize * props.Font.Footer.RelativeSize
					})
				end

				v9.SizeConstraint = sizeConstraint
				displayName = createElement4(v7, v8, v9)
			end

			v6.DisplayName = displayName

			local createElement5 = Roact.createElement
			local v10 = {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, size_500),
				Text = "@" .. player.Name,
				FontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font),
				TextSize = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				TextXAlignment = 0,
				TextTruncate = 0,
				BackgroundTransparency = 1,
				TextScaled = 0
			}
			local textSize2

			if FFlagEnableMobilePlayerListOnConsole then
				textSize2 = data.DropDownHeaderPlayerNameTextSize
			else
				textSize2 = props.Font.BaseSize * props.Font.CaptionHeader.RelativeSize
			end

			v10.TextSize = textSize2
			v10.TextColor3 = props.Theme.TextMuted.Color
			v10.TextTransparency = props.Theme.TextMuted.Transparency
			v10.TextXAlignment = Enum.TextXAlignment.Left
			v10.TextTruncate = Enum.TextTruncate.AtEnd

			v10.TextScaled = not FFlagEnableMobilePlayerListOnConsole or nil
			local sizeConstraint2

			if not FFlagEnableMobilePlayerListOnConsole then
				sizeConstraint2 = Roact.createElement("UITextSizeConstraint", {
					MaxTextSize = props.Font.BaseSize * props.Font.CaptionHeader.RelativeSize,
					MinTextSize = props.Font.BaseSize * props.Font.Footer.RelativeSize
				})
			end

			v6.PlayerName = createElement5("TextLabel", v10, { SizeConstraint = sizeConstraint2 })

			local platformName = FFlagPlayerListDropDownShowPlatformName

			if platformName then
				if v2 then
					local createElement6 = Roact.createElement
					local v11 = {
						LayoutOrder = 3,
						tag = "row align-y-center gap-xsmall radius-small",
						Size = UDim2.new(1, 0, 0, size_500),
						onActivated = canShowPlatformProfile and function()
							local platformProfileId = p.props.platformProfileId

							if result and platformProfileId and platformProfileId ~= "" then
								result:ShowProfile(platformProfileId)
							end
						end or nil
					}

					local v12 = {
						PlatformIcon = Roact.createElement(Image, {
							LayoutOrder = 1,
							Image = "rbxasset://textures/ui/Shell/Icons/PlatformLogo@3x.png",
							tag = "size-400",
							imageStyle = {
								Color3 = props.Theme.TextMuted.Color,
								Transparency = canShowPlatformProfile and 0 or 0.4
							}
						}),
						PlatformNameButton = 0
					}

					local createElement7 = Roact.createElement
					local v13 = {
						LayoutOrder = 2,
						tag = "auto-y fill text-align-x-left text-truncate-end",
						Text = p.props.platformName,
						fontStyle = {
							Font = props.Font.CaptionHeader.Font,
							FontSize = data.DropDownHeaderPlayerNameTextSize
						},
						textStyle = 0
					}

					local textStyle = { Color3 = props.Theme.TextMuted.Color, Transparency = 0 }
					local transparency

					if canShowPlatformProfile then
						transparency = props.Theme.TextMuted.Transparency
					else
						transparency = math.clamp(props.Theme.TextMuted.Transparency + 0.3, 0, 1)
					end

					textStyle.Transparency = transparency
					v13.textStyle = textStyle
					v12.PlatformNameButton = createElement7(Text, v13)
					platformName = createElement6(View, v11, v12)
				else
					platformName = v2
				end
			end

			v6.PlatformName = platformName
			return createElement("TextButton", v3, {
				Background = createElement2("ImageLabel", v4, {
					TextContainerFrame = createElement3("Frame", v5, v6)
				}),
				AvatarImage = Roact.createElement("ImageLabel", {
					Position = UDim2.new(0, tokens.Size.Size_1400, 0, 0),
					Size = UDim2.new(0, data.DropDownHeaderSizeY, 0, data.DropDownHeaderSizeY),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					ImageTransparency = p.props.transparency,
					Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(player.UserId),
					ZIndex = 2
				}),
				Divider = not p.props.lastButton and Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1),
					Visible = p.props.contentVisible,
					BackgroundTransparency = props.Theme.Divider.Transparency,
					BackgroundColor3 = props.Theme.Divider.Color,
					BorderSizePixel = 0,
					ZIndex = 3
				})
			})
		end)
	end)
end

return function(p)
	local layoutValues = useLayoutValues()
	local tokens = useTokens()
	local showVerifiedBadge

	if FFlagEnableVerifiedBadgeStore then
		showVerifiedBadge = useVerifiedBadge(p.player)
	end

	local platformName = nil
	local platformProfileId = nil
	local canShowPlatformProfile

	if FFlagPlayerListDropDownShowPlatformName then
		local userId = tostring(p.player.UserId)
		local v = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { userId },
			query = UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
		})

		if v.data then
			platformName = UserProfiles.Selectors.getPlatformNameFromId(v.data, userId)
			platformProfileId = UserProfiles.Selectors.getPlatformProfileIdFromId(v.data, userId)
		end

		canShowPlatformProfile = game:GetEngineFeature("PlatformFriendsService")
			and game:GetEngineFeature("PlatformFriendsProfile")
			and result
			and result:IsProfileEnabled()
			and platformProfileId
			and platformProfileId ~= ""
	end

	local createElement = Roact.createElement
	local join = Cryo.Dictionary.join

	if not FFlagEnableVerifiedBadgeStore then
		showVerifiedBadge = nil
	end

	if not FFlagPlayerListDropDownShowPlatformName then
		platformName = nil
	end

	if not FFlagPlayerListDropDownShowPlatformName then
		platformProfileId = nil
	end

	if not FFlagPlayerListDropDownShowPlatformName then
		canShowPlatformProfile = nil
	end

	return createElement(extended, join(p, {
		layoutValues = layoutValues,
		tokens = tokens,
		showVerifiedBadge = showVerifiedBadge,
		platformName = platformName,
		platformProfileId = platformProfileId,
		canShowPlatformProfile = canShowPlatformProfile
	}))
end
