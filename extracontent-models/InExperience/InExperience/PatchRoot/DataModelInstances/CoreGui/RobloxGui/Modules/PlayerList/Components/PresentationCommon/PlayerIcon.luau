local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local t = require(CorePackages.Packages.t)

local playerInterface = require(RobloxGui.Modules.Interfaces.playerInterface)

local parent = script.Parent.Parent
local connection = parent.Connection
local LayoutValues = require(connection.LayoutValues)
local WithLayoutValues = LayoutValues.WithLayoutValues

local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local useLayoutValues = PlayerList.Common.useLayoutValues

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local parent2 = parent.Parent
local FFlagPlayerListReduceRerenders = require(parent2.Flags.FFlagPlayerListReduceRerenders)
local FFlagPlayerListFoundationSubscriptionIcon = PlayerList.Flags.FFlagPlayerListFoundationSubscriptionIcon

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local function isFoundationImage(value: string?): boolean -- 2 equivalent calls inferred from this helper
	return value ~= nil and value ~= "" and value:match("^%w+://.*$") == nil
end

local extended = Roact.PureComponent:extend("PlayerIcon")

extended.validateProps = t.strictInterface({
	player = playerInterface,
	layoutOrder = t.optional(t.integer),
	isSmallTouchDevice = t.optional(t.boolean),
	playerIconInfo = t.strictInterface({
		isPlaceOwner = t.boolean,
		avatarIcon = t.optional(t.table),
		specialGroupIcon = t.optional(t.table)
	}),
	playerRelationship = t.strictInterface({
		isBlocked = t.boolean,
		friendStatus = t.enum(Enum.FriendStatus),
		isFollowing = t.boolean,
		isFollower = t.boolean
	}),
	layoutValues = t.optional(t.table)
})

local function getSocialIconImage(data, p) -- 1 equivalent call inferred from this helper
	local friendIcon = data.FriendIcons[p.friendStatus]

	if p.isBlocked then
		return data.BlockedIcon
	end

	return friendIcon or nil
end

local function getIconImage(layoutValues, player, playerIconInfo, playerRelationship)
	local socialIconImage = getSocialIconImage(layoutValues, playerRelationship) -- inferred equivalent call

	if socialIconImage then
		return socialIconImage
	end

	if playerIconInfo.isPlaceOwner then
		return layoutValues.PlaceOwnerIcon
	end

	if layoutValues.CustomPlayerIcons[player.UserId] then
		return layoutValues.CustomPlayerIcons[player.UserId]
	end

	if playerIconInfo.specialGroupIcon then
		return playerIconInfo.specialGroupIcon
	end

	if playerRelationship.isFollowing then
		return layoutValues.FollowingIcon
	end

	local v = player.MembershipType == Enum.MembershipType.Premium

	if FFlagEnableBlackbirdCheck then
		if game:GetEngineFeature("ReadHasRobloxSubscriptionLua") and player.HasRobloxSubscription then
			return layoutValues.SubscriptionIcon
		end

		local v2 = not FFlagHidePremiumIconography and v and layoutValues.MembershipIcons[player.MembershipType]

		if v2 then
			return v2
		end
	else
		local v2 = v and layoutValues.MembershipIcons[player.MembershipType]

		if v2 then
			return v2
		end
	end

	return ""
end

function extended.render(p)
	return WithLayoutValues(function(_)
		local layoutValues = p.props.layoutValues

		local image = p.props.playerIconInfo and p.props.playerIconInfo.avatarIcon

		if image == nil then
			image = layoutValues.DefaultThumbnail
		end

		if layoutValues.IsTenFoot then
			return Roact.createElement("ImageLabel", {
				LayoutOrder = p.props.layoutOrder or 1,
				Size = layoutValues.PlayerIconBackgroundSize,
				BackgroundTransparency = 1,
				Image = layoutValues.PlayerBackgroundImage
			}, { Roact.createElement("ImageLabel", {
					Size = layoutValues.PlayerIconSize,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = image,
					BorderSizePixel = 0
				}) })
		end

		if p.props.isSmallTouchDevice then
			local iconImage = getIconImage(
				layoutValues,
				p.props.player,
				p.props.playerIconInfo,
				p.props.playerRelationship
			)

			if
				not FFlagCoreUiMigrateUIBloxToFoundation
				and (not FFlagPlayerListFoundationSubscriptionIcon or typeof(iconImage) ~= "table" or not iconImage.isFoundationIcon)
			then
				return Roact.createElement(ImageSetLabel, {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, layoutValues.PlayerNamePaddingXMobile, 0.5, 0),
					Size = layoutValues.PlayerIconSizeMobile,
					BackgroundTransparency = 1,
					Image = iconImage,
					BorderSizePixel = 0
				})
			end

			local v

			if typeof(iconImage) == "table" then
				v = iconImage.name
			else
				v = iconImage
			end

			if FFlagCoreUiMigrateUIBloxToFoundation then
				if typeof(iconImage) == "table" and iconImage.Image ~= nil then
					v = iconImage.Image
				end

				if not isFoundationImage(v) then -- inferred equivalent call
					local imageRect = typeof(iconImage) == "table"
						and { offset = iconImage.ImageRectOffset, size = iconImage.ImageRectSize }
						or nil

					return Roact.createElement(Foundation.Image, {
						Image = v,
						imageRect = imageRect,
						Size = layoutValues.PlayerIconSizeMobile,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, layoutValues.PlayerNamePaddingXMobile, 0.5, 0)
					})
				end
			end

			return Roact.createElement(Foundation.Icon, {
				name = v,
				size = Foundation.Enums.IconSize.Medium,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, layoutValues.PlayerNamePaddingXMobile, 0.5, 0)
			})
		else
			local iconImage = getIconImage(
				layoutValues,
				p.props.player,
				p.props.playerIconInfo,
				p.props.playerRelationship
			)

			if
				not FFlagCoreUiMigrateUIBloxToFoundation
				and (not FFlagPlayerListFoundationSubscriptionIcon or typeof(iconImage) ~= "table" or not iconImage.isFoundationIcon)
			then
				return Roact.createElement(ImageSetLabel, {
					LayoutOrder = p.props.layoutOrder,
					Size = layoutValues.PlayerIconSize,
					BackgroundTransparency = 1,
					Image = iconImage,
					BorderSizePixel = 0
				})
			end

			local v

			if typeof(iconImage) == "table" then
				v = iconImage.name
			else
				v = iconImage
			end

			if FFlagCoreUiMigrateUIBloxToFoundation then
				if typeof(iconImage) == "table" and iconImage.Image ~= nil then
					v = iconImage.Image
				end

				if not isFoundationImage(v) then -- inferred equivalent call
					local imageRect = typeof(iconImage) == "table"
						and { offset = iconImage.ImageRectOffset, size = iconImage.ImageRectSize }
						or nil

					return Roact.createElement(Foundation.Image, {
						Image = v,
						imageRect = imageRect,
						Size = layoutValues.PlayerIconSize,
						LayoutOrder = p.props.layoutOrder
					})
				end
			end

			return Roact.createElement(Foundation.Icon, {
				name = v,
				size = Foundation.Enums.IconSize.Small,
				LayoutOrder = p.props.layoutOrder
			})
		end
	end)
end

local function mapStateToProps(p)
	return { isSmallTouchDevice = p.displayOptions.isSmallTouchDevice }
end

local function fn(p)
	local layoutValues = useLayoutValues()

	return React.createElement(extended, Cryo.Dictionary.join(p, { layoutValues = layoutValues }))
end

if FFlagPlayerListReduceRerenders then
	return React.memo(RoactRodux.connect(mapStateToProps, nil)(fn))
end

return RoactRodux.connect(mapStateToProps, nil)(fn)
