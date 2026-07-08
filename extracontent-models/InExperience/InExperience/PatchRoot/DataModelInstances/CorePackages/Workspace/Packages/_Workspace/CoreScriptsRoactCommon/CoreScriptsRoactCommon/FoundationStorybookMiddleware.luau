local Parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local ReactRoblox = require(Parent.ReactRoblox)
local FoundationProvider = Foundation.FoundationProvider
local t1 = {
	Default = Foundation.Enums.Theme.Dark,
	Light = Foundation.Enums.Theme.Light,
	Dark = Foundation.Enums.Theme.Dark
}
local t2 = {
	Default = "Desktop",
	Desktop = "Desktop",
	Console = "Console"
}
local useStyleSheet = Foundation.Hooks.useStyleSheet

local function StyleLinkPortal(t3: {[any]: any}) -- line: 25
	-- upvalues: useStyleSheet (copy), ReactRoblox (copy)
	if not useStyleSheet() or not t3.overlay then
		return nil
	end

	return ReactRoblox.createPortal(nil, t3.overlay)
end
local function useCreateOverlay(t4: {[any]: any}) -- line: 35
	-- upvalues: React (copy)
	local v14 = React.useRef(Instance.new("Frame"))

	if v14.current.Parent ~= t4.focus then
		v14.current.Parent = t4.focus
	end

	React.useEffect(function() -- line: 43
		-- upvalues: v14 (copy)
		v14.current.Size = UDim2.fromScale(1, 1)
		v14.current.BackgroundTransparency = 1

		return function() -- line: 47
			-- upvalues: v14 (copy)
			v14.current:Destroy()
		end
	end, {})

	return v14.current
end
local function FoundationStorybookMiddleware(p1) -- line: 62
	-- upvalues: useCreateOverlay (copy), t1 (copy), React (copy), FoundationProvider (copy), t2 (copy), StyleLinkPortal (copy)
	return function(t5: {[any]: any}) -- line: 63
		-- upvalues: useCreateOverlay (copy), t1 (copy), React (copy), FoundationProvider (copy), t2 (copy), p1 (copy), StyleLinkPortal (copy)
		local v17 = useCreateOverlay(t5)
		local v18 = t1[t5.theme]

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10)
			}),
			FoundationContext = React.createElement(FoundationProvider, {
				theme = v18,
				device = t2[t5.platform],
				preferences = t5.settings,
				scale = t5.settings and t5.settings.scale,
				overlayGui = v17
			}, {
				Child = React.createElement(p1, t5),
				StyleLink = React.createElement(StyleLinkPortal, {
					overlay = v17
				})
			})
		})
	end
end

return FoundationStorybookMiddleware
