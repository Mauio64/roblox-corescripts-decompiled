local module = require("@luauforge/bundled/gTj")

local isAvatarRoute = module.isAvatarRoute
local isAvatarExperienceWrapper = module.isAvatarExperienceWrapper
local opaquePageFromRoute = module.opaquePageFromRoute

local function isAxRelevantRoute(list)
	local item = list[#list]

	if isAvatarRoute(item.name) then
		return true
	end

	local v5 = opaquePageFromRoute(list)
	return isAvatarRoute(v5.name) or isAvatarExperienceWrapper(item) or isAvatarExperienceWrapper(v5)
end

local function pagesAreEquivalent(data, data2): boolean
	return data.name == data2.name and data.detail == data2.detail and data.extraProps == data2.extraProps
end

return function(list, list2)
	if list == list2 then
		return true
	end

	if list == nil or list2 == nil then
		return false
	end

	local item = list[#list]
	local item2 = list2[#list2]

	if isAvatarRoute(item.name) and isAvatarRoute(item2.name) then
		return true
	end

	local item3 = list[#list]
	local v5

	if isAvatarRoute(item3.name) then
		v5 = true
	else
		local v6 = opaquePageFromRoute(list)
		v5 = isAvatarRoute(v6.name) or isAvatarExperienceWrapper(item3) or isAvatarExperienceWrapper(v6)
	end

	if not v5 then
		local item4 = list2[#list2]
		local v6

		if isAvatarRoute(item4.name) then
			v6 = true
		else
			local v7 = opaquePageFromRoute(list2)
			v6 = isAvatarRoute(v7.name) or isAvatarExperienceWrapper(item4) or isAvatarExperienceWrapper(v7)
		end

		if not v6 then
			return true
		end
	end

	local v6

	if item.name == item2.name and item.detail == item2.detail then
		v6 = item.extraProps == item2.extraProps
	else
		v6 = false
	end

	if not v6 then
		return v6
	end

	local v7 = opaquePageFromRoute(list)
	local v8 = opaquePageFromRoute(list2)
	v6 = v7.name == v8.name and v7.detail == v8.detail and v7.extraProps == v8.extraProps
	return v6
end
