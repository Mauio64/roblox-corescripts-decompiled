local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local AppStorageService = game:GetService("AppStorageService")

local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib.Signal

local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout

local v = {
	showDelay = 1000,
	dismissDelay = 7000,
	onDismissed = function(_: boolean, _: string?) end
}

return function(p)
	local union = Cryo.Dictionary.union(v, p)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local ref = React.useRef(setTimeout(function() end, union.showDelay))
	local ref2 = React.useRef(setTimeout(function() end, union.dismissDelay))

	local v2 = not (React.useMemo(function(): boolean
		if not union.localStorageKey then
			return false
		end

		local success, result = pcall(function()
			return AppStorageService:GetItem(union.localStorageKey)
		end)
		return not success or result == "true"
	end, { union.localStorageKey }) or state2)
	local active = state and v2

	local v3 = useLocalization({ headerText = union.headerKey, bodyText = union.bodyKey })

	local v4 = React.useCallback(function(p2: string?)
		if union.onDismissed then
			union.onDismissed(active, p2)
		end

		setState2(true)
	end, { setState2, active })

	React.useEffect(function()
		local v5 = {
			GuiService.MenuOpened:Connect(function()
				if v2 then
					v4("menuOpened")
				end
			end),
			union.iconClickedSignal:connect(function()
				if v2 then
					v4("chatIconClicked")
				end
			end)
		}

		return function()
			for _, connection in v5 do
				if connection.disconnect then
					connection:disconnect()
				elseif connection.Disconnect then
					connection:Disconnect()
				end
			end
		end
	end, { GuiService.MenuOpened, union.iconClickedSignal, v2, v4 })

	React.useEffect(function()
		clearTimeout(ref.current)

		if v2 then
			ref.current = setTimeout(function()
				if v2 then
					setState(true)
				end
			end, union.showDelay)
		end
	end, { v2, ref })

	React.useEffect(function()
		clearTimeout(ref2.current)

		if state then
			ref2.current = setTimeout(function()
				v4("timeout")
			end, union.dismissDelay)
		end
	end, { state, ref2 })

	React.useEffect(function()
		if active and union.localStorageKey then
			pcall(function()
				AppStorageService:SetItem(union.localStorageKey, "true")
			end)
		end
	end, { active, union.localStorageKey })

	return withTooltip(
		{ headerText = v3.headerText, bodyText = v3.bodyText },
		{
			DisplayOrder = 10,
			active = active,
			guiTarget = CoreGui,
			preferredOrientation = TooltipOrientation.Bottom
		},
		function(p2)
			return React.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				[React.Change.AbsoluteSize] = p2,
				[React.Change.AbsolutePosition] = p2
			})
		end
	)
end
