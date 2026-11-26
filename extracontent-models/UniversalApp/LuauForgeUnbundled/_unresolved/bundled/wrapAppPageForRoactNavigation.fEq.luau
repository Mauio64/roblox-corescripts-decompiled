local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local module2 = require("@luauforge/bundled/dGJ")
local v5 = require("@luauforge/bundled/fEr")()

local useTTINavigationTracking = require("@luauforge/bundled/fEs").useTTINavigationTracking

local fFlagSignalsNavP3aWrapAppPage = SharedFlags.FFlagSignalsNavP3aWrapAppPage
local fFlagSignalsNavDeferProjection = SharedFlags.FFlagSignalsNavDeferProjection

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

local getLegacyHistoryFromRoactNavigationState

if fFlagSignalsNavDeferProjection then
	getLegacyHistoryFromRoactNavigationState = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Utils.getLegacyHistoryFromRoactNavigationState
else
	getLegacyHistoryFromRoactNavigationState = nil
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

local function getRootStackState(p2)
	local dangerouslyGetParent = p2._dangerouslyGetParent
	local v9 = if dangerouslyGetParent then dangerouslyGetParent() else nil

	if v9 == nil or v9._dangerouslyGetParent == nil or v9._dangerouslyGetParent() ~= nil then
		return nil
	end

	return v9.state
end

local function resolvePendingPageProps(p2, p3, p4)
	if p4 ~= 0 then
		return p3, p4
	end

	local dangerouslyGetParent = p2.navigation._dangerouslyGetParent
	local v9 = if dangerouslyGetParent then dangerouslyGetParent() else nil
	local state

	if not (v9 == nil or v9._dangerouslyGetParent == nil or v9._dangerouslyGetParent() ~= nil) then
		state = v9.state
	end

	if state == nil then
		return p3, p4
	end

	local v10 = computeNavProps(getLegacyHistoryFromRoactNavigationState(state), p2)
	return v10.isVisible, v10.displayOrder
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

		if fFlagSignalsNavDeferProjection and v12 == 0 then
			local dangerouslyGetParent = p3.navigation._dangerouslyGetParent
			local v13 = if dangerouslyGetParent then dangerouslyGetParent() else nil
			local state

			if not (v13 == nil or v13._dangerouslyGetParent == nil or v13._dangerouslyGetParent() ~= nil) then
				state = v13.state
			end

			if state ~= nil then
				local v14 = computeNavProps(getLegacyHistoryFromRoactNavigationState(state), p3)
				v10 = v14.isVisible
				v12 = v14.displayOrder
			end
		end

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

	local appPageForRoactNavigation

	if fFlagSignalsNavP3aWrapAppPage then
		appPageForRoactNavigation = function(p3)
			local legacyNavigationStore = getLegacyNavigationStore(false)
			local key = p3.navigation.state.key

			if not v7[key] then
				v7[key] = Signals.createComputed(function(p4): boolean
					local history = legacyNavigationStore.getHistory(p4)
					local v11 = history[#history]
					local v12 = 1

					for i = #v11, 1, -1 do
						if not (module2[v11[i].name] or {}).renderUnderlyingPage then
							v12 = i
							break
						end
					end

					local v13 = math.max(v12 + 1, #history - v5 + 1)

					for i, v14 in ipairs(v11) do
						if v14.rnKey == key then
							return i == v12 or v13 <= i
						end
					end

					return #v11 == 1
				end)
			end

			local v11 = useSignalState(v7[key])

			if not v8[key] then
				v8[key] = Signals.createComputed(function(p4)
					local history = legacyNavigationStore.getHistory(p4)
					local v13 = history[#history]

					for i, v14 in ipairs(v13) do
						if v14.rnKey == key then
							return i
						end
					end

					return 0
				end)
			end

			local v13 = useSignalState(v8[key])

			if fFlagSignalsNavDeferProjection and v13 == 0 then
				local dangerouslyGetParent = p3.navigation._dangerouslyGetParent
				local v14 = if dangerouslyGetParent then dangerouslyGetParent() else nil
				local state

				if not (v14 == nil or v14._dangerouslyGetParent == nil or v14._dangerouslyGetParent() ~= nil) then
					state = v14.state
				end

				if state ~= nil then
					local v15 = computeNavProps(getLegacyHistoryFromRoactNavigationState(state), p3)
					v11 = v15.isVisible
					v13 = v15.displayOrder
				end
			end

			local param = p3.navigation.getParam("detail")

			local param2 = p3.navigation.getParam(
				"extraProps",
				not fFlagSignalsNavP3aWrapAppPage and {} or v6
			)

			return (React.useMemo(function()
				return React.createElement(extended, {
					isVisible = v11,
					displayOrder = v13,
					detail = param,
					extraProps = param2
				})
			end, { v11, v13, param, param2 }))
		end
	else
		local v10 = RoactRodux.connect(function(p3, p4)
			local v11

			if fFlagUseNavigationSelectors then
				v11 = selectors.selectLegacyHistory(p3)
			else
				v11 = p3.Navigation.history
			end

			return computeNavProps(v11, p4)
		end)(extended)
		appPageForRoactNavigation = RoactNavigation.withNavigation(v10)
	end

	return appPageForRoactNavigation
end

return wrapAppPageForRoactNavigation
