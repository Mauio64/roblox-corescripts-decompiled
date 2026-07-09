local function AvatarPolicies(p1) -- line: 1
	return {
		getAvatarHeaderIcon = function() -- line: 3
			-- upvalues: p1 (copy)
			return p1.AvatarHeaderIcon or "LuaApp/icons/ic-back"
		end,
		getAvatarEditorShowBuyRobuxOnTopBar = function() -- line: 6
			-- upvalues: p1 (copy)
			return p1.AvatarEditorShowBuyRobuxOnTopBar or false
		end,
		getCustomOutfitNames = function() -- line: 9
			-- upvalues: p1 (copy)
			if p1.CustomCostumeNames ~= nil then
				return p1.CustomCostumeNames
			end

			return true
		end
	}
end

return AvatarPolicies
