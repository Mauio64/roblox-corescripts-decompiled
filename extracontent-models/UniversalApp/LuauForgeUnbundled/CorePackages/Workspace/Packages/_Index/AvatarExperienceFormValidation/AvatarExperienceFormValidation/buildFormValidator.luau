require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceFormValidation/AvatarExperienceFormValidation/FormValidationErrorEnum")

local function buildFormValidator(items)
	return function(p2)
		for k, item in items do
			local v5, v6 = item(p2)

			if not v5 then
				return false, v6
			end
		end

		return true, nil
	end
end

return buildFormValidator
