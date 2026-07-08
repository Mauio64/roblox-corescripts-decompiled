local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactRoblox = require(FoundationParent.ReactRoblox)
local Device = require(Foundation.Enums.Device)
local Flags = require(Foundation.Utility.Flags)
local Foundation2 = require(Foundation.Providers.Foundation)
local Theme = require(Foundation.Enums.Theme)
local Types = require(Foundation.Utility.Stories.Types)
local TokenOverridesStore = require(script.Parent.TokenOverridesStore)
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)
local useStyleSheet = require(Foundation.Providers.Style.StyleSheetContext).useStyleSheet

local function useTokenOverrides() -- line: 21
	-- upvalues: TokenOverridesStore (copy), React (copy)
	local v17 = TokenOverridesStore()
	local v18, v19 = React.useState(function() -- line: 23
		-- upvalues: v17 (copy)
		return v17.getTokenOverrides()
	end)

	React.useEffect(function() -- line: 27
		-- upvalues: v17 (copy), v19 (copy)
		local v28 = v17.subscribe(function(p1) -- line: 28
			-- upvalues: v19 (copy)
			v19(p1)
		end)

		return function() -- line: 31
			-- upvalues: v28 (copy)
			v28()
		end
	end, { v17 })

	return v18
end
local function StyleLinkPortal(t1: {[any]: any}) -- line: 51
	-- upvalues: useStyleSheet (copy), ReactRoblox (copy), React (copy)
	local v21 = useStyleSheet()

	if not v21 or not t1.overlay then
		return nil
	end

	return ReactRoblox.createPortal(React.createElement("StyleLink", {
		StyleSheet = v21
	}), t1.overlay)
end
local function useCreateOverlay(p2) -- line: 66
	-- upvalues: Types (copy), React (copy)
	local v23 = Types.toFlipbookStoryProps(p2)
	local v24 = if not v23 then p2.focus else v23.widget
	local v25 = v24.Name == "StorybookEmbed"
	local v26 = React.useRef(Instance.new("Frame"))

	if v24 ~= v26.current.Parent then
		v26.current.Parent = v24
	end

	React.useEffect(function() -- line: 80
		-- upvalues: v26 (copy)
		v26.current.Size = UDim2.fromScale(1, 1)
		v26.current.BackgroundTransparency = 1

		return function() -- line: 84
			-- upvalues: v26 (copy)
			v26.current:Destroy()
		end
	end, {})

	if v25 then
		return nil
	end

	return v26.current
end
local function StoryMiddleware(p3) -- line: 92
	-- upvalues: useCreateOverlay (copy), Theme (copy), useTokenOverrides (copy), Types (copy), Device (copy), Flags (copy), isPluginSecurity (copy), React (copy), Foundation2 (copy), StyleLinkPortal (copy)
	return function(p4) -- line: 94
		-- upvalues: useCreateOverlay (copy), Theme (copy), useTokenOverrides (copy), Types (copy), Device (copy), Flags (copy), isPluginSecurity (copy), React (copy), Foundation2 (copy), p3 (copy), StyleLinkPortal (copy)
		local v30 = useCreateOverlay(p4)
		local v31 = Theme[p4.theme]
		local v32 = useTokenOverrides()
		local v33 = Types.toDeveloperStorybookStoryProps(p4)
		local v34 = nil
		local settings = nil

		if v33 then
			v34 = Device[v33.platform]
			settings = v33.settings
		end

		local FoundationPopoverPluginSupport = Flags.FoundationPopoverPluginSupport

		if Flags.FoundationPopoverPluginSecurityGate then
			FoundationPopoverPluginSupport = FoundationPopoverPluginSupport and isPluginSecurity()
		end

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
			FoundationContext = React.createElement(Foundation2, {
				theme = v31,
				device = v34,
				preferences = settings,
				scale = settings and settings.scale,
				overlayGui = v30,
				plugin = if not FoundationPopoverPluginSupport then nil else p4.plugin,
				tokenOverrides = v32
			}, {
				Child = React.createElement(p3, p4),
				StyleLink = React.createElement(StyleLinkPortal, if not v30 then nil else {
					overlay = v30
				})
			})
		})
	end
end

return StoryMiddleware
