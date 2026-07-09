local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes
local SearchUuid = require(Modules.LuaApp.SearchUuid)
local SetSearchParameters = require(Modules.LuaApp.Actions.SetSearchParameters)
local TenFootUiSearchTypeSelector = require(script.Parent.TenFootUiSearchTypeSelector)
local TenFootUiSearchBar = require(script.Parent.TenFootUiSearchBar)
local TenFootUiSearchExperiencesGrid = require(script.Parent.TenFootUiSearchExperiencesGrid)
local TenFootUiSearchPlayersGrid = require(script.Parent.TenFootUiSearchPlayersGrid)
local FocusNavigationEventNameEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigationEventNameEnum
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local useNavigationProps = require(CorePackages.Workspace.Packages.RobloxAppNavigation).useNavigationProps

local function TenFootUiSearch(_: {[any]: any}) -- line: 26
	-- upvalues: useDispatch (copy), useDesignTokens (copy), React (copy), useNavigationProps (copy), SearchTypes (copy), SearchUuid (copy), FocusNavigationEventNameEnum (copy), ReactFocusNavigation (copy), InputHandlers (copy), SetSearchParameters (copy), FFlagRenameDeprecatedUIBloxTokens (copy), TenFootUiSearchBar (copy), TenFootUiSearchTypeSelector (copy), TenFootUiSearchExperiencesGrid (copy), TenFootUiSearchPlayersGrid (copy)
	local v20 = useDispatch()
	local v21 = useDesignTokens()
	local v22, v23 = React.useState("")
	local v24 = useNavigationProps(function(_, _, p3) -- line: 31
		-- upvalues: SearchTypes (copy)
		return p3.getParam("defaultSearchType", SearchTypes.Games)
	end)
	local v25, v26 = React.useState(v24)
	local v27, v28 = React.useState(SearchUuid())
	local v29 = React.useRef(nil)
	local v30 = React.useMemo(function() -- line: 41
		-- upvalues: FocusNavigationEventNameEnum (copy)
		return {
			[Enum.KeyCode.ButtonR1] = FocusNavigationEventNameEnum.TabForward,
			[Enum.KeyCode.ButtonL1] = FocusNavigationEventNameEnum.TabBackward
		}
	end, {})
	local v31 = ReactFocusNavigation.useEventMap(v30, v29)
	local v32 = React.useMemo(function() -- line: 49
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v25 (copy), SearchTypes (copy), v26 (copy)
		return {
			[FocusNavigationEventNameEnum.TabBackward] = {
				handler = InputHandlers.onRelease(function(_) -- line: 52
					-- upvalues: v25 (copy), SearchTypes (copy), v26 (copy)
					if v25 ~= SearchTypes.Games then
						v26(SearchTypes.Games)
					end
				end)
			},
			[FocusNavigationEventNameEnum.TabForward] = {
				handler = InputHandlers.onRelease(function(_) -- line: 60
					-- upvalues: v25 (copy), SearchTypes (copy), v26 (copy)
					if v25 ~= SearchTypes.Players then
						v26(SearchTypes.Players)
					end
				end)
			}
		}
	end, {
		v25,
		v26
	})
	local v33 = ReactFocusNavigation.useEventHandlerMap(v32, v31)

	React.useEffect(function() -- line: 72
		-- upvalues: v22 (copy), v20 (copy), SetSearchParameters (copy), v27 (copy)
		local t2 = {
			isKeywordSuggestionEnabled = false,
			searchKeyword = v22
		}

		v20(SetSearchParameters(v27, t2))
	end, {
		v22,
		v27
	})

	local v34 = React.createRef()

	React.useEffect(function() -- line: 97
		-- upvalues: v34 (copy)
		if v34.current then
			v34.current:CaptureFocus()
		end
	end, {})

	return React.createElement("Frame", {
		ZIndex = 2,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ref = v33,
		BackgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Color.Common.Overlay else v21.Color.Common.Scrim)).Transparency,
		BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Color.Common.Overlay else v21.Color.Common.Scrim)).Color3
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v21.LuaApps.Search.SearchPaddingVertical),
			PaddingRight = UDim.new(0, v21.LuaApps.Search.SearchPaddingVertical),
			PaddingTop = UDim.new(0, v21.LuaApps.Search.SearchPaddingVertical)
		}),
		SearchBox = React.createElement(TenFootUiSearchBar, {
			layoutOrder = 1,
			textBoxRef = v34,
			onFocused = function() -- line: 128
			end,
			onSubmitSearch = function(p6) -- line: 129
				-- upvalues: v22 (copy), v28 (copy), SearchUuid (copy), v23 (copy)
				if p6.Text ~= v22 then
					v28(SearchUuid())
					v23(p6.Text)
				end
			end
		}),
		SearchTypeSelector = React.createElement(TenFootUiSearchTypeSelector, {
			layoutOrder = 2,
			onSearchTypeSelected = function(p7) -- line: 84
				-- upvalues: v25 (copy), SearchTypes (copy), v26 (copy)
				if v25 ~= SearchTypes.Games and v25 ~= SearchTypes.Players then
					warn("Invalid search type: " .. tostring(p7))
				end

				if p7 == v25 then
					return
				end

				v26(p7)
			end,
			searchType = v25
		}),
		ExperiencesGrid = React.createElement(TenFootUiSearchExperiencesGrid, {
			layoutOrder = 3,
			searchType = v25,
			searchUuid = v27,
			searchKeyword = v22
		}),
		PlayersGrid = React.createElement(TenFootUiSearchPlayersGrid, {
			layoutOrder = 4,
			searchType = v25,
			searchKeyword = v22
		})
	})
end

return TenFootUiSearch
