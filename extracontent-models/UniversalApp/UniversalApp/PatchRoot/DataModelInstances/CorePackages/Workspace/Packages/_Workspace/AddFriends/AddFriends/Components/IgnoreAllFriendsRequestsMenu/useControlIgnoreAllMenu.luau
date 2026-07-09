local Parent = script:FindFirstAncestor("AddFriends").Parent
local React = require(Parent.React)
local Images = require(Parent.UIBlox).App.ImageSet.Images
local Foundation = require(Parent.Foundation)
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local FFlagAddFriendsUserListEnabled = require(Parent.SharedFlags).FFlagAddFriendsUserListEnabled

local function useControlIgnoreAllMenu() -- line: 14
	-- upvalues: React (copy), FFlagAddFriendsUserListEnabled (copy), IconName (copy), IconVariant (copy), Images (copy)
	local v9, v10 = React.useState(false)
	local v11 = React.useCallback(function() -- line: 17
		-- upvalues: v10 (copy)
		v10(function(p1) -- line: 18
			return not p1
		end)
	end, {})
	local v12 = React.useCallback(function() -- line: 23
		-- upvalues: v10 (copy)
		v10(false)
	end, {})
	local v13 = if not FFlagAddFriendsUserListEnabled then if not v9 then Images["icons/menu/more_off"] else Images["icons/menu/more_on"] else {
		name = IconName.ThreeDotsHorizontal,
		variant = if not v9 then IconVariant.Regular else IconVariant.Filled
	}

	return {
		isMenuOpen = v9,
		menuIcon = v13,
		onIconClick = v11,
		closeMenu = v12
	}
end

return useControlIgnoreAllMenu
