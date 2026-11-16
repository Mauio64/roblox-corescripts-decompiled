local function AvatarPolicies(data)
	return {
		getAvatarHeaderIcon = function()
			return data.AvatarHeaderIcon or "LuaApp/icons/ic-back"
		end,
		getAvatarEditorShowBuyRobuxOnTopBar = function()
			return data.AvatarEditorShowBuyRobuxOnTopBar or false
		end,
		getCustomOutfitNames = function()
			return data.CustomCostumeNames == nil or data.CustomCostumeNames
		end
	}
end

return AvatarPolicies
