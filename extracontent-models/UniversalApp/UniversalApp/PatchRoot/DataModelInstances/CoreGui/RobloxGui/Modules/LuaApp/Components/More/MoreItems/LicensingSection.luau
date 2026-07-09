local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local DropdownMenu = UIBlox.App.Menu.DropdownMenu
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useLicenseData = require(Modules.LuaApp.Components.More.Licensing.useLicenseData)
local GetTextSize = require(CorePackages.Workspace.Packages.Style).GetTextSize
local ScrollBarType = UIBlox.App.Container.Enum.ScrollBarType
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView
local FocusFrame = require(Modules.LuaApp.Components.FocusFrame)
local MoreSection = require(Modules.LuaApp.TenFootUI.MoreComponents.MoreSection)
local BodyText = require(Modules.LuaApp.TenFootUI.MoreComponents.MoreText).BodyText

require(script.Parent.Types)

local function useDropDownData() -- line: 26
	-- upvalues: useLicenseData (copy), React (copy), Dash (copy)
	local v20 = useLicenseData()
	local licenseList = v20.licenseList
	local initialLicenseKey = v20.initialLicenseKey
	local v23, v24 = React.useState(nil)
	local v25 = React.useMemo(function() -- line: 32
		-- upvalues: Dash (copy), licenseList (copy), v23 (copy), initialLicenseKey (copy)
		local v52 = Dash.map(licenseList, function(p1) -- line: 33
			return {
				key = p1.key,
				value = table.concat(p1.value, "\n")
			}
		end)

		return (Dash.find(v52, function(p2) -- line: 40
			-- upvalues: v23 (copy), initialLicenseKey (copy)
			return p2.key == (v23 or initialLicenseKey)
		end) or (v52[1] or {
			key = "",
			value = ""
		})).value
	end, {
		v23,
		licenseList,
		initialLicenseKey
	})

	return React.useMemo(function() -- line: 47
		-- upvalues: Dash (copy), licenseList (copy)
		return Dash.map(licenseList, function(p3) -- line: 48
			return {
				text = p3.key
			}
		end)
	end, { licenseList }), v25, v24
end
local function PanelContentWrapper(p4) -- line: 58
	-- upvalues: useDesignTokens (copy), React (copy), VerticalScrollView (copy), ScrollBarType (copy)
	local v27 = useDesignTokens()
	local v28 = React.useRef(nil)
	local v29 = React.useRef(nil)

	React.useEffect(function() -- line: 63
		-- upvalues: v28 (copy), v29 (copy), p4 (copy)
		if v28.current then
			for _, descendant in v28.current:GetDescendants() do
				if descendant:IsA("GuiObject") then
					if descendant == v29.current and p4.selectable then
						descendant.Selectable = true
					else
						descendant.Selectable = false
					end
				end
			end
		end
	end)

	return React.createElement("Frame", {
		SelectionGroup = true,
		ref = v28,
		Position = UDim2.new(),
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v27.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = not p4.selectable and 1 or v27.Color.Surface.Surface_0.Transparency,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop
	}, React.createElement(VerticalScrollView, {
		useAutomaticCanvasSize = true,
		isGamepadFocusable = true,
		ref = v29,
		canvasSizeY = UDim.new(),
		scrollingEnabled = p4.scrollingEnabled,
		scrollBarType = if not p4.scrollingEnabled then nil else ScrollBarType.Gamepad
	}, p4.children))
end
local function renderPanel(p5, p6, p7) -- line: 102
	-- upvalues: React (copy), PanelContentWrapper (copy)
	return React.createElement(PanelContentWrapper, {
		scrollingEnabled = p5,
		selectable = p6
	}, p7)
end
local function LicensingSection(p8) -- line: 109
	-- upvalues: useLocalization (copy), useDesignTokens (copy), React (copy), useDropDownData (copy), GetTextSize (copy), BodyText (copy), MoreSection (copy), DropdownMenu (copy), FocusFrame (copy), renderPanel (copy)
	local v34 = useLocalization({
		noLicenses = "CommonUI.Messages.Message.NoLicenses",
		title = p8.titleKey
	})
	local v35 = useDesignTokens()
	local LicensePanelWidthScale = v35.LuaApps.More.LicensePanelWidthScale
	local v37, v38 = React.useState(0)
	local uDim = UDim.new(0, v35.Size.Size_600)
	local ScrimColor3 = v35.Color.Common.Scrim.Color3
	local ScrimTransparency = v35.Color.Common.Scrim.Transparency
	local Surface_0 = v35.Color.Surface.Surface_0
	local BodyLargeFont = v35.Typography.BodyLarge.Font
	local FontSize = v35.Typography.BodyLarge.FontSize
	local Size_600 = v35.Size.Size_600
	local v46, v47, v48 = useDropDownData()
	local v49 = React.useCallback(function(p9) -- line: 128
		-- upvalues: v38 (copy), LicensePanelWidthScale (copy)
		if p9 then
			v38(p9.AbsoluteSize.X * LicensePanelWidthScale)
		end
	end, {})
	local v50 = React.useMemo(function() -- line: 134
		-- upvalues: v47 (copy), GetTextSize (copy), FontSize (copy), BodyLargeFont (copy), v37 (copy), Size_600 (copy)
		if v47 then
			return GetTextSize(v47, FontSize, BodyLargeFont, Vector2.new(v37 + Size_600 * 2, 1e999)).Y
		end

		return 0
	end, {
		v47,
		FontSize,
		BodyLargeFont,
		v37,
		Size_600
	})
	local v51 = React.useCallback(function() -- line: 155
		-- upvalues: React (copy), LicensePanelWidthScale (copy), uDim (copy), BodyText (copy), v47 (copy), v50 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(),
			Size = UDim2.fromScale(LicensePanelWidthScale, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, React.createElement("UIPadding", {
			PaddingTop = uDim,
			PaddingBottom = uDim
		}), React.createElement(BodyText, {
			layoutOrder = 2,
			text = v47,
			size = UDim2.new(1, 0, 1, v50),
			TextYAlignment = Enum.TextYAlignment.Top
		}))
	end, {
		v47,
		v50,
		uDim,
		LicensePanelWidthScale
	})

	return React.createElement(MoreSection, {
		layoutOrder = p8.layoutOrder,
		withDivider = p8.withDivider,
		title = v34.title
	}, React.createElement("Frame", {
		Name = "LicenseDropdown",
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		ZIndex = 2,
		ref = v49,
		Size = UDim2.new(1, 0, 0, 72)
	}, React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, React.createElement(DropdownMenu, {
		placeholder = if not (#v46 > 0) then v34.noLicenses else v46[1].text,
		onChange = v48,
		height = UDim.new(0, 72),
		screenSize = Vector2.new(1920, 1080),
		cellDatas = v46,
		menuListBackground = {
			Color = Surface_0.Color3,
			Transparency = Surface_0.Transparency
		}
	}))), React.createElement(FocusFrame, {
		layoutOrder = 2,
		limitInlineHeight = true,
		safeAreaSize = UDim2.new(1, -2 * v35.Size.Size_1600, 0, 3 * v35.Size.Size_2000),
		overlayColor3 = ScrimColor3,
		overlayTransparency = ScrimTransparency,
		renderContents = v51,
		renderContentWrapper = renderPanel
	}))
end

return LicensingSection
