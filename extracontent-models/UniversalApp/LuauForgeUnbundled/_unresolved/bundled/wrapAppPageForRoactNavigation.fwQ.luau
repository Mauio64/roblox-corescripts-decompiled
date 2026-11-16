local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local module2 = require("@luauforge/bundled/dDE")
local v5 = require("@luauforge/bundled/fwR")()

local useTTINavigationTracking = require("@luauforge/bundled/fwS").useTTINavigationTracking

local fFlagSignalsNavP3aWrapAppPage = SharedFlags.FFlagSignalsNavP3aWrapAppPage

local v6 = {}

local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3aWrapAppPage then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local function computeNavProps(list, p2)
	local navigation = p2.navigation
	local key = navigation.state.key
	local param = navigation.getParam("detail")
	local param2 = navigation.getParam("extraProps", {})
	local item = list[#list]
	local v7 = 1

	for i = #item, 1, -1 do
		if not (module2[item[i].name] or {}).renderUnderlyingPage then
			v7 = i
			break
		end
	end

	local v8 = math.max(v7 + 1, #list - v5 + 1)

	local v9 = #item == 1
	local v10 = 0

	for i, v12 in ipairs(item) do
		if v12.rnKey == key then
			v9 = i == v7 or v8 <= i
			v10 = i
			break
		end
	end

	return { isVisible = v9, displayOrder = v10, detail = param, extraProps = param2 }
end

local v7 = {}
local v8 = {}
setmetatable(v7, { __mode = "v" })
setmetatable(v8, { __mode = "v" })

local function getPageIsVisible(p2, p3)
	if not v7[p3] then
		v7[p3] = Signals.createComputed(function(p4): boolean
			local history = p2.getHistory(p4)
			local v9 = history[#history]
			local v10 = 1

			for i = #v9, 1, -1 do
				if not (module2[v9[i].name] or {}).renderUnderlyingPage then
					v10 = i
					break
				end
			end

			local v11 = math.max(v10 + 1, #history - v5 + 1)

			for i, v12 in ipairs(v9) do
				if v12.rnKey == p3 then
					return i == v10 or v11 <= i
				end
			end

			return #v9 == 1
		end)
	end

	return v7[p3]
end

local function getPageDisplayOrder(p2, p3)
	if not v8[p3] then
		v8[p3] = Signals.createComputed(function(p4)
			local history = p2.getHistory(p4)
			local v9 = history[#history]

			for i, v10 in ipairs(v9) do
				if v10.rnKey == p3 then
					return i
				end
			end

			return 0
		end)
	end

	return v8[p3]
end

local function wrapWithSignalsNavStore(p2)
	return function(p3)
		local legacyNavigationStore = getLegacyNavigationStore(false)
		local key = p3.navigation.state.key

		if not v7[key] then
			v7[key] = Signals.createComputed(function(p4): boolean
				local history = legacyNavigationStore.getHistory(p4)
				local v10 = history[#history]
				local v11 = 1

				for i = #v10, 1, -1 do
					if not (module2[v10[i].name] or {}).renderUnderlyingPage then
						v11 = i
						break
					end
				end

				local v12 = math.max(v11 + 1, #history - v5 + 1)

				for i, v13 in ipairs(v10) do
					if v13.rnKey == key then
						return i == v11 or v12 <= i
					end
				end

				return #v10 == 1
			end)
		end

		local v10 = useSignalState(v7[key])

		if not v8[key] then
			v8[key] = Signals.createComputed(function(p4)
				local history = legacyNavigationStore.getHistory(p4)
				local v12 = history[#history]

				for i, v13 in ipairs(v12) do
					if v13.rnKey == key then
						return i
					end
				end

				return 0
			end)
		end

		local v12 = useSignalState(v8[key])
		local param = p3.navigation.getParam("detail")

		local param2 = p3.navigation.getParam("extraProps", not fFlagSignalsNavP3aWrapAppPage and {} or v6)

		return (React.useMemo(function()
			return React.createElement(p2, {
				isVisible = v10,
				displayOrder = v12,
				detail = param,
				extraProps = param2
			})
		end, { v10, v12, param, param2 }))
	end
end

local function wrapAppPageForRoactNavigation(callback, p2)
	local extended = Roact.Component:extend("RNPageWrapper(" .. p2 .. ")")

	local v9 = RoactNavigation.withNavigationFocus(function(data)
		local isVisible = data.isVisible
		useTTINavigationTracking("NavigateTo_" .. p2)

		return callback(
			{ isVisible = isVisible, displayOrder = data.displayOrder },
			data.detail,
			data.extraProps
		)
	end)

	function extended.render(p3)
		local isVisible = p3.props.isVisible
		local displayOrder = p3.props.displayOrder
		local detail = p3.props.detail
		local extraProps = p3.props.extraProps

		return Roact.createElement(v9, {
			isVisible = isVisible,
			displayOrder = displayOrder,
			detail = detail,
			extraProps = extraProps
		})
	end

	local v10

	if fFlagSignalsNavP3aWrapAppPage then
		v10 = function(p3)
			local legacyNavigationStore = getLegacyNavigationStore(false)
			local key = p3.navigation.state.key

			if not v7[key] then
				v7[key] = Signals.createComputed(function(p4): boolean
					local history = legacyNavigationStore.getHistory(p4)
					local v12 = history[#history]
					local v13 = 1

					for i = #v12, 1, -1 do
						if not (module2[v12[i].name] or {}).renderUnderlyingPage then
							v13 = i
							break
						end
					end

					local v14 = math.max(v13 + 1, #history - v5 + 1)

					for i, v15 in ipairs(v12) do
						if v15.rnKey == key then
							return i == v13 or v14 <= i
						end
					end

					return #v12 == 1
				end)
			end

			local v12 = useSignalState(v7[key])

			if not v8[key] then
				v8[key] = Signals.createComputed(function(p4)
					local history = legacyNavigationStore.getHistory(p4)
					local v14 = history[#history]

					for i, v15 in ipairs(v14) do
						if v15.rnKey == key then
							return i
						end
					end

					return 0
				end)
			end

			local v14 = useSignalState(v8[key])
			local param = p3.navigation.getParam("detail")

			local param2 = p3.navigation.getParam(
				"extraProps",
				not fFlagSignalsNavP3aWrapAppPage and {} or v6
			)

			return (React.useMemo(function()
				return React.createElement(extended, {
					isVisible = v12,
					displayOrder = v14,
					detail = param,
					extraProps = param2
				})
			end, { v12, v14, param, param2 }))
		end
	else
		v10 = RoactRodux.connect(function(p3, p4)
			local v11

			if fFlagUseNavigationSelectors then
				v11 = selectors.selectLegacyHistory(p3)
			else
				v11 = p3.Navigation.history
			end

			return computeNavProps(v11, p4)
		end)(extended)
	end

	return (RoactNavigation.withNavigation(v10))
end

return wrapAppPageForRoactNavigation
