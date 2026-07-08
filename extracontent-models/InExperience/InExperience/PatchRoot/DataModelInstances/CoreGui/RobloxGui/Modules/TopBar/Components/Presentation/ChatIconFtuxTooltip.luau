local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local AppStorageService = game:GetService("AppStorageService")
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local _ = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
local t1 = {
	showDelay = 1000,
	dismissDelay = 7000,
	onDismissed = function(_: boolean, _: string?) -- line: 26
	end
}

return function(t2: {[any]: any}) -- line: 41
	-- upvalues: Cryo (copy), t1 (copy), React (copy), setTimeout (copy), AppStorageService (copy), useLocalization (copy), GuiService (copy), clearTimeout (copy), withTooltip (copy), CoreGui (copy), TooltipOrientation (copy)
	local v19 = Cryo.Dictionary.union(t1, t2)
	local v20, v21 = React.useState(false)
	local v22, v23 = React.useState(false)
	local v24 = React.useRef(setTimeout(function() -- line: 45
	end, v19.showDelay))
	local v25 = React.useRef(setTimeout(function() -- line: 46
	end, v19.dismissDelay))
	local v26 = not (React.useMemo(function() -- line: 48
		-- upvalues: v19 (copy), AppStorageService (copy)
		local v30 = false

		if v19.localStorageKey then
			local ok, result = pcall(function() -- line: 51
				-- upvalues: AppStorageService (copy), v19 (copy)
				return AppStorageService:GetItem(v19.localStorageKey)
			end)

			if ok then
				return result == "true"
			end

			v30 = true
		end

		return v30
	end, { v19.localStorageKey }) or v22)
	local v27 = v20 and v26
	local v28 = useLocalization({
		headerText = v19.headerKey,
		bodyText = v19.bodyKey
	})
	local v29 = React.useCallback(function(s2: string?) -- line: 66
		-- upvalues: v19 (copy), v27 (copy), v23 (copy)
		if v19.onDismissed then
			v19.onDismissed(v27, s2)
		end

		v23(true)
	end, {
		v23,
		v27
	})

	React.useEffect(function() -- line: 75
		-- upvalues: GuiService (copy), v26 (copy), v29 (copy), v19 (copy)
		local t3 = {
			GuiService.MenuOpened:Connect(function() -- line: 77
				-- upvalues: v26 (copy), v29 (copy)
				if v26 then
					v29("menuOpened")
				end
			end),
			v19.iconClickedSignal:connect(function() -- line: 82
				-- upvalues: v26 (copy), v29 (copy)
				if v26 then
					v29("chatIconClicked")
				end
			end)
		}

		return function() -- line: 89
			-- upvalues: t3 (copy)
			for _, v37 in t3 do
				if v37.disconnect then
					v37:disconnect()
				elseif v37.Disconnect then
					v37:Disconnect()
				end
			end
		end
	end, {
		GuiService.MenuOpened,
		v19.iconClickedSignal,
		v26,
		v29
	})
	React.useEffect(function() -- line: 101
		-- upvalues: clearTimeout (copy), v24 (copy), v26 (copy), setTimeout (copy), v21 (copy), v19 (copy)
		clearTimeout(v24.current)

		if v26 then
			v24.current = setTimeout(function() -- line: 104
				-- upvalues: v26 (copy), v21 (copy)
				if v26 then
					v21(true)
				end
			end, v19.showDelay)
		end
	end, {
		v26,
		v24
	})
	React.useEffect(function() -- line: 113
		-- upvalues: clearTimeout (copy), v25 (copy), v20 (copy), setTimeout (copy), v29 (copy), v19 (copy)
		clearTimeout(v25.current)

		if v20 then
			v25.current = setTimeout(function() -- line: 116
				-- upvalues: v29 (copy)
				v29("timeout")
			end, v19.dismissDelay)
		end
	end, {
		v20,
		v25
	})
	React.useEffect(function() -- line: 122
		-- upvalues: v27 (copy), v19 (copy), AppStorageService (copy)
		if v27 and v19.localStorageKey then
			pcall(function() -- line: 124
				-- upvalues: AppStorageService (copy), v19 (copy)
				AppStorageService:SetItem(v19.localStorageKey, "true")
			end)
		end
	end, {
		v27,
		v19.localStorageKey
	})

	return withTooltip({
		headerText = v28.headerText,
		bodyText = v28.bodyText
	}, {
		DisplayOrder = 10,
		active = v27,
		guiTarget = CoreGui,
		preferredOrientation = TooltipOrientation.Bottom
	}, function(p1) -- line: 139
		-- upvalues: React (copy)
		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = p1,
			[React.Change.AbsolutePosition] = p1
		})
	end)
end
