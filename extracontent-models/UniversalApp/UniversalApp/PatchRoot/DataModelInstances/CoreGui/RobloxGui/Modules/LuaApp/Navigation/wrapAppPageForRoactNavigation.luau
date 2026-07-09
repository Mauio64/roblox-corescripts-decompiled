local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local AppPageProperties = require(Modules.LuaApp.AppPageProperties)
local v13 = require(Modules.LuaApp.Flags.GetFIntLuaAppTransparentPageMaxCount)()
local useTTINavigationTracking = require(CorePackages.Workspace.Packages.TTINavigationTracking).useTTINavigationTracking
local FFlagSignalsNavP3aWrapAppPage = SharedFlags.FFlagSignalsNavP3aWrapAppPage
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v17 = if not FFlagSignalsNavP3aWrapAppPage then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore

local function computeNavProps(p1, p2) -- line: 30
	-- upvalues: AppPageProperties (copy), v13 (copy)
	local navigation = p2.navigation
	local key = navigation.state.key
	local v25 = navigation.getParam("detail")
	local v26 = navigation.getParam("extraProps", {})
	local v27 = p1[#p1]
	local n1 = 1

	for i = #v27, 1, -1 do
		if not (AppPageProperties[v27[i].name] or {}).renderUnderlyingPage then
			n1 = i

			break
		end
	end

	local v30 = math.max(n1 + 1, #p1 - v13 + 1)
	local v31 = #v27 == 1
	local n2 = 0

	for i, v in ipairs(v27) do
		if key == v.rnKey then
			v31 = i == n1 or v30 <= i
			n2 = i

			return {
				isVisible = v31,
				displayOrder = n2,
				detail = v25,
				extraProps = v26
			}
		end
	end

	return {
		isVisible = v31,
		displayOrder = n2,
		detail = v25,
		extraProps = v26
	}
end
local function wrapWithSignalsNavStore(p3) -- line: 73
	-- upvalues: v17 (copy), useSignalState (copy), React (copy), Cryo (copy), computeNavProps (copy)
	return function(p4) -- line: 74
		-- upvalues: v17 (copy), useSignalState (copy), React (copy), p3 (copy), Cryo (copy), computeNavProps (copy)
		local v44 = v17(false)
		local v45 = useSignalState(v44.getHistory)

		return React.createElement(p3, Cryo.Dictionary.join(p4, (computeNavProps(v45, p4))))
	end
end
local function wrapAppPageForRoactNavigation(p5, p6) -- line: 81
	-- upvalues: Roact (copy), RoactNavigation (copy), SharedFlags (copy), useTTINavigationTracking (copy), FFlagSignalsNavP3aWrapAppPage (copy), v17 (copy), useSignalState (copy), React (copy), Cryo (copy), computeNavProps (copy), RoactRodux (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	local v38 = Roact.Component:extend("RNPageWrapper(" .. p6 .. ")")
	local v39 = p5
	local u40 = RoactNavigation.withNavigationFocus(function(p7) -- line: 85
		-- upvalues: SharedFlags (copy), useTTINavigationTracking (copy), p6 (copy), v39 (copy)
		local isVisible = p7.isVisible

		if SharedFlags.FFlagLuaAppNavigationTTITracking then
			useTTINavigationTracking("NavigateTo_" .. p6)
		end

		local displayOrder = p7.displayOrder
		local detail = p7.detail
		local extraProps = p7.extraProps
		local t1 = {
			isVisible = isVisible,
			displayOrder = displayOrder
		}

		return v39(t1, detail, extraProps)
	end)

	function v38.render(p8) -- line: 101
		-- upvalues: Roact (copy), u40 (ref)
		local isVisible = p8.props.isVisible
		local displayOrder = p8.props.displayOrder
		local detail = p8.props.detail
		local extraProps = p8.props.extraProps

		return Roact.createElement(u40, {
			isVisible = isVisible,
			displayOrder = displayOrder,
			detail = detail,
			extraProps = extraProps
		})
	end

	local v42

	if FFlagSignalsNavP3aWrapAppPage then
		local v41 = v38

		function v42(p9) -- line: 74
			-- upvalues: v17 (copy), useSignalState (copy), React (copy), v41 (copy), Cryo (copy), computeNavProps (copy)
			local v58 = v17(false)
			local v59 = useSignalState(v58.getHistory)

			return React.createElement(v41, Cryo.Dictionary.join(p9, (computeNavProps(v59, p9))))
		end
	else
		v42 = RoactRodux.connect(function(p10, p11) -- line: 121
			-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), computeNavProps (copy)
			local v62 = if not FFlagUseNavigationSelectors then p10.Navigation.history else Selectors.selectLegacyHistory(p10)

			return (computeNavProps(v62, p11))
		end)(v38)
	end

	return (RoactNavigation.withNavigation(v42))
end

return wrapAppPageForRoactNavigation
