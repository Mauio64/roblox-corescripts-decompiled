local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local UserInputService = game:GetService("UserInputService")

local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local Service = require(Chrome.Service)
local LocalStore = require(Chrome.ChromeShared.Service.LocalStore)
local TooltipContext = require(Chrome.ChromeShared.Unibar.Tooltips.TooltipContext)
require(Chrome.ChromeShared.Unibar.Tooltips.TooltipProvider)
local useIsTooltipTurn = require(Chrome.ChromeShared.Unibar.Tooltips.useIsTooltipTurn)

local menuIconHoveredSignal = require(Chrome.Parent.TopBar.Components.Presentation.menuIconHoveredSignal)

local FtuxTooltipAnchor = require(Chrome.Integrations.FtuxTooltipAnchor)

local v = {
	id = nil,
	priority = 1,
	showDelay = 3000,
	dismissDelay = 5000,
	onDismissed = function(_: boolean, _: string?) end
}

local function fn(props)
	local ref = React.useRef(nil)
	local state, _ = React.useState(false)
	local state2, setState = React.useState(false)

	local v2 = React.useContext(TooltipContext)
	local v3 = useIsTooltipTurn(props.id) or false

	local v4 = React.useMemo(function()
		if props.localStorageKey then
			return LocalStore.getValue(props.localStorageKey) or false
		end

		return false
	end, { props.localStorageKey })

	local v5 = props.isIconVisible and not (v4 or state2)
	local shouldShowTooltip = v5 and v3

	local v6 = useLocalization({ headerText = props.headerKey, bodyText = props.bodyKey })

	local v7 = React.useCallback(function(p: string?)
		if props.onDismissed then
			props.onDismissed(shouldShowTooltip, p)
		end

		setState(true)

		if v2 and props.id then
			v2.dismissTooltip(props.id, p)
		end
	end, { setState, shouldShowTooltip })

	React.useEffect(function()
		local inputBeganConnection

		if props.dismissOnOutsideInput and state and not state2 then
			inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
				if
					(input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1)
					and ref.current ~= nil
				then
					local position = input.Position
					local absolutePosition = ref.current.AbsolutePosition
					local absoluteSize = ref.current.AbsoluteSize

					if
						v5
						and not (position.X >= absolutePosition.X and position.X <= absolutePosition.X + absoluteSize.X and position.Y >= absolutePosition.Y and position.Y <= absolutePosition.Y + absoluteSize.Y)
					then
						v7("outsideInput")
					end
				end
			end)
		else
			inputBeganConnection = nil
		end

		return function()
			if inputBeganConnection then
				inputBeganConnection:Disconnect()
				inputBeganConnection = nil
			end
		end
	end, { state2, state, v5 })

	React.useEffect(function()
		if v2 and props.id and v5 then
			v2.registerTooltip(
				props.id,
				props.priority,
				props.showDelay or v.showDelay,
				props.dismissDelay or v.dismissDelay
			)
		end

		return function()
			if v2 and props.id and v5 then
				v2.unregisterTooltip(props.id)
			end
		end
	end, { v5, props.id })

	React.useEffect(function()
		local v8 = {
			Service:onIntegrationActivated():connect(function()
				if v5 then
					v7("unibarActivated")
				end
			end),
			Service:onIntegrationHovered():connect(function()
				if v5 then
					v7("unibarHovered")
				end
			end),
			GuiService.MenuOpened:Connect(function()
				if v5 then
					v7("menuOpened")
				end
			end),
			menuIconHoveredSignal:connect(function(p)
				if v5 and p then
					v7("menuIconHovered")
				end
			end)
		}

		return function()
			for _, connection in v8 do
				if connection.disconnect then
					connection:disconnect()
				elseif connection.Disconnect then
					connection:Disconnect()
				end
			end
		end
	end, { Service, GuiService, menuIconHoveredSignal, v5, v7 })

	React.useEffect(function()
		if shouldShowTooltip and props.localStorageKey then
			LocalStore.storeForLocalPlayer(props.localStorageKey, true)
		end
	end, { shouldShowTooltip, props.localStorageKey })

	return React.createElement(FtuxTooltipAnchor, {
		ref = ref,
		bodyText = v6.bodyText,
		headerText = v6.headerText,
		shouldShowTooltip = shouldShowTooltip
	})
end

return function(p)
	local union = Cryo.Dictionary.union(v, p)
	return React.createElement(fn, union)
end
