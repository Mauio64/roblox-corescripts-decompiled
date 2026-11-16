local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

local Constants = require(InExperienceShop.Constants)
require(InExperienceShop.Types)

local ROBUX_CATEGORY_NAME = Constants.ROBUX_CATEGORY_NAME

local function isRobuxNamed(item): boolean -- 2 equivalent calls inferred from this helper
	return item.name == ROBUX_CATEGORY_NAME
end

local function findRobux(sections) -- 1 equivalent call inferred from this helper
	for _, item in ipairs(sections) do
		if isRobuxNamed(item) then -- inferred equivalent call
			return item
		end
	end

	return nil
end

local function replaceOrRemoveRobux(list, p)
	local result = table.create(#list)
	local v = false

	for _, item in ipairs(list) do
		if isRobuxNamed(item) then -- inferred equivalent call
			if p ~= nil then
				table.insert(result, p)
			end

			v = true
		else
			table.insert(result, item)
		end
	end

	if not v and p ~= nil then
		table.insert(result, p)
	end

	return result
end

local function mergeRobuxShopData(p, p2, p3)
	local robux = findRobux(p3.sections) -- inferred equivalent call
	local v

	if robux ~= nil then
		local categories = p3.categories

		for _, category in ipairs(categories) do
			if category.name == ROBUX_CATEGORY_NAME then
				v = category
				break
			end
		end
	end

	return replaceOrRemoveRobux(p, v), replaceOrRemoveRobux(p2, robux)
end

return mergeRobuxShopData
