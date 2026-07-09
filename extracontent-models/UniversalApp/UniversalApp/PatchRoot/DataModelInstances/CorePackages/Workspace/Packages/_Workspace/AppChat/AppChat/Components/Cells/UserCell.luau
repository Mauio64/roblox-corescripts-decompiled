local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)

require(AppChatParent.UIBlox)

local Cryo = require(AppChatParent.Cryo)
local PresenceBubbleCellStyled = require(script.Parent.PresenceBubbleCellStyled)
local UserModel = require(AppChatParent.UserLib).Models.UserModel
local v7 = require(AppChatParent.UIBlox).App.ImageSet.Images["component_assets/circle_25"]
local TestStyle = require(AppChat.SocialLibraries).Components.TestStyle
local FFlagEnableBlackbirdCheck = require(AppChatParent.SharedFlags).FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = require(AppChatParent.UserProfiles).Hooks.useIsRobloxSubscriber
local t1 = {
	subTitleText = "subTitleText",
	childWidth = 0,
	showDivider = true,
	boldTitle = true,
	user = {},
	style = Cryo.Dictionary.join(TestStyle, {
		Tokens = {
			Color = {
				None = {}
			}
		}
	})
}

local function UserCell(t2: {[any]: any}) -- line: 49
	-- upvalues: Cryo (copy), t1 (copy), React (copy), FFlagEnableBlackbirdCheck (copy), useIsRobloxSubscriber (copy), PresenceBubbleCellStyled (copy), UserModel (copy), v7 (copy)
	local v14 = Cryo.Dictionary.join(t1, t2)
	local v15 = React.useCallback(function() -- line: 51
		-- upvalues: v14 (copy)
		if v14.onActivated then
			v14.onActivated(v14.user)
		end
	end)
	local user = v14.user
	local v17 = user.metadata and user.metadata.isPending
	local v18 = nil

	if FFlagEnableBlackbirdCheck then
		v18 = useIsRobloxSubscriber(if not user.id then nil else tostring(user.id))
	end

	local v19 = React.useMemo(function() -- line: 65
		-- upvalues: user (copy)
		return { user.thumbnail }
	end, { user.thumbnail })

	return React.createElement(PresenceBubbleCellStyled, {
		style = v14.style,
		childWidth = v14.childWidth,
		onActivated = v15,
		onCircleActivated = v14.onCircleActivated,
		subTitleText = v14.subTitleText,
		showDivider = v14.showDivider,
		boldTitle = not v17 and v14.boldTitle,
		isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v18,
		avatarCirclePresenceImage = if user.presence == UserModel.PresenceType.OFFLINE or user.presence == nil then nil else v7,
		titleText = user.displayName,
		secondaryTitleText = user.alias,
		thumbnails = v19
	}, v14.children or {})
end

return React.memo(UserCell)
