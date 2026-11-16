local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/dwA")
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useBreakpointXOrLarger = Responsive.useBreakpointXOrLarger

local module3 = require("@luauforge/deferred/fyI")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local function getPadding(p2)
	local v5 = useBreakpointXOrLarger(Responsive.Keys.Small)

	if module3 then
		return p2.Size.Size_500, p2.Size.Size_600
	end

	if v5 then
		return module.MORE_PAGE_WIDE_PADDING_HORIZONTAL, module.MORE_PAGE_WIDE_PADDING_VERTICAL
	end

	return module.MORE_PAGE_COMPACT_PADDING_HORIZONTAL, module.MORE_PAGE_SECTION_PADDING
end

local function withMorePagePaddings(p2)
	return function(p3)
		local v5 = useDesignTokens()
		local v6 = useBreakpointXOrLarger(Responsive.Keys.Small)
		local v7, v8

		if module3 then
			v7 = v5.Size.Size_500
			v8 = v5.Size.Size_600
		elseif v6 then
			v7 = module.MORE_PAGE_WIDE_PADDING_HORIZONTAL
			v8 = module.MORE_PAGE_WIDE_PADDING_VERTICAL
		else
			v7 = module.MORE_PAGE_COMPACT_PADDING_HORIZONTAL
			v8 = module.MORE_PAGE_SECTION_PADDING
		end

		local v9 = module.MORE_PAGE_CONTENT_MAX_WIDTH + v7 * 2

		return React.createElement(p2, Cryo.Dictionary.join(p3, {
			paddings = {
				paddingHorizontal = v7,
				paddingVertical = v8,
				contentMaxWidth = v9
			}
		}))
	end
end

return withMorePagePaddings
