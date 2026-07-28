local ShareSheet = script:FindFirstAncestor("ShareSheet")
local ShareSheetParent = ShareSheet.Parent
local LocalizationService = game:GetService("LocalizationService")
local React = require(ShareSheetParent.React)
local ReactRoblox = require(ShareSheetParent.ReactRoblox)
local Foundation = require(ShareSheetParent.Foundation)
local Localization = require(ShareSheetParent.Localization)
local RobloxAppLocales = require(ShareSheetParent.RobloxAppLocales)
local LocalizationProvider = Localization.LocalizationProvider
local Localization2 = RobloxAppLocales.Localization
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local t1 = {
	Dark = Theme.Dark,
	Light = Theme.Light
}
local useStyleSheet = Foundation.Hooks.useStyleSheet

local function StyleLinkPortal(t2: {[any]: any}) -- line: 26
	-- upvalues: useStyleSheet (copy), ReactRoblox (copy), React (copy)
	local v18 = useStyleSheet()

	return ReactRoblox.createPortal(React.createElement("StyleLink", {
		StyleSheet = v18
	}), t2.overlay)
end

return {
	name = "ShareSheet",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 36
		-- upvalues: React (copy), Localization2 (copy), LocalizationService (copy), LocalizationProvider (copy), FoundationProvider (copy), t1 (copy), Theme (copy), Device (copy), StyleLinkPortal (copy)
		return function(p2) -- line: 37
			-- upvalues: React (copy), Localization2 (copy), LocalizationService (copy), LocalizationProvider (copy), FoundationProvider (copy), t1 (copy), Theme (copy), Device (copy), p1 (copy), StyleLinkPortal (copy)
			local v21 = React.useRef(Instance.new("Frame"))

			if v21.current.Parent ~= p2.focus then
				v21.current.Parent = p2.focus
			end

			React.useLayoutEffect(function() -- line: 43
				-- upvalues: v21 (copy)
				v21.current.Size = UDim2.fromScale(1, 1)
				v21.current.BackgroundTransparency = 1
			end, {})

			local v22 = React.useMemo(function() -- line: 48
				-- upvalues: Localization2 (copy), LocalizationService (copy)
				return Localization2.new(LocalizationService.RobloxLocaleId)
			end, {})

			return React.createElement(LocalizationProvider, {
				localization = v22
			}, { React.createElement(FoundationProvider, {
				theme = t1[p2.theme] or Theme.Dark,
				device = Device[p2.platform] or Device.Phone,
				preferences = p2.settings,
				scale = p2.settings and p2.settings.scale,
				overlayGui = v21.current
			}, {
				Story = React.createElement(p1, p2),
				StyleLink = React.createElement(StyleLinkPortal, {
					overlay = v21.current
				})
			}) })
		end
	end,
	storyRoot = ShareSheet
}
