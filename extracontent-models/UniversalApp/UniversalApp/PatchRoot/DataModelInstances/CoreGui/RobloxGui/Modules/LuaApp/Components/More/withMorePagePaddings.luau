local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Constants = require(Modules.LuaApp.Constants)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useBreakpointXOrLarger = Responsive.useBreakpointXOrLarger
local FFlagEnableDevicePreferenceLayoutUpdate = require(Modules.LuaApp.Flags.FFlagEnableDevicePreferenceLayoutUpdate)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens

local function getPadding(p1) -- line: 18
	-- upvalues: useBreakpointXOrLarger (copy), Responsive (copy), FFlagEnableDevicePreferenceLayoutUpdate (copy), Constants (copy)
	local v13 = useBreakpointXOrLarger(Responsive.Keys.Small)

	if FFlagEnableDevicePreferenceLayoutUpdate then
		return p1.Size.Size_500, p1.Size.Size_600
	end

	if v13 then
		return Constants.MORE_PAGE_WIDE_PADDING_HORIZONTAL, Constants.MORE_PAGE_WIDE_PADDING_VERTICAL
	end

	return Constants.MORE_PAGE_COMPACT_PADDING_HORIZONTAL, Constants.MORE_PAGE_SECTION_PADDING
end
local function withMorePagePaddings(p2) -- line: 29
	-- upvalues: useDesignTokens (copy), useBreakpointXOrLarger (copy), Responsive (copy), FFlagEnableDevicePreferenceLayoutUpdate (copy), Constants (copy), React (copy), Cryo (copy)
	return function(p3) -- line: 30
		-- upvalues: useDesignTokens (copy), useBreakpointXOrLarger (copy), Responsive (copy), FFlagEnableDevicePreferenceLayoutUpdate (copy), Constants (copy), React (copy), p2 (copy), Cryo (copy)
		local v16 = useDesignTokens()
		local v17 = useBreakpointXOrLarger(Responsive.Keys.Small)
		local Size_500, Size_600

		if FFlagEnableDevicePreferenceLayoutUpdate then
			Size_500 = v16.Size.Size_500
			Size_600 = v16.Size.Size_600
		elseif v17 then
			Size_500 = Constants.MORE_PAGE_WIDE_PADDING_HORIZONTAL
			Size_600 = Constants.MORE_PAGE_WIDE_PADDING_VERTICAL
		else
			Size_500 = Constants.MORE_PAGE_COMPACT_PADDING_HORIZONTAL
			Size_600 = Constants.MORE_PAGE_SECTION_PADDING
		end

		local v20 = Constants.MORE_PAGE_CONTENT_MAX_WIDTH + Size_500 * 2

		return React.createElement(p2, Cryo.Dictionary.join(p3, {
			paddings = {
				paddingHorizontal = Size_500,
				paddingVertical = Size_600,
				contentMaxWidth = v20
			}
		}))
	end
end

return withMorePagePaddings
