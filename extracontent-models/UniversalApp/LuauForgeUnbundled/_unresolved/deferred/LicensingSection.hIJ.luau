local CorePackages = game:GetService("CorePackages")

local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local dropdownMenu = UIBlox.App.Menu.DropdownMenu
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local module = require("@luauforge/deferred/hIK")
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local scrollBarType = UIBlox.App.Container.Enum.ScrollBarType
local verticalScrollView = UIBlox.App.Container.VerticalScrollView
local module2 = require("@luauforge/deferred/fYZ")

local module3 = require("@luauforge/bundled/hHN")
local bodyText = require("@luauforge/bundled/hHO").BodyText

require("@luauforge/bundled/hHQ")

local function useDropDownData(useLicenseData)
	local v5 = useLicenseData()
	local licenseList = v5.licenseList
	local initialLicenseKey = v5.initialLicenseKey
	local state, setState = React.useState(nil)

	local v6 = React.useMemo(function()
		local mapped = Dash.map(licenseList, function(p2)
			return { key = p2.key, value = table.concat(p2.value, "\n") }
		end)

		return (Dash.find(mapped, function(p2): boolean
			return p2.key == (state or initialLicenseKey)
		end) or mapped[1] or { key = "", value = "" }).value
	end, { state, licenseList, initialLicenseKey })

	return React.useMemo(function()
		return Dash.map(licenseList, function(p2)
			return { text = p2.key }
		end)
	end, { licenseList }), v6, setState
end

local function PanelContentWrapper(props)
	local v5 = useDesignTokens()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	React.useEffect(function()
		if ref.current then
			for i, guiObject in ref.current:GetDescendants() do
				if not guiObject:IsA("GuiObject") then
					continue
				end

				if guiObject == ref2.current and props.selectable then
					guiObject.Selectable = true
				else
					guiObject.Selectable = false
				end
			end
		end
	end)

	local createElement = React.createElement

	local v7 = {
		ref = ref,
		Position = UDim2.new(),
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v5.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = not props.selectable and 1 or v5.Color.Surface.Surface_0.Transparency,
		SelectionGroup = true,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop
	}

	local createElement2 = React.createElement
	local v9 = {
		ref = ref2,
		canvasSizeY = UDim.new(),
		useAutomaticCanvasSize = true,
		isGamepadFocusable = true,
		scrollingEnabled = props.scrollingEnabled,
		scrollBarType = 0
	}
	local v10 = if props.scrollingEnabled then scrollBarType.Gamepad else nil
	v9.scrollBarType = v10
	return createElement("Frame", v7, createElement2(verticalScrollView, v9, props.children))
end

local function renderPanel(p2, p3, p4)
	return React.createElement(PanelContentWrapper, {
		scrollingEnabled = p2,
		selectable = p3
	}, p4)
end

local function LicensingSection(props)
	local v5 = useLocalization({
		title = props.titleKey,
		noLicenses = "CommonUI.Messages.Message.NoLicenses"
	})

	local v6 = useDesignTokens()
	local licensePanelWidthScale = v6.LuaApps.More.LicensePanelWidthScale
	local state, setState = React.useState(0)

	local udim = UDim.new(0, v6.Size.Size_600)
	local color3 = v6.Color.Common.Scrim.Color3
	local transparency = v6.Color.Common.Scrim.Transparency
	local surface_0 = v6.Color.Surface.Surface_0
	local font = v6.Typography.BodyLarge.Font
	local fontSize = v6.Typography.BodyLarge.FontSize
	local size_600 = v6.Size.Size_600

	local v7, v8, v9 = useDropDownData(props.useLicenseData or module)
	local v10 = React.useCallback(function(p2)
		if p2 then
			setState(p2.AbsoluteSize.X * licensePanelWidthScale)
		end
	end, {})

	local v11 = React.useMemo(function()
		if v8 then
			return getTextSize(v8, fontSize, font, Vector2.new(state + size_600 * 2, 1e999)).Y
		end

		return 0
	end, { v8, fontSize, font, state, size_600 })

	local v12 = React.useCallback(function()
		return React.createElement(
			"Frame",
			{
				Position = UDim2.new(),
				Size = UDim2.fromScale(licensePanelWidthScale, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			React.createElement("UIPadding", { PaddingTop = udim, PaddingBottom = udim }),
			React.createElement(bodyText, {
				text = v8,
				layoutOrder = 2,
				size = UDim2.new(1, 0, 1, v11),
				TextYAlignment = Enum.TextYAlignment.Top
			})
		)
	end, { v8, v11, udim, licensePanelWidthScale })

	local createElement = React.createElement

	local v14 = {
		layoutOrder = props.layoutOrder,
		withDivider = props.withDivider,
		title = v5.title
	}

	local createElement2 = React.createElement

	local v16 = {
		Name = "LicenseDropdown",
		ref = v10,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 72),
		BackgroundTransparency = 1,
		ZIndex = 2
	}

	local createElement3 = React.createElement

	local v18 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local createElement4 = React.createElement
	local v21 = if #v7 > 0 then v7[1].text else v5.noLicenses
	return createElement(
		module3,
		v14,
		createElement2("Frame", v16, createElement3("Frame", v18, createElement4(dropdownMenu, {
			placeholder = v21,
			onChange = v9,
			height = UDim.new(0, 72),
			screenSize = Vector2.new(1920, 1080),
			cellDatas = v7,
			menuListBackground = {
				Color = surface_0.Color3,
				Transparency = surface_0.Transparency
			}
		}))),
		React.createElement(module2, {
			layoutOrder = 2,
			safeAreaSize = UDim2.new(1, -2 * v6.Size.Size_1600, 0, 3 * v6.Size.Size_2000),
			limitInlineHeight = true,
			overlayColor3 = color3,
			overlayTransparency = transparency,
			renderContents = v12,
			renderContentWrapper = renderPanel
		})
	)
end

return LicensingSection
