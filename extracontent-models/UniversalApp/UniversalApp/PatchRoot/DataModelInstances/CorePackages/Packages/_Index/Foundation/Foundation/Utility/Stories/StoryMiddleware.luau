local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactRoblox = require(FoundationParent.ReactRoblox)
local Device = require(Foundation.Enums.Device)
local Foundation2 = require(Foundation.Providers.Foundation)
local Theme = require(Foundation.Enums.Theme)
local Types = require(Foundation.Utility.Stories.Types)
local TokenOverridesStore = require(script.Parent.TokenOverridesStore)
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)
local useStyleSheet = require(Foundation.Providers.Style.StyleSheetContext).useStyleSheet

local function useTokenOverrides() -- line: 20
	-- upvalues: TokenOverridesStore (copy), React (copy)
	local v16 = TokenOverridesStore()
	local v17, v18 = React.useState(function() -- line: 22
		-- upvalues: v16 (copy)
		return v16.getTokenOverrides()
	end)

	React.useEffect(function() -- line: 26
		-- upvalues: v16 (copy), v18 (copy)
		local v27 = v16.subscribe(function(p1) -- line: 27
			-- upvalues: v18 (copy)
			v18(p1)
		end)

		return function() -- line: 30
			-- upvalues: v27 (copy)
			v27()
		end
	end, { v16 })

	return v17
end
local function StyleLinkPortal(t1: {[any]: any}) -- line: 50
	-- upvalues: useStyleSheet (copy), ReactRoblox (copy), React (copy)
	local v20 = useStyleSheet()

	if not v20 or not t1.overlay then
		return nil
	end

	return ReactRoblox.createPortal(React.createElement("StyleLink", {
		StyleSheet = v20
	}), t1.overlay)
end
local function useCreateOverlay(p2) -- line: 65
	-- upvalues: Types (copy), React (copy)
	local v22 = Types.toFlipbookStoryProps(p2)
	local v23 = if not v22 then p2.focus else v22.widget
	local v24 = v23.Name == "StorybookEmbed"
	local v25 = React.useRef(Instance.new("Frame"))

	if v23 ~= v25.current.Parent then
		v25.current.Parent = v23
	end

	React.useEffect(function() -- line: 79
		-- upvalues: v25 (copy)
		v25.current.Size = UDim2.fromScale(1, 1)
		v25.current.BackgroundTransparency = 1

		return function() -- line: 83
			-- upvalues: v25 (copy)
			v25.current:Destroy()
		end
	end, {})

	if v24 then
		return nil
	end

	return v25.current
end
local function StoryMiddleware(p3) -- line: 91
	-- upvalues: useCreateOverlay (copy), Theme (copy), useTokenOverrides (copy), Types (copy), Device (copy), React (copy), Foundation2 (copy), isPluginSecurity (copy), StyleLinkPortal (copy)
	return function(p4) -- line: 93
		-- upvalues: useCreateOverlay (copy), Theme (copy), useTokenOverrides (copy), Types (copy), Device (copy), React (copy), Foundation2 (copy), isPluginSecurity (copy), p3 (copy), StyleLinkPortal (copy)
		local v29 = useCreateOverlay(p4)
		local v30 = Theme[p4.theme]
		local v31 = useTokenOverrides()
		local v32 = Types.toDeveloperStorybookStoryProps(p4)
		local v33 = nil
		local settings = nil

		if v32 then
			v33 = Device[v32.platform]
			settings = v32.settings
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
				theme = v30,
				device = v33,
				preferences = settings,
				scale = settings and settings.scale,
				overlayGui = v29,
				plugin = if not isPluginSecurity() then nil else p4.plugin,
				tokenOverrides = v31
			}, {
				Child = React.createElement(p3, p4),
				StyleLink = React.createElement(StyleLinkPortal, if not v29 then nil else {
					overlay = v29
				})
			})
		})
	end
end

return StoryMiddleware
