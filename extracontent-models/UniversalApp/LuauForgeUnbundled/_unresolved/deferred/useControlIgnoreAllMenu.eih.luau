local module = require("@luauforge/deferred/eeO")
local images = require("@luauforge/deferred/egd").App.ImageSet.Images

local module2 = require("@luauforge/deferred/ege")
local iconName = module2.Enums.IconName
local iconVariant = module2.Enums.IconVariant

local fFlagAddFriendsUserListEnabled = require("@luauforge/deferred/efc").FFlagAddFriendsUserListEnabled

local function useControlIgnoreAllMenu()
	local state, setState = module.useState(false)

	local ref = module.useRef(nil)
	local v5 = module.useCallback(function()
		setState(function(p2): boolean
			return not p2
		end)
	end, {})

	local v6 = module.useCallback(function()
		setState(false)
	end, {})
	local v7

	if fFlagAddFriendsUserListEnabled then
		v7 = { name = iconName.ThreeDotsHorizontal, variant = 0 }
		local v8 = if state then iconVariant.Filled else iconVariant.Regular
		v7.variant = v8
	else
		v7 = if state then images["icons/menu/more_on"] else images["icons/menu/more_off"]
	end

	return {
		isMenuOpen = state,
		menuIcon = v7,
		onIconClick = v5,
		closeMenu = v6,
		iconRef = ref
	}
end

return useControlIgnoreAllMenu
