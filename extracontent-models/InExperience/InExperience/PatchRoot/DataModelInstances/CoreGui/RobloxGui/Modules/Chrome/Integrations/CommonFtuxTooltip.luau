local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local Service = require(Chrome.Service)
local LocalStore = require(Chrome.ChromeShared.Service.LocalStore)
local TooltipContext = require(Chrome.ChromeShared.Unibar.Tooltips.TooltipContext)

require(Chrome.ChromeShared.Unibar.Tooltips.TooltipProvider)

local useIsTooltipTurn = require(Chrome.ChromeShared.Unibar.Tooltips.useIsTooltipTurn)
local menuIconHoveredSignal = require(Chrome.Parent.TopBar.Components.Presentation.menuIconHoveredSignal)
local FtuxTooltipAnchor = require(Chrome.Integrations.FtuxTooltipAnchor)
local t1 = {
	id = nil,
	priority = 1,
	showDelay = 3000,
	dismissDelay = 5000,
	onDismissed = function(_: boolean, _: string?) -- line: 37
	end
}

local function v15(p1) -- line: 40
	-- upvalues: React (copy), TooltipContext (copy), useIsTooltipTurn (copy), LocalStore (copy), useLocalization (copy), UserInputService (copy), t1 (copy), Service (copy), GuiService (copy), menuIconHoveredSignal (copy), FtuxTooltipAnchor (copy)
	local v19 = React.useRef(nil)
	local v20, _ = React.useState(false)
	local v22, v23 = React.useState(false)
	local v24 = React.useContext(TooltipContext)
	local v25 = useIsTooltipTurn(p1.id) or false
	local v26 = React.useMemo(function() -- line: 48
		-- upvalues: p1 (copy), LocalStore (copy)
		local v33 = false

		if p1.localStorageKey then
			v33 = LocalStore.getValue(p1.localStorageKey) or false
		end

		return v33
	end, { p1.localStorageKey })
	local v27 = p1.isIconVisible and (not v26 and not v22)
	local v28 = v27 and v25
	local v29 = useLocalization({
		headerText = p1.headerKey,
		bodyText = p1.bodyKey
	})
	local v30 = React.useCallback(function(s2: string?) -- line: 65
		-- upvalues: p1 (copy), v28 (copy), v23 (copy), v24 (copy)
		if p1.onDismissed then
			p1.onDismissed(v28, s2)
		end

		v23(true)

		if v24 and p1.id then
			v24.dismissTooltip(p1.id, s2)
		end
	end, {
		v23,
		v28
	})

	React.useEffect(function() -- line: 77
		-- upvalues: p1 (copy), v20 (copy), v22 (copy), UserInputService (copy), v19 (copy), v27 (copy), v30 (copy)
		local connection = nil

		if p1.dismissOnOutsideInput and (v20 and not v22) then
			connection = UserInputService.InputBegan:Connect(function(input) -- line: 80
				-- upvalues: v19 (copy), v27 (copy), v30 (copy)
				if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and v19.current ~= nil then
					local inputPosition = input.Position
					local AbsolutePosition = v19.current.AbsolutePosition
					local AbsoluteSize = v19.current.AbsoluteSize

					if v27 and (not (inputPosition.X >= AbsolutePosition.X) or not (inputPosition.X <= AbsolutePosition.X + AbsoluteSize.X) or not (inputPosition.Y >= AbsolutePosition.Y) or not (inputPosition.Y <= AbsolutePosition.Y + AbsoluteSize.Y)) then
						v30("outsideInput")
					end
				end
			end)
		end

		return function() -- line: 107
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, {
		v22,
		v20,
		v27
	})
	React.useEffect(function() -- line: 115
		-- upvalues: v24 (copy), p1 (copy), v27 (copy), t1 (copy)
		if v24 and (p1.id and v27) then
			v24.registerTooltip(p1.id, p1.priority, p1.showDelay or t1.showDelay, p1.dismissDelay or t1.dismissDelay)
		end

		return function() -- line: 124
			-- upvalues: v24 (copy), p1 (copy), v27 (copy)
			if v24 and (p1.id and v27) then
				v24.unregisterTooltip(p1.id)
			end
		end
	end, {
		v27,
		p1.id
	})
	React.useEffect(function() -- line: 131
		-- upvalues: Service (copy), v27 (copy), v30 (copy), GuiService (copy), menuIconHoveredSignal (copy)
		local t2 = {
			Service:onIntegrationActivated():connect(function() -- line: 135
				-- upvalues: v27 (copy), v30 (copy)
				if v27 then
					v30("unibarActivated")
				end
			end),
			Service:onIntegrationHovered():connect(function() -- line: 140
				-- upvalues: v27 (copy), v30 (copy)
				if v27 then
					v30("unibarHovered")
				end
			end),
			GuiService.MenuOpened:Connect(function() -- line: 145
				-- upvalues: v27 (copy), v30 (copy)
				if v27 then
					v30("menuOpened")
				end
			end),
			menuIconHoveredSignal:connect(function(p2) -- line: 150
				-- upvalues: v27 (copy), v30 (copy)
				if v27 and p2 then
					v30("menuIconHovered")
				end
			end)
		}

		return function() -- line: 157
			-- upvalues: t2 (copy)
			for _, v43 in t2 do
				if v43.disconnect then
					v43:disconnect()
				elseif v43.Disconnect then
					v43:Disconnect()
				end
			end
		end
	end, {
		Service,
		GuiService,
		menuIconHoveredSignal,
		v27,
		v30
	})
	React.useEffect(function() -- line: 168
		-- upvalues: v28 (copy), p1 (copy), LocalStore (copy)
		if v28 and p1.localStorageKey then
			LocalStore.storeForLocalPlayer(p1.localStorageKey, true)
		end
	end, {
		v28,
		p1.localStorageKey
	})

	return React.createElement(FtuxTooltipAnchor, {
		ref = v19,
		bodyText = v29.bodyText,
		headerText = v29.headerText,
		shouldShowTooltip = v28
	})
end

return function(t3: {[any]: any}) -- line: 196
	-- upvalues: Cryo (copy), t1 (copy), React (copy), v15 (copy)
	local v32 = Cryo.Dictionary.union(t1, t3)

	return React.createElement(v15, v32)
end
