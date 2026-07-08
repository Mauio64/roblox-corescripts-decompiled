local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local t = require(CorePackages.Packages.t)
local playerInterface = require(RobloxGui.Modules.Interfaces.playerInterface)
local ParentParent = script.Parent.Parent
local Connection = ParentParent.Connection
local WithLayoutValues = require(Connection.LayoutValues).WithLayoutValues
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local useLayoutValues = PlayerList.Common.useLayoutValues
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local ParentParentParent = ParentParent.Parent
local FFlagPlayerListReduceRerenders = require(ParentParentParent.Flags.FFlagPlayerListReduceRerenders)
local FFlagPlayerListFoundationSubscriptionIcon = PlayerList.Flags.FFlagPlayerListFoundationSubscriptionIcon
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local function isFoundationImage(s1: string?) -- line: 34
	return s1 ~= nil and (s1 ~= "" and s1:match("^%w+://.*$") == nil)
end

local v25 = Roact.PureComponent:extend("PlayerIcon")

v25.validateProps = t.strictInterface({
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

local function getSocialIconImage(p1, p2) -- line: 61
	local v33 = p1.FriendIcons[p2.friendStatus]

	if p2.isBlocked then
		return p1.BlockedIcon
	end

	if v33 then
		return v33
	end

	return nil
end
local function getIconImage(p3, p4, p5, p6) -- line: 73
	-- upvalues: FFlagEnableBlackbirdCheck (copy), FFlagHidePremiumIconography (copy)
	local v38 = p3.FriendIcons[p6.friendStatus]
	local v39 = if not p6.isBlocked then v38 or nil else p3.BlockedIcon

	if v39 then
		return v39
	end

	if p5.isPlaceOwner then
		return p3.PlaceOwnerIcon
	end

	if p3.CustomPlayerIcons[p4.UserId] then
		return p3.CustomPlayerIcons[p4.UserId]
	end

	if p5.specialGroupIcon then
		return p5.specialGroupIcon
	end

	if p6.isFollowing then
		return p3.FollowingIcon
	end

	local v40 = p4.MembershipType == Enum.MembershipType.Premium

	if FFlagEnableBlackbirdCheck then
		if game:GetEngineFeature("ReadHasRobloxSubscriptionLua") and p4.HasRobloxSubscription then
			return p3.SubscriptionIcon
		end

		if not FFlagHidePremiumIconography and v40 then
			local v41 = p3.MembershipIcons[p4.MembershipType]

			if v41 then
				return v41
			end
		end
	elseif v40 then
		local v42 = p3.MembershipIcons[p4.MembershipType]

		if v42 then
			return v42
		end
	end

	return ""
end

function v25.render(p7) -- line: 115
	-- upvalues: WithLayoutValues (copy), Roact (copy), getIconImage (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FFlagPlayerListFoundationSubscriptionIcon (copy), Foundation (copy), ImageSetLabel (copy)
	return WithLayoutValues(function(_) -- line: 116
		-- upvalues: p7 (copy), Roact (copy), getIconImage (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FFlagPlayerListFoundationSubscriptionIcon (copy), Foundation (copy), ImageSetLabel (copy)
		local layoutValues = p7.props.layoutValues
		local v49 = p7.props.playerIconInfo and p7.props.playerIconInfo.avatarIcon

		if v49 == nil then
			v49 = layoutValues.DefaultThumbnail
		end

		if layoutValues.IsTenFoot then
			return Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = p7.props.layoutOrder or 1,
				Size = layoutValues.PlayerIconBackgroundSize,
				Image = layoutValues.PlayerBackgroundImage
			}, { Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = layoutValues.PlayerIconSize,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = v49
			}) })
		end

		if p7.props.isSmallTouchDevice then
			local v50 = getIconImage(layoutValues, p7.props.player, p7.props.playerIconInfo, p7.props.playerRelationship)

			if FFlagCoreUiMigrateUIBloxToFoundation or FFlagPlayerListFoundationSubscriptionIcon and typeof(v50) == "table" and v50.isFoundationIcon then
				local v51 = if typeof(v50) ~= "table" then v50 else v50.name

				if FFlagCoreUiMigrateUIBloxToFoundation then
					if typeof(v50) == "table" and v50.Image ~= nil then
						v51 = v50.Image
					end

					if v51 == nil or (v51 == "" or v51:match("^%w+://.*$") ~= nil) then
						local v52 = if typeof(v50) ~= "table" then nil else {
							offset = v50.ImageRectOffset,
							size = v50.ImageRectSize
						}

						return Roact.createElement(Foundation.Image, {
							Image = v51,
							imageRect = v52,
							Size = layoutValues.PlayerIconSizeMobile,
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(0, layoutValues.PlayerNamePaddingXMobile, 0.5, 0)
						})
					end
				end

				return Roact.createElement(Foundation.Icon, {
					name = v51,
					size = Foundation.Enums.IconSize.Medium,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, layoutValues.PlayerNamePaddingXMobile, 0.5, 0)
				})
			end

			return Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, layoutValues.PlayerNamePaddingXMobile, 0.5, 0),
				Size = layoutValues.PlayerIconSizeMobile,
				Image = v50
			})
		end

		local v53 = getIconImage(layoutValues, p7.props.player, p7.props.playerIconInfo, p7.props.playerRelationship)

		if FFlagCoreUiMigrateUIBloxToFoundation or FFlagPlayerListFoundationSubscriptionIcon and typeof(v53) == "table" and v53.isFoundationIcon then
			local v54 = if typeof(v53) ~= "table" then v53 else v53.name

			if FFlagCoreUiMigrateUIBloxToFoundation then
				if typeof(v53) == "table" and v53.Image ~= nil then
					v54 = v53.Image
				end

				if v54 == nil or (v54 == "" or v54:match("^%w+://.*$") ~= nil) then
					local v55 = if typeof(v53) ~= "table" then nil else {
						offset = v53.ImageRectOffset,
						size = v53.ImageRectSize
					}

					return Roact.createElement(Foundation.Image, {
						Image = v54,
						imageRect = v55,
						Size = layoutValues.PlayerIconSize,
						LayoutOrder = p7.props.layoutOrder
					})
				end
			end

			return Roact.createElement(Foundation.Icon, {
				name = v54,
				size = Foundation.Enums.IconSize.Small,
				LayoutOrder = p7.props.layoutOrder
			})
		end

		return Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = p7.props.layoutOrder,
			Size = layoutValues.PlayerIconSize,
			Image = v53
		})
	end)
end

local function mapStateToProps(p9) -- line: 239
	return {
		isSmallTouchDevice = p9.displayOptions.isSmallTouchDevice
	}
end
local function v29(p10) -- line: 245
	-- upvalues: useLayoutValues (copy), React (copy), v25 (copy), Cryo (copy)
	local v46 = useLayoutValues()

	return React.createElement(v25, Cryo.Dictionary.join(p10, {
		layoutValues = v46
	}))
end

if FFlagPlayerListReduceRerenders then
	return React.memo(RoactRodux.connect(mapStateToProps, nil)(v29))
end

return RoactRodux.connect(mapStateToProps, nil)(v29)
